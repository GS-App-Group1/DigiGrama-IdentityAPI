isolated function validateNIC(string nic) returns true|error {
    if (nic == "") {
        return error("NIC cannot be empty");
    }

    if (nic.length() < 10 || nic.length() > 12) {
        return error("Invalid NIC");
    }

    return true;
}
