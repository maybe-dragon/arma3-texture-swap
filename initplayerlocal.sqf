
params ["_unit","_JIP"];

// Only add this comm menu, or...
_unit spawn F85_TextureSwap_addCommunicationMenu;

// The communication menu is added after a small delay. If you want to add multiple comm menus in
// a specific order, use the safeAdd function instead.
// For example: This script in combination with GOM Aircraft Loadout:
// [_unit, ["GOM_aircraftLoadoutMenu","F85_TextureSwap_CommunicationMenu"]] spawn F85_TextureSwap_safeAddMenus;