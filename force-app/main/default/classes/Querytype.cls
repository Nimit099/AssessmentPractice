public with sharing class Querytype {
    public static void SOSLquery(){
        List<list<SObject>> SearchList = [FIND 'Nimit' IN ALL FIELDS RETURNING Account(Id,Name),Contact(Id, FirstName)];
        List<Account> acclist = SearchList[0]; // It required static number to get particular object records
        List<Contact> conlist = SearchList[1];

        for (Account acc : acclist) {
            System.debug(acc);
        }
    }

    public static void ParentChildquery(){
        // To make parent child query then always use child object Plural Name
        List<Account> acclist = [SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account];
        List<List<Contact>> conlist = new List<List<Contact>>();
        List<Contact> cons = new List<Contact>();
        for (Account acc : acclist) {
            for(Contact c : acc.Contacts){
                cons.add(c);
            }
        }
    }

    public static void ChildParentquery() {
        List<Contact> conlist = [SELECT  Id, Account.Name, AccountId FROM Contact];
        for(Contact c : conlist){
            System.debug(c.Account.Name);
        }
    }

    @AuraEnabled
    public static Map<Account, List<Contact>> treelist(){
        Map<Account, List<Contact>> accconmap = new Map<Account, List<Contact>>();
        List<Contact> conlist = new List<Contact>();
        List<Account> acclist = [SELECT Id, Name, (SELECT Id, LastName FROM Contacts) FROM Account];
        for (Account acc : acclist) {
            conlist.add(acc.Contacts);
            accconmap.put(acc, conlist);
        }
        return accconmap;
    }
}