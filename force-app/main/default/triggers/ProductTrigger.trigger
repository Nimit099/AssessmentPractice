trigger ProductTrigger on OpportunityLineItem__c (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        ContactClass.Scene2(Trigger.new);
    }
}