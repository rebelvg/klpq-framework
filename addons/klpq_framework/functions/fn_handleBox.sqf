params ["_box", ["_side", sideEmpty]];

if (!isServer) exitWith {};

clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

if (_box isKindOf "thing") then {
    _box allowDamage false;
};

private _loadoutArray = [];

switch (_side) do {
case WEST: {
        _loadoutArray = call mf_fnc_loadoutWest;
    };
case EAST: {
        _loadoutArray = call mf_fnc_loadoutEast;
    };
case RESISTANCE: {
        _loadoutArray = call mf_fnc_loadoutGuer;
    };
case CIVILIAN: {
        _loadoutArray = call mf_fnc_loadoutCiv;
    };
};

if (_box isKindOf "car") then {
    [_box, 3, "ACE_Wheel"] call ace_repair_fnc_addSpareParts;
};

if (_box isKindOf "tank") then {
    [_box, 3, "ACE_Track"] call ace_repair_fnc_addSpareParts;
};

if (_box isKindOf "air") then {
    _box addBackpackCargoGlobal ["B_Parachute", count fullCrew [_box, "", true]];
};

if (count _loadoutArray == 0) exitWith {};

private _multiplier = 1;

if !(_box isKindOf "thing") then {
    _multiplier = 1/4;
};

_loadoutArray params [["_eqps", []], ["_items", []], ["_boxes", []]];

{
    _x params [["_item", ""], ["_count", 0]];

    private _config = configFile >> "CfgVehicles" >> _item;

    if (count _item != 0) then {
        if (getText (_config >> "vehicleClass") == "backpacks") then {
            _box addBackpackCargoGlobal [_item, ceil (_count * _multiplier)];
        } else {
            _box addItemCargoGlobal [_item, ceil (_count * _multiplier)];
        };
    };
} forEach _boxes;

{
    _x params [["_classes", []], ["_eqp", []]];
    _eqp params [["_fashion", []], ["_weapons", []]];

    {
        _x params [["_weapon", ""], ["_mags", []]];

        {
            _x params [["_mag", ""], ["_count", 0]];

            if (isClass (configFile >> "CfgMagazines" >> _mag)) then {
                _box addMagazineCargoGlobal [_mag, ceil (60 * _multiplier)];
            };
        } forEach _mags;
    } forEach _weapons;
} forEach _eqps;

[_box] call mf_fnc_dynamicItems;

["klpq_framework_fillBox", [_box]] call CBA_fnc_globalEvent;
