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


    // The following trigger creates the number of contacts which are 
    // equal to the number which we will enter in the Number of 
    // Locations field on the Account Object.
    public static void Scene6(List<Account> acclist){
        List<Contact> conlist = new List<Contact>();
        for(Account acc : acclist){
            for(Integer i = 0; i < acc.Number_of_Locations__c; i++){
                conlist.add(new Contact(LastName = 'ABC', AccountId = acc.Id));
            }
        }
        insert conlist;
    }

    // When we create the Account record, the Account Owner will be automatically
    //  added to Sales Rep field. When we update the Account owner of the record,
    //   then also the Sales Rep will be automatically updated.
    public static void Scene7(Map<Id,Account> oldacclist, List<Account> acclist){
        List<Account> updateaccounts =  new List<Account>();
        for (Account acc : acclist) {
            System.debug(oldacclist.get(acc.Id).OwnerId);
            if(oldacclist.get(acc.Id).OwnerId != acc.OwnerId){
                updateaccounts.add(acc);
            }
        }
        for (Account acc : updateaccounts) {
            acc.Sales_Rep__c = acc.Owner.Name;
        }
        update updateaccounts;
        // for (Id newaccountId : newacclist.keyset()) {
        //     if(newacclist.get(newaccountId) != oldacclist.get(newaccountId)){
        //         Account a = newacclist.get(newaccountId);
        //         a.Sales_Rep__c = newacclist.get(newaccountId).owner.Name;
        //     }
        // }
    }
    // Create "Sales Rep" field with the data type(Text) on the Account object When we create the Account record,
    // the Account owners will be automatically added to the sales rep field. When we update the Account owner 
    // of the record, then also the Sales Rep will be automatically updated.
    public static void Scene8(List<Account> acclist, Map<Id, Account> oldacclist){

        Set<Id> ownerId = new Set<Id>();
        if (oldacclist == null) {
            for (Account acc : acclist) {
                ownerId.add(acc.OwnerId);
            }
            Map<Id, User> users = new Map<Id, User>([SELECT Name FROM User WHERE Id IN: ownerId]);
            for (Account acc : acclist) {
                acc.Sales_Rep__c = users.get(acc.OwnerId).Name;
            }
        } else {
            for (Account acc : acclist) {
                Account a = oldacclist.get(acc.Id);
                if (a.Owner.Name != acc.Owner.Name) {
                    acc.Sales_Rep__c = acc.Owner.Name;
                }
            }
        }
    }


    
    
     public void main(){
         HttpRequest request = new HttpRequest();
         request.setEndpoint('https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9fe4g9fhX0E71nnkMx60HwrbvDLZJqeomupQH8bgZnyx4AEwFJn9EbDySPZKOsIS2X7.BWFGY9OMF.s5C&client_secret=A0FC9747723055DF1FC84FF31215EED3547ADA5290D4EBFA89205D875D4E5E5C&username=nimit.s@mvclouds.developer.com&password=24_Whitedevil&=');
         request.setMethod('POST');
         Http http = new Http();
         HttpResponse response = new HttpResponse();
         response = http.send(request);
         Oauth oauthdata = (Oauth)JSON.deserialize(response.getBody(),Oauth.class);
         if(oauthdata.access_token != null){
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint('https://mvclouds29-dev-ed.develop.my.salesforce.com/services/apexrest/getBoard');
            request1.setMethod('GET');
            request1.setHeader('Content-Type', 'application/json');
            request1.setHeader('Authorization', 'Bearer '+oauthdata.access_token);
            Http http1 = new Http();
            HttpResponse response1 = new HttpResponse();
            response1 = http1.send(request1);
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'File File';
            contentVersion.PathOnClient = 'file.pdf';
            contentVersion.VersionData = response1.getBodyAsBlob();
            insert contentVersion;
         }
     }
     public class Oauth{
         public String access_token{get; set;}
         public String instance_url{get; set;}
         public String id{get; set;}
         public String token_type{get; set;}
         public String issued_at{get; set;}
         public String signature{get; set;}
     }
}