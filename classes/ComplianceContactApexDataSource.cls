global with sharing class ComplianceContactApexDataSource implements smartlists.SmartListApexSourceInterface2 {
    public List<Map<String, Object>> getPage(smartlists.SmartListApexSourceGetPage parms) {
        String query = 'SELECT AccountId, Account.Name, ContactId, Contact.Name	,Transaction_Limit__c,  Date_of_Signing__c, Roles, Signed_Agreement__c, Id FROM AccountContactRelation WHERE ' + parms.getFilter();
        query = query.replace('parentId', parms.getParentId());
        System.debug('query ' + query);

        List<sObject> records = Database.query(query);
        return buildRecords(records);
    
    }
    public List<Map<String, Object>> getRecord(String id) {
        String query = 'SELECT AccountId, Account.Name, ContactId, Contact.Name	,Transaction_Limit__c, Date_of_Signing__c, Roles, Signed_Agreement__c, Id FROM AccountContactRelation WHERE Id = \'' + id + '\'';
        List<sObject> records = Database.query(query);
        return buildRecords(records);
    
    }

    private List<Map<String, Object>> buildRecords(List<sObject> records) {
        List<Map<String, Object>> results = new List<Map<String, Object>>();
        System.debug('records ' + records);
        for (sObject result : records) {
            Map<String, Object> record = new Map<String, Object>();
            record.put('RowKey', (String)result.get('Id'));
            record.put('Id', result.get('Id')); 
            record.put('Account.Name', result.getSobject('Account').get('Name'));
            record.put('Contact.Name', result.getSobject('Contact').get('Name'));
            record.put('AccountId', result.get('AccountId'));
            record.put('ContactId', result.get('ContactId'));
            record.put('Transaction_Limit__c', result.get('Transaction_Limit__c'));
            record.put('Date_of_Signing__c', result.get('Date_of_Signing__c'));
            record.put('Signed_Agreement__c', result.get('Signed_Agreement__c'));
            record.put('Roles', result.get('Roles'));

            results.add(record);
        }
        return results;
    }
}