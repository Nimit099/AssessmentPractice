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
     // *******---------------------*******************


    // Once an Account will update then that Account will update with the total amount from All its
    // Opportunities on the Account Level. The account field name would be ” Total Opportunity Amount.
    public static void Scene4(List<Account> acclist){
        Set<Id> accId = new Set<Id>();
        Map<Id,Double> amountMap = new Map<Id,Double>();
        for(Account acc : acclist){
            accId.add(acc.Id);
        }
        List<AggregateResult> results=[select AccountId,sum(Amount)TotalAmount from opportunity where AccountId in :accId group by AccountId];
    
        for(AggregateResult a: results){
            Id accountId = (Id)a.get('AccountId');
            double TotalAmount = (double)a.get('TotalAmount');
            amountMap.put(accountId,TotalAmount);
        }
        for(Account acc: acclist){
            if(amountMap.containskey(acc.Id)){
                acc.Total_Opportunity_Amount__c=amountMap.get(acc.Id);
            }
        }
    }
    // *******---------------------*******************


    // Create a field on Account Named (Client Contact lookup to Contact). Once an Account is inserted a Contact
    // will create with the name of the Account and that Contact will be the Client Contact on the Account.
    public static void Scene5(List<Account> acclist){
        List<Contact> conlist = new List<Contact>();
        Set<Id> accId = new Set<Id>();
        for(Account acc : acclist){
            conlist.add(new Contact(LastName = acc.Name, AccountId = acc.Id));
            accId.add(acc.Id);
        } 
        insert conlist;
        Map<Id, Account> mapofAccount = new Map<Id, Account>();
        List<Account> accounts = [SELECT Id, Contact__c FROM Account WHERE Id IN: acclist];
        for(Account acc : accounts){
            mapofAccount.put(acc.Id, acc);
        }
        List<Account> accounttoupdate = new List<Account>();
        for(Contact con: conlist){
            Account a = mapofAccount.get(con.AccountId);
            a.Contact__c = con.Id;
            accounttoupdate.add(a);
        }
        update accounttoupdate;
    }
    // *******---------------------*******************
}