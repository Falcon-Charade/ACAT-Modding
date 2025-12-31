/*
    ACAT Core - Zeus Scripts
*/

if (!hasInterface) exitWith {};   // only clients with UI

// Ensure player is ready
waitUntil { !isNull player && { alive player } };

//Check the setting is enabled
if (!(missionNamespace getVariable ["ACAT_EnableZeusActions", true])) exitWith {};

// Only register once per client
if (missionNamespace getVariable ["ACAT_ZeusActionsRegistered", false]) exitWith {};
try
{
	// Hide action
	if (missionNamespace getVariable ["ACAT_EnableZeusHide", true]) then
	{
		private _zHide = [
			"hideZeus",
			"Hide Zeus",
			"\a3\ui_f\data\igui\cfg\HoldActions\holdAction_search_ca.paa",
			{[LOGIC] call zen_modules_fnc_moduleHideZeus}
		] call zen_context_menu_fnc_createAction;
		[_zHide, [], 1] call zen_context_menu_fnc_addAction;
	};
	
	// Monitor action
	if (missionNamespace getVariable ["ACAT_EnableMonitor", true]) then
	{
		private _zMonitor = [
			"fpsMonitor",
			"Toggle FPS Monitor",
			"\a3\ui_f\data\igui\cfg\HoldActions\holdAction_hack_ca.paa",
			{private _start = (isNil 'FPSMON_handle') || {isNull FPSMON_handle}; [_start, 3] execVM '\ACAT_Core\scripts\monitor.sqf'},
			{hasInterface && !isNull findDisplay 312}
		] call zen_context_menu_fnc_createAction;
		[_zMonitor, [], 1] call zen_context_menu_fnc_addAction;
	};
	missionNamespace setVariable ["ACAT_ZeusActionsRegistered", true];
}
catch
{
	diag_log "[ACAT] Failed to add Zeus Action(s) due to the following error: " + _exception 
};

//#include "fn_addZeusContext.hpp"