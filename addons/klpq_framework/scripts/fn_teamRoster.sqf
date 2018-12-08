/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Author 		: Skippy
//
//Description 	: Displays team members in the diary
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private ["_strRole", "_strFinal", "_oldGrp", "_newGrp", "_unitsArr"];

_strRole = "";
_strFinal = "";
_oldGrp = grpNull;
_newGrp = grpNull;

_unitsArr = (playableUnits + switchableUnits) select {side group _x == side group player};

{
    _newGrp = group _x;

    private _mf_groupChannel = _newGrp getVariable ["mf_groupChannel", [9, 5]];
    _mf_groupChannel params ["_squad", "_team"];

    private _strColorGrp = "";
    if (_newGrp != _oldGrp) then {
        switch (side _x) do {
        case EAST: {
                _strColorGrp = "'#990000'";
            };
        case WEST: {
                _strColorGrp = "'#0066CC'";
            };
        case RESISTANCE: {
                _strColorGrp = "'#339900'";
            };
        case CIVILIAN: {
                _strColorGrp = "'#990099'";
            };
        };

        _strFinal = _strFinal + "<br/>" + "<font color=" + _strColorGrp + ">" + ((group _x) getVariable ["kf_groupId", (groupID (group _x))]) + "</font><br/>";

        _strFinal = _strFinal + format ["<font color='#FFEC00'>[</font color><font color='#8A8A8A'>PRC152 / Channel - 1</font color><font color='#FFEC00'>]</font color>"];
        _strFinal = _strFinal + format [" - "];
        _strFinal = _strFinal + format ["<font color='#FFEC00'>[</font color><font color='#8A8A8A'>PRC343 / Channel - %1</font color><font color='#FFEC00'>]</font color><br/>", _squad];
    };

    _oldGrp = group _x;

    private _teamColor = "";
    switch (_team) do {
    case 1: {
            _teamColor = "'#FF0000'";
        };
    case 2: {
            _teamColor = "'#00FF00'";
        };
    case 3: {
            _teamColor = "'#0000FF'";
        };
    case 4: {
            _teamColor = "'#FFFF00'";
        };
    };

    _strRole = " - " + getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");

    _strFinal =  _strFinal + "<font color=" + _teamColor + ">" + name _x + "</font>" + _strRole + "<br/>";
} forEach _unitsArr;

player createDiarySubject ["roster", "Team Roster"];
player createDiaryRecord ["roster", [format ["Roster (%1 seconds)", time], _strFinal]];
