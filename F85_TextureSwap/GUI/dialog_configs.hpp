#include "dialog_parent_configs.hpp"

// Grid Macros
#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

// Control ids
#define IDC_F85_TEXTURESWAP_RSCLISTBOX_TEXTURES 1500
#define IDC_F85_TEXTURESWAP_RSCLISTBOX_ANIMATIONS 1501

class F85_TextureSwap_MainDialog {
	idd = 85000;
	movingEnable = false;
	enableSimulation = true;
	class Controls {
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT START (by Fafnir, v1.063, #Dyryvo)
		////////////////////////////////////////////////////////
		class F85_TextureSwap_Label_Texture: F85_TextureSwap_RscText
		{
			idc = -1;
			text = "Select Texture"; //--- ToDo: Localize;
			x = 6 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class F85_TextureSwap_ListBox_Texture: F85_TextureSwap_RscListbox
		{
			idc = IDC_F85_TEXTURESWAP_RSCLISTBOX_TEXTURES;
			x = 6 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 13 * GUI_GRID_H;
		};
		class F85_TextureSwap_Label_Animation: F85_TextureSwap_RscText
		{
			idc = -1;
			text = "Toggle Extras"; //--- ToDo: Localize;
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class F85_TextureSwap_ListBox_Animation: F85_TextureSwap_RscListbox
		{
			idc = IDC_F85_TEXTURESWAP_RSCLISTBOX_ANIMATIONS;
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 12 * GUI_GRID_W;
			h = 13 * GUI_GRID_H;
			style = ST_MULTI + LB_MULTI;
		};
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////
	};
};
