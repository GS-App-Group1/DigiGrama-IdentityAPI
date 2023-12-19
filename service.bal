import ballerina/http;
import ballerinax/mongodb;

type Identity record {|
    string _id;
    string nic;
    string name;
    string dob;
    string phoneNumber;
    string gsDivision;
    string civilStatus;
    string race;
    string nationality;
|};

# Configurations for the MongoDB endpoint
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;
configurable string collection = ?;

# A service representing a network-accessible API
# bound to port `9090`.
service /identity on new http:Listener(9090) {
    final mongodb:Client databaseClient;

    public function init() returns error? {
        self.databaseClient = check new ({connection: {url: string `mongodb+srv://${username}:${password}@digigrama.pgauwpq.mongodb.net/`}});
    }

    # A resource for getting the Identity of a given nic
    # + nic - NIC of the person
    # + return - Identity or error
    resource function get getIdentityFromNIC(string nic) returns json|error {
        stream<Identity, error?>|mongodb:Error IdentityStream = check self.databaseClient->find(collection, database, {nic: nic});
        Identity[]|error identities = from Identity Identity in check IdentityStream
            select Identity;

        return (check identities).toJson();
    }

    resource function get getGSDivisionFromNIC(string nic) returns json|error {
        stream<Identity, error?>|mongodb:Error IdentityStream = check self.databaseClient->find(collection, database, {nic: nic});
        Identity[]|error identities = from Identity Identity in check IdentityStream
            select Identity;

        return (check identities)[0].gsDivision.toJson();
    }
    resource function get liveness() returns http:Ok {
        return http:OK;
    }

    resource function get readiness() returns http:Ok|error {
        int _ = check self.databaseClient->countDocuments(collection, database);
        return http:OK;
    }
}
