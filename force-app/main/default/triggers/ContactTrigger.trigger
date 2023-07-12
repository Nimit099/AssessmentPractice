trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        // ContactClass.Scene1(Trigger.new);
    }
}