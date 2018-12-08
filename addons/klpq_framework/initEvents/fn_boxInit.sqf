params ["_box"];

if (!klpq_framework_enable) exitWith {};

if (!isServer) exitWith {};

clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;
