if (!klpq_framework_enable) exitWith {};

if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
    [false, true] call acre_api_fnc_setupMission;
};

if (isMultiplayer && ("AddZeus" call BIS_fnc_getParamValue) == 0) then {
    {
        deleteVehicle _x;
    } forEach allCurators;
};

if (isServer) then {
    [] spawn {
        if (!isMultiplayer) then {
            [] call mf_debugLoadout_fnc;
        };
    };

    addMissionEventHandler ["EntityRespawned", {
        params ["_entity"];

        [_entity] call kf_fnc_handleDacPlayer;
    }];

    [] spawn kf_fnc_handleBoxesLoop;
};

if (hasInterface) then {
    [] spawn {
        [] call mf_fnc_frameworkBriefing;
        //[] call mf_fnc_radioBriefing;

        [player] call mf_fnc_giveLoadout;
        [] spawn mf_fnc_acreSettings;

        if (didJIP) then {
            [[], "mf_fnc_teamRoster"] call BIS_fnc_MP;
        } else {
            [] call mf_fnc_teamRoster;
        };

        [{!isNull findDisplay 46}, murshun_assignTeam_fnc, [player]] call CBA_fnc_waitUntilAndExecute;
        [{!isNull findDisplay 46}, kf_fnc_assignGroupId, [player]] call CBA_fnc_waitUntilAndExecute;

        [] call mf_fnc_onlyPilotsCanFlyPlayer;

        player setVariable ["ace_medical_medicClass", 1, true];

        waitUntil {time > 180 || (!isMultiplayer && time > 10)};

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

        [parseText format ["<t font='PuristaBold' shadow='2' align='right' size='1.6'>""%1""</t><br/><t shadow='2' align='right' size='1.4'>%2</t>", _day + "/" + _monthName + "/" + _year, _hour + ":" + _minute], true, nil, 9, 1, 0] spawn BIS_fnc_textTiles;

        sleep 11;

        {
            [parseText format ["<t font='PuristaBold' shadow='2' align='right' size='1.6'>%1</t><br/><t shadow='2' align='right' size='1.4'>%2</t>", "Starring", name _x], true, nil, 1, 0.5, 0] spawn BIS_fnc_textTiles;
            sleep 1.5;
        } forEach allPlayers;

        sleep 0.5;

        [parseText format ["<t font='PuristaBold' shadow='2' align='right' size='1.6'>""%1""</t><br/><t shadow='2' align='right' size='1.4'>%2</t>", getText (missionConfigFile >> "onLoadName"), getText (configFile >> "CfgWorlds" >> worldName >> "description")], true, nil, 9, 1, 0] spawn BIS_fnc_textTiles;

        sleep 11;

        [parseText format ["<t font='PuristaBold' shadow='2' align='right' size='1.6'>%1</t><br/><t shadow='2' align='right' size='1.6'>%2</t>", "Created and Directed", "by " + getMissionConfigValue ["author", "KLPQ"]], true, nil, 9, 1, 0] spawn BIS_fnc_textTiles;
    };
};
