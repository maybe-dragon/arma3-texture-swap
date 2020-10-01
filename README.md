# Arma 3 - Texture swap script
Dead-simple vehicle texture change script

Inspired by [GOM_fnc_aircraftLoadout by Grumpy Old Man](https://www.armaholic.com/page.php?id=32755)

## Features
  - Change the texture of the currently controlled vehicle
  - Toggle animations of the vehicle (e.g. bags, camo nets, tools, ...)

## Usage

The included showcase adds a support module to trigger the functionality, but that is not necessary. You could call `[player] call F85_textureSwap_showVehicleSubMenu` from any user interaction.

However, currently the script expects the player to sit inside of the vehicle which he wants to change.

- Copy the `scripts` folder
- Add (or merge) the class configs from `description.ext` to your own
- Set up the communication menu for all players (or just some players). See the example in `initPlayerLocal.sqf`

## Limitations

- Texture selection does not look very good for vehicles with more than 10 skins (eg. MH-900) (but it works just fine)
- Not all animations can be toggled. Only animations which are listed for randomization at spawn are listed.
