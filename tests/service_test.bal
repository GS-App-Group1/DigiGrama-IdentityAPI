import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9090");

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("Running Identity API Service tests...");
}

// Test function

@test:Config {}
function testServiceWithProperNIC() {
    json|error response_1 = testClient->get("/identity/getIdentityFromNIC/?nic=200005703120");
    json|error response_2 = testClient->get("/identity/getGSDivisionFromNIC/?nic=200005703120");
    json[] responseJson_1 = [{"_id": "6577d59cd8bb5abb8ec323fa", "nic": "200005703120", "name": "Themira", "dob": "31.03.2000", "phoneNumber": "0766652613", "isMarried": false, "isEmployed": true, "gsDivision": "Sooriyagoda"}];
    json responseJson_2 = {"gsDivision": "Sooriyagoda"};
    test:assertEquals(response_1, responseJson_1);
    test:assertEquals(response_2, responseJson_2);
}

// Negative test function

@test:Config {}
function testServiceWithEmptyNIC() returns error? {
    http:Response response_1 = check testClient->get("/identity/getIdentityFromNIC/?nic=");
    http:Response response_2 = check testClient->get("/identity/getGSDivisionFromNIC/?nic=");
    test:assertEquals(response_1.statusCode, 500);
    test:assertEquals(response_2.statusCode, 500);
    json errorPayload_1 = check response_1.getJsonPayload();
    json errorPayload_2 = check response_2.getJsonPayload();
    test:assertEquals(errorPayload_1.message, "NIC cannot be empty");
    test:assertEquals(errorPayload_2.message, "NIC cannot be empty");
}

@test:Config {}
function testServiceWithInvalidNIC() returns error? {
    http:Response response_1 = check testClient->get("/identity/getIdentityFromNIC/?nic=1234567");
    http:Response response_2 = check testClient->get("/address/getGSDivisionFromNIC/?nic=12345689781367");
    test:assertEquals(response_1.statusCode, 500);
    test:assertEquals(response_2.statusCode, 500);
    json errorPayload_1 = check response_1.getJsonPayload();
    json errorPayload_2 = check response_1.getJsonPayload();
    test:assertEquals(errorPayload_1.message, "Invalid NIC");
    test:assertEquals(errorPayload_2.message, "Invalid NIC");
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("Completed Identity API Service tests...");
}
