/**
 * Fafnir's dead-simple texture switching command module
 *
 * Author: Fafnir
 * Homepage: https://github.com/maybe-dragon/arma3-texture-swap
 * License: MIT
 */

F85_TextureSwap_addCommunicationMenu = {
	params [["_unit", objnull]];

	[_unit, ["F85_TextureSwap_CommunicationMenu"]] call F85_TextureSwap_safeAddMenus;
};

F85_TextureSwap_safeAddMenus = {
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

F85_TextureSwap_showVehicleSubMenu = {
	params ["_player"];

	private _vehicle = vehicle _player;
 	if (_vehicle == _player) exitWith {
	  systemChat 'Texture Swap: You are not in a vehicle';
	  false
	};

	private _vehDisplayName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");

	createDialog "F85_TextureSwap_MainDialog";
	private _display = findDisplay 85000;
	private _textureList = _display displayCtrl 1500;
	private _animationList = _display displayCtrl 1501;

	[_player, _textureList] call F85_TextureSwap_generateTextureList;
	[_player, _animationList] call F85_TextureSwap_generateAnimationList;

	_textureList ctrlAddEventHandler ["LBSelChanged",
		format ["[%1, _this select 0, _this select 1] call F85_TextureSwap_setTextureFromControl;", _player]];
	_animationList ctrlAddEventHandler ["LBSelChanged",
		format ["[%1, _this select 0, _this select 1] call F85_TextureSwap_setAnimationFromControl", _player]];

	playSound "Click";
	true
};

F85_TextureSwap_generateTextureList = {
	params ["_player", "_control"];

	private _vehicle = vehicle _player;
	private _textureSources = "true" configClasses (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources");

	{
		private _configName = configName _x;
		private _textureName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources" >> _configName >> "displayName");

		private _index = _control lbAdd _textureName;
		_control lbSetData [_index, configName _x];

		private _textures = getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources" >> _configName >> "textures");
		private _currentTextures = getObjectTextures _vehicle;
		if ([_currentTextures, _textures] call F85_TextureSwap_areTexturesEqual) then {
			_control lbSetCurSel _index;
		};
	} forEach _textureSources;
};

F85_TextureSwap_areTexturesEqual = {
	params ["_a", "_b"];
	if (count _a != count _b) exitWith {
		false
	};
	private _result = true;
	for "_i" from 0 to (count _a) - 1 do {
		private _nA = (_a select _i) call F85_TextureSwap_normalizeTextureString;
		private _nB = (_b select _i) call F85_TextureSwap_normalizeTextureString;
		// Case insensitive string comparison
		if (_nA != _nB) exitWith {
			_result = false;
		};
	};
	_result;
};

F85_TextureSwap_normalizeTextureString = {
	// Some textures strings start with a "\"
	params ["_tex"];
	if (_tex select [0, 1] == "\") exitWith {
		_tex select [1]
	};
	_tex
};

F85_TextureSwap_setTextureFromControl = {
	params ["_player", "_control", "_selectedIndex"];

	private _textureName = _control lbData _selectedIndex;
	[_player, _textureName] call F85_TextureSwap_setTexture;
};

F85_TextureSwap_setTexture = {
	params ["_player", "_textureName"];

	private _vehicle = vehicle _player;
	private _textures = getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources" >> _textureName >> "textures");

	{
		_vehicle setObjectTextureGlobal [_forEachIndex, _x];
	} forEach _textures;

	playSound "Click";
	true
};

F85_TextureSwap_generateAnimationList = {
	params ["_player", "_control"];

	private _vehicle = vehicle _player;
	private _animationsList = getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "animationList");
	// animationList contains animation names and their probabilities
	private _animationNames = [];
	{
		if (_x isEqualType "") then {
			// _x is a string
			_animationNames pushBack _x;
		}
	} forEach _animationsList;

	{
		private _animationName = _x;
		private _displayName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "AnimationSources" >> _animationName >> "displayName");
		if (_displayName == "") then {
			_displayName = _animationName;
		};

		private _index = _control lbAdd _displayName;
		_control lbSetData [_index, _animationName];
	} forEach _animationNames;
};

F85_TextureSwap_setAnimationFromControl = {
	params ["_player", "_control", "_selectedIndex"];

	private _animationName = _control lbData _selectedIndex;
	[_player, _animationName] call F85_TextureSwap_toggleAnimation;
};

F85_TextureSwap_toggleAnimation = {
	params ["_player", "_animationName"];

	private _vehicle = vehicle _player;

	private _currentPhase = _vehicle animationSourcePhase _animationName;
	if (_currentPhase < 0.5) then {
		_vehicle animateSource [_animationName, 1, 1];
	} else {
		_vehicle animateSource [_animationName, 0, 1];
	};
};
