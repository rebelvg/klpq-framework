murshun_giveUniform_fnc = {
    params ["_unit", "_className"];

    if (!isClass (configFile >> "CfgWeapons" >> _className)) exitWith {};

    _unit forceAddUniform _className;
};

murshun_giveVest_fnc = {
    params ["_unit", "_className"];

    if (!isClass (configFile >> "CfgWeapons" >> _className)) exitWith {};

    _unit addVest _className;
};

murshun_giveHeadgear_fnc = {
    params ["_unit", "_className"];

    if (!isClass (configFile >> "CfgWeapons" >> _className)) exitWith {};

    _unit addHeadgear _className;
};

murshun_giveBackpack_fnc = {
    params ["_unit", "_className"];

    if (!isClass (configFile >> "CfgVehicles" >> _className)) exitWith {};

    _unit addBackpack _className;
};

murshun_giveGoggles_fnc = {
    params ["_unit", "_className"];

    if (!isClass (configFile >> "CfgGlasses" >> _className)) exitWith {};

    _unit addGoggles _className;
};

murshun_giveWeapon_fnc = {
    params ["_unit", "_weaponArray"];

    _weaponArray params [["_weapon", ""], ["_mags", []], ["_devices", []]];

    if (isClass (configFile >> "CfgWeapons" >> _weapon)) then {
        _unit addWeapon _weapon;
    };

    {
        _x params [["_mag", ""], ["_count", 0]];

        if (count _mag != 0) then {
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "primary") then {
                _unit addPrimaryWeaponItem _mag;
            };
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "handgun") then {
                _unit addHandgunItem _mag;
            };
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "secondary") then {
                _unit addSecondaryWeaponItem _mag;
            };
        };
    } forEach _mags;

    {
        _x params [["_mag", ""], ["_count", 0]];

        if (isClass (configFile >> "CfgMagazines" >> _mag)) then {
            _unit addMagazines [_mag, _count];
        };
    } forEach _mags;

    {
        if (count _x != 0) then {
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "primary") then {
                _unit addPrimaryWeaponItem _x;
            };
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "handgun") then {
                _unit addHandgunItem _x;
            };
            if (([_weapon] call ace_common_fnc_getItemType) select 1 == "secondary") then {
                _unit addSecondaryWeaponItem _x;
            };
        };
    } forEach _devices;
};

murshun_giveItems_fnc = {
    params ["_unit", "_array"];

    {
        _x params [["_item", ""], ["_count", 0]];

        if (count _item != 0) then {
            for "_i" from 1 to _count do {_unit addItem _item};
        };
    } forEach _array;
};

murshun_giveLinkItems = {
    params ["_unit", "_array"];

    {
        if (count _x != 0) then {
            _unit linkItem _x;
        };
    } forEach _array;
};

mf_disableAI_fnc = {
    params ["_unit"];

    if (_unit in switchableUnits) then {
        _unit disableAI "ANIM";
        _unit switchMove "";
    };
};

mf_debugLoadout_fnc = {
    [{time > 0}, {
        {
            if (!isPlayer _x) then {
                [_x] call mf_fnc_giveLoadout;
                [_x] call murshun_assignTeam_fnc;
                //[_x] call kf_fnc_assignGroupId;
            };
        } forEach switchableUnits;
    }] call CBA_fnc_waitUntilAndExecute;
};

murshun_assignTeam_fnc = {
    [{
        params ["_unit"];

        private _grp = group _unit;

        private _mf_groupChannel = _grp getVariable ["mf_groupChannel", [9, 5]];
        _mf_groupChannel params ["_squad", "_team"];

        private _teamsArray = ["MAIN", "RED", "GREEN", "BLUE", "YELLOW"];

        if (_team > 0 && _team < 5) then {
            [_unit, _teamsArray select _team] call ace_interaction_fnc_joinTeam;
        };
    }, _this, 3] call CBA_fnc_waitAndExecute;
};

kf_fnc_assignGroupId = {
    [{
        params ["_unit"];

        private _groupId = (group _unit) getVariable ["kf_groupId", nil];

        if (isNil "_groupId") exitWith {};

        if ({(groupId _x) == _groupId && side _x == side (group _unit)} count allGroups > 0) exitWith {};

        (group _unit) setGroupIdGlobal [_groupId];
    }, _this, 3] call CBA_fnc_waitAndExecute;
};

