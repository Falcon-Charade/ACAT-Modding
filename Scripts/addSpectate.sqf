/*
===================================================================================================
 Script:        addSpectate.sqf
 Title:         Add Spectate
 Author:        Falcon Charade |  Contact: Falcon Charade on github
 Version:       1.0.0          |  Last updated: 2025-08-27

 Description:
   Adds an ACE Spectate zone which is opened via a trigger area.
   The trigger can be placed in 3DEN for a custom size.
   A 12x12 trigger is created if the "_zeusMenu" parameter = true

 Usage:
   Example 1 - Uses the trigger "tv" for the spectate area: 
      tv execVM 'addSpectate.sqf';
   Example 2 - Creates trigger over the object: 
      [_this, true] execVM 'addSpectate.sqf';
   Example 3 - Creates a trigger over hovered entity (requires ZeusEnhanced):
      [_hoveredEntity,true] execVM 'addSpectate.sqf';

 Parameters:
   0: <type> - <name>  (default: <value>)  - <what it is / units / allowed values>
   1: Object - _target  (default: objNull)  - Dictates the centre of the spectate area
   2: Boolean - _zeusMenu  (default: false)  - Determines if a trigger area needs to be made

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
   Recommended call rate: No faster than every 5s

 License:
   Copyright © 2025 FalconCharade All rights reserved.
   Except where otherwise noted, this work is licensed under CC BY-NC-SA 4.0,
   available for reference at <https://creativecommons.org/licenses/by-nc-sa/4.0>
===================================================================================================
*/

params [
  ["_target", objNull, [objNull]], 
  ["_zeusMenu", false, [true]]
];


// addSpectate.sqf  (ACE spectator version, per-client, robust cleanup)
if (!hasInterface) exitWith {};   // Make sure this only runs on clients

// Choose a position for the spectate area. If you pass _target, use that; otherwise use the player.
//private _pos = if (!isNil "_target") then { getPos _target } else { getPos player };

if (isNil "fc_spectateTrigger") then {
	if (!_zeusMenu) then {
		_this setTriggerStatements [
		// Condition
		"player in thisList",
	
		"specAction = player addAction ['Spectate',
				{
					[true,false,true] call ace_spectator_fnc_setSpectator;
					[[0,1,2],[]] call ace_spectator_fnc_updateCameraModes;
					[[], allUnits] call ace_spectator_fnc_updateUnits;
					_sideUnits = units (side player);
					[_sideUnits, [player]] call ace_spectator_fnc_updateUnits;
					_civUnits = units civilian;
					[_civUnits, [player]] call ace_spectator_fnc_updateUnits;
					private _sides = [WEST,EAST,independent];
					_sides = _sides - [side player];
					[[side player,civilian], _sides] call ace_spectator_fnc_updateSides;
				},nil, 1.5, false, true, '', 'true', 15, false, ''];
			private _txt = [parseText 'In Spectate Area',lineBreak,'Use scroll wheel to enter Spectator mode',lineBreak,lineBreak,'To leave Spectator mode', lineBreak,'Press Escape'];
			hint (composeText _txt);",
			"player removeAction specAction;
			hint '';
			[false] call ace_spectator_fnc_setSpectator;
			if !(isnil 'TFAR_fnc_forceSpectator') then {
				[player, false] call TFAR_fnc_forceSpectator;
			};"
		];
	}
	else {
		if (isNull _target) exitwith{["Please hover over an object when trying to add spectate", "Spectate Creations Error"] call BIS_fnc_guiMessage};
		fc_spectateTrigger = createTrigger ["EmptyDetector", getpos _target, false];
		fc_spectateTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
		fc_spectateTrigger setTriggerArea [12, 12, 0, false, 0];
	
		fc_spectateTrigger setTriggerStatements [
		// Condition
		"player in thisList",
	
		"specAction = player addAction ['Spectate',
				{
					[true,false,true] call ace_spectator_fnc_setSpectator;
					[[0,1,2],[]] call ace_spectator_fnc_updateCameraModes;
					[[], allUnits] call ace_spectator_fnc_updateUnits;
					_sideUnits = units (side player);
					[_sideUnits, [player]] call ace_spectator_fnc_updateUnits;
					_civUnits = units civilian;
					[_civUnits, [player]] call ace_spectator_fnc_updateUnits;
					private _sides = [WEST,EAST,independent];
					_sides = _sides - [side player];
					[[side player,civilian], _sides] call ace_spectator_fnc_updateSides;
				},nil, 1.5, false, true, '', 'true', 15, false, ''];
			private _txt = [parseText 'In Spectate Area',lineBreak,'Use scroll wheel to enter Spectator mode',lineBreak,lineBreak,'To leave Spectator mode', lineBreak,'Press Escape'];
			hint (composeText _txt);",
			"player removeAction specAction;
			hint '';
			[false] call ace_spectator_fnc_setSpectator;
			if !(isnil 'TFAR_fnc_forceSpectator') then {
				[player, false] call TFAR_fnc_forceSpectator;
			};"
		];
	};
} else {
    ['ACAT: Spectate area already defined. Only one allowed.','Spectate Creation Error'] call BIS_fnc_guiMessage;
    ['[SPECTATE ERROR] ACAT: Spectate area already defined. Only one allowed'] remoteExec ['diag_log', 0, true];
};