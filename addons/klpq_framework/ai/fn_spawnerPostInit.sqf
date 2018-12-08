if (!isServer) exitWith {};

[{call mf_fnc_garbageCollectionLoop}, 30, []] call CBA_fnc_addPerFrameHandler;

enableDynamicSimulationSystem true;
"Group" setDynamicSimulationDistance 300;
