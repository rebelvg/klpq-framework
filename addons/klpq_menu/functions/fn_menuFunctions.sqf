murshun_menu_logFF_fnc = {
	params ["_player", "_shooter", "_damage"];

	murshun_ffArray = murshun_ffArray + [[_player, _shooter, CBA_missionTime, _damage]];
	publicVariable "murshun_ffArray";
};

murshun_jipTeleport_fnc = {
	params ["_player"];

	if (isObjectHidden _player) exitWith {
		systemChat "Can't teleport you, you're spectating.";
	};

    private _code = {
        private ["_x"];

        side _x == side _player && _x distance2d _player > 100 && !isObjectHidden _x && (vehicle _x == _x or (count fullCrew [vehicle _x, "", true] > count fullCrew [vehicle _x, "", false]))
    };

	private _groupUnitsFar = (units group _player) select _code;

	if (count _groupUnitsFar == 0) then {
		_groupUnitsFar = allPlayers select _code;
	};

	if (count _groupUnitsFar > 0) then {
		private _unit = selectRandom _groupUnitsFar;

		if (vehicle _unit == _unit) then {
            private ["_LX", "_LY", "_LZ"];
			_LX = (getPosATL _unit select 0) + (3 * sin ((getDir _unit) - 180));
			_LY = (getPosATL _unit select 1) + (3 * cos ((getDir _unit) - 180));
			_LZ = (getPosATL _unit select 2);

			_player setPosATL [_LX,_LY,_LZ];
		} else {
			_player moveInAny vehicle _unit;
		};

		[_player, 1, ["ACE_SelfActions", "murshun_murshunMenu", "murshun_teleportToSL"]] call ace_interact_menu_fnc_removeActionFromObject;

        format ["%1 teleported to %2 using JIP teleport.", name _player, name _unit] remoteExec ["systemChat"];
	} else {
		systemChat "Team members should be at least 100m away and not in a full vehicle.";
	};
};

murshun_noCustomFace_fnc = {
	if (face player == "Custom") then {
        private _string = "Custom faces are not allowed.";
        [player, _string] remoteExec ["sideChat"];

		[{!isNull findDisplay 46}, {
			params ["_string"];

			["KLPQ Menu", composeText [parseText format ["<t align='center'>%1</t>", _string]], {findDisplay 46 closeDisplay 0}] call ace_common_fnc_errorMessage;
		}, [_string]] call CBA_fnc_waitUntilAndExecute;
	};
};

if (isNil "murshun_ffArray") then {
	murshun_ffArray = [];
};

if (isNil "murshun_allowJipTeleporting") then {
	murshun_allowJipTeleporting = true;
};

mushun_menu_adminActionsEnabled = false;
