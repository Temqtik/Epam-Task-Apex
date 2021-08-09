public with sharing class testClassForAccount {
    public testClassForAccount() { }

    public class RequestObject {
        @InvocableVariable(required=true label='Account ID')
        public Id accountId;
        @InvocableVariable(required=true label='Account Name')
        public String accountName;
        @InvocableVariable(required=true label='Created Date')
        public Datetime created;
        @InvocableVariable(required=true label='Last Modified Date')
        public Datetime updated;
    }

    @InvocableMethod
    public static void createNewTask(List<RequestObject> requests){
        
        List<Task> taskList = [SELECT OwnerId, WhatId FROM Task];
        List<User> Users =  [SELECT Id FROM User];
        List<Task> taskToInsert = new List<Task>();
        List<Task> taskToUpdate = new List<Task>();

        for(RequestObject request : requests){
            if(request.created == request.updated){
                Task task = new Task();
                task.Subject = 'Negotiations with ' + request.accountName;
                task.Is_Synced__c = true;
                task.WhatId = request.accountId;
                taskToInsert.add(task);
            } else{
                List<Task> accountTasks = new List<Task>();
                for(Task task : taskList){
                    if(task.WhatId == request.accountId){
                        accountTasks.add(task);
                    }
                }
                if(accountTasks.size() > 3) {
                    User user = Users[Integer.valueOf(Math.random() * (Users.size() - 1))];
                    for(Task changeTask : accountTasks) {
                        changeTask.OwnerId = user.Id;
                        taskToUpdate.add(changeTask);
                    }
                }
            }       
        }

        if(!taskToInsert.isEmpty()){
            insert taskToInsert;
        }
        if(!taskToUpdate.isEmpty()){
            update taskToUpdate;
        }
    }
}
