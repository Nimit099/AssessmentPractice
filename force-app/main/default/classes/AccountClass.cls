
public with sharing class AccountClass {

    // ** Write a trigger on Account, when an account is inserted, automatically account **
    // ** billing address should populate into the account shipping address.**
    public static void Scene1(List<Account> acclist){
        for (Account acc : acclist) {
            if(acc.BillingStreet != null){
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingState = acc.BillingState;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCountry = acc.BillingCountry;
            }
        }
    }
    // *******---------------------*******************

    
}