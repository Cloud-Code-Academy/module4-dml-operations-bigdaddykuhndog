/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author T.J. Kuhn
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account myAccount = new Account();

        // Set some fields on the Account
        myAccount.Name = 'First Apex Account';

        // Insert the Account into the database
        system.debug('Before Insert: ' + myAccount);
        insert myAccount;
        system.debug('After Insert: ' + myAccount);

        // Return the Id of the newly created Account
        return myAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account hw02Account = new Account();

        hw02Account.name = name;
        hw02Account.industry = industry;

        // Insert the Account
        insert hw02Account;

    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact hw03Contact = new Contact();

        // Set some fields on the Contact
        hw03Contact.FirstName = 'T.J.';
        hw03Contact.LastName = 'BigDaddyKuhnDog';

        // Set the AccountId field to the given accountId
        hw03Contact.AccountId = accountId;

        // Insert the Contact into the database
        insert hw03Contact;

        // Return the Id of the newly created Contact
        return hw03Contact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact hw04Contact =  [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        hw04Contact.LastName = newLastName;

        // Update the Contact in the database
        update hw04Contact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        Opportunity hw05Opportunity = [SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        hw05Opportunity.StageName = newStage;

        // Update the Opportunity in the database
        update hw05Opportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        Account hw06Account =  [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        hw06Account.Name = newName;
        hw06Account.Industry = newIndustry;
        System.debug('Before updating: ' + hw06Account);
        update hw06Account;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for(opportunity eachOpportunity : opportunities){
            // Set the Opportunity's Stage to Qualification
            eachOpportunity.StageName = 'Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            eachOpportunity.CloseDate = date.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            eachOpportunity.Amount = 50000;
        }
            
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {

        // System.debug('I got to 1');
        id accountIdForOpp;
        
        // System.debug('I got to 2');
        List<Account> doesAccountExist = [SELECT Id FROM Account WHERE Name = :accountName limit 1];

        // System.debug('I got to 3');
        if (doesAccountExist.size() == 0 ){
            // System.debug('I got to 3.1');
            // System.debug('doesAccountExist = ' + doesAccountExist);
            account newAccount = new Account();
            newAccount.Name = accountName;
            // system.debug('before insert: ' + newAccount);
            insert newAccount;
            // system.debug('after insert: ' + newAccount);
            accountIdForOpp = newAccount.Id;
        } 
        else {
            // System.debug('I got to 4');
            // System.debug('doesAccountExist = ' + doesAccountExist);
            //accountIdForOpp = doesAccountExist[0];
        }

    
        // Loop through each Opportunity name
        
        for (string eachOppName : oppNames){
            // system.debug('Got to 5');
            // Create an Opportunity with the given name
            opportunity hw08Opportunity = new Opportunity();
            hw08Opportunity.Name = eachOppName;
            hw08Opportunity.AccountId = accountIdForOpp;
            hw08Opportunity.StageName = 'Qualification';
            hw08Opportunity.CloseDate = date.today();

            // Add the Opportunity to the list
            // System.debug('Opportunity = ' + hw08Opportunity);
            insert hw08Opportunity;
        }
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
        // System.debug('got to 0.1');
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        // system.debug('got to 0.2');
        Account accountToReturn;
		// if the Account exists, update the description
        if (accounts.size() > 0) {
            for (Account eachAccount : accounts) {
                // system.debug('got to 1');
                // system.debug('before upsert: ' + eachAccount);
                eachAccount.Description = 'Updated Account';
                upsert eachAccount;
                // system.debug('after upsert: ' + eachAccount);
                accountToReturn = eachAccount;
            }
            return accountToReturn;           
        }
        
        
        // otherwise, create a new Account and set the description
        else {
            // system.debug('got to a new account ');
            Account newAccount = new Account();
            newAccount.Name = accountName;
            newAccount.Description = 'New Account';
            // Upsert the Account
            // system.debug('before new account insert: ' + newAccount);
            insert newAccount;
            // system.debug('after new account insert: ' + newAccount);
            accountToReturn = newAccount;
            return newAccount;
        }	
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        for (Contact eachContact : contactsToUpsert) {
            // Extract the Account Name from Contact's LastName    
            // Get the account based on the name or create one if it doesn't exist
            Account thisAccount = upsertAccount(eachContact.LastName);

            // Link the Contact to its Account using the Account Id
            eachContact.AccountId = thisAccount.Id;
         
            // Upsert the Contacts
            upsert eachContact;
            // System.debug('contact = ' + eachContact);
        }
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        for (string eachLeadName : leadNames) {
            Lead thisLead = new Lead();
            // System.debug('lead before upsert: ' + thisLead);
            thisLead.LastName = eachLeadName;
            thisLead.Company = eachLeadName;
            // System.debug('after before upsert: ' + thisLead);
            // Insert the Leads
            upsert thisLead;

            // Delete the Leads
            delete thisLead;
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        
        for (Integer i = 0; i < numOfCases; i++) {
            Case thisCase = new Case();
            thisCase.AccountId = accountId;
            // Insert the cases
            insert thisCase;

            // Delete the cases
            delete thisCase;
        }

        

    }
}