public with sharing class NextStepFuture {

    /** 
     * Update/Uncomment the template code to create a method
     * Create a future method that updates all account and opportunities next step to 'Meeting in the future'
     * Account Next Step field is a custom field
     * Opportunity Next Step field is a standard field
     * Update the corresponding test class AsynchronousTest and test method nextStepFuture_testUpdateAllNextStep to cover test this method
     */
    //[public | private ] [static] data_type method_name (input parameters) {
    //  The body of the method
    //}

    //Mix DML Error
    public static void createDealAndUpdateRole() {
        Opportunity bigDeal = new Opportunity();
        insertBigDeal(bigDeal);

        UserRole[] roles = [SELECT Id, Name FROM UserRole WHERE Id = :UserInfo.getUserRoleId() OR Name = 'CRO' LIMIT 1];
        updateUserRoleName(roles);
    }

    private static void insertBigDeal(Opportunity opp) {
        opp.Amount = 1000000;
        opp.Name = 'Big Deal';
        opp.StageName = 'Closed Won'; 
        opp.CloseDate = Date.today();
        
        insert opp;
    }


    private static void updateUserRoleName(UserRole[] roles){
        UserRole role;
        if (roles.isEmpty()) {
            role = new UserRole();
            role.portalType = 'None'; 
            role.CaseAccessForAccountOwner = 'Edit'; 
            role.OpportunityAccessForAccountOwner = 'Read';
        } else {
            role = roles[0];
        }

        role.Name = 'CRO';

        upsert role;
    }
}