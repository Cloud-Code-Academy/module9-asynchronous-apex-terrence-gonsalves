public with sharing class NextStepBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name, Next_Step__c FROM Account]);
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope){
        String nextStep = 'Batching the next meetings together.';
        Set<Id> accountIds = new Set<Id>();
        for(Account a : scope){
            a.Next_Step__c = nextStep;
            accountIds.add(a.Id);
        }
        update scope;
        
        List<Opportunity> opps = [SELECT Id, Name, NextStep FROM Opportunity WHERE AccountId IN :accountIds];
        for(Opportunity o : opps){
            o.NextStep = nextStep;
        }
        update opps;
    }
    
    public void finish(Database.BatchableContext BC){
        List<User> users = [SELECT Id, Name, Email FROM User WHERE IsActive = true AND (NOT Email LIKE 'autoproc%')];
        Set<String> emails = new Set<String>();
        for (User u : users){
            emails.add(u.Email);
        }        
        if (!emails.isEmpty()) {
            sendEmail(emails);
        }
    }

    private void sendEmail(Set<String> emails){
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>(emails));
            mail.setSubject('Next Step Batch Complete');
            mail.setPlainTextBody('The next step batch has completed.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
        }
        
    }
}