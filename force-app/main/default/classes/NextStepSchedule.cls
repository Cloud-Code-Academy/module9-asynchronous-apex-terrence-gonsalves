global with sharing class NextStepSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        NextStepBatch batch = new NextStepBatch(); 
        Database.executeBatch(batch);
    }
}