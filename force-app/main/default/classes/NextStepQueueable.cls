public with sharing class NextStepQueueable implements Queueable {

    private Map<Id,Account> accounts;

    public NextStepQueueable(Map<Id,Account> accounts) {
        this.accounts = accounts;
    }

    public static void enqueueJob() {
        Map<Id,Account> accountMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Next_Step__c != NULL LIMIT 10]);
        if (!accountMap.isEmpty()){
            System.enqueueJob(new NextStepQueueable(accountMap));
        }        
    }

    public void execute(QueueableContext context) { 
        for (Account acc : accounts.values()) {
            removeDescription(acc);
        }
        update accounts.values();

        List<Opportunity> opps = [SELECT Id, NextStep FROM Opportunity WHERE AccountId IN :accounts.keySet()];
        for (Opportunity opp : opps) {
            removeDescription(opp);
        }
        update opps;
    }


    private static void removeDescription(Opportunity opp) {
        opp.NextStep = null;
    }

    private static void removeDescription(Account acc) {
        acc.Next_Step__c = null;
    }
}