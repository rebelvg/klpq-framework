params ["_vehicle"];

[_vehicle] call {
    params ["_vehicle"];

    if !(_vehicle isKindOf "air") exitWith {};

    private _simType = toLower getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "simulation");

    if (_simType in ["parachute", "paraglide"]) exitWith {};

    private _action = ["klpq_menu_action_jumpOut", "Jump Out (Paradrop)", "", {
        params ["_vehicle"];

        private ["_LX", "_LY", "_LZ"];
        _LX = (getPos _vehicle select 0) + (15 * sin ((getDir _vehicle) - 180));
        _LY = (getPos _vehicle select 1) + (15 * cos ((getDir _vehicle) - 180));
        _LZ = (getPos _vehicle select 2);

        format ["%1 jumped out.", name player] remoteExec ["systemChat", crew _vehicle];

        private _parachute = createVehicle ["Steerable_Parachute_F", [_LX,_LY,_LZ], [], 0, "NONE"];
        player moveInAny _parachute;
        _parachute allowDamage false;
    }, {
        params ["_vehicle"];

        private _LZ = (getPosATL _vehicle select 2);

       _LZ > 5 && !visibleMap
    }] call ace_interact_menu_fnc_createAction;
    [_vehicle, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

[_vehicle] call {
    params ["_vehicle"];

    (vehicle _vehicle) removeAction ((vehicle _vehicle) getVariable ["ace_aircraft_ejectAction", -1]);
};

if (!isServer) exitWith {};

[{time > 3}, {
    params ["_vehicle"];

    {
        _x addCuratorEditableObjects [[_vehicle], true];
    } forEach allCurators;
}, [_vehicle]] call CBA_fnc_waitUntilAndExecute;
