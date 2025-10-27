// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Chainlink, ChainlinkClient} from "@chainlink/contracts/src/v0.8/operatorforwarder/ChainlinkClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract ConsumerContract is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10; // 0.1 LINK
    bytes32 private externalJobId;
    string public lastRetrievedInfo;

    event RequestForInfoFulfilled(bytes32 indexed requestId, string indexed response);

    constructor() ConfirmedOwner(msg.sender) {
        _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);   // Ethereum Sepolia LINK
        _setChainlinkOracle(0x52Ee9d274b3059575672389C372C03D97Ab71D2a);  // # Oracle contract address per Rational Link 
        externalJobId = "9b12d1e1cc6645e09a50c1c30bda7171";               // # Job id per Rational Link 
    }


    function requestInfo(
        address _oracle,
        string memory _jobId,
        uint256 exchars,  // Changed from string to uint256
        string memory titles
    ) public onlyOwner {
        Chainlink.Request memory req = _buildOperatorRequest(
            stringToBytes32(_jobId),
            this.fulfillRequestInfo.selector
        );
        req._add("titles", titles);
        // Encode the uint256 as bytes for the Chainlink request
        req._add("exchars", abi.encode(exchars));
        _sendOperatorRequestTo(_oracle, req, ORACLE_PAYMENT);
    }


    function fulfillRequestInfo(bytes32 _requestId, string memory _info)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestForInfoFulfilled(_requestId, _info);
        lastRetrievedInfo = _info;
    }

  function stringToBytes32(
    string memory source
  ) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly {
      // solhint-disable-line no-inline-assembly
      result := mload(add(source, 32))
    }
  }

    // Helper function to convert uint256 to string
function uint256ToString(uint256 value) public pure returns (string memory) {
    if (value == 0) return "0";
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
        digits++;
        temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    temp = value;
    for (uint256 i = digits; i > 0; i--) {
        buffer[i - 1] = bytes1(uint8(48 + temp % 10));
        temp /= 10;
    }
    return string(buffer);
}
}