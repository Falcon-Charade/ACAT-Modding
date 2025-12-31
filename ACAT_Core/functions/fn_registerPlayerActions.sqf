/*
    ACAT Core - Self Interact Scripts
*/

if (!hasInterface) exitWith {};   // only clients with UI

// Ensure player is ready
waitUntil { !isNull player && { alive player } };

//Check the setting is enabled
if (!(missionNamespace getVariable ["ACAT_EnablePlayerSelfActions", true])) exitWith {};
try 
{
  // Where we hang our submenu
  private _rootPath = ["ACE_SelfActions"];

  // Create a submenu "Player Actions"
  private _cat = [
    "fc_player_actions",
    "Player Actions",
    "\a3\ui_f\data\igui\cfg\HoldActions\holdAction_hack_ca.paa",
    {},         // no code on open
    { true }    // condition
  ] call ace_interact_menu_fnc_createAction;

    [typeOf player, 1, _rootPath, _cat] call ace_interact_menu_fnc_addActionToClass;

    // AFK action
    if (missionNamespace getVariable ["ACAT_EnableAFK", true]) then
    {
      private _afk = [
        "fc_afk",
        "AFK",
        "\a3\ui_f\data\igui\cfg\simpletasks\types\Use_ca.paa",
        { [] execVM "\ACAT_Core\scripts\afk.sqf"; },
        { true }
      ] call ace_interact_menu_fnc_createAction;
      [typeOf player, 1, _rootPath + ["fc_player_actions"], _afk] call ace_interact_menu_fnc_addActionToClass;
    };

    // SHBF action
    if (missionNamespace getVariable ["ACAT_EnableSHBF", true]) then
    {
      private _shbf = [
        "fc_shbf",
        "Super Head Bug Fix",
        "\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa",
        { [] execVM "\ACAT_Core\scripts\shbf.sqf"; },
        { true }
      ] call ace_interact_menu_fnc_createAction;
      [typeOf player, 1, _rootPath + ["fc_player_actions"], _shbf] call ace_interact_menu_fnc_addActionToClass;
    };

    // Stuck action
    if (missionNamespace getVariable ["ACAT_EnableStuck", true]) then
    {
      private _stuck = [
        "fc_stuck",
        "Stuck (nudge)",
        "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\help_ca.paa",
        { [] execVM "\ACAT_Core\scripts\stuck.sqf"; },
        { true }
      ] call ace_interact_menu_fnc_createAction;
      [typeOf player, 1, _rootPath + ["fc_player_actions"], _stuck] call ace_interact_menu_fnc_addActionToClass;
    };
}
catch
{
	diag_log "[ACAT] Failed to add Player Self-Interact Action(s) due to the following error: " + _exception 
};