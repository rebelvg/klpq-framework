murshun_spectator_addToSpectators_fnc = {
    params ["_unit"];

    private _name = name _unit;

    if (!murshun_spectator_enable) exitWith {};

    if (!(_name in murshun_respawnArray)) then {
        murshun_respawnArray = murshun_respawnArray + [_name];
        publicVariable "murshun_respawnArray";
        [[_name], "murshun_addMurshunMenuActionSpectators_fnc"] call BIS_fnc_MP;

        _unit setVariable ["murshun_spectator_diedPosition", getPosATL _unit, true];
    };
};

murshun_spectator_removeFromSpectators_fnc = {
    params ["_name"];

    murshun_respawnArray = murshun_respawnArray - [_name];
    publicVariable "murshun_respawnArray";
    [[_name], "murshun_removeMurshunMenuActionSpectators_fnc"] call BIS_fnc_MP;
};

klpq_spectator_fnc_reviveWhereDied = {
    private _markerName = [player] call klpq_spectator_fnc_getMarkerName;

    private _pos = player getVariable ["murshun_spectator_diedPosition", getMarkerPos _markerName];

    [_pos] spawn murshun_disableSpectator_fnc;
};

klpq_spectator_fnc_reviveAtMarker = {
    params ["_marker"];

    private _pos = getMarkerPos _marker;

    [_pos] spawn murshun_disableSpectator_fnc;
};

klpq_spectator_fnc_reviveAtPosition = {
    params ["_pos"];

    [_pos] spawn murshun_disableSpectator_fnc;
};

murshun_disableSpectator_fnc = {
    params ["_pos"];

    waitUntil {!((name player) in murshun_respawnArray)};

    waitUntil {alive player};

    player allowDamage true;
    detach player;
    [[player, false], "hideObjectGlobal", false] call BIS_fnc_MP;
    player setVariable ["klpq_spectator_isSpectating", false, true];
    GCamKill = true;
    STHud_UIMode = (missionNamespace getVariable ["STHud_Settings_HUDMode", 3]);

    if (!isNil "acre_api_fnc_setSpectator") then {
        [false] call acre_api_fnc_setSpectator;
    };

    player setPosATL _pos;

    format ["%1 respawned at %2.", name player, mapGridPosition _pos] remoteExec ["systemChat"];
};

murshun_addMurshunMenuActionSpectators_fnc = {
    params ["_name"];

    private _action = [format ["murshun_reviveSpectators_%1", _name], _name + " (Where Died)", "", {
        params ["", "", "_name"];

        [[], "klpq_spectator_fnc_reviveWhereDied", allPlayers select {name _x == _name}] call BIS_fnc_MP;

        [[_name], "murshun_spectator_removeFromSpectators_fnc", false] call BIS_fnc_MP;
    }, {serverCommandAvailable "#unlock"}, {}, _name] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_reviveSpectators", "murshun_reviveSpectators_names"], _action] call ace_interact_menu_fnc_addActionToObject;
};

