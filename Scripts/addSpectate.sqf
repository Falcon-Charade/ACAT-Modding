/*
===================================================================================================
 Script:        addSpectate.sqf
 Title:         Add Spectate
 Author:        Falcon Charade |  Contact: Falcon Charade on github
 Version:       1.0.1          |  Last updated: 2025-09-22

 Description:
   Adds an ACE Spectate zone which is opened via a trigger area.
   The trigger can be placed in 3DEN for a custom size.
   A 12x12 trigger is created if the "_createTriggerArea" parameter = true

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
   2: Boolean - _createTriggerArea  (default: false)  - Determines if a trigger area needs to be made

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
  ["_createTriggerArea", false, [false]],
  ["_radius",1, [12]]
];


if (!hasInterface) exitWith {};   // Make sure this only runs on clients

if (_createTriggerArea) then {
	fc_3denSpectateTrigger = _this;
	fc_3denSpectateTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	fc_3denSpectateTrigger setTriggerStatements [
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
	fc_scriptSpectateTrigger = createTrigger ["EmptyDetector", getpos _target, false];
	fc_scriptSpectateTrigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	fc_scriptSpectateTrigger setTriggerArea [_radius, _radius, 0, false, 0];

	fc_scriptSpectateTrigger setTriggerStatements [
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