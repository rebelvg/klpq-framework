if (!isServer) exitWith {};

[] spawn {
    waitUntil {time > 0};

    private _allPatches = "true" configClasses (configFile >> "CfgPatches");

    _allPatches = _allPatches apply {toLower configName _x};

    private _prefixes = ["klpq_"];

    private _addons = _allPatches select {
        private _className = _x;

        {_className find toLower _x == 0} count _prefixes > 0
    };

    _addons = _addons apply {[_x, getText (configFile >> "CfgPatches" >> _x >> "version")]};

    private _checkAddons_fnc = {
        params ["_addons", "_kickClient_fnc"];

        private _kick = false;
        private _outdatedAddons = [];

        {
            _x params ["_modName", "_versionServer"];
            private _versionLocal = getText (configFile >> "CfgPatches" >> _modName >> "version");

            if (_versionServer != _versionLocal) then {
                [{!isNull findDisplay 46}, {
                    params ["_versionServer", "_versionLocal", "_modName"];

                    [player, format ["%3: Version mismatch. Server - %1, Client - %2.", _versionServer, _versionLocal, _modName]] remoteExec ["sideChat"];
                }, [_versionServer, _versionLocal, _modName]] call CBA_fnc_waitUntilAndExecute;

                _outdatedAddons pushBack _modName;
                _kick = true;
            };
        } forEach _addons;

        if (_kick) then {
            [_outdatedAddons] call _kickClient_fnc;
        };
    };

    private _kickClient_fnc = {
        params ["_outdatedAddons"];

        [{!isNull findDisplay 46}, {
            params ["_addons"];

            ["KLPQ Menu", composeText [parseText format ["<t align='center'>%1 are outdated.</t>", _addons]], {findDisplay 46 closeDisplay 0}] call ace_common_fnc_errorMessage;
        }, [_outdatedAddons]] call CBA_fnc_waitUntilAndExecute;
    };

    [[_addons, _kickClient_fnc], _checkAddons_fnc] remoteExec ["spawn", 0, true];
};
