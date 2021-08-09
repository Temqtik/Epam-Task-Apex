public with sharing class WithoutTaskClass {
    public WithoutTaskClass() {}

    @future
    public static void UpdateAccounts(){
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, BillingAddress FROM Account LIMIT 150]);

        for (Id accountId : accounts.keySet()) {
            if(accounts.get(accountId).BillingAddress == null) {
                accounts.remove(accountId);
            }
        }

        List<Contact> contactToUpdate = [select id from Contact where AccountId IN :accounts.values()];
        System.debug(contactToUpdate.size());

        for (Contact cont : contactToUpdate) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Future__c = true;
        }

        update contactToUpdate;
    } 

}
