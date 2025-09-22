/*
===================================================================================================
 Script:        afk.sqf
 Title:         Player AFK
 Author:        Falcon Charade |  Contact: Falcon Charade on github
 Version:       1.0.1          |  Last updated: 2025-08-27

 Description:
   Allows a player to toggle afk, and avoid taking damage.
   Going AFK moves their model underground and places blue arrow where they stood.
   Returning from AFK deletes the blue arrow and places the player where they stood before.

 Usage:
   Example 1 - Runs on the player calling the script: 
      [] execVM "afk.sqf";

 Returns:
   true on success

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
   Recommended call rate: No faster than every 2s

 License:
   Copyright © 2025 FalconCharade All rights reserved.
   Except where otherwise noted, this work is licensed under CC BY-NC-SA 4.0,
   available for reference at <https://creativecommons.org/licenses/by-nc-sa/4.0>
===================================================================================================
*/

if (player getVariable ["afk", false]) then {
	//Move to surface and delete flag
	_user = profilename;
	_userAFK = _user + " AFK";
	player setPosASL [getPosASL player select 0, getPosASL player select 1, (getPosASL player select 2) +50];
	_plrLoc = getPos player;
	_AFKGRAVE = missionNamespace getVariable [_userAFK, nearestObjects [_plrLoc, ["Sign_Arrow_Large_Blue_F"], 3]];
	deleteVehicle _AFKGRAVE;
	player enableSimulationGlobal true;
	player hideObjectGlobal false;
	
	//Reset AFK variable
	_announce = _user + " is back from AFK";
	_announce remoteExec ["systemchat", 0, false];
	player setVariable ["afk", false, 0];
	cutText [" ", "BLACK IN", 1];
} else {
	//Set AFK variables
	cutText ["AFK", "BLACK OUT", 0.001];
	player setVariable ["afk", true, 0];
	_relPos = [0,1,1];
	_worldPos = player modelToWorld _relPos;
	_plrDir = getDir player;
	_AFKDir = (_plrDir + 180);
	_user = profilename;
	_userAFK = _user + " AFK";
	
	//Create flag
	_AFKGRAVE = createVehicle ["Sign_Arrow_Large_Blue_F", _worldPos, [], 0, "NONE"];
	_AFKGRAVE setDir _AFKDir;
	_AFKGRAVE setpos _worldPos;
	_ARRTEX = "#(argb,8,8,3)color(0,0,1,0.25,ca)";
	_AFKGRAVE setObjectTextureGlobal [0, _texture];
	_AFKGRAVE allowDamage false;
	missionnamespace setVariable [_userAFK, _AFKGRAVE, true];
	
	//AFK Message
	_announce = _user + " is AFK";
	_announce remoteExec ["systemchat", 0, false];
	
	//Move underground
	player enableSimulationGlobal false;
	player hideObjectGlobal true;
	player setPosASL [getPosASL player select 0, getPosASL player select 1, (getPosASL player select 2) -50];
	sleep 0.1;
	_AFKGRAVE enableSimulation false;
};
