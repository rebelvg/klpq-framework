params ["_box"];

if (!isServer) exitWith {};

waitUntil {time > 0};

clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

_box allowDamage false;

if (ace_medical_level > 1) then {
    _box addItemCargoGlobal ["ACE_fieldDressing", 1000];
    _box addItemCargoGlobal ["ACE_quikclot", 1000];
    _box addItemCargoGlobal ["ACE_morphine", 400];
    _box addItemCargoGlobal ["ACE_epinephrine", 400];
    _box addItemCargoGlobal ["ACE_tourniquet", 200];
    _box addItemCargoGlobal ["ACE_personalAidKit", 200];
    _box addItemCargoGlobal ["ACE_bloodIV_500", 200];
} else {
    _box addItemCargoGlobal ["ACE_fieldDressing", 2000];
    _box addItemCargoGlobal ["ACE_morphine", 400];
    _box addItemCargoGlobal ["ACE_epinephrine", 400];
    _box addItemCargoGlobal ["ACE_bloodIV_500", 200];
};

[_box] call mf_fnc_dynamicItems;
