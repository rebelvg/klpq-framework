kf_fnc_ai_soldierArray = {
    params ["_faction", "_type"];

    private _conf = missionConfigFile >> "KF_AI" >> "Units" >> _faction >> _type;

    getArray _conf
};

kf_fnc_ai_vehicleArray = {
    params ["_faction", "_vehicle"];

    private _conf = missionConfigFile >> "KF_AI" >> "Units" >> _faction>> _vehicle;

    getArray _conf
};

kf_fnc_ai_getSkill = {
    params ["_skillName", "_skillType"];

    private _skill = [[0.01, 0.01], [0.01, 0.01], [0.01, 0.01], [0.3, 0.3], [0.1, 0.1], [0.1, 0.1], [0.5, 0.5], [0.1, 0.1], [0.5, 0.5], [0.3, 0.3]];

    _skill
};

kf_fnc_ai_getSide = {
    params ["_class"];
    private ["_side"];

    if (!isNumber (configFile >> "CfgVehicles" >> _class >> "side")) exitWith {sideEmpty};

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

kf_fnc_ai_applySkillUnit = {
    params ["_unit", "_skillName", "_skillType"];

    private _skill = [_skillName, _skillType] call kf_fnc_ai_getSkill;
    _skill params ["_aimingAccuracy", "_aimingShake", "_aimingSpeed", "_endurance", "_spotDistance", "_spotTime", "_courage", "_reloadSpeed", "_commanding", "_general"];

    _unit setSkill ["aimingAccuracy", _aimingAccuracy call BIS_fnc_randomNum];
    _unit setSkill ["aimingShake", _aimingShake call BIS_fnc_randomNum];
    _unit setSkill ["aimingSpeed", _aimingSpeed call BIS_fnc_randomNum];
    _unit setSkill ["endurance", _endurance call BIS_fnc_randomNum];
    _unit setSkill ["spotDistance", _spotDistance call BIS_fnc_randomNum];
    _unit setSkill ["spotTime", _spotTime call BIS_fnc_randomNum];
    _unit setSkill ["courage", _courage call BIS_fnc_randomNum];
    _unit setSkill ["reloadSpeed", _reloadSpeed call BIS_fnc_randomNum];
    _unit setSkill ["commanding", _commanding call BIS_fnc_randomNum];
    _unit setSkill ["general", _general call BIS_fnc_randomNum];

    _unit allowFleeing 0;

    true
};

kf_fnc_ai_applySkillGroup = {
    params ["_grp", "_skillName", "_skillType"];

    {
        [_x, _skillName, _skillType] call kf_fnc_ai_applySkillUnit;
    } forEach (units _grp);
};

kf_fnc_ai_createUnit = {
    params ["_pos", "_group", "_class", ["_form", "FORM"]];

    if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {objNull};

    private _unit = _group createUnit [_class, _pos, [], 0, _form];

    {
        _x addCuratorEditableObjects [[_unit], true];
    } forEach allCurators;

    _unit setVariable ["kf_var_mfUnit", true];

    _unit addEventHandler ["killed", {
        params ["_unit"];

        _unit setVariable ["kf_var_killedTime", CBA_missionTime];
    }];

    _unit
};

kf_fnc_ai_createVehicle = {
    params ["_pos", "_class", "_form"];

    if !(isClass (configFile >> "CfgVehicles" >> _class)) exitWith {objNull};

    private _vehicle = createVehicle [_class, _pos, [], 0, _form];

    {
        _x addCuratorEditableObjects [[_vehicle], true];
    } forEach allCurators;

    _vehicle
};

kf_fnc_ai_createGroup = {
    params ["_pos", "_faction", ["_count", 7], ["_skill", "LOW"]];

    private _infPool = [_faction, "infantry"] call kf_fnc_ai_soldierArray;
    _infPool params [["_leaderUnit", ""]];

    if (count _infPool < 2) exitWith {grpNull};

    private _groupMembers = _infPool select [1, count _infPool];

    private _side = [_leaderUnit] call kf_fnc_ai_getSide;

    private _grp = createGroup _side;
    private _unit = [_pos, _grp, _leaderUnit] call kf_fnc_ai_createUnit;
    [_unit, _skill, "Infantry"] call kf_fnc_ai_applySkillUnit;

    for "_i" from 1 to _count do
    {
         _unitClass = selectRandom _groupMembers;

        [{
            params ["_pos", "_grp", "_unitClass", "_skill"];

            private _spawnPos = (_pos getPos [3, random 360]);
            private _unit = [_spawnPos, _grp, _unitClass] call kf_fnc_ai_createUnit;
            [_unit, _skill, "Infantry"] call kf_fnc_ai_applySkillUnit;
        }, [_pos, _grp, _unitClass, _skill], _i * 0.3] call CBA_fnc_waitAndExecute;
    };

    _grp
};

kf_fnc_ai_createCrew = {
    params ["_grp", "_veh", "_driver", "_crew", ["_isAirCrew", false], ["_skill", "LOW"], ["_turretPositions", 0.3]];

    if (_veh emptyPositions "driver" > 0) then
    {
        private _unit = [getPos _veh, _grp, _driver] call kf_fnc_ai_createUnit;
        _unit moveInDriver _veh;
    };

    if (_veh emptyPositions "commander" > 0) then
    {
        private _unit = [getPos _veh, _grp, _crew] call kf_fnc_ai_createUnit;
        _unit moveInCommander _veh;
    };

    if (_veh emptyPositions "gunner" > 0) then
    {
        private _unit = [getPos _veh, _grp, _crew] call kf_fnc_ai_createUnit;
        _unit moveInGunner _veh;
    };

    {
        if (_forEachIndex < _turretPositions * (count fullCrew [_veh, "turret", true])) then {
            private _unit = [getPos _veh, _grp, _crew] call kf_fnc_ai_createUnit;
            _unit moveInTurret [_veh, (_x select 3)];
        }
    } forEach (fullCrew [_veh, "turret", true]);

    if (_isAirCrew) then {
        {
            removeBackpack _x;
            _x addBackpack "B_Parachute";
        } forEach (units _grp);
    };

    [_grp, _skill, "Vehicles"] call kf_fnc_ai_applySkillGroup;
};

kf_fnc_ai_infantryAttack = {
    params ["_grp", "_attackPos", ["_radius", 15]];

    if (!isServer) exitWith {grpNull};

    [_grp, _attackPos, _radius, "MOVE", "AWARE", "YELLOW", "FULL"] call CBA_fnc_addWaypoint;

    _grp
};

kf_fnc_ai_infantryDefend = {
    params ["_grp", "_attackPos", ["_radius", 25]];

    if (!isServer) exitWith {grpNull};

    [_grp, _attackPos, _radius] call CBA_fnc_taskDefend;

    _grp
};

kf_fnc_ai_infantryPatrol = {
    params ["_grp", "_attackPos", ["_radius", 100], ["_wpCount", 5]];

    if (!isServer) exitWith {grpNull};

    [_grp, _attackPos, _radius, _wpCount] call CBA_fnc_taskPatrol;

    _grp
};

kf_fnc_ai_infantryBunker = {
    params ["_pos", "_faction", "_radius", "_count", ["_skill", "LOW"], ["_threshold", 0], ["_unitPos", ["MIDDLE", "UP"], [[]], [1,2,3,4]]];

    if (!isServer) exitWith {grpNull};

    private _buildings = _pos nearObjects ["Building", _radius];
    _buildings = _buildings select {!(_x getVariable ["kf_var_ai_buildingBunkered", false])};

    private _positions = [];

    {
        private _buildingPositions = (_x buildingPos -1);

        if (_threshold > 0) then {
            _buildingPositions = _buildingPositions select [((floor random (count _buildingPositions)) max 0) min ((count _buildingPositions) - _threshold), _threshold];
        };

        _positions = _positions + _buildingPositions;
        _x setVariable ["kf_var_ai_buildingBunkered", true];
    } forEach _buildings;

    if (count _positions == 0) exitWith {
        systemChat format ["No bunker positions found at %1", mapGridPosition _pos];

        grpNull
    };

    private _randomPositions = [];

    for "_i" from 1 to (_count min (count _positions)) do
    {
        private _randomPos = selectRandom _positions;
        _randomPositions pushBackUnique _randomPos;
        _positions = _positions - [_randomPos];
    };

    private _infPool = [_faction, "infantry"] call kf_fnc_ai_soldierArray;
    _infPool params [["_leaderUnit", ""]];

    if (count _infPool < 2) exitWith {grpNull};

    private _groupMembers = _infPool select [1, count _infPool];

    private _side = [_leaderUnit] call kf_fnc_ai_getSide;

    private _grp = createGroup _side;

    {
        _unitClass = selectRandom _groupMembers;
        _unitStance = (selectRandom _unitPos);

        [{
            params ["_pos", "_grp", "_unitClass", "_skill", "_unitStance"];

            private _unit = [_pos, _grp, _unitClass, "CAN_COLLIDE"] call kf_fnc_ai_createUnit;
            _unit disableAI "PATH";
            [_unit, _skill, "Infantry"] call kf_fnc_ai_applySkillUnit;
            _unit setUnitPos _unitStance;
        }, [_x, _grp, _unitClass, _skill, _unitStance], _forEachIndex * 0.3] call CBA_fnc_waitAndExecute;
    } forEach _randomPositions;

    [{
        params ["_grp"];

        _grp enableDynamicSimulation true;
    }, [_grp], (count _randomPositions) * 0.3] call CBA_fnc_waitAndExecute;

    _grp
};

kf_fnc_ai_createVehicleGroup = {
    params ["_pos", "_faction", "_vehicle", ["_skill", "LOW"], ["_turretPositions", 0.3]];

    if (!isServer) exitWith {objNull};

    private _infPool = [_faction, "crew"] call kf_fnc_ai_soldierArray;
    _infPool params [["_crewUnit", ""], ["_pilotUnit", ""]];

    if (count _infPool < 1) exitWith {objNull};

    private _vehicleArray = [_faction, _vehicle] call kf_fnc_ai_vehicleArray;

    if (count _vehicleArray == 0) exitWith {objNull};

    private _vehClass = selectRandom _vehicleArray;

    private _spawnPos = (_pos getPos [random 10, random 360]);
    private _veh = [_spawnPos, _vehClass, "FORM"] call kf_fnc_ai_createVehicle;

    private _side = [_crewUnit] call kf_fnc_ai_getSide;

    private _grp = createGroup _side;
    [_grp, _veh, _crewUnit, _crewUnit, false, _skill, _turretPositions] call kf_fnc_ai_createCrew;

    _veh
};

kf_fnc_ai_createWheeledVehicleGroup = {
    params ["_pos", "_faction", ["_skill", "LOW"], ["_turretPositions", 0.3]];

    private _veh = [_pos, _faction, "wheeled", _skill, _turretPositions] call kf_fnc_ai_createVehicleGroup;

    _veh
};

kf_fnc_ai_createArmoredVehicleGroup = {
    params ["_pos", "_faction", ["_skill", "LOW"], ["_turretPositions", 0.3]];

    private _veh = [_pos, _faction, "armored", _skill, _turretPositions] call kf_fnc_ai_createVehicleGroup;

    _veh
};

kf_fnc_ai_vehicleAttack = {
    params ["_veh", "_attackPos", ["_radius", 30]];

    if (!isServer) exitWith {objNull};

    [_veh, _attackPos, _radius, "MOVE", "SAFE", "YELLOW", "LIMITED"] call CBA_fnc_addWaypoint;

    _veh
};

kf_fnc_ai_createAirVehicleGroup = {
    params ["_pos", "_faction", ["_skill", "LOW"], ["_flyHeight", 100], ["_turretPositions", 0.3]];

    if (!isServer) exitWith {objNull};

    private _infPool = [_faction, "crew"] call kf_fnc_ai_soldierArray;
    _infPool params [["_crewUnit", ""], ["_pilotUnit", ""]];

    if (count _infPool < 2) exitWith {objNull};

    private _vehicleArray = [_faction, "air"] call kf_fnc_ai_vehicleArray;

    if (count _vehicleArray == 0) exitWith {objNull};

    private _vehClass = selectRandom _vehicleArray;

    private _spawnPos = (_pos getPos [random 100, random 360]);
    private _veh = [_spawnPos, _vehClass, "FLY"] call kf_fnc_ai_createVehicle;

    private _side = [_pilotUnit] call kf_fnc_ai_getSide;

    private _grp = createGroup _side;
    [_grp, _veh, _pilotUnit, _crewUnit, true, _skill, _turretPositions] call kf_fnc_ai_createCrew;

    _veh flyInHeight _flyHeight;

    _veh
};

kf_fnc_ai_airPatrol = {
    params ["_veh", "_attackPos", ["_radius", 300], ["_wpCount", 5]];

    [_veh, _attackPos, _radius, _wpCount] call CBA_fnc_taskPatrol;

    _veh
};

kf_fnc_ai_mortarAttack = {
    _this spawn {
        params ["_pos", "_count", "_interval", "_radius", "_round", ["_height", 200]];

        if (!isServer) exitWith {};

        for "_i" from 1 to _count do
        {
            private _psn = (_pos getPos [random _radius, random 360]);
            _psn set [2, (_psn select 2) + _height];
            private _mortar = createVehicle [_round, _psn, [], 0, "NONE"];
            _mortar setVelocity [0, 0, -15];
            sleep random [_interval * 0.5, _interval, _interval * 1.5];
        };
    };

    true
};