mf_fnc_dynamicItems = {
    params ["_box"];

    if (!(isClass (configFile >> "CfgPatches" >> "acre_main"))) exitWith {};

    private _itemCargo = getItemCargo _box;
    _itemCargo params ["_itemCargoItems", "_itemCargoCount"];

    if (count _itemCargoItems == 0) exitWith {};

    _box setVariable ["kf_var_itemCargo", _itemCargo];

    //clearItemCargoGlobal is broken for JIP clients, it hides weapons for JIP clients
    clearItemCargoGlobal _box;

    //"fix" removes weapons and adds them again
    private _weaponCargo = getWeaponCargo _box;
    _weaponCargo params ["_weaponCargoItems", "_weaponCargoCount"];

    clearWeaponCargoGlobal _box;

    {
        private _count = _weaponCargoCount select _forEachIndex;
        _box addItemCargoGlobal [_x, _count];
    } forEach _weaponCargoItems;

    [{
        params ["_args", "_handle"];
        _args params ["_box"];

        _itemCargo = _box getVariable ["kf_var_itemCargo", []];
        _itemCargo params ["_itemCargoItems", "_itemCargoCount"];

        if (!alive _box) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        private _thisItemCargo = getItemCargo _box;
        _thisItemCargo params ["_thisItemCargoItems", "_thisItemCargoCount"];

        {
            private _count = _itemCargoCount select _forEachIndex;

            if (_count > 0) then {
                if (_x in _thisItemCargoItems) then {
                    private _index = _thisItemCargoItems find _x;

                    if ((_thisItemCargoCount select _index) < 2) then {
                        _box addItemCargoGlobal [_x, 1];
                        _itemCargoCount set [_forEachIndex, _count - 1];
                    };
                } else {
                    _box addItemCargoGlobal [_x, 1];
                    _itemCargoCount set [_forEachIndex, _count - 1];
                };
            };
        } forEach _itemCargoItems;

        _box setVariable ["kf_var_itemCargo", [_itemCargoItems, _itemCargoCount]];
    }, 1/2, [_box]] call CBA_fnc_addPerFrameHandler;
};

mf_fnc_isUnitPilot = {
    params ["_unit"];

    if (vehicle _unit == _unit) exitWith {false};

    private _veh = (vehicle _unit);

    if (!(_veh isKindOf "air")) exitWith {false};

    private _simType = toLower getText (configFile >> "CfgVehicles" >> typeOf _veh >> "simulation");
    if (_simType == "parachute" || _simType == "paraglide") exitWith {false};

    (driver _veh == _unit)
};

mf_fnc_isUnitCoPilot = {
    params ["_unit"];

    if (vehicle _unit == _unit) exitWith {false};

    private _veh = (vehicle _unit);
    private _cfg = configFile >> "CfgVehicles" >> typeOf (_veh);
    private _trts = _cfg >> "turrets";

    if (!(_veh isKindOf "air")) exitWith {false};

    private _simType = toLower getText (configFile >> "CfgVehicles" >> typeOf _veh >> "simulation");
    if (_simType == "parachute" || _simType == "paraglide") exitWith {false};

    private _return = false;

    for "_i" from 0 to (count _trts - 1) do {
        private _trt = _trts select _i;

        if (getNumber (_trt >> "isCoPilot") == 1) exitWith {
            _return = (_veh turretUnit [_i] == _unit);
        };
    };

    _return
};

mf_fnc_addVehicleRespawn = {
    params ["_vehicle", ["_side", sideEmpty]];

    if (!isServer) exitWith {};

    if (_vehicle isKindOf "Man") exitWith {};

    _vehicle setVariable ["mf_vehicleRespawnPos", getPosATL _vehicle];
    _vehicle setVariable ["mf_vehicleDir", getDir _vehicle];
    _vehicle setVariable ["mf_vehicleLoadoutSide", _side];

    waitUntil {time > 3};

    _vehicle addMPEventHandler ["MPKilled", {
        _this spawn {
            params ["_vehicle"];

            if (!isServer) exitWith {};

            private _spawnPos = _vehicle getVariable "mf_vehicleRespawnPos";
            private _vehDir = _vehicle getVariable "mf_vehicleDir";
            private _loadoutSide = _vehicle getVariable "mf_vehicleLoadoutSide";
            private _vehClass = typeOf _vehicle;

            sleep 55;

            private _wrecks = (allDead select {_x distance _spawnPos < 15});

            if (count _wrecks > 0) then {
                {
                    deleteVehicle _x;
                } forEach _wrecks;
            };

            sleep 5;

            _spawnPos params ["_x", "_y"];
            private _newVehicle = _vehClass createVehicle ([0, 0, 0] getPos [random 50, random 360]);
            _newVehicle setDir _vehDir;
            _newVehicle setPosATL [_x, _y, 0];

            [[_newVehicle, _loadoutSide], "mf_fnc_fillBox", true, true] call BIS_fnc_MP;
            [_newVehicle, _loadoutSide] spawn mf_fnc_addVehicleRespawn;

            format ["Vehicle %1 respawned at %2.", _vehClass, mapGridPosition _spawnPos] remoteExec ["systemChat"];
        };
    }];
};

