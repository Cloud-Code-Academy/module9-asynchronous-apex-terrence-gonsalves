public with sharing class Asynchronous {
    /**
     * Asynchronously update all Account description to 'Updated from Asynchronous future'
     */
    @future
    public static void updateAllAccountNames() {
        List<Account> accountsToUpdate = [SELECT Id, Name FROM Account];
        
        for(Account acc : accountsToUpdate) {
            acc.Description = 'Updated from Asynchronous future';
        }
        
        update accountsToUpdate;
    }

    
    public static void mixDMLError() {
        Opportunity bigDeal = new Opportunity(Amount = 1000000, Name = 'Big Deal', StageName = 'Closed Won', CloseDate = Date.today());
        insert bigDeal;
        List<User> currentUserList = [SELECT Id, Title, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()];
        User currentUser = currentUserList[0];
        Asynchronous async = new Asynchronous();
        async.updateUserRoleName(currentUser);
    }

    // @future
    private Id updateUserRoleName(User currentUser) {

        UserRole role;
        if (currentUser.UserRoleId == null) {
            role.portalType = 'None'; // use 'CustomerPortal' for customer portal roles
            role.CaseAccessForAccountOwner = 'Edit'; //Modify as needed
            role.OpportunityAccessForAccountOwner = 'Read'; //Modify as needed
            role.Name = switchRoleName(role.Name);
            
        } else {
            role = [SELECT Id, Name FROM UserRole WHERE Id = :currentUser.UserRoleId];
            role.Name = switchRoleName(role.Name);
        }

        upsert role;
        currentUser.UserRoleId = role.Id;
        update currentUser;
        return role.Id;
    }


    private static String switchRoleName(String name) {
        if (String.isNotBlank(name) || name != 'CRO') {
            return 'CRO';
        } else {
            return 'CSO';
        }
    }
}