if (!(isClass (configFile >> "CfgPatches" >> "acre_main"))) exitWith {};

private _grp = group player;

private _mf_groupChannel = _grp getVariable ["mf_groupChannel", [9, 5]];
_mf_groupChannel params ["_channel", "_team"];

waitUntil {
	time > 0 and [] call acre_api_fnc_isInitialized
};

private _343Radios = (items player) select {[_x] call acre_api_fnc_getBaseRadio == "ACRE_PRC343"};
private _152Radios = (items player) select {[_x] call acre_api_fnc_getBaseRadio == "ACRE_PRC152"};

if (count _343Radios > 0) then {
	[(_343Radios select 0), _channel] call acre_api_fnc_setRadioChannel;
	[(_343Radios select 0), "LEFT"] call acre_api_fnc_setRadioSpatial;
	[(_343Radios select 0)] call acre_api_fnc_setCurrentRadio;
};

if (count _152Radios > 0) then {
	[(_152Radios select 0), 1] call acre_api_fnc_setRadioChannel;
	[(_152Radios select 0), "RIGHT"] call acre_api_fnc_setRadioSpatial;
};