mf_fnc_addMusicRadio = {
    if (!isNil "klpq_musicRadio_fnc_addRadio") then {
        _this call klpq_musicRadio_fnc_addRadio;
    };
};

mf_teamParadrop_fnc = {
    params ["_player"];

    private _code = {
        private ["_x"];

        side _x == side _player && _x distance2d _player > 100 && !isObjectHidden _x && (vehicle _x == _x || (count fullCrew [vehicle _x, "", true] > count fullCrew [vehicle _x, "", false]))
    };

    private _groupUnitsFar = (units group _player) select _code;

    if (count _groupUnitsFar == 0) then {
        _groupUnitsFar = allUnits select _code;
    };

    if (count _groupUnitsFar > 0) then {
        private _unit = selectRandom _groupUnitsFar;

        if (vehicle _unit == _unit) then {
            private ["_LX", "_LY", "_LZ"];
            _LX = (getPosATL _unit select 0) + (3 * sin ((getDir _unit) - 180));
            _LY = (getPosATL _unit select 1) + (3 * cos ((getDir _unit) - 180));
            _LZ = (getPosATL _unit select 2);

            private _parachute = createVehicle ["Steerable_Parachute_F", [_LX,_LY,_LZ + 300], [], 0, "NONE"];
            _player moveInAny _parachute;
            _parachute allowDamage false;
        } else {
            _player moveInAny vehicle _unit;
        };

        format ["%1 teleported to %2 using team paradrop.", name _player, name _unit] remoteExec ["systemChat"];
    } else {
        systemChat "Team members should be at least 100m away and not in a full vehicle.";
    };
};

kf_fnc_handleDacPlayer = {
    params ["_unit"];

    if (!isPlayer _unit) exitWith {};

    private _side = side _unit;

    private _counterVarName = format ["kf_dac_%1_units", _side];

    private _counter = missionNamespace getVariable [_counterVarName, 1];

    missionNamespace setVariable [_counterVarName, _counter + 1];

    private _varName = format ["kf_dac_%1_%2", _side, _counter];

    missionNamespace setVariable [_varName, _unit];

    publicVariable _varName;

    DAC_STRPlayers pushBackUnique _varName;

    publicVariable "DAC_STRPlayers";
};

kf_fnc_handleBoxesLoop = {
    waitUntil {time > 3};

    while {true} do {
        if (count klpq_fm_var_boxes > 0) then {
            private _box = klpq_fm_var_boxes select 0;

            _box call mf_fnc_handleBox;

            klpq_fm_var_boxes deleteAt 0;
        };

        sleep (1/2);
    };
};

if (isNil "mf_fnc_loadoutWest") then {
    mf_fnc_loadoutWest = {
        []
    };
};

if (isNil "mf_fnc_loadoutEast") then {
    mf_fnc_loadoutEast = {
        []
    };
};

if (isNil "mf_fnc_loadoutGuer") then {
    mf_fnc_loadoutGuer = {
        []
    };
};

if (isNil "mf_fnc_loadoutCiv") then {
    mf_fnc_loadoutCiv = {
        []
    };
};

if (isNil "klpq_framework_enable") then {
    klpq_framework_enable = false;
};

if (isNil "mf_customEnemyLoadouts") then {
    mf_customEnemyLoadouts = false;
};

if (isNil "mf_onlyPilotsCanFly") then {
    mf_onlyPilotsCanFly = false;
};

if (isNil "mf_forceSideNVGs") then {
    mf_forceSideNVGs = [];
};

if (isNil "mf_forceVirtualArsenal") then {
    mf_forceVirtualArsenal = false;
};

if (isNil "mf_addParadropOption") then {
    mf_addParadropOption = false;
};

if (isNil "mf_debriefingText") then {
    mf_debriefingText = "";
};

if (isNil "klpq_fm_var_boxes") then {
    klpq_fm_var_boxes = [];
};

if (!isMultiplayer) then {
    DAC_Com_Values = [1,2,3,1];
    DAC_Marker = 2;
};

DAC_STRPlayers = [];

klpq_framework_version = getText (configFile >> "CfgPatches" >> "klpq_framework" >> "version");
