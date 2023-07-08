trigger AccountTrigger on Account (before insert, after update) {
    // Write a trigger on Account, when an account is inserted, automatically 
    //account billing address should populate into the account shipping address.
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountClass.Scene1(Trigger.New);
        }
    }
    // ****************************

        // Write a trigger on the Account when the Account is updated check all opportunities related to
        // the account. Update all Opportunities Stage to close lost if an
        // opportunity created date is greater than 30 days from today and stage not equal to close won.

        if(Trigger.isUpdate){
            if(Trigger.isAfter){
                AccountClass.Scene2(Trigger.New);
            }
        }
}