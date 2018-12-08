private _toDelete = allDead select {_x getVariable ["kf_var_mfUnit", false]};

private _collectionTime = 180;
private _collectionRadius = 150;

{
    private _unit = _x;

    if ((CBA_missionTime - (_unit getVariable ["kf_var_killedTime", 0])) > _collectionTime || {_x distance2d _unit < _collectionRadius} count allPlayers == 0) then {
        deleteVehicle _unit;
    };
} forEach _toDelete;
