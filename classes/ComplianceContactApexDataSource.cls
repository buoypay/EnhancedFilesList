global with sharing class ComplianceContactApexDataSource implements smartlists.SmartListApexSourceInterface2 {
    public List<Map<String, Object>> getPage(smartlists.SmartListApexSourceGetPage parms) {
        String query = 'SELECT AccountId, Account.Name ContactId, Contact.Name	,Transaction_Limit__c,  Date_of_Signing__c, Roles, Signed_Agreement__c, Id FROM AccountContactRelation WHERE ' + parms.getFilter();
        query.replace('parentId', parms.getParentId());
    
    }
    public List<Map<String, Object>> getRecord(String id) {
        String query = 'SELECT AccountId, Account.Name ContactId, Contact.Name	,Transaction_Limit__c, Date_of_Signing__c, Roles, Signed_Agreement__c, Id FROM AccountContactRelation WHERE Id = ' + id;
        AggregateResult[] records = Database.query(query);
        return buildRecords(recors)
    
    }

    private List<Map<String, Object>> buildRecords(AggregateResult[] records) {
        List<Map<String, Object>> results = new List<Map<String, Object>>();
        System.debug('records ' + records);
        for (AggregateResult record : records) {
            Map<String, Object> record = new Map<String, Object>();
            record.put('RowKey', (String)record.get('Id')); // Note: Required field for 
            identifying a unique record
            record.put('Id', record.get('Id')); // Note: A field called Id is required in the list for using flow actions
            record.put('Account.Name', record.get('AccountName'));
            record.put('Contact.Name', record.get('ContactName'));
            record.put('AccountId', record.get('AccountId'));
            record.put('ContactId', record.get('ContactId'));
            record.put('Transaction_Limit__c', record.get('Transaction_Limit__c'));
            record.put('Date_of_Signing__c', record.get('Date_of_Signing__c'));
            record.put('Signed_Agreement__c', record.get('Signed_Agreement__c'));
            record.put('Roles', record.get('Roles'));

            results.add(record);
        }
        return results;
    }
}