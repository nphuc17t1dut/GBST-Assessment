public with sharing class OpportunityController {
    @AuraEnabled
    public static List<Opportunity> getOpportunities(Id accountId) {
        return [SELECT Id, Name, CreatedDate, LastModifiedDate FROM Opportunity WHERE AccountId = :accountId];
    }

    @AuraEnabled
    public static void deleteAllOpportunities(Id accountId) {
        List<Opportunity> opportunitiesToDelete = [SELECT Id FROM Opportunity WHERE AccountId = :accountId];

        if(opportunitiesToDelete.size() > 0) {
            delete opportunitiesToDelete;
        }
    }

    @AuraEnabled
    public static void createOpportunities(Id accountId) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            opportunities.add(new Opportunity(Name='New Opportunity ' + i, CloseDate=Date.today().addDays(30), StageName='Prospecting', AccountId=accountId));
        }

        insert opportunities;
    }

    @AuraEnabled
    public static void updateAccountName(Id accountId, String updateName) {
        try {
            Account acc = [SELECT Id, Name FROM Account WHERE id = :accountId][0];
            acc.Name = updateName;

            update acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
       
    }
}