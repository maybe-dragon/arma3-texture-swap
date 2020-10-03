/**
 * Fafnir's dead-simple texture switching command module
 *
 * Author: Fafnir
 * Homepage: https://github.com/maybe-dragon/arma3-texture-swap
 * License: MIT
 */

F85_textureSwap_addCommunicationMenu = {
	params [["_unit", objnull]];

	[_unit, ["F85_textureSwapCommunicationMenu"]] call F85_textureSwap_safeAddMenus;
};

F85_textureSwap_safeAddMenus = {
	// I don't actually know whether all this is really necessary. But better safe than sorry. JIP problems?

	params [["_unit", objnull], "_menus"];

	if (_unit isequalto objnull) exitWith {systemchat "Texture Swap: You need to enter a player as parameter"};

	waitUntil {_unit isequalto _unit};
	sleep 1;

	{
		[_unit, _x] call BIS_fnc_addCommMenuItem;
	} forEach _menus;

	true
};

F85_textureSwap_showVehicleSubMenu = {
	params ["_player"];

	_vehicle = vehicle _player;
 	if (_vehicle == _player) exitWith {
	  systemChat 'Texture Swap: You are not in a vehicle';
	  false
	};

	_vehDisplayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "displayName");

	createDialog "F85_TextureSwap_MainDialog";
	_display = findDisplay 85000;
	_textureList = _display displayCtrl 1500;
	_textureList ctrlAddEventHandler ["LBSelChanged",
		format ["[%1, _this select 0, _this select 1] call F85_TextureSwap_setTextureFromControl;", _player]];
	_animationList = _display displayCtrl 1501;
	_animationList ctrlAddEventHandler ["LBSelChanged",
		format ["[%1, _this select 0, _this select 1] call F85_TextureSwap_setAnimationFromControl", _player]];

	[_player, _textureList] call F85_textureSwap_generateTextureList;
	[_player, _animationList] call F85_textureSwap_generateAnimationList;

	playSound "Click";
	true
};

F85_textureSwap_generateTextureList = {
	params ["_player", "_control"];

	_vehicle = vehicle _player;
	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources");

	{
		_textureName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources" >> configName _x >> "displayName");

		_index = _control lbAdd _textureName;
		_control lbSetData [_index, configName _x];
	} foreach _textureSources;
};

F85_TextureSwap_setTextureFromControl = {
	params ["_player", "_control", "_selectedIndex"];

	_textureName = _control lbData _selectedIndex;
	[_player, _textureName] call F85_textureSwap_setTexture;
};

F85_textureSwap_setTexture = {
	params ["_player", "_textureName"];

	_vehicle = vehicle _player;
	_textures = getArray (configfile >> "CfgVehicles" >> typeof _vehicle >> "TextureSources" >> _textureName >> "textures");

	{
		_vehicle setObjectTextureGlobal [_forEachIndex, _x];
	} foreach _textures;

	playSound "Click";
	true
};

F85_textureSwap_generateAnimationList = {
	params ["_player", "_control"];

	_vehicle = vehicle _player;
	_animationsList = getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "animationList");
	// animationList contains animation names and their probabilities
	_animationNames = [];
	{
		if (_x isEqualType "") then {
			// _x is a string
			_animationNames pushBack _x;
		}
	} forEach _animationsList;

	{
		_animationName = _x;
		_displayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "AnimationSources" >> _animationName >> "displayName");
		if (_displayName == "") then {
			_displayName = _animationName;
		};

		_index = _control lbAdd _displayName;
		_control lbSetData [_index, _animationName];
	} foreach _animationNames;
};

F85_TextureSwap_setAnimationFromControl = {
	params ["_player", "_control", "_selectedIndex"];

	_animationName = _control lbData _selectedIndex;
	[_player, _animationName] call F85_textureSwap_toggleAnimation;
};

F85_textureSwap_toggleAnimation = {
	params ["_player", "_animationName"];

	_vehicle = vehicle _player;

	_currentPhase = _vehicle animationSourcePhase _animationName;
	if (_currentPhase < 0.5) then {
		_vehicle animateSource [_animationName, 1, 1];
	} else {
		_vehicle animateSource [_animationName, 0, 1];
	};
};
