// Runs very early on each machine (CBA XEH).
// Define settings in preInit so they exist before postInit tries to use them.

// Platoon Roster
[
    "ACAT_EnableRoster",                 			// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable the ACAT Platoon Roster", "Adds the ACAT Platoon Roster to the Map Sidebar Menu."], // display name + tooltip
    ["ACAT", "ACAT Functions"],                     // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Catch all for player actions
[
    "ACAT_EnablePlayerSelfActions",                 // setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable ACAT Player Self Actions", "Allows you to add the ACAT ACE self-interaction menu entries."], // display name + tooltip
    ["ACAT", "Player Actions"],                     // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// AFK Script
[
    "ACAT_EnableAFK",                 				// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable ACAT Player AFK Function", "Adds the ACAT ACE AFK function to all players."], // display name + tooltip
    ["ACAT", "Player Actions"],                     // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Super Head-Bug Fix Script
[
    "ACAT_EnableSHBF",                 				// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable ACAT Player Super Headbug Fix", "Adds the ACAT ACE Super Headbug Fix function to all players."], // display name + tooltip
    ["ACAT", "Player Actions"],                     // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Stuck Script
[
    "ACAT_EnableStuck",                 			// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable ACAT Player Stuck Fix", "Adds the ACAT ACE Stuck Fix function to all players."], // display name + tooltip
    ["ACAT", "Player Actions"],                     // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Requires Zeus Enhanced/////
// Catch all for Zeus actions
[
    "ACAT_EnableZeusActions",               	    // setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable ACAT Zeus Actions", "Allows you to add the ACAT Zeus right-click menu functions."], // display name + tooltip
    ["ACAT", "Zeus Actions"],                       // category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Performance Monitor
[
    "ACAT_EnableMonitor",                			// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable the ACAT Performance Monitor", "Adds a right-click option to toggle the performance monitor script."], // display name + tooltip
    ["ACAT", "Zeus Actions"],                    	// category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

// Hide Zeus
[
    "ACAT_EnableZeusHide",                			// setting variable name (no spaces)
    "CHECKBOX",                                     // type
    ["Enable the 'Hide Zeus' Function", "Adds a right-click option to toggle the visibility of the zeus character."], // display name + tooltip
    ["ACAT", "Zeus Actions"],                    	// category (addon + subgroup)
    true,                                           // default value
    true,                                           // isGlobal: true means mission setting is synchronized in MP
    {}                                              // onChanged (optional)
] call CBA_fnc_addSetting;

