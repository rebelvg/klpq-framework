params ["_box", ["_side", sideEmpty]];

if (!isMultiplayer || mf_forceVirtualArsenal || ("AddVirtualArsenal" call BIS_fnc_getParamValue) == 1) then {
    if (_box isKindOf "thing") then {
        _box addAction ["Virtual Arsenal", {["Open", true] spawn BIS_fnc_arsenal}];
    };
};

if (_box isKindOf "thing") then {
    private _action = ["mf_paradrop_action", "Paradrop to Your Team", "", {[player] spawn mf_teamParadrop_fnc}, {mf_addParadropOption}] call ace_interact_menu_fnc_createAction;
    [_box, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    _action = ["mf_resetLoadout_action", "Reset Loadout", "", {
        [player] call mf_fnc_giveLoadout;
        [] spawn mf_fnc_acreSettings;
    }, {true}] call ace_interact_menu_fnc_createAction;
    [_box, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};

if (!isServer) exitWith {};

klpq_fm_var_boxes pushBackUnique [_box, _side];
