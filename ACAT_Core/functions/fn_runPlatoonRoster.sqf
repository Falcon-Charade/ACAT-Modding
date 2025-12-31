/*
    ACAT Core - Runs the roster script on the server with re-entry protection
*/

if (!isServer) exitWith {};

private _canRun = missionNamespace getVariable ["ACAT_canRunRoster", true];
if (!_canRun) exitWith {};

missionNamespace setVariable ["ACAT_canRunRoster", false, true];

// Run your script (addon path)
[] spawn {
    // If your PlatoonRoster.sqf expects to run scheduled, spawn is correct.
    [] execVM "\ACAT_Core\scripts\PlatoonRoster.sqf";

    // Lockout window to stop PlatoonRoster running too often
    sleep 10;
    missionNamespace setVariable ["ACAT_canRunRoster", true, true];
};
