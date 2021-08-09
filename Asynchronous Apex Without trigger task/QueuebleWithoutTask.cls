public with sharing class QueuebleWithoutTask implements Queueable{

    Map<Id, Account> accounts;

    public QueuebleWithoutTask() {
        accounts = new Map<Id, Account>([SELECT Id, BillingAddress FROM Account LIMIT 150]);
    }


    public void execute(QueueableContext qb) {

        for (Id accountId : accounts.keySet()) {
            if(accounts.get(accountId).BillingAddress == null) {
                accounts.remove(accountId);
            }
        }   


        List<Contact> contactToUpdate = [select id from Contact where AccountId IN :accounts.values()];
        System.debug(contactToUpdate.size());

        for (Contact cont : contactToUpdate) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Queue__c = true;
        }

        update contactToUpdate;
    }
}

