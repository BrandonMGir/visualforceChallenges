public with sharing class FilterAccountController {

    public Account account {get; set;}

    public FilterAccountController() {
        account = new Account();
    }

    public PageReference Filter(){
        PageReference page = Page.vfAllAccountsAndContactsPage;
        page.getParameters().put('filterName', account.Name);

        return page;
    }
}