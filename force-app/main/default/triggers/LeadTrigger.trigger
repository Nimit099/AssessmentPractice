trigger LeadTrigger on Lead (before insert) {

    // When ever Lead is created with LeadSource as Web then give rating as cold otherwise hot.
    if(Trigger.isInsert && Trigger.isBefore){
        LeadController.Scene1(Trigger.new);
    }
}