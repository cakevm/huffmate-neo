// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "foundry-huff-neo/HuffNeoDeployer.sol";

interface IECDSA {
    function recoverCd(bytes32 hash, bytes calldata signature) external view returns (address);
    function recoverShortSig(bytes32 hash, bytes32 r, bytes32 vs) external view returns (address);
    function toEthSignedMessageHash(bytes32 hash) external view returns (bytes32);
    function toEthSignedMessageHashDyn(bytes memory s) external view returns (bytes32);
}

contract ECDSATest is Test {
    /// @notice ECDSA wrapper instance
    IECDSA public ecdsa;

    bytes32 constant TEST_MESSAGE = 0x7dbaf558b0a1a5dc7a67202117ab143c1d8605a983e4a743bc06fcc03162dc0d;

    bytes32 constant WRONG_MESSAGE = 0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3;

    address constant SIGNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    address constant V0_SIGNER = 0x2cc1166f6212628A0deEf2B33BEFB2187D35b86c;

    address constant V1_SIGNER = 0x1E318623aB09Fe6de3C9b8672098464Aeda9100E;

    function setUp() public {
        /// @notice deploy a new instance of ECDSA
        ecdsa = IECDSA(HuffNeoDeployer.deploy("test/utils/mocks/ECDSAWrappers.huff"));
    }

    function testRecoverWithInvalidShortSignatureReturnsZero() public {
        bytes memory signature = hex"1234";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithInvalidLongSignatureReturnsZero() public {
        bytes memory signature = hex"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithValidSignature() public {
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertTrue(ecdsa.recoverCd(ecdsa.toEthSignedMessageHash(TEST_MESSAGE), signature) == SIGNER);
    }

    function testRecoverWithWrongSigner() public {
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertTrue(ecdsa.recoverCd(ecdsa.toEthSignedMessageHash(WRONG_MESSAGE), signature) != SIGNER);
    }

    function testRecoverWithInvalidSignature() public {
        bytes memory signature = hex"332ce75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e01c";
        assertTrue(ecdsa.recoverCd(ecdsa.toEthSignedMessageHash(TEST_MESSAGE), signature) != SIGNER);
    }

    function testRecoverWithV0SignatureWithVersion00ReturnsZero() public {
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be89200";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV0SignatureWithVersion27() public {
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be8921b";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == V0_SIGNER);
    }

    function testRecoverWithV0SignatureWithWrongVersionReturnsZero() public {
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be89202";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV0SignatureWithShortEIP2098Format() public {
        bytes32 r = 0x5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f;
        bytes32 vs = 0x3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be892;
        assertTrue(ecdsa.recoverShortSig(TEST_MESSAGE, r, vs) == V0_SIGNER);
    }

    function testRecoverWithV0SignatureWithShortEIP2098FormatAsCalldataReturnsZero() public {
        bytes memory signature = hex"5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be892";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV1SignatureWithVersion01ReturnsZero() public {
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e001";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV1SignatureWithVersion28() public {
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e01c";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == V1_SIGNER);
    }

    function testRecoverWithV1SignatureWithWrongVersionReturnsZero() public {
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e002";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testRecoverWithV1SignatureWithShortEIP2098Format() public {
        bytes32 r = 0x331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff;
        bytes32 vs = 0xc8e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e0;
        assertTrue(ecdsa.recoverShortSig(TEST_MESSAGE, r, vs) == V1_SIGNER);
    }

    function testRecoverWithV1SignatureWithShortEIP2098FormatAsCalldataReturnsZero() public {
        bytes memory signature = hex"331fe75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feffc8e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e0";
        assertTrue(ecdsa.recoverCd(TEST_MESSAGE, signature) == address(0));
    }

    function testBytes32ToEthSignedMessageHash() public {
        assertTrue(ecdsa.toEthSignedMessageHash(TEST_MESSAGE) == bytes32(0x7d768af957ef8cbf6219a37e743d5546d911dae3e46449d8a5810522db2ef65e));
    }

    function testBytesToEthSignedMessageHashShort() public {
        bytes memory message = hex"61626364";
        assertTrue(ecdsa.toEthSignedMessageHashDyn(message) == bytes32(0xefd0b51a9c4e5f3449f4eeacb195bf48659fbc00d2f4001bf4c088ba0779fb33));
    }

    function testBytesToEthSignedMessageHashEmpty() public {
        bytes memory message = hex"";
        assertTrue(ecdsa.toEthSignedMessageHashDyn(message) == bytes32(0x5f35dce98ba4fba25530a026ed80b2cecdaa31091ba4958b99b52ea1d068adad));
    }

    function testBytesToEthSignedMessageHashEmptyLong() public {
        bytes memory message = hex"4142434445464748494a4b4c4d4e4f505152535455565758595a6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383921402324255e262a28292d3d5b5d7b7d";
        assertTrue(ecdsa.toEthSignedMessageHashDyn(message) == bytes32(0xa46dbedd405cff161b6e80c17c8567597621d9f4c087204201097cb34448e71b));
    }
}
