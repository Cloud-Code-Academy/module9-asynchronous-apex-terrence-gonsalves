public with sharing class NextStepQueueable {

    // Member variable to store the accounts
    private Map<Id,Account> accounts;

    public NextStepQueueable(Map<Id,Account> accounts) {
        // Store the accounts in a member variable
    }

    public static void enqueueJob() {
        // Get 10 accounts with Next Step populated

        // If there are any accounts, queue the job using System.enqueueJob
    }

    public void execute(QueueableContext context) { 
        // Get the accounts from the member variable

            // Remove the Next Step using the helper method

        // Update the accounts

        // Get the opportunities related to the accounts

            // Remove the Next Step using the helper method

        // Update the opportunities
    }

    // Helper method to remove the Next Step
    // Overloaded method to accept an opportunity
    private static void removeDescription(Opportunity opp) {
        opp.NextStep = null;
    }

    // Helper method to remove the Next Step
    // Overloaded method to accept an account
    private static void removeDescription(Account acc) {
        acc.Next_Step__c = null;
    }
}