murshun_removeMurshunMenuActionSpectators_fnc = {
    params ["_name"];

    [player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_reviveSpectators", "murshun_reviveSpectators_names", format ["murshun_reviveSpectators_%1", _name]]] call ace_interact_menu_fnc_removeActionFromObject;
};

murshun_initSpectator_fnc = {
    GCamKill = false;
    player allowDamage false;
    player switchMove "";
    player setPosATL getPosATL murshun_spectator_respawnFlag;
    player attachTo [murshun_spectator_respawnFlag, [0,0,0]];
    [[player, true], "hideObjectGlobal", false] call BIS_fnc_MP;
    player setVariable ["klpq_spectator_isSpectating", true, true];
    STHud_UIMode = 0;

    [] call gcam_fnc_gcamInit;

    if (!isNil "acre_api_fnc_setSpectator") then {
        [true] call acre_api_fnc_setSpectator;
    };

    [["gcam", "gcam_hint"], 30, "", 30, "", true, false, true, false] call BIS_fnc_advHint;

    format ["%1 joined spectators.", name player] remoteExec ["systemChat", call klpq_spectator_getSpectators];
};

murshun_drawSpectatorIcon = {
    params ["_unit"];

    private _color = [];
    private _side = side _unit;

    switch (_side) do {
    case WEST: { _color = [0,0,1,1] };
    case EAST: { _color = [1,0,0,1] };
    case RESISTANCE: { _color = [0,1,0,1] };
    case CIVILIAN: { _color = [1,0,1,1] };
        default { _color = [1,1,1,1] };
    };

    private _circleIcon = murshun_spectator_folder_root + "circle.paa";

    private _iconPos = ASLToAGL getPosASLVisual _unit;

    if (isPlayer _unit) then {
        drawIcon3D [_circleIcon, _color, _iconPos, 0.3, 0.3, 0, name _unit, 1, 0.035, "PuristaMedium"];
    } else {
        drawIcon3D [_circleIcon, _color, _iconPos, 0.3, 0.3, 0];
    };
};

murshun_drawAdvancedStats_fnc = {
    private _detailedHudPos = positionCameraToWorld [600,400,1000];
    drawIcon3D ["", [1,1,1,0.9], _detailedHudPos, 0, 0, 0, format ["Players: %1", {!isObjectHidden _x && alive _x} count allPlayers], 1, 0.04, "PuristaMedium"];

    _detailedHudPos = positionCameraToWorld [600,385,1000];
    drawIcon3D ["", [1,1,1,0.9], _detailedHudPos, 0, 0, 0, format ["AI: %1", {alive _x} count (allUnits - playableUnits)], 1, 0.04, "PuristaMedium"];

    _detailedHudPos = positionCameraToWorld [600,370,1000];
    drawIcon3D ["", [1,1,1,0.9], _detailedHudPos, 0, 0, 0, format ["Spectators: %1", {isObjectHidden _x && alive _x} count allPlayers], 1, 0.04, "PuristaMedium"];
};

murshun_spectator_drawCompass_fnc = {
    private _north = positionCameraToWorld [0,0,0];
    _north set [1, (_north select 1) + 3000];
    _north set [2, 0];
    drawIcon3D ["", [1,1,1,0.9], _north, 0, 0, 0, "N", 2, 0.05, "PuristaMedium"];

    private _east = positionCameraToWorld [0,0,0];
    _east set [0, (_east select 0) + 3000];
    _east set [2, 0];
    drawIcon3D ["", [1,1,1,0.9], _east, 0, 0, 0, "E", 2, 0.05, "PuristaMedium"];

    private _west = positionCameraToWorld [0,0,0];
    _west set [0, (_west select 0) - 3000];
    _west set [2, 0];
    drawIcon3D ["", [1,1,1,0.9], _west, 0, 0, 0, "W", 2, 0.05, "PuristaMedium"];

    private _south = positionCameraToWorld [0,0,0];
    _south set [1, (_south select 1) - 3000];
    _south set [2, 0];
    drawIcon3D ["", [1,1,1,0.9], _south, 0, 0, 0, "S", 2, 0.05, "PuristaMedium"];
};

murshun_spectator_drawMarkers_fnc = {
    private _closeMarker = allMapMarkers select {markerAlpha _x != 0 && getMarkerPos _x distance2d gcam_var_c < viewDistance};

    {
        private ["_draw", "_name", "_pos", "_type", "_icon", "_text"];

        _draw = true;

        _name = "";
        _pos = getMarkerPos _x;
        _type = toLower getMarkerType _x;
        _icon = getText (configFile >> "CfgMarkers" >> _type >> "icon");
        _text = markerText _x;

        if (_type in ["empty", "select"]) then {
            _draw = false;
        };

        if (_icon == "") then {
            _draw = false;
        };

        if (_x find "_USER_DEFINED #" >= 0) then {
            _name = format ["Player #%1", allMapMarkers find _x];
        } else {
            _name = format ["Mission #%1", allMapMarkers find _x];
        };

        if (_text != "") then {
            _name = _name + format [" - %1", _text];
        };

        if (_draw) then {
            drawIcon3D [_icon, [0,0,0,0.9], _pos, 0.7, 0.7, (getDir gcam_var_c) - (markerDir _x), _name, 0, 0.03, "PuristaMedium"];
        };
    } forEach _closeMarker;
};

murshun_drawSpectatorHud_fnc = {
    if (murshun_spectator_showHUD > 0) then {
        private _players = allPlayers select {!isObjectHidden _x};

        {
            [_x] call murshun_drawSpectatorIcon;
        } forEach _players;

        if (murshun_spectator_showHUD > 1) then {
            private _aiUnits = allUnits select {!isPlayer _x && _x distance2d gcam_var_c < viewDistance};

            {
                [_x] call murshun_drawSpectatorIcon;
            } forEach _aiUnits;

            [] call murshun_drawAdvancedStats_fnc;
            [] call murshun_spectator_drawCompass_fnc;
            [] call murshun_spectator_drawMarkers_fnc;
        };
    };
};

klpq_spectator_fnc_reviveAllSidePlayers = {
    params [
        ["_pos", []],
        ["_side", sideEmpty]
    ];

    private _revivePlayers = allPlayers select {name _x in murshun_respawnArray && (side _x == _side)};

    {
        if (count _pos == 0) then {
            private _markerName = [_x] call klpq_spectator_fnc_getMarkerName;

            [[_markerName], "klpq_spectator_fnc_reviveAtMarker", _x] call BIS_fnc_MP;
        } else {
            [[_pos], "klpq_spectator_fnc_reviveAtPosition", _x] call BIS_fnc_MP;
        };

        [[name _x], "murshun_spectator_removeFromSpectators_fnc", false] call BIS_fnc_MP;
    } forEach _revivePlayers;
};

klpq_spectator_fnc_reviveAllPlayers = {
    params [
        ["_pos", []]
    ];

    private _revivePlayers = allPlayers select {name _x in murshun_respawnArray};

    {
        if (count _pos == 0) then {
            private _markerName = [_x] call klpq_spectator_fnc_getMarkerName;

            [[_markerName], "klpq_spectator_fnc_reviveAtMarker", _x] call BIS_fnc_MP;
        } else {
            [[_pos], "klpq_spectator_fnc_reviveAtPosition", _x] call BIS_fnc_MP;
        };
    } forEach _revivePlayers;

    {
        [[_x], "murshun_spectator_removeFromSpectators_fnc", false] call BIS_fnc_MP;
    } forEach murshun_respawnArray;
};

klpq_spectator_fnc_getSide = {
    params ["_unit"];

    private ["_side"];

    private _class = typeOf _unit;

    if (!isNumber (configFile >> "CfgVehicles" >> _class >> "side")) exitWith {
        sideEmpty
    };

    private _sideNumber = getNumber (configFile >> "CfgVehicles" >> _class >> "side");

    switch (_sideNumber) do {
    case 0: {
            _side = EAST;
        };
    case 1: {
            _side = WEST;
        };
    case 2: {
            _side = RESISTANCE;
        };
    case 3: {
            _side = CIVILIAN;
        };
        default {
            _side = sideEmpty;
        };
    };

    _side
};

klpq_spectator_fnc_getMarkerName = {
    params ["_unit"];

    toLower (format ["base_marker_%1", [_unit] call klpq_spectator_fnc_getSide])
};

klpq_spectator_getSpectators = {
    allPlayers select {_x getVariable ["klpq_spectator_isSpectating", false]}
};

if (isNil "murshun_respawnArray") then {
    murshun_respawnArray = [];
};

if (isNil "murshun_spectator_enable") then {
    murshun_spectator_enable = false;
};

murshun_spectator_folder_root = "klpq_menu\";
murshun_spectator_showHUD = 1;

//legacy
murshun_spectator_reviveAllPlayers_fnc = klpq_spectator_fnc_reviveAllPlayers;
