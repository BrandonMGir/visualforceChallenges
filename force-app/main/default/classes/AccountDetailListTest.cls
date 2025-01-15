@isTest
public class AccountDetailListTest {

    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();

        Integer count = 0;

        for(Integer i = 0; i < 40; i++){
            Account acc = new Account(Name='testAcc' + i);
            
            Integer r = Integer.valueOf(Math.random() * 4 + 1);

            for(Integer x = 0; x < r; x++){
                Contact con = new Contact(FirstName = 'test', LastName = '' + count, AccountId = acc.Id);
                conList.add(con);
                count++;
            }

            accList.add(acc);
        }

        insert accList;
        insert conList;
    }

    //positive
    @isTest
    static void GetAccountInfo_PositiveTest() {
        CustomAccountDetailController controller = new CustomAccountDetailController();
        final String accName = 'testAcc0';

        Account acc = [SELECT Id FROM Account WHERE Name = :accName Limit 1];
        List<Contact> cts = [SELECT Name FROM Contact WHERE AccountId = :acc.Id];
        
        controller.account.Name = accName;
        controller.GetAccountInfo();

        Assert.isNotNull(controller.account.Id);
        Assert.areEqual(controller.contacts.size(), cts.size());

        for(Contact con : controller.contacts){
            Assert.isNotNull(con.Id);
            Assert.areEqual(con.AccountId == controller.account.Id, true);
        }
    }

    @isTest
    static void GetPartialAccountInfo_PositiveTest() {
        CustomAccountDetailController controller = new CustomAccountDetailController();
        final String accName = '%testAcc%';

        List<Account> acc = [SELECT Name FROM Account Where Name LIKE :accName LIMIT 1];
        List<Contact> cts = [SELECT Name FROM Contact WHERE AccountId = :acc[0].Id];
        
        controller.account.Name = accName;
        controller.GetPartialAccountInfo();

        Assert.isNotNull(controller.account.Id);
        Assert.areEqual(controller.contacts.size(), cts.size());

        for(Contact con : controller.contacts){
            Assert.isNotNull(con.Id);
            Assert.areEqual(con.AccountId == controller.account.Id, true);
        }
    }

    @isTest
    static void SaveChanges_PositiveTest() {
        CustomAccountDetailController controller = new CustomAccountDetailController();
        final String oldAccName = 'testAcc0';
        final String newAccName = 'newAccountName';
        final String newContactName = 'newContactName';

        Account acc = [SELECT Name FROM Account Where Name = :oldAccName Limit 1];
        List<Contact> contacts = [SELECT Name FROM Contact WHERE AccountId = :acc.Id];

        controller.account = acc;
        controller.contacts = contacts;

        controller.account.Name = newAccName;
        controller.contacts[0].FirstName = newContactName;

        controller.SaveChanges();

        acc = [SELECT Name FROM Account Where Name = :newAccName Limit 1];
        contacts = [SELECT Name FROM Contact WHERE AccountId = :acc.Id];

        controller.account = acc;
        controller.contacts = contacts;

        Assert.areEqual(newAccName, acc.Name);
        Assert.areEqual(newContactName, contacts[0].FirstName);

    }

    //negative
    @isTest
    static void GetAccountInfo_NegativeTest() {
        CustomAccountDetailController controller = new CustomAccountDetailController();
        final String accName = 'testAcc';
        
        controller.account.Name = accName;
        controller.GetAccountInfo();

        Assert.isNull(controller.account.Id);
    }


}