// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DIDRegistry {
    struct Key {
        uint256 purpose;
        bytes32 keyData;
    }

    struct Attestation {
        address attester;
        bytes32 claim;
    }

    mapping (uint256 => Key) public keys;
    uint256 public keyCount;

    mapping (bytes32 => bool) public claims;
    mapping (bytes32 => Attestation) public attestations;

    event KeyAdded(uint256 indexed key, uint256 indexed purpose, bytes32 keyData);
    event KeyRemoved(uint256 indexed key, uint256 indexed purpose);
    event ClaimAdded(bytes32 indexed claim);
    event ClaimRemoved(bytes32 indexed claim);
    event AttestationAdded(bytes32 indexed claim, address indexed attester);

    constructor() {
        // Assign the default purpose to the contract deployer
        addKey(msg.sender, 1, bytes32(0));
    }

    modifier onlyManagement() {
        require(keys[msg.sender].purpose == 1, "Not authorized");
        _;
    }

    function addKey(address _key, uint256 _purpose, bytes32 _keyData) public onlyManagement {
        require(_key != address(0), "Invalid address");
        require(keys[_key].purpose == 0, "Key already exists");

        keys[_key] = Key({
            purpose: _purpose,
            keyData: _keyData
        });

        keyCount++;

        emit KeyAdded(uint256(uint160(_key)), _purpose, _keyData);
    }

    function removeKey(address _key, uint256 _purpose) public onlyManagement {
        require(keys[_key].purpose == _purpose, "Purpose does not match");

        delete keys[_key];
        keyCount--;

        emit KeyRemoved(uint256(uint160(_key)), _purpose);
    }

    function addClaim(bytes32 _claim) public onlyManagement {
        require(!claims[_claim], "Claim already exists");
        claims[_claim] = true;
        emit ClaimAdded(_claim);
    }

    function removeClaim(bytes32 _claim) public onlyManagement {
        require(claims[_claim], "Claim does not exist");
        delete claims[_claim];
        emit ClaimRemoved(_claim);
    }

    function attestClaim(bytes32 _claim, address _attester) public onlyManagement {
        require(!attestations[_claim].attester, "Attestation already exists");
        attestations[_claim] = Attestation({
            attester: _attester,
            claim: _claim
        });
        emit AttestationAdded(_claim, _attester);
    }

    function getAttestation(bytes32 _claim) public view returns (address attester, bytes32 claim) {
        Attestation storage att = attestations[_claim];
        return (att.attester, att.claim);
    }

    function getKeyPurpose(address _key) public view returns (uint256) {
        return keys[_key].purpose;
    }

    function getKeyData(address _key) public view returns (bytes32) {
        return keys[_key].keyData;
    }

    function hasClaim(bytes32 _claim) public view returns (bool) {
        return claims[_claim];
    }
}
