class F85_textureSwapCommunicationMenu
{
    text = "Texture Swap";
    submenu = "";
    expression = "[player] spawn F85_textureSwap_showVehicleSubMenu"; // Code executed upon activation
    icon = "\a3\Ui_f\data\gui\Cfg\CommunicationMenu\call_ca.paa"; // Icon displayed permanently next to the command menu
    cursor = "\a3\Ui_f\data\gui\Cfg\CommunicationMenu\call_ca.paa"; // Custom cursor displayed when the item is selected
    enable = "1"; // Simple expression condition for enabling the item
    removeAfterExpressionCall = 0; // 1 to remove the item after calling
};