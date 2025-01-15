public with sharing class customAccountController {
    private transient ID accountId = '001Ru00000P9m5UIAR';

    public transient boolean visible{get; set;}
    public transient String accountName{get; set;}

    public customAccountController() {
        visible = false;
        accountName = ApexPages.currentPage().getParameters().get('name');
    }

    public Account getAccount(){
        return (Account)[SELECT Name From Account Where Id = :accountId LIMIT 1];
    }

    public void ToggleVisible(){
        visible = !visible;
    }

    //challenge 6: get account name from url?
}