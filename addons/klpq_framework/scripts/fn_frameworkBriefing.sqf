private _vars = ["klpq_framework_version", "klpq_framework_enable", "mf_customEnemyLoadouts", "mf_onlyPilotsCanFly", "mf_forceSideNVGs", "mf_forceVirtualArsenal", "mf_addParadropOption", "murshun_spectator_enable", "murshun_easywayout_enable", "klpq_musicRadio_enable", "klpq_musicRadio_radioThemes", "klpq_musicRadio_enableBackpackRadioMP"];

private _fwSettings = "Variable values on mission start.<br/><br/>";

{
    _fwSettings = _fwSettings + format ["%1 - %2.<br/>", _x, (missionNamespace getVariable [_x, "is not set"])];
} forEach _vars;

private _date = date;

{
    if (_x < 10) then {
        _date set [_forEachIndex, "0" + str _x];
    } else {
        _date set [_forEachIndex, str _x];
    };
} forEach _date;

date params ["_year", "_month", "_day", "_hour", "_minute"];

private _monthName = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] select (_month - 1);

_date params ["_year", "_month", "_day", "_hour", "_minute"];

private _fwCredits = format ["Date - %1.<br/>", _day + "/" + _monthName + "/" + _year];
_fwCredits = _fwCredits + format ["Time - %1.<br/>", _hour + ":" + _minute];
_fwCredits = _fwCredits + format ["Author - %1.<br/><br/>", getMissionConfigValue ["author", "KLPQ"]];
_fwCredits = _fwCredits + format ["Mission Name - %1.<br/>", getText (missionConfigFile >> "onLoadName")];
_fwCredits = _fwCredits + format ["Island - %1.<br/>", getText (configFile >> "CfgWorlds" >> worldName >> "description")];

player createDiaryRecord ["diary", ["Settings", _fwSettings]];
player createDiaryRecord ["diary", ["Credits", _fwCredits]];
