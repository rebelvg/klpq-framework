private _action = ["murshun_reviveSpectators", "Revive Spectators", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_reviveSpectators_reviveEveryone", "Revive Everyone (At Base)", "", {
    [] call klpq_spectator_fnc_reviveAllPlayers;
}, {serverCommandAvailable "#unlock"}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_reviveSpectators"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_reviveSpectators_reviveEveryoneHere", "Revive Everyone (Here)", "", {
    if (isObjectHidden player) exitWith {
        systemChat "Can't revive here, you're spectating.";
    };

    if (vehicle player != player) exitWith {
        systemChat "Can't revive here, you're in a vehicle.";
    };

    [getPosATL player] call klpq_spectator_fnc_reviveAllPlayers;
}, {serverCommandAvailable "#unlock"}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_reviveSpectators"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_reviveSpectators_names", "Names", "", {}, {serverCommandAvailable "#unlock"}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_reviveSpectators"], _action] call ace_interact_menu_fnc_addActionToObject;

if (isServer) then {
    private _respawnFlag = "Flag_White_F" createVehicle [0,0,0];
    hideObjectGlobal _respawnFlag;
    hideObject _respawnFlag;
    _respawnFlag allowDamage false;

    _respawnFlag setPosASL [0,0,0];
    if ((getPosATL _respawnFlag select 2) < 0) then {
        _respawnFlag setPosATL [0,0,0];
    };

    murshun_spectator_respawnFlag = _respawnFlag;
    publicVariable "murshun_spectator_respawnFlag";

    addMissionEventHandler ["EntityKilled", {
        params ["_unit"];

        if (isPlayer _unit) then {
            [_unit] call murshun_spectator_addToSpectators_fnc;
        };
    }];

    addMissionEventHandler ["EntityRespawned", {
        params ["_unit"];

        if (isPlayer _unit && (name _unit) in murshun_respawnArray) then {
            [[], "murshun_initSpectator_fnc", _unit] call BIS_fnc_MP;
        };
    }];
};

[] spawn {
    if (!hasInterface) exitWith {};

    waitUntil {!isNull player};

    private _markerName = [player] call klpq_spectator_fnc_getMarkerName;

    if !(_markerName in allMapMarkers) then {
        createMarkerLocal [_markerName, getPos player];
    };

    if !("respawn" in allMapMarkers) then {
        createMarkerLocal ["respawn", getPos player];
    };

    waitUntil {!isNull findDisplay 46};

    {
        [_x] spawn murshun_addMurshunMenuActionSpectators_fnc;
    } forEach murshun_respawnArray;

    if ((name player) in murshun_respawnArray) then {
        [] spawn murshun_initSpectator_fnc;
    };
};

gcam_var_c = objNull;
