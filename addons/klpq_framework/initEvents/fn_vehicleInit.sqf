params ["_vehicle"];

if (!klpq_framework_enable) exitWith {};

[_vehicle] call mf_fnc_onlyPilotsCanFlyVehicle;

if (!isServer) exitWith {};

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearItemCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

_vehicle addItemCargoGlobal ["ToolKit", 2];
