
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

    // Write a trigger on the Account when the Account is updated check all opportunities related to the account.
    // Update all Opportunities Stage to close lost if an opportunity created date is greater than 30 days from
    // today and stage not equal to close won.

    public static void Scene2(List<Account> acclist){
        Date currentDate = System.today();
        List<Opportunity> opplist = [Select Id, StageName, CreatedDate FROM Opportunity WHERE AccountId IN: acclist];
        
        for(Opportunity opp : opplist){
            if(currentDate.daysBetween(opp.CreatedDate.Date()) > 30){
                if(opp.StageName != 'Closed Won'){
                    opp.StageName = 'Closed Lost';
                }
            }
        }
        update opplist;
    }
    // *******---------------------*******************

    // Once an Account is inserted an email should go to the System Admin user with specified text below.
    // An account has been created and the name is “Account Name”.

    public static void Scene3(List<Account> acclist){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> email = new List<String>();
        List<User> ulist = [SELECT Id, Email FROM User WHERE Profile.Name = 'System Administrator'];
        for(User u : ulist ){
            email.add(u.email);
        }
        for(Account acc : acclist){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.toAddresses = email;
            mail.setSubject('Test Mail');
            mail.setPlainTextBody('An account has been created and the name is '+ acc.Name + '.');
            mails.add(mail);
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);

    }

}