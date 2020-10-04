
params ["_unit","_JIP"];

// If you use this as the only support, you can call the setup function directly:
_unit spawn F85_TextureSwap_addCommunicationMenu;

// But `spawn` does not guarantee scripts to be executed in order.
// Consider using F85_TextureSwap_safeAddMenus to setup multiple communication menus in a specific order:
// private _menus = ["GOM_aircraftLoadoutMenu", "F85_TextureSwap_CommunicationMenu"];
// [_unit, _menus] spawn F85_TextureSwap_safeAddMenus;

// Alternatively you could use BIS_fnc_spawnOrdered to spawn the setup functions in order:
// private _mutexName = "spawn support modules"; // Mutex can be any unique string
// [_unit, "GOM_aircraftLoadoutMenu", _mutexName] call BIS_fnc_spawnOrdered;
// [_unit, "F85_TextureSwap_addCommunicationMenu", _mutexName] call BIS_fnc_spawnOrdered;