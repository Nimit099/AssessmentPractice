public with sharing class LeadController {

    // When ever Lead is created with LeadSource as Web then give rating as cold otherwise hot.
    public static void Scene1(List<Lead> leadlist){
        for (Lead leads : leadlist) {
            if(leads.LeadSource == 'Web'){
                leads.Rating = 'Hot';
            }
        }
    }
}