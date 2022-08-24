// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import "./OrigamiSVGStrings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract OrigamiNFT is ERC721URIStorage, OrigamiSVGStrings {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewOrigamiNFTMinted(address sender, uint tokenId);

    struct NftHolder {
        uint[] tokens;
    }

    mapping(address => NftHolder) private nftHolders;

    string[] bgColours = [
        "#FFADAD",
        "#FFD6A5",
        "#FDFFB6",
        "#CAFFBF",
        "#9BF6FF",
        "#A0C4FF",
        "#BDB2FF",
        "#FFC6FF"
    ];
    string[] swordColours = [
        "#FBF8CC",
        "#FDE4CF",
        "#FFCFD2",
        "#F1C0E8",
        "#CFBAF0",
        "#A3C4F3",
        "#90DBF4",
        "#90DBF4",
        "#8EECF5",
        "#98F5E1",
        "#B9FBC0"
    ];

    constructor() ERC721("OrigamiSword", "OGSWORD") {
        console.log("Pastel origami swords");
        _tokenIds.increment();
    }

    function pickRandomBGColour(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BG_COLOUR", Strings.toString(tokenId)))
        );
        rand = rand % bgColours.length;
        return string(abi.encodePacked(bgSvg, bgColours[rand]));
    }

    function pickRandomBladeColour(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BLADE_COLOUR", Strings.toString(tokenId)))
        );
        rand = rand % swordColours.length;
        return
            string(
                abi.encodePacked(
                    bladeSvg1,
                    swordColours[rand],
                    bladeSvg2,
                    swordColours[rand]
                )
            );
    }

    function pickRandomHiltColourFirstHalf(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("HILT_COLOUR", Strings.toString(tokenId)))
        );
        rand = rand % swordColours.length;
        return
            string(
                abi.encodePacked(
                    hilt1,
                    swordColours[rand],
                    hilt2,
                    swordColours[rand],
                    hilt3,
                    swordColours[rand],
                    hilt4,
                    swordColours[rand],
                    hilt5,
                    swordColours[rand]
                )
            );
    }

    function pickRandomHiltColourSecondHalf(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("HILT_COLOUR", Strings.toString(tokenId)))
        );
        rand = rand % swordColours.length;
        return
            string(
                abi.encodePacked(
                    hilt6,
                    swordColours[rand],
                    hilt7,
                    swordColours[rand],
                    hilt8,
                    swordColours[rand],
                    hilt9,
                    swordColours[rand],
                    hilt10,
                    swordColours[rand],
                    svgEnd
                )
            );
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function setNftHolder(uint256 _tokenId) internal {
        nftHolders[msg.sender].tokens.push(_tokenId);
    }

    function getTokensByAddress(address _address)
        public
        view
        returns (uint[] memory)
    {
        return nftHolders[_address].tokens;
    }

    function mintOrigamiNFT() public {
        uint256 newNFTId = _tokenIds.current();

        require(newNFTId < 101, "All NFTs minted!");

        setNftHolder(newNFTId);

        string memory chosenBgColour = pickRandomBGColour(newNFTId);
        string memory chosenBladeColour = pickRandomBladeColour(newNFTId);
        string memory chosenHiltColour = pickRandomHiltColourFirstHalf(
            newNFTId
        );
        string memory chosenHiltColour2 = pickRandomHiltColourSecondHalf(
            newNFTId
        );

        string memory finalSvg = string(
            abi.encodePacked(
                chosenBgColour,
                chosenBladeColour,
                chosenHiltColour,
                chosenHiltColour2
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        "Origami Sword #",
                        Strings.toString(newNFTId),
                        '", "description": "A beautiful collection of razor sharp origami swords.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newNFTId);

        _setTokenURI(newNFTId, finalTokenUri);

        console.log(
            "New origami sword with ID %s minted to %s",
            newNFTId,
            msg.sender
        );

        _tokenIds.increment();

        emit NewOrigamiNFTMinted(msg.sender, newNFTId);
    }
}
