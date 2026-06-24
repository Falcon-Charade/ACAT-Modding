/*
    ACAT Core - Server init (addon replacement for initServer.sqf)
*/

if (!isServer) exitWith {};

try
{
	if (missionNamespace getVariable ["ACAT_EnableRoster", true]) then
	{
		// Gate variable (public)
		missionNamespace setVariable ["ACAT_canRunRoster", true, true];

		// Run once at mission start
		call ACAT_fnc_runPlatoonRoster;
	};

	// Log connections
	addMissionEventHandler ["PlayerConnected", {
	    params ["_id", "_uid", "_name", "_jip", "_owner"];

	    private _timeStamp = serverTime;
	    private _timeDate  = systemTime apply { if (_x < 10) then { "0" + str _x } else { str _x } };

	    private _formattedDate = format [
	        "%1-%2-%3 %4:%5",
	        _timeDate select 2,
	        _timeDate select 1,
	        _timeDate select 0,
	        _timeDate select 3,
	        _timeDate select 4
	    ];

	    diag_log format [
	        "[ACAT][PLAYER CONNECT] Time: %3 (uptime: %4s) | Name: %1 | UID: %2 | JIP: %5",
	        _name, _uid, _formattedDate, _timeStamp, _jip
	    ];

	    // Re-run roster on connect
	    if (missionNamespace getVariable ["ACAT_EnableRoster", true]) then {call ACAT_fnc_runPlatoonRoster};
	}];

	if (missionNamespace getVariable ["ACAT_EnableRoster", true]) then
	{
		// Re-run roster on disconnect
		addMissionEventHandler ["PlayerDisconnected", {
		    call ACAT_fnc_runPlatoonRoster;
		}];
	};
}
catch
{
	diag_log "[ACAT] Failed to run serverInit due to the following error: " + _exception 
}