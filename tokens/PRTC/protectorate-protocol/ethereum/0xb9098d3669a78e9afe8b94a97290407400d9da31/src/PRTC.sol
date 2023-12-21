// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

/*
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMWdllldNMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMM0kkkNd.'dkx,.oNkkk0MMMMMMMMMMMMM
MMMMMMMMMMMO,.:ll'..WMMMM..'ll:.'OMMMMMMMMMMM
MMMMMMMMMMM, KMMMW..MMMMM..WMMMX 'MMMMMMMMMMM
MMMMMMMMMMM, NMMMM'.MMMMM..MMMMW.'MMMMMMMMMMM
MMMMMMMMMMM, NMMMM'.MMMMM..MMMMW.'MMMMMMMMMMM
MMMMMMMMMMM, NMMMM'.MMMMM..MMMMW.'MMMMMMMMMMM
MMMMMMMMMMM, NMMMM'.MMMMM..MMMMW.'MMMMMMMMMMM
MMMMMMMMMMM, NMMMM'.MMMMM..MMMMW.'MMMMMMMMMMM
MMMM0o::::l. NMMMM,lMMMMMo'MMMMW..o::::o0MMMM
MMO,.ck00Od. NMMMMWMWd'oWMWMMMMW..oO00kl.'OMM
MMK;.cXMMMMMOWMMMMMWOkOkOWMMMMMWkWMMMMXc.;0MM
MMMMX:.:KMMMMMMMMMNOxdooxOXMMMMMMMMMXc.:KMMMM
MMMMMMX: :WMMMMKl.         .c0MMMMMc ;KMMMMMM
MMMMMMMM: OMM0;.cOc       :0l.,OMM0 ;MMMMMMMM
MMMMMMMMo kMl .XMMl       cMMN' cM0 lMMMMMMMM
MMMMMMMMo kMMO'.oNWd'   .oWWd.'kMM0 lMMMMMMMM
MMMMMMMMO..xWMMO,.:kKXXXKkc.,OMMMk'.OMMMMMMMM
MMMMMMMMMWx..dWMMNxc,'..,cxXMMWx..xWMMMMMMMMM
MMMMMMMMMMMWk..dWMMMMMMMMMMMWx..xWMMMMMMMMMMM
MMMMMMMMMMMMMMk'.cxkkkkkkkxl.'kMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMM0doooooooood0MMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
*/

/// @title PRTC
/// @author Protectorate
/// @notice Token contract for PRTC.
contract PRTC is ERC20 {
    constructor(address _recipient) ERC20("Protectorate", "PRTC") {
        _mint(_recipient, 100_000_000e18);
    }
}