params ["_vehicle"];

if (!isMultiplayer) exitWith {};

if (!mf_onlyPilotsCanFly) exitWith {};

if (!(_vehicle isKindOf "air")) exitWith {};

private _simType = toLower getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "simulation");
if (_simType == "parachute" or _simType == "paraglide") exitWith {};

_vehicle addEventHandler ["ControlsShifted", {
	params ["_veh", "_unit"];

	private _className = toLower getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");

	if (_className == "pilot") exitWith {};

	if (speed _veh != 0) exitWith {};

	[[[_veh, _unit], {
		params ["_veh", "_unit"];

		_unit action ["SuspendVehicleControl", _veh];

		systemChat "Can take controls only when flying.";
	}], "BIS_fnc_spawn", _unit] call BIS_fnc_MP;
}];
