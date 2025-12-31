/*
    Starts a lightweight watcher that runs when the local player is assigned curator.
    Safe to call at client postInit.
*/

if (!hasInterface) exitWith {};
if (!(missionNamespace getVariable ["ACAT_EnableZeusActions", true])) exitWith {};

// Prevent starting multiple watchers
if (missionNamespace getVariable ["ACAT_ZeusWatcherStarted", false]) exitWith {};

try
{
	[] spawn
	{
	    private _hadCurator = false;

	    while { true } do
	    {
	        // Assigned curator logic (objNull when not Zeus)
	        private _curator = getAssignedCuratorLogic player;
	        private _hasCurator = !isNull _curator;

	        // Trigger on transition: not Zeus -> Zeus
	        if (_hasCurator && { !_hadCurator }) then
	        {
	            // Optional: also ensure ZEN is loaded/available
	            waitUntil { !isNil "zen_context_menu_fnc_addAction" };

	            // Register your ZEN context actions
	            call ACAT_fnc_registerZeusActions;
	        };

	        _hadCurator = _hasCurator;
	        uiSleep 1;   // cheap, sufficient; curator assignment is not time-critical
	    };
	};
	missionNamespace setVariable ["ACAT_ZeusWatcherStarted", true];
}
catch
{
	diag_log "[ACAT] Failed to add Zeus Watcher due to the following error: " + _exception 
};