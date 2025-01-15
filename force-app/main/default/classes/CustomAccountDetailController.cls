public with sharing class CustomAccountDetailController {

    public Account account{get; set;}
    public List<Contact> contacts{get;set;}
    public Integer contactSize{get{return contacts.size();}}

    public CustomAccountDetailController() {
        account = new Account();
        contacts = new List<Contact>();
    }

    
    public void GetAccountInfo(){
        try{
            account = (Account)[SELECT Name FROM Account Where Name = :account.Name LIMIT 1];

            if(account != null){
                List<Contact> tempContacts = [SELECT FirstName, LastName FROM Contact WHERE AccountId = :account.Id];
                if(tempContacts.size() > 0){
                    contacts = tempContacts;
                }
            }
            else{
                contacts.clear();
            }
        }
        catch(System.DmlException e){
            ApexPages.addMessages(e);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }

    public void GetPartialAccountInfo(){

            String partialLike = '%' + account.Name + '%';
            List<Account> acc = [SELECT Name FROM Account Where Name LIKE :partialLike LIMIT 1];

            if(acc.size() > 0){
                account = acc[0];
                contacts.clear();
                List<Contact> tempContacts = [SELECT FirstName, LastName FROM Contact WHERE AccountId = :account.Id];
                if(tempContacts.size() > 0){
                    contacts = tempContacts;
                }
            }
            else{
                contacts.clear();
            }
    }

    public void SaveChanges(){
        update account;
        update contacts;
    }
}