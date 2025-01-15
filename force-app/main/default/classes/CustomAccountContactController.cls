public with sharing class CustomAccountContactController {

    transient String filter{get; set;}

    public CustomAccountContactController() {
        String filterKey = 'filterName';
        if(ApexPages.currentPage().getParameters().containsKey(filterKey)){
            filter = ApexPages.currentPage().getParameters().get(filterKey);
        }
    }


    public List<WrappedAccountContact> getData(){

        List<Account> accounts;

        if(String.isEmpty(filter)){
            accounts = [SELECT Name FROM Account];
        }
        else{
            accounts = [SELECT Name FROM Account WHERE Name = :filter];
        }
        
        List<Contact> contacts = [SELECT Name, AccountId FROM Contact];
        List<WrappedAccountContact> wacList = new List<WrappedAccountContact>();

        if(accounts.size() == 0){
            return wacList;
        }

        for(Account acc : accounts){
            List<String> accContacts = new List<String>();
            String contactsString = '';

            for(Contact con : contacts){

                if(con.AccountId == null || con.AccountId != acc.Id){
                    continue;
                }

                accContacts.add(con.Name);
            }

            if(accContacts.size() > 0){
                contactsString = String.join(accContacts, ',');
            }

            wacList.add(new WrappedAccountContact(acc, contactsString));
        }

        return wacList;
    }

    public class WrappedAccountContact{
        public Account account{get; set;}
        public String contacts{get; set;}

        WrappedAccountContact(Account account, String contacts){
            this.account = account;
            this.contacts = contacts;
        }
    }
}