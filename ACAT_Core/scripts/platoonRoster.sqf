/*
===================================================================================================
 Script:        platoonRoster.sqf
 Title:         Add Platoon Roster to Track Players
 Author:        Falcon Charade
 Version:       1.0.0          |  Last updated: 2025-08-30

 Description:
   Adds a Platoon Roster in the map menu. This will show the sections each player is in.
   This will also highlight special roles like Medics and Engineers.
   This will also highlight ranks to indicate leaders, such as sergeant and lieutenant.

 Usage:
   In "initServer.sqf", call the following to start the roster:
      missionNamespace setVariable ["canRun", true, true];
      [] execvm "scripts\PlatoonRoster.sqf";
   In "initplayerlocal.sqf", call the following to start the player's UI:
      ["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;
   Running when a player connects or disconnects is advised to keep the roster up to date:
      addMissionEventHandler ["PlayerConnected", {
         "PlatoonRoster.sqf" remoteExec ["execVM", 2, false];
      }
	  addMissionEventHandler ["PlayerDisconnected", {
         "PlatoonRoster.sqf" remoteExec ["execVM", 2, false];
      }

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
   Recommended call rate: No faster than every 10s
===================================================================================================
*/

// --- Build a map of groups to player display names (with icons) ---
private _rosterMap = createHashMap;

// --- Rank weights (Arma ranks) ---
private _rankWeight = createHashMapFromArray [
    ["PRIVATE",0],
    ["CORPORAL",1],
    ["SERGEANT",2],
    ["LIEUTENANT",3],
    ["CAPTAIN",4],
    ["MAJOR",5],
    ["COLONEL",6]
];

// --- Build: group -> [players with icons]; group -> maxRankWeight ---
private _rosterMap    = createHashMap;
private _groupMaxRank = createHashMap;

{
    // Gather player info
    private _grpname     = groupId (group _x);
    private _playerrank  = rank _x;
    private _playermed   = _x getVariable ["ace_medical_medicClass", 0];
    private _playerengi  = _x getVariable ["ace_isEngineer", 0];
    private _playerEOD   = _x getVariable ["ace_isEOD", false];
    private _playerZeus  = getAssignedCuratorLogic _x;

    // Base name via ACE (matches your original)
    private _playerID    = [_x, false, false] call ace_common_fnc_getName;

    // --- Build _playerIcon exactly like your original ---
    private _playerIcon = "";
    switch (_playerrank) do {
        case "COLONEL":    {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\colonel_gs.paa' width='16' height='16'/></font>";};
        case "MAJOR":      {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\major_gs.paa' width='16' height='16'/></font>";};
        case "CAPTAIN":    {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\captain_gs.paa' width='16' height='16'/></font>";};
        case "LIEUTENANT": {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\lieutenant_gs.paa' width='16' height='16'/></font>";};
        case "SERGEANT":   {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\sergeant_gs.paa' width='16' height='16'/></font>";};
        case "CORPORAL":   {_playerIcon = "<font color='#fae051' img image='\A3\Ui_f\data\GUI\Cfg\Ranks\corporal_gs.paa' width='16' height='16'/></font>";};
        default {};
    };

    if (!isNull _playerZeus) then {
        _playerIcon = _playerIcon + "<font color='#CCFFFF' img image='a3\modules_f_curator\Data\portraitCurator_ca.paa' width='16' height='16'/></font>";
    }
	else {
		if (_playermed == 2) then {
			_playerIcon = _playerIcon + "<font color='#FF3535' img image='\a3\ui_f\data\igui\cfg\simpletasks\types\Heal_ca.paa' width='16' height='16'/></font>";
		};
		if (_playermed == 1) then {
			_playerIcon = _playerIcon + "<font color='#aa2525' img image='\z\ace\addons\zeus\ui\Icon_Module_Zeus_Medic_ca.paa' width='16' height='16'/></font>";
		};
		if (_playerengi == 2) then {
			_playerIcon = _playerIcon + "<font color='#777777' img image='\a3\ui_f\data\igui\cfg\simpletasks\types\Use_ca.paa' width='16' height='16'/></font>";
		};
		if (_playerengi == 1) then {
			_playerIcon = _playerIcon + "<font color='#555555' img image='\z\ace\addons\explosives\UI\Defuse_ca.paa' width='16' height='16'/></font>";
		};
		if (_playerEOD == true) then {
			_playerIcon = _playerIcon + "<font color='#ffaf3d' img image='\a3\ui_f\data\igui\cfg\simpletasks\types\destroy_ca.paa' width='16' height='16'/></font>";
		};
	};

    private _displayName = _playerIcon + _playerID;
    private _w = if (isNil {_rankWeight get _playerrank}) then {-1} else {_rankWeight get _playerrank};

    // add to group list
    if (isNil {_rosterMap get _grpname}) then { _rosterMap set [_grpname, []]; };
    private _list = +(_rosterMap get _grpname);
    // store [weight, displayName, plainName] so we can sort by weight then name
    _list pushBack [_w, _displayName, _playerID];
    _rosterMap set [_grpname, _list];

    // track group's highest rank weight
    private _cur = if (isNil {_groupMaxRank get _grpname}) then {-1} else {_groupMaxRank get _grpname};
    if (_w > _cur) then { _groupMaxRank set [_grpname, _w]; };

} forEach allPlayers;// NOTE: Use allPlayers for MP. For local testing including AI, switch to playableUnits/allUnits.



// --- Sort groups by highest rank (desc), tie-break by group name (asc) ---
// Use BIS_fnc_sortBy with a composite key: [-weight, groupName] ascending
private _groups = keys _rosterMap;
_groups sort true; // pre-sort alphabetically (optional)
private _sortedGroups = [
    _groups,
    [],
    {
        private _w = if (isNil {_groupMaxRank get _x}) then {-1} else {_groupMaxRank get _x};
        [ - _w, _x ]                    // primary: -rankWeight (so higher rank sorts first), secondary: group name (asc)
    },
    "ASCEND"
] call BIS_fnc_sortBy;

// --- Build final roster text ---
private _platrosterfinal = "";
{
    private _g = _x;
    private _members = +(_rosterMap get _g); // [[w, display, name], ...]
    
    // Build sortable tuples: [primaryKey, secondaryKey, payload]
    // primary: -weight (so higher rank first), secondary: UPPER(name) (A->Z)
    private _tuples = _members apply {
        private _w    = _x select 0;
        private _disp = _x select 1;
        private _name = _x select 2;
        [ -_w, toUpper _name, _x ]        // payload is the original [w,display,name]
    };
    
    // Lexicographic ascending on [ -w, NAME ]
    _tuples sort true;
    
    // Extract back the original member triples, now sorted
    private _sortedMembers = _tuples apply { _x select 2 };
    
    // turn into string of display names (with icons)
    private _memberText = (_sortedMembers apply { _x select 1 }) joinString ",  ";
    
    if ((count _sortedMembers) > 0) then {
        _platrosterfinal = _platrosterfinal
            + format ["<font color='#ffffff'>%1</font><br/>%2<br/><br/>", _g, _memberText];
    };
} forEach _sortedGroups;

// --- Publish + write diary (same as your original) ---
missionNamespace setVariable ["platroster", _platrosterfinal, true];
publicVariable "platroster";

[{
    private _fullroster = "";
    player removeDiarySubject "PltRoster";
    _fullroster = missionNamespace getVariable "platroster";
    player createDiarySubject ["PltRoster","Platoon Roster"];
    player createDiaryRecord ["PltRoster", ["Platoon Roster", format ["%1", _fullroster]]];
}] remoteExec ["call", 0, true];