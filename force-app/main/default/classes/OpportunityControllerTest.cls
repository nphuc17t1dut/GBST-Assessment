@isTest
public with sharing class OpportunityControllerTest {
    @isTest
    static void testGetOpportunities() {
        // Setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Test.startTest();
        List<Opportunity> opportunities = OpportunityController.getOpportunities(testAccount.Id);
        Test.stopTest();
        
        // Verify
        System.assertEquals(1, opportunities.size(), 'Expected one opportunity to be returned');
        System.assertEquals(testOpportunity.Id, opportunities[0].Id, 'The opportunity ID should match');
    }

    @isTest
    static void testDeleteAllOpportunities() {
        // Setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Test.startTest();
        OpportunityController.deleteAllOpportunities(testAccount.Id);
        Test.stopTest();
        
        // Verify
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, opportunities.size(), 'Expected no opportunities to remain');
    }

    @isTest
    static void testCreateOpportunities() {
        // Setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Test.startTest();
        OpportunityController.createOpportunities(testAccount.Id);
        Test.stopTest();
        
        // Verify
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assertEquals(10, opportunities.size(), 'Expected 10 opportunities to be created');
    }

    @isTest
    static void testUpdateAccountName() {
        // Setup
        Account testAccount = new Account(Name = 'Old Account Name');
        insert testAccount;

        Test.startTest();
        OpportunityController.updateAccountName(testAccount.Id, 'New Account Name');
        Test.stopTest();

        // Verify result
        Account updatedAccount = [SELECT Name FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('New Account Name', updatedAccount.Name, 'The account name should be updated');
    }

    @isTest
    static void testNegativeUpdateAccountName() {
        try {
            Test.startTest();
            OpportunityController.updateAccountName(null, 'New Account Name');
            Test.stopTest();
        } catch (AuraHandledException e) {
            System.assert(true, 'Exception was thrown as expected');
        }
    }
}