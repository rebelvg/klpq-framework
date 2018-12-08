params ["_unit"];

if (!isServer) exitWith {};

[{time > 3}, {
    params ["_unit"];

    if (!(_unit in (switchableUnits + playableUnits)) || isPlayer _unit) then {
        {
            _x addCuratorEditableObjects [[_unit], true];
        } forEach allCurators;
    };
}, [_unit]] call CBA_fnc_waitUntilAndExecute;
