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
        for (AggregateResult result : records) {
            Map<String, Object> record = new Map<String, Object>();
            record.put('RowKey', (String)result.get('Id'));
            record.put('Id', result.get('Id')); 
            record.put('Account.Name', result.get('AccountName'));
            record.put('Contact.Name', result.get('ContactName'));
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