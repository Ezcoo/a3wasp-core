// by ALIAS
// SNOW STORM SCRIPT DEMO
// Tutorial: https://www.youtube.com/aliascartoons

if (!isServer) exitWith {};
params ["_snowfall","_duration_storm","_ambient_sounds_al","_breath_vapors","_snow_burst","_effect_on_objects","_vanilla_fog","_local_fog","_intensifywind","_unitsneeze"];
[] execVM "Common\Module\Weather\SnowStorm\alias_hunt.sqf"; waitUntil {!isNil "hunt_alias"};
if (_vanilla_fog) then {al_foglevel = fog; publicVariable "al_foglevel"; 60 setFog [1,0.01,0.5]};
[_duration_storm] spawn {params ["_duration_storm"];al_snowstorm_om=true; publicvariable "al_snowstorm_om"; sleep _duration_storm; al_snowstorm_om=false; publicvariable "al_snowstorm_om"; if (!isNil "al_foglevel") then {60 setFog al_foglevel}};
sleep 5;
["Common\Module\Weather\SnowStorm\al_check_pos.sqf"] remoteExec ["execVM",0,true];
if (_local_fog) then {["Common\Module\Weather\SnowStorm\medium_fog.sqf"] remoteExec ["execVM",0,true]};
if (_ambient_sounds_al>0) then {[_ambient_sounds_al] execvm "Common\Module\Weather\SnowStorm\umblator.sqf"};
if (_breath_vapors) then {["Common\Module\Weather\SnowStorm\snow_breath.sqf"] remoteExec ["execVM",0,true]};
if (_unitsneeze) then {["Common\Module\Weather\SnowStorm\al_unit_seeze.sqf"] remoteExec ["execVM",0,true]};
if (_snowfall) then {["Common\Module\Weather\SnowStorm\alias_snowfall_SFX.sqf"] remoteExec ["execVM",0,true]};
if (_snow_burst>0) then {[_effect_on_objects] execvm "Common\Module\Weather\SnowStorm\rotocol_server.sqf"; interval_burst = _snow_burst; publicVariable "interval_burst"; sleep 10; [[_unitsneeze],"Common\Module\Weather\SnowStorm\rotocol_client.sqf"] remoteExec ["execVM",0,true]};
if (_intensifywind) then {
	["Common\Module\Weather\SnowStorm\intens_sound.sqf"] remoteExec ["execVM",0,true];
	al_windlevel	= wind;	for "_i" from 1 to 5 step 0.2 do {setWind [(al_windlevel#0)*_i,(al_windlevel#1)*_i,true]; sleep 4};
	waitUntil {sleep 60; !al_snowstorm_om};
	al_windlevel	= wind;	for "_i" from 1 to 5 step 0.1 do {setWind [(al_windlevel#0)/_i,(al_windlevel#1)/_i,true]; sleep 4};
};

