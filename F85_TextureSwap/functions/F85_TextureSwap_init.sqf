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

F85_TextureSwap_showVehicleMenu = {
	private _vehicle = vehicle player;

 	if (_vehicle == player) exitWith {
		hint "Texture Swap failed \nGet in the driver seat of a vehicle.";
		false
	};

	// TODO: Add a configuration parameter to toggle this functionality
	// if (not (driver _vehicle isEqualTo player)) exitWith {
	// 	hint "Texture Swap failed \nGet in the driver seat first.";
	// 	false
	// };

	createDialog "F85_TextureSwap_MainDialog";
	private _display = findDisplay 85000;
	private _textureList = _display displayCtrl 1500;
	private _animationList = _display displayCtrl 1501;

	[_vehicle, _textureList] call F85_TextureSwap_generateTextureList;
	[_vehicle, _animationList] call F85_TextureSwap_generateAnimationList;

	player setVariable ["F85_TextureSwap_targetVehicle", _vehicle];
	_textureList ctrlAddEventHandler ["LBSelChanged", F85_TextureSwap_setTextureFromControl];
	_animationList ctrlAddEventHandler ["LBSelChanged", F85_TextureSwap_setAnimationFromControl];

	playSound "Click";
	true
};

F85_TextureSwap_generateTextureList = {
	params ["_vehicle", "_control"];

	private _textureSources = configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources";
	{
		private _textureSource = _textureSources >> configName _x;
		private _textureDisplayName = getText (_textureSource >> "displayName");

		private _index = _control lbAdd _textureDisplayName;
		_control lbSetData [_index, configName _x];

		private _textures = getArray (_textureSource >> "textures");
		private _currentTextures = getObjectTextures _vehicle;
		if ([_currentTextures, _textures] call F85_TextureSwap_areTexturesEqual) then {
			_control lbSetCurSel _index;
		};
	} forEach ("true" configClasses _textureSources);
};

F85_TextureSwap_areTexturesEqual = {
	// Compares arrays of texture names (string[]). Case insensitive. Ignores leading '\'.
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
			// break loop
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
	params ["_control", "_selectedIndex"];

	private _vehicle = player getVariable "F85_TextureSwap_targetVehicle";
	private _textureName = _control lbData _selectedIndex;
	[_vehicle, _textureName] call F85_TextureSwap_setTexture;

	playSound "Click";
};

F85_TextureSwap_setTexture = {
	params ["_vehicle", "_textureName"];

	private _textures = getArray (configFile >> "CfgVehicles" >> typeOf _vehicle >> "TextureSources" >> _textureName >> "textures");
	{
		_vehicle setObjectTextureGlobal [_forEachIndex, _x];
	} forEach _textures;
};

F85_TextureSwap_generateAnimationList = {
	params ["_vehicle", "_control"];

	private _vehicleConfig = configFile >> "CfgVehicles" >> typeOf _vehicle;
	// TODO filter AnimationSources directly?
	private _animationsList = getArray (_vehicleConfig >> "animationList");
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
		private _displayName = getText (_vehicleConfig >> "AnimationSources" >> _animationName >> "displayName");
		if (_displayName == "") then {
			_displayName = _animationName;
		};

		private _index = _control lbAdd _displayName;
		_control lbSetData [_index, _animationName];
		// Set selection if animation is active
		private _currentPhase = _vehicle animationSourcePhase _animationName;
		if (_currentPhase > 0.5) then {
			_control lbSetSelected [_index, true];
		};
	} forEach _animationNames;
};

F85_TextureSwap_setAnimationFromControl = {
	params ["_control", "_selectedIndex"];

	// Normally the listbox would unselect all entries on an unmodified click. But we
	// want all previously selected items selected.
	// We can't change the current selection inside this handler. Spawn a new function (async)
	[_control, lbSelection _control, _selectedIndex] spawn F85_TextureSwap_addToSelection;

	private _vehicle = player getVariable "F85_TextureSwap_targetVehicle";
	private _animationName = _control lbData _selectedIndex;
	[_vehicle, _animationName] call F85_TextureSwap_toggleAnimation;

	playSound "Click";
};

F85_TextureSwap_addToSelection = {
	// Select all rows in _selection, except for the current row
	params ["_control", "_selection", "_current"];
	{
		_control lbSetSelected [_x, _x != _current];
	} forEach _selection;
};

F85_TextureSwap_toggleAnimation = {
	params ["_vehicle", "_animationName"];

	private _currentPhase = _vehicle animationSourcePhase _animationName;
	if (_currentPhase < 0.5) then {
		_vehicle animateSource [_animationName, 1, 1];
	} else {
		_vehicle animateSource [_animationName, 0, 1];
	};
};
