
params ["_unit","_JIP"];

// Only add this comm menu
_unit spawn F85_textureSwap_addCommunicationMenu;
// The communication is added after a small delay. If you want to add multiple comm menus in
// a specific order, call the safeAdd function directly.
//[_unit, ["F85_textureSwapCommunicationMenu","F85_textureSwapCommunicationMenu"]] spawn F85_textureSwap_safeAddMenus;