/** 
 * Fafnir's dead-simple texture switching command module
 *
 * Inspired by GOM_fnc_aircraftLoadout V1.35 made by Grumpy Old Man 17-5-2017
 */


F85_textureSwap_addCommunicationMenu = {

	params [["_unit",objnull]];
	
	if (_unit isequalto objnull) exitWith {systemchat "Texture Swap: You need to enter a player as parameter"};
	
	waitUntil {_unit isequalto _unit};
	sleep 1;
	_support = [_unit,"F85_textureSwapCommunicationMenu"] call BIS_fnc_addCommMenuItem;

	true
};

F85_textureSwap_showVehicleSubMenu = {

	params ["_player"];

	_vehicle = vehicle _player;
 	if (_vehicle == _player) exitWith {
	  systemChat 'Texture Swap: You are not in a vehicle';
	  false
	};

	_displayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "displayName");
	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources");
	if (count _textureSources == 0) exitWith {
		systemChat "Texture Swap: Vehicle does not have any texture sources";
		false
	};
	
	MENU_COMMS_1 = [ ["Select texture", false] ]; // Menu name, has input focus
	{
		_textureName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources" >> configName _x >> "displayName");
		
		MENU_COMMS_1 pushBack [
			_textureName, // title
			[(2 + _forEachIndex)], // key
			"", // Submenu_name
			-5, // CMD (-5: CMD_EXECUTE)
			[["expression", (format ["[%1, %2] call F85_textureSwap_setTexture;", _player, _forEachIndex])]],
			"1", // isVisible
			"1" // isActive
		];
	} foreach _textureSources;
	
	showCommandingMenu "#USER:MENU_COMMS_1";

	playSound "Click";
	true
};

F85_textureSwap_setTexture = {

	params ["_player", "_sourceIndex"];

	_vehicle = vehicle _player;
	if (_vehicle == _player) exitWith {
	  systemChat 'Texture Swap: Please stay in the vehicle';
	  false
	};
	
	_displayName = getText (configfile >> "CfgVehicles" >> typeof _vehicle >> "displayName");
	_textureSources = "true" configClasses (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources");

	if (count _textureSources == 0) exitWith {
		systemChat "Texture Swap: Vehicle does not have any texture sources. How did you get here?";
		false
	};
	
	_selectedSource = _textureSources select _sourceIndex;
	_textures = getArray (configfile >> "CfgVehicles" >> typeof _vehicle >> "textureSources" >> configName _selectedSource >> "textures");

	{
		_vehicle setObjectTextureGlobal [_forEachIndex, _x];
	} foreach _textures;

	playSound "Click";
	true
};
