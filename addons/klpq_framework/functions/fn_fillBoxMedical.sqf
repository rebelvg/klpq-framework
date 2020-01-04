params ["_box"];

if (!isServer) exitWith {};

waitUntil {time > 0};

clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

_box allowDamage false;

_box addItemCargoGlobal ["ACE_fieldDressing", 2000];
_box addItemCargoGlobal ["ACE_morphine", 400];
_box addItemCargoGlobal ["ACE_splint", 400];
_box addItemCargoGlobal ["ACE_epinephrine", 200];
_box addItemCargoGlobal ["ACE_tourniquet", 100];
_box addItemCargoGlobal ["ACE_bloodIV_500", 100];

[_box] call mf_fnc_dynamicItems;
