/*
===================================================================================================
 Script:        addSpectate.sqf
 Title:         Add Spectate
 Author:        Falcon Charade
 Version:       1.0.2          |  Last updated: 2025-12-28

 Description:
   Adds an ACE Spectate zone which is opened via a trigger area.
   The trigger can be created for a custom size, with a default size of 20x20m.
   If used on an existing trigger (_createTriggerArea=false), the trigger’s existing area is preserved.
   _height=-1 means infinite height.

 Usage:
   Example 1 - Uses the trigger "tv" for the spectate area: 
      tv execVM 'addSpectate.sqf';
   Example 2 - Creates trigger over the object with the default size of 20×20m: 
      [_this, true] execVM 'addSpectate.sqf';
   Example 3 - Creates trigger over the object with a circular size of 5m, 6m tall: 
      [_this, true, 5, 5, 6, 0, false] execVM 'addSpectate.sqf';
   Example 4 - Creates trigger over the object with a rectangular size of 5m by 10m, 3m tall: 
      [_this, true, 5, 10, 3, 0, true] execVM 'addSpectate.sqf';
   Example 5 - Creates a trigger over hovered entity with default size (requires ZeusEnhanced):
      [_hoveredEntity,true] execVM 'addSpectate.sqf';

 Parameters:
   0: <type> - <name>  (default: <value>)  - <what it is / units / allowed values>
   1: Object - _target  (default: objNull)  - Dictates the centre of the spectate area
   2: Boolean - _createTriggerArea (default: false) - Determines if a trigger area needs to be made
   3: Number - _a (default: 10) - Determines half the width of the trigger area
   4: Number - _b (default: 10) - Determines half the length of the trigger area
   5: Number - _height (default: -1) - Determines half the height of the trigger area
   6: Number - _angle (default: 0) - Determines the rotational angle of the trigger area
   7: Boolean - _isRectangle (default: false) - Determines if the trigger should be a rectangle

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
===================================================================================================
*/

params [
  ["_target", objNull, [objNull]], 
  ["_createTriggerArea", false, [false]],
  ["_a", 10, [0]],
  ["_b", 10, [0]],
  ["_height", -1, [0]],
  ["_angle", 0, [0]],
  ["_isRectangle", false, [false]]
];


if (!hasInterface) exitWith {};   // Make sure this only runs on clients

if (_createTriggerArea) then {
	private _trg = createTrigger ["EmptyDetector", getPosATL _target, false];
	_trg setTriggerActivation ["ANY", "PRESENT", true];
	_trg setTriggerArea [_a, _b, _angle, _isRectangle, _height];

	_trg setTriggerStatements [
	// Condition
	"player inArea thisTrigger",
	
	"private _actionId = player addAction ['Spectate',
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
		hint (composeText _txt);
		thisTrigger setVariable ['ACAT_specActionId', _actionId];",
		"private _id = thisTrigger getVariable ['ACAT_specActionId', -1];
		if (_id >= 0) then { player removeAction _id; };
		hint '';
		[false] call ace_spectator_fnc_setSpectator;
		if !(isnil 'TFAR_fnc_forceSpectator') then {
			[player, false] call TFAR_fnc_forceSpectator;
		};"
	];
}
else {
	if !(_target isKindOf "EmptyDetector") exitWith {
		systemChat "[ACAT] Expected an existing trigger when Create Trigger Area is disabled.";
	};
	private _trg = _target;
	_trg setTriggerActivation ["ANY", "PRESENT", true];
	_trg setTriggerStatements [
	// Condition
	"player inArea thisTrigger",

	"private _actionId = player addAction ['Spectate',
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
		hint (composeText _txt);
		thisTrigger setVariable ['ACAT_specActionId', _actionId];",
		"private _id = thisTrigger getVariable ['ACAT_specActionId', -1];
     	if (_id >= 0) then { player removeAction _id; };
		hint '';
		[false] call ace_spectator_fnc_setSpectator;
		if !(isnil 'TFAR_fnc_forceSpectator') then {
			[player, false] call TFAR_fnc_forceSpectator;
		};"
	];
};