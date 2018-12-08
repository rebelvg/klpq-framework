params ["_unit"];

if (!klpq_framework_enable) exitWith {};

if (isServer) then {
    [_unit] call kf_fnc_handleDacPlayer;
};

if (!local _unit) exitWith {};

if (!isMultiplayer) then {
    [_unit] call mf_disableAI_fnc;
};

if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
    if (!isPlayer _unit) then {
        removeAllItems _unit;
    };
};

[{
    params ["_unit"];

    if (!(_unit in (switchableUnits + playableUnits))) then {
        if (mf_customEnemyLoadouts) then {
            [_unit] call mf_fnc_giveLoadout;
        };

        if ((side group _unit) in mf_forceSideNVGs) then {
            _unit linkItem "ACE_NVG_Gen1";
        };
    };
}, [_unit]] call CBA_fnc_execNextFrame;
