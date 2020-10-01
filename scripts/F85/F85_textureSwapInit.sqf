/**
 * Fafnir's dead-simple texture switching command module
 *
 * Inspired by GOM_fnc_aircraftLoadout V1.35 made by Grumpy Old Man 17-5-2017
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
	MENU_COMMS_TEX_1 = _player call F85_textureSwap_generateTextureMenu;
	MENU_COMMS_ANIM_1 = _player call F85_textureSwap_generateAnimationMenu;

	MENU_COMMS_1 = [
		["Customize vehicle", true],
		["Textures", [2], "#USER:MENU_COMMS_TEX_1", -5, [], "1", "count MENU_COMMS_TEX_1 > 1"],
		["Animations", [3], "#USER:MENU_COMMS_ANIM_1", -5, [], "1", "count MENU_COMMS_ANIM_1 > 1"]
	];
	showCommandingMenu "#USER:MENU_COMMS_1";

	playSound "Click";
	true
};

F85_textureSwap_generateTextureMenu = {
	params ["_player"];

	_vehicle = vehicle _player;
	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources");

	_comm_menu = [ ["Select texture", true] ]; // Menu name, has input focus
	{
		_textureName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources" >> configName _x >> "displayName");

		_comm_menu pushBack [
			_textureName, // title
			[(2 + _forEachIndex)], // key
			"", // Submenu_name
			-5, // CMD (-5: CMD_EXECUTE)
			[["expression", (format ["[%1, %2] call F85_textureSwap_setTexture;", _player, _forEachIndex])]],
			"1", // isVisible
			"1" // isActive
		];
	} foreach _textureSources;

	_comm_menu
};

F85_textureSwap_setTexture = {

	params ["_player", "_sourceIndex"];

	_vehicle = vehicle _player;
	if (_vehicle == _player) exitWith {
	  systemChat 'Texture Swap: Please stay in the vehicle';
	  false
	};

	_displayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "displayName");
	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "TextureSources");

	if (count _textureSources == 0) exitWith {
		systemChat "Texture Swap: Vehicle does not have any texture sources. How did you get here?";
		false
	};

	_selectedSource = _textureSources select _sourceIndex;
	_textures = getArray (configfile >> "CfgVehicles" >> typeof _vehicle >> "TextureSources" >> configName _selectedSource >> "textures");

	{
		_vehicle setObjectTextureGlobal [_forEachIndex, _x];
	} foreach _textures;

	playSound "Click";
	true
};

F85_textureSwap_generateAnimationMenu = {
	params ["_player"];

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

	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources");
	if (count _textureSources == 0) exitWith {
		//  Vehicle does not have any texture sources
		systemChat "Texture Swap: Cannot customize this vehicle";
		false
	};

	_comm_menu = [ ["Trigger animation", true] ]; // Menu name, has input focus
	{
		_animationName = _x;
		_displayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "AnimationSources" >> _animationName >> "displayName");
		if (_displayName == "") then {
			_displayName = _animationName;
		};

		_comm_menu pushBack [
			_displayName, // title
			[(2 + _forEachIndex)], // key
			"", // Submenu_name
			-5, // CMD (-5: CMD_EXECUTE)
			[["expression", (format ["[%1, '%2'] call F85_textureSwap_triggerAnimation;", _player, _animationName])]],
			"1", // isVisible
			"1" // isActive
		];
	} foreach _animationNames;

	_comm_menu
};

F85_textureSwap_triggerAnimation = {
	params ["_player", "_animationName"];

	_vehicle = vehicle _player;
	if (_vehicle == _player) exitWith {
		systemChat 'Texture swap: Please stay in the vehicle';
		false
	};

	_currentPhase = _vehicle animationSourcePhase _animationName;
	if (_currentPhase < 0.5) then {
		_vehicle animateSource [_animationName, 1, 1];
	} else {
		_vehicle animateSource [_animationName, 0, 1];
	};
};
