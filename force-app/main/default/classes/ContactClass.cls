public with sharing class ContactClass {
    public static void Scene1(List<Contact> conlist){
        Map<String, Contact> emailContact = new Map<String, Contact>();
        Map<String, Contact> phoneContact = new Map<String, Contact>();
        for(Contact con : conlist){
            if(con.Email != null){
                emailContact.put(con.Email, con);
            }
            if(con.MobilePhone != null){
                phoneContact.put(con.MobilePhone, con);
            }
        }
        List<Contact> contacts = [SELECT Id,FirstName, LastName, MobilePhone, Email FROM Contact];

        for(Contact con : contacts){
            if(emailContact.get(con.Email) != null){
                conlist[0].addError('Contact with this email exist');
            }
            if(phoneContact.get(con.MobilePhone) != null){
                conlist[0].addError('Contact with this phone exist');
            }
        }

    }

    public static void Scene2(List<OpportunityLineItem__c> opplines){
        Set<Id> opplineId = new Set<Id>();
        for(OpportunityLineItem__c oppline : opplines){
            if(oppline.Opportunity__c != null){
                opplineId.add(oppline.Opportunity__c);
            }
        }
        List<Opportunity> opplist = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: opplineId];

        Set<Id> accId = new Set<Id>();
        for(Opportunity opp : opplist){
            if(opp.AccountId != null){
                accId.add(opp.AccountId);
            }
        }
        List<Account> acclist = [SELECT Id, Contact__c FROM Account WHERE Id IN: accId];

        Set<Id> conId = new Set<Id>();
        for(Account acc : acclist){
            if(acc.Contact__c != null){
                conId.add(acc.Contact__c);
            }
        }
        List<Contact> conlist = [SELECT Id,Name, Email FROM Contact WHERE Id IN: conId];

        List<String> email = new List<String>();
        for(Contact con : conlist){
            if(con.Email != null){
                email.add(con.Email);
            }
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Contact con : conlist){
            if(con.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.toAddresses = email;
                mail.setSubject('Test Mail');
                mail.setPlainTextBody('An OpportunityLine has been created and the name is '+ con.Name + '.');
                mails.add(mail);
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);

    }
}