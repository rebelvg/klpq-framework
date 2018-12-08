private _action = ["murshun_murshunMenu", "KLPQ Menu", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_showFF", "Friendly Fire Logs", "", {
    systemChat "---Friendly Fire Logs---";

    {
        _x params ["_player", "_shooter", "_time", "_damage"];
        systemChat format ["%1 -> %2 (%3s ago / %4).", _shooter, _player, ceil (CBA_missionTime - _time), _damage];
    } forEach murshun_ffArray;

    systemChat "------";
}, {(serverCommandAvailable "#unlock" or !isMultiplayer)}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_missionEnd", "End The Mission", "", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_missionEnd_completed", "Completed", "", {
    "Admin requested mission end." remoteExec ["systemChat"];
    ["KF_Completed", true, true, true] remoteExec ["BIS_fnc_endMission"];
}, {(serverCommandAvailable "#unlock" or !isMultiplayer)}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_missionEnd"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_missionEnd_failed", "Failed", "", {
    "Admin requested mission end." remoteExec ["systemChat"];
    ["KF_Failed", false, true, true] remoteExec ["BIS_fnc_endMission"];
}, {(serverCommandAvailable "#unlock" or !isMultiplayer)}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_missionEnd"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_switchEasywayout", "Switch Easywayout", "", {
    murshun_easywayout_enable = !murshun_easywayout_enable;
    publicVariable "murshun_easywayout_enable";
    format ["murshun_easywayout_enable is now - %1.", murshun_easywayout_enable] remoteExec ["systemChat"];
}, {(serverCommandAvailable "#unlock" or !isMultiplayer) && isClass (configFile >> "CfgPatches" >> "murshun_easywayout")}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["murshun_switchAdminActions", "Switch Admin Actions", "", {
    mushun_menu_adminActionsEnabled = !mushun_menu_adminActionsEnabled;

    player allowDamage !mushun_menu_adminActionsEnabled;
    [[player, mushun_menu_adminActionsEnabled], "hideObjectGlobal", false] call BIS_fnc_MP;

    systemChat format ["mushun_menu_adminActionsEnabled is now - %1.", mushun_menu_adminActionsEnabled];
}, {(serverCommandAvailable "#unlock" or !isMultiplayer)}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

if (isServer) then {
    mm_playersKilled = 0;
    mm_aiKilled = 0;
    publicVariable "mm_playersKilled";
    publicVariable "mm_aiKilled";

    addMissionEventHandler ["EntityKilled", {
        params ["_unit"];

        if (_unit isKindOf "CAManBase") then {
            if (isPlayer _unit) then {
                mm_playersKilled = mm_playersKilled + 1;
                publicVariable "mm_playersKilled";
            } else {
                mm_aiKilled = mm_aiKilled + 1;
                publicVariable "mm_aiKilled";
            };
        };
    }];

    ["ace_advanced_throwing_throwFiredXEH", {
        params ["_unit", "", "", "", "", "", "_proj"];
        _proj setShotParents [_unit, _unit];
    }] call CBA_fnc_addEventHandler;
};

addMissionEventHandler ["Ended", {
    private _ffArray = "";

    {
        _x params ["_player", "_shooter", "_time", "_damage"];
        _ffArray = _ffArray + format ["%1 -> %2 (%3m ago / %4)<br/>", _shooter, _player, ceil ((CBA_missionTime - _time) / 60), _damage];
    } forEach murshun_ffArray;

    mf_debriefingText = format [
    "---Mission---<br/>Author - %6<br/>Duration - %7m<br/>---Friendly Fire Logs---<br/>%1---Spectators---<br/>%2<br/>---Alive Players---<br/>%8<br/>---All Players---<br/>%3<br/>---Players Killed---<br/>%4<br/>---AI Killed---<br/>%5",
    _ffArray,
    murshun_respawnArray,
    (allPlayers apply {name _x}),
    mm_playersKilled,
    mm_aiKilled,
    getMissionConfigValue ["author", "KLPQ"],
    ceil (CBA_missionTime / 60),
    (allPlayers - (allPlayers select {name _x in murshun_respawnArray})) apply {name _x}
    ];
}];

addMissionEventHandler ["MapSingleClick", {
    params ["_units", "_pos"];

    if (mushun_menu_adminActionsEnabled) then {
        (vehicle player) setPos _pos;
        systemChat format ["You teleported to %1.", mapGridPosition _pos];
    };
}];

[] spawn {
    if (!hasInterface) exitWith {};

    waitUntil {!isNull player};

    player addEventHandler ["Hit", {
        params ["_player", "_shooter", "_damage", "_realShooter"];

        if (isNull _realShooter) then {
            _realShooter = _shooter;
        };

        if (side group _player == side group _realShooter && _player != _realShooter) then {
            [[name _player, name _realShooter, format ["%1 dmg", _damage toFixed 2]], "murshun_menu_logFF_fnc", false] call BIS_fnc_MP;
        };
    }];

    player addEventHandler ["Killed", {
        params ["_player", "_killer", "_realShooter"];

        if (isNull _realShooter) then {
            _realShooter = _killer;
        };

        if (side group _player == side group _realShooter && _player != _realShooter) then {
            [[name _player, name _realShooter, "killed"], "murshun_menu_logFF_fnc", false] call BIS_fnc_MP;
        };

        if (_player != player) exitWith {};

        private _respawnTime = (playerRespawnTime max 10) + 1;

        cutText ["", "BLACK FADED", _respawnTime / 10];

        [_respawnTime] spawn {
            params ["_respawnTime"];

            ["murshun_menu_killed", 0, true] call ace_common_fnc_setHearingCapability;

            sleep _respawnTime;

            ["murshun_menu_killed", 0, false] call ace_common_fnc_setHearingCapability;
        };
    }];

    player addEventHandler ["HandleRating", {
        params ["_unit", "_rating"];

        if (_rating < 0) exitWith {
            0
        };
    }];

    waitUntil {!isNull findDisplay 46};

    [] call murshun_noCustomFace_fnc;

    if (didJIP) then {
        systemChat "You JIPed. You have 10 minutes to teleport yourself to your team. Use self-interaction, KLPQ menu.";
    };

    _action = ["murshun_teleportToSL", "Teleport to Your Team", "", {[player] spawn murshun_jipTeleport_fnc}, {didJIP}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "murshun_murshunMenu"], _action] call ace_interact_menu_fnc_addActionToObject;

    sleep 600;

    [player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_teleportToSL"]] call ace_interact_menu_fnc_removeActionFromObject;
};

["murshun_menu", 1, true] call ace_common_fnc_setHearingCapability;

ace_hearing_disableVolumeUpdate = true;
