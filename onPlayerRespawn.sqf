params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

hudOn = true;

if(!isFirstSpawnIsDone) then {
    isFirstSpawnIsDone = true;
};

_unit = _newUnit;
_loadDefault = true;

WF_DeathLocation = getPosATL _oldUnit;
_spawn = nil;
if(vehicle _unit != _unit) then {
    _spawn = vehicle _unit
} else {
    _spawn_locations = [WF_Client_SideJoined, WF_DeathLocation] Call WFCL_FNC_GetRespawnAvailable;
    _spawn = [WF_DeathLocation, _spawn_locations] Call WFCO_FNC_GetClosestEntity;
};
_typeof = typeOf _spawn;

WF_Client_IsRespawning = false;
_allowCustom = true;

//--- Default gear enforcement on mobile respawn.
if ((missionNamespace getVariable "WF_C_RESPAWN_MOBILE") == 2) then {
	if (_typeof in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {_allowCustom = false};
};

[_this # 0] spawn {
	waitUntil {!isNil "ASL_Add_Player_Actions"};

	if!(_this # 0 getVariable ["ASL_Actions_Loaded",false]) then {
		[] call ASL_Add_Player_Actions;
		_this # 0 setVariable ["ASL_Actions_Loaded",true];
	};
};

waitUntil {clientInitComplete};

_respawnRoleCombo = uiNamespace getVariable (["BIS_RscRespawnControlsMap_ctrlRoleList", "BIS_RscRespawnControlsSpectate_ctrlComboLoadout"] select (uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]));
WF_SK_V_Type = _respawnRoleCombo lbText (lbCurSel _respawnRoleCombo);

_respawnCombo = uiNamespace getVariable (["BIS_RscRespawnControlsMap_ctrlComboLoadout", "BIS_RscRespawnControlsSpectate_ctrlComboLoadout"] select (uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]));
_respawnTemplateDisplayName = _respawnCombo lbText (lbCurSel _respawnCombo);

if (_respawnTemplateDisplayName == 'Last Saved Gear') then {
			_respawn_gear = if (isNil 'WF_P_CurrentGear') then {missionNamespace getVariable format ["WF_AI_%1_DEFAULT_GEAR", WF_Client_SideJoined]} else {WF_P_CurrentGear};
    [player, _respawn_gear] call WFCO_FNC_EquipUnit;
};

WF_PlayerMenuAction = player addAction ["<t color='#42b6ff'>" + (localize "STR_WF_Options") + "</t>",{createDialog "WF_Menu"}, "", 999, false, true, "", ""];
(_unit) Call WFCL_fnc_applySkill;

if (!isNull commanderTeam) then {
	_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
    _hqs = [(leader WF_Client_Team),_mhqs] call WFCO_FNC_GetClosestEntity;
	if (commanderTeam == group _unit) then {
		HQAction = _unit addAction [localize "STR_WF_BuildMenu",{call WFCL_fnc_callBuildMenu}, [_hqs], 1000, false, true, "", "hqInRange && canBuildWHQ && (_target == player)"];
    };
};

// adjusting fatigue
if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
    (leader WF_Client_Team) setCustomAimCoef 0.35;
    (leader WF_Client_Team) setUnitRecoilCoefficient 0.75;
    (leader WF_Client_Team) enablestamina false;
};

[WF_Client_SideJoinedText,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;