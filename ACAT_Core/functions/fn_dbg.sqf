/*
    ACAT_fnc_dbg
    Usage: ["message"] call ACAT_fnc_dbg;
*/

params [["_msg", "", [""]]];

if ((getNumber (configFile >> "CfgSettings" >> "ACAT" >> "debug")) > 0) then {
    systemChat format ["[ACAT][DBG] %1", _msg];
};
