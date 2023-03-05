/**
 * Utility class for working with Picklists
 */
public with sharing class PicklistUtils {
    // Cache for dynamic Apex calls
    private final static Map<String, List<Schema.PicklistEntry>> apexCache = new Map<String, List<Schema.PicklistEntry>>();

    // Cache for case status values
    private static List<CaseStatus> caseStatuses;

    /**
     * Retrieves picklist values for a given object and field
     * This method uses dynamic Apex and does not support record types.
     * Example:
     *   List<Schema.PicklistEntry> entries = PicklistUtils.getPicklistValues(Account.sObjectType, Account.Industry);
     * @param sObjectType the object such as Account.sObjectType
     * @param field the object field that is a picklist such as Account.Industry
     */
    public static List<Schema.PicklistEntry> getPicklistValues(
        sObjectType sObjectType,
        Schema.sObjectField field
    ) {
        // Try to get entries from cache
        String cacheKey =
            String.valueOf(sObjectType) +
            '.' +
            String.valueOf(field);
        List<Schema.PicklistEntry> entries = apexCache.get(cacheKey);
        if (entries == null) {
            // Get picklist values
            entries = field.getDescribe().getPicklistValues();
            // Exclude inactive picklist values
            entries = getActivePicklistEntries(entries);
            // Cache entries
            apexCache.put(cacheKey, entries);
        }
        return entries;
    }

    /**
     * Retrieves picklist values for a given object and field
     * This method uses dynamic Apex and does not support record types.
     * @param objectName
     * @param fieldName
     * @throws System.InvalidParameterValueException if objectName or fieldName are invalid
     */
     @AuraEnabled(Cacheable=true)
    public static List<PicklistEntryWrapper> getPicklistValuesSimple(
        String objectName,
        String fieldName
    ) {
        // Try to get entries from cache
        String cacheKey = objectName + '.' + fieldName;
        List<Schema.PicklistEntry> entries = apexCache.get(cacheKey);
        if (entries == null) {
            // Use dynamic Apex to get object description
            // Schema.describeSObjects throws System.InvalidParameterValueException if objectName is invalid
            Schema.DescribeSobjectResult objDescription = Schema.describeSObjects(
                new List<String>{ objectName }
            )[0];
            // Retrieve field map and check that field exists
            Schema.SObjectField field = objDescription.fields.getMap()
                .get(fieldName);
            if (field == null) {
                InvalidParameterValueException e = new InvalidParameterValueException(
                    'fieldName',
                    fieldName
                );
                e.setMessage(
                    'Could not find field ' +
                        fieldName +
                        ' on object ' +
                        objectName
                );
                throw e;
            }
            // Get picklist values
            entries = field.getDescribe().getPickListValues();
            // Exclude inactive picklist values
            entries = getActivePicklistEntries(entries);
            // Cache entries
            apexCache.put(cacheKey, entries);
        }

        return returnWrappedEntries(entries);
    }

    /**
     * Gets all case status values for both closed AND open cases
     */
    public static List<CaseStatus> getCaseStatusValues() {
        if (caseStatuses == null) {
            caseStatuses = [
                SELECT Id, MasterLabel, IsClosed, SortOrder, ApiName, IsDefault
                FROM CaseStatus
                ORDER BY SortOrder ASC
            ];
        }
        return caseStatuses;
    }

    /**
     * Gets case status values for closed OR open cases
     * @param isCaseClosed whether to return values for open cases or closed cases
     */
    public static List<CaseStatus> getCaseStatusValues(Boolean isCaseClosed) {
        List<CaseStatus> allValues = getCaseStatusValues();
        List<CaseStatus> requestedValues = new List<CaseStatus>();
        for (CaseStatus value : allValues) {
            if (value.IsClosed == isCaseClosed) {
                requestedValues.add(value);
            }
        }
        return requestedValues;
    }

    /**
     * Return active picklist entries
     * @param entries list of picklist entries
     */
    private static List<Schema.PicklistEntry> getActivePicklistEntries(
        List<Schema.PicklistEntry> entries
    ) {
        List<Schema.PicklistEntry> activeEntries = new List<Schema.PicklistEntry>();
        for (Schema.PicklistEntry entry : entries) {
            if (entry.isActive()) {
                activeEntries.add(entry);
            }
        }
        return activeEntries;
    }

    private static List<PicklistEntryWrapper> returnWrappedEntries(List<Schema.PicklistEntry> entries) {
        List<PicklistEntryWrapper> wrapped = new List<PicklistEntryWrapper>();
        for (Schema.PicklistEntry entry : entries) {
            PicklistEntryWrapper wrapper = new PicklistEntryWrapper();
            wrapper.label = entry.label;
            wrapper.value = entry.value;
            wrapped.add(wrapper);
        
        }
        return wrapped;
    }

    public class PicklistEntryWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
}
