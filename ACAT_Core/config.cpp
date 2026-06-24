// In the following example addons refers to CfgPatches class name, NOT PBO file name!
class CfgSettings
{
    class ACAT
    {
        debug = 0;   // 0 = off, 1 = on
    };
};
class CfgPatches
{
	class ACAT_Core
	{
		// Meta information for editor
		name = "ACAT Core";
		author = "ACAT";

		// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game. Note: was disabled on purpose some time late into Arma 2: OA.
		requiredVersion = 2.20;

		// Required addons, used for setting load order.
		// When any of the addons are missing, a pop-up warning will appear when launching the game.
		requiredAddons[] = 
		{ 
			"A3_UI_F", 
			"A3_Functions_F", 
			"A3_Modules_F",
			"cba_main",
            "ace_main",
            "ace_spectator",
			"ace_interact_menu"
		};

		// List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
		units[] = 
		{
			"ACAT_Module_AddSpectate_Eden",
    		"ACAT_Module_AddSpectate_Zeus"
		};

		// List of weapons (CfgWeapons classes) contained in the addon.
		weapons[] = {};

		// Optional. If this is 1, if any of requiredAddons[] entry is missing in your game the entire config will be ignored and return no error (but in rpt) so useful to make a compat Mod (Since Arma 3 2.14)
		skipWhenMissingDependencies = 0;

		// Optional. If any of the addons in the array are found, MyAddon is not loaded. 
		// AVOID SKIPPING ON AN ADDON THAT ITSELF MIGHT BE SKIPPED IF ANOTHER ADDON IS PRESENT
		//skipWhenAnyAddonPresent[] = { "AnotherAddon1", "AnotherAddon2" }; // Arma 3 Profiling only as of 19.10.25
	};
};

#include "cfgFunctions.hpp"
#include "cfgFactionClasses.hpp"
#include "cfgVehicles_Modules.hpp"
#include "cfgXEH.hpp"