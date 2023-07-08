// Write a trigger on Account, when an account is inserted, automatically account billing address should populate into the account shipping address.

trigger AccountTrigger on Account (before insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountClass.Scene1(Trigger.New);
        }
    }
}