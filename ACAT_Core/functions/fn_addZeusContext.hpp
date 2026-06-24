/*
    ACAT Core - Self Interact Scripts
*/

class zen_context_menu_actions {//Zen Actions
	//https://zen-mod.github.io/ZEN/#/frameworks/context_menu?id=adding-actions-through-config
	class ACAT_Functions {
		displayName = "Zeus Functions";
		class hidezeus {
			displayName ="Hide Zeus";
			statement = "[LOGIC] call zen_modules_fnc_moduleHideZeus";
		};
		class fpsMonitor {
			displayName ="Toggle FPS Monitor";
			condition = "hasInterface && !isNull findDisplay 312";
			statement  = "private _start = (isNil 'FPSMON_handle') || {isNull FPSMON_handle}; [_start, 3] execVM 'scripts\monitor.sqf'";
		};
	};
};