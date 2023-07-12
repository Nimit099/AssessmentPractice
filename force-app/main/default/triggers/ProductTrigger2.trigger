trigger ProductTrigger2 on Product2 (after insert) {

    if(Trigger.isInsert && Trigger.isAfter){
        ProductController.scene1(Trigger.new);
    }
}