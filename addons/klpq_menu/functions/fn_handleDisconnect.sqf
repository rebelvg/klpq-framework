if (!isServer) exitWith {};

addMissionEventHandler ["HandleDisconnect", {
    params [["_unit", objNull]];

    deleteVehicle _unit;

    false
}];
