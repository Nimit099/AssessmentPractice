trigger AccountTrigger on Account (before insert, after update, after insert, before update) {
    // Write a trigger on Account, when an account is inserted, automatically 
    //account billing address should populate into the account shipping address.
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            // AccountClass.Scene1(Trigger.New);
        }
    }
    // ****************************


    // Write a trigger on the Account when the Account is updated check all opportunities related to
    // the account. Update all Opportunities Stage to close lost if an
    // opportunity created date is greater than 30 days from today and stage not equal to close won.
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            // AccountClass.Scene2(Trigger.New);
        }
    }
    // ****************************


    // Once an Account is inserted an email should go to the System Admin user with specified text below.
    // An account has been created and the name is “Account Name”.
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            // AccountClass.Scene3(Trigger.New);
            AccountClass.Scene6(Trigger.new);
        }
    }
    // ****************************


    // Once an Account will update then that Account will update with the total amount from All its
    // Opportunities on the Account Level. The account field name would be ” Total Opportunity Amount.
    if(Trigger.isUpdate){
        if(Trigger.isbefore){
            // AccountClass.Scene4(Trigger.New);
        }
    }
    // ****************************


    // Create a field on Account Named (Client Contact lookup to Contact). Once an Account is inserted a Contact
    //  will create with the name of the Account and that Contact will be the Client Contact on the Account.
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            // AccountClass.Scene5(Trigger.New);
        }
    }
    // ****************************

    // When we create the Account record, the Account Owner will be automatically
    //  added to Sales Rep field. When we update the Account owner of the record,
    //   then also the Sales Rep will be automatically updated.
    if(Trigger.isUpdate && Trigger.isAfter){
        AccountClass.Scene7(Trigger.oldMap, Trigger.new);
    }

}