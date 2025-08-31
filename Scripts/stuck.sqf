/*
===================================================================================================
 Script:        stuck.sqf
 Title:         Stuck Player
 Author:        Falcon Charade |  Contact: Falcon Charade on github
 Version:       1.0.0          |  Last updated: 2025-08-31

 Description:
   Moves a player to a nearby location to stop them being stuck.
   Will post a small message in system chat to avoid being abused.

 Usage:
   To execute the script:
      [] execVM "scripts\stuck.sqf";

 Locality & Environment:
   Execution:      Scheduled
   Locality:       Client
   JIP-safe:       Yes
   RemoteExec:     Yes
   Reentrancy:     Not safe

 Dependencies:
   Required mods:  CBA, ACE

 Performance Notes:
   Complexity: Simple
   Recommended call rate: No faster than every 1s

 License:
   Copyright © 2025 FalconCharade All rights reserved.
   Except where otherwise noted, this work is licensed under CC BY-NC-SA 4.0,
   available for reference at <https://creativecommons.org/licenses/by-nc-sa/4.0>
===================================================================================================
*/
private _pos = 
[
  player, // centred on player
  1,      // min dist 1m
  10,     // max dist 20m
  5,      // 5m from objects
  0,      // Cannot be in water (0 = not in water, 1 = either in or out, 2 = Must be in water
  25     // Max gradient 25 deg
] call BIS_fnc_findSafePos;
_user = profilename;
_announce = _user + " has been nudged";
player setpos _pos;
_announce remoteExec ["systemchat", 0, false];