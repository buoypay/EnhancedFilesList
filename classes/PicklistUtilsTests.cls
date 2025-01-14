@isTest
global class PicklistUtilsTests {
    @isTest
    static void getPicklistValues_works_with_object_referemce() {
        Test.startTest();
        List<Schema.PicklistEntry> entries = PicklistUtils.getPicklistValues(
            Account.sObjectType,
            Account.Industry
        );
        Test.stopTest();

        System.assert(entries.size() > 0);
    }

    @isTest
    static void getPicklistValues_works_with_strings() {
        Test.startTest();
        List<PicklistUtils.PicklistEntryWrapper> entries = PicklistUtils.getPicklistValuesSimple(
            'Account',
            'Industry'
        );
        Test.stopTest();

        System.assert(entries.size() > 0);
    }

    @isTest
    static void getPicklistValues_fails_when_invalid_objectName() {
        Test.startTest();
        try {
            PicklistUtils.getPicklistValuesSimple('Unknown', 'Industry');
            System.assert(false, 'Exception was expected');
        } catch (Exception e) {
            System.assert(
                e instanceof InvalidParameterValueException,
                'Expected PicklistUtils.PicklistException, got ' + e
            );
            System.assert(
                e.getMessage().contains('Invalid sobject provided'),
                'Expected exception message to contain "Invalid sobject provided", got ' +
                e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void getPicklistValues_fails_when_invalid_fieldName() {
        Test.startTest();
        try {
            PicklistUtils.getPicklistValuesSimple('Account', 'Unknown');
            System.assert(false, 'Exception was expected');
        } catch (Exception e) {
            System.assert(
                e instanceof InvalidParameterValueException,
                'Expected PicklistUtils.PicklistException, got ' + e
            );
            System.assertEquals(
                'Could not find field Unknown on object Account',
                e.getMessage()
            );
        }
        Test.stopTest();
    }

  
    @isTest
    static void getCaseStatusValues_works_with_closed_cases() {
        Test.startTest();
        Integer count = database.countQuery(
            'SELECT COUNT() FROM CaseStatus WHERE IsClosed=true'
        );
        List<CaseStatus> values = PicklistUtils.getCaseStatusValues(true);
        Test.stopTest();

        System.assertEquals(count, values.size());
    }

    @isTest
    static void getCaseStatusValues_works_with_open_cases() {
        Test.startTest();
        Integer count = database.countQuery(
            'SELECT COUNT() FROM CaseStatus WHERE IsClosed=false'
        );
        List<CaseStatus> values = PicklistUtils.getCaseStatusValues(false);
        Test.stopTest();

        System.assertEquals(count, values.size());
    }

    public class MockSimpleHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String body;

        public MockSimpleHttpResponse(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.statusCode);
            res.setBody(this.body);
            return res;
        }
    }
}
