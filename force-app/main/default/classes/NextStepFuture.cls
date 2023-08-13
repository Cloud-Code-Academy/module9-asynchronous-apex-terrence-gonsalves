public with sharing class NextStepFuture {
    @future
    public static void updateAllNextStep() {
        String nextStep = 'Meeting in the future';
        Map<Id,Account> accountsToUpdate = new Map<Id,Account>([SELECT Id, Name FROM Account]);
        List<Opportunity> oppsToUpdate = [SELECT Id, Name FROM Opportunity WHERE AccountId IN :accountsToUpdate.keySet()];
        for(Account acc : accountsToUpdate.values()) {
            acc.Next_Step__c = nextStep;
        }

        for (Opportunity opp : oppsToUpdate) {
            opp.NextStep = nextStep;
        }
        
        update accountsToUpdate.values();
        update oppsToUpdate;
    }

    //Mix DML Error
    public static void createDealAndUpdateRole() {
        insertBigDeal();
        updateUserRoleName();
    }

    private static void insertBigDeal() {
        Opportunity bigDeal = new Opportunity(Amount = 1000000, Name = 'Big Deal', StageName = 'Closed Won', CloseDate = Date.today());
        insert bigDeal;
    }

    @future
    private static void updateUserRoleName(){
        UserRole[] roles = [SELECT Id, Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId() OR Name = 'CRO' LIMIT 1];

        UserRole role = roles.isEmpty() ? new UserRole() : roles[0];

        if (roles.isEmpty()) {
            role = new UserRole();
            role.portalType = 'None'; 
            role.CaseAccessForAccountOwner = 'Edit'; 
            role.OpportunityAccessForAccountOwner = 'Read';
            
        }

        role.Name = 'CRO';

        upsert role;
    }
}