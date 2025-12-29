/*
    ACAT Core - Spectate module wrapper
*/
scopeName "ACAT_addSpectateWrapper";

params ["_logic", "_units", "_activated"];

// Eden safety: ignore initial non-activation call
if (!isNil "_activated" && {!_activated}) exitWith {};

// Some Eden contexts can call module functions with a classname/string.
// Bail out safely if _logic isn't an object.
if !(_logic isEqualType objNull) exitWith {};

// Normalize _units (defensive)
if (isNil "_units" || { !(_units isEqualType []) }) then { _units = []; };

// Spectator UI is client-side
if (!hasInterface) exitWith {};

_isZeusModule = (typeOf _logic) isEqualTo "ACAT_Module_AddSpectate_Zeus";


// --- Resolve MODULE ATTRIBUTES ---
private _createTriggerArea = true;
private _a = 0;
private _b = 0;
private _angle = 0;
private _isRectangle = false;
private _height = -1;
private _trigger = objNull;
private _target  = objNull;

if (!_isZeusModule) then
{
	_createTriggerArea = _logic getVariable ["ACAT_createTriggerArea", false];
	{
		if (_x isKindOf "EmptyDetector") then { _trigger = _x; };
	} forEach _units;
	[format ["createTrigger=%1", _createTriggerArea]] call ACAT_fnc_dbg;
};

[format ["Wrapper ran. logic=%1 create=%2 zeus=%3", _logic, _createTriggerArea, _isZeusModule]] call ACAT_fnc_dbg;

// --- Resolve TARGET ---
if (_isZeusModule) then
{
    // Zeus: must be within 2m of an object (not a unit). Triggers will not match AllVehicles/Thing.
    private _near = nearestObjects [getPosATL _logic, ["AllVehicles","Thing"], 2];
    _near = _near select { !(_x isKindOf "CAManBase") && { _x != _logic } };

    if (_near isEqualTo []) exitWith {
        systemChat "[ACAT Spectate] Zeus module: place within 2m of an object (not a unit).";
        breakOut "ACAT_addSpectateWrapper";
    };

    _target = _near # 0;
}
else
{
    if (_createTriggerArea) then
    {
        // Eden: allow blank placement; centre on the module itself
        _target = _logic;
    }
    else
    {
        // Eden: using existing trigger; allow sync or nearest trigger within 1m
        if (isNull _trigger) then {
            private _nearTrg = nearestObjects [getPosATL _logic, ["EmptyDetector"], 1];
            if (_nearTrg isNotEqualTo []) then { _trigger = _nearTrg # 0; };
        };

        // If still no trigger, fail clearly (cannot "use existing trigger" without one)
        if (isNull _trigger) exitWith {
            systemChat "[ACAT Spectate] Editor module: place on / sync to a trigger, or enable 'Create Trigger Area'.";
            breakOut "ACAT_addSpectateWrapper";
        };

        // When using an existing trigger, that trigger is the target in addSpectate.sqf
        _target = _trigger;
    };
};

// --- Resolve AREA PARAMETERS ---
if (_isZeusModule) then
{
    _a = _logic getVariable ["ACAT_a", 5];
    _b = _logic getVariable ["ACAT_b", 5];
    _height = _logic getVariable ["ACAT_c", -1];
    _angle = _logic getVariable ["ACAT_angle", 0];
    _isRectangle = _logic getVariable ["ACAT_isRectangle", false];

    if (_a <= 0 || _b <= 0) exitWith {
        systemChat "[ACAT Spectate] Zeus module: set Area X/Y before execution.";
        breakOut "ACAT_addSpectateWrapper";
    };
}
else
{
    if (!_createTriggerArea) then
    {
        // Using existing trigger: pull its area (including height)
        private _ta = triggerArea _trigger; // [a,b,angle,isRectangle,c]
        _a = _ta # 0;
        _b = _ta # 1;
        _angle = _ta # 2;
        _isRectangle = _ta # 3;
        _height = _ta # 4;
    }
    else
    {
        // Creating a trigger in Eden: use module's area widget settings
        _objectarea = _logic getVariable ["objectArea",[0,0,0,false,0]]; //[x,y,dir,isRec,z]
        _a = _objectarea # 0;
        _b = _objectarea # 1;
        _angle = _objectarea # 2;
        _isRectangle =_objectarea # 3;
        _height = _objectarea # 4;
		[format ["Logic Size:. width=%1 length=%2 height=%3 Rotation=%4 Rectangle=%5", _a, _b, _height, _angle, _isRectangle]] call ACAT_fnc_dbg;

        if (_a <= 0 || _b <= 0) exitWith {
            systemChat "[ACAT Spectate] Editor module: set area size before creating trigger.";
            breakOut "ACAT_addSpectateWrapper";
        };
    };
};

// --- Call script with expected params ---
[
    _target,
    _createTriggerArea,
	_a,
	_b,
	_height,
	_angle,
    _isRectangle
] execVM "\ACAT_Core\scripts\addSpectate.sqf";
