class CfgVehicles
{
	class Logic;
	class Module_F : Logic
	{
		class AttributesBase;
		class ModuleDescription;
	};

	class ACAT_Module_AddSpectate_Eden : Module_F
	{
		// Standard object definitions:
		scope = 2;												// Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 0;										// Zeus visibility
		displayName = "Add Spectate (ACAT)";					// Name displayed in the menu
		icon = "\ACAT_Core\data\icon_Spectate_ca.paa";			// Map icon. Delete this entry to use the default icon.
		category = "ACAT_Modules";

		function = "ACAT_fnc_addSpectateModule";				// Name of function triggered once conditions are met
		functionPriority = 1;									// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 1;											// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 0;									// 1 for module waiting until all synced triggers are activated
		isDisposable = 0;										// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		is3DEN = 0;												// 1 to run init function in Eden Editor as well
		curatorCanAttach = 0;									// 1 to allow Zeus to attach the module to an entity

		// Module description (must inherit from base class, otherwise pre-defined entities won't be available)
		class ModuleDescription : ModuleDescription
		{
			description = "Adds ACAT spectate functionality.";		// Short description, will be formatted as structured text
			sync[] = {"AnyVehicle","EmptyDetector"};	// Array of synced entities (can contain base classes)
		};

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes : AttributesBase
		{
            class ACAT_createTriggerArea
            {
                property = "ACAT_createTriggerArea";
                control = "Checkbox";
                displayName = "Create Trigger Area";
                tooltip = "If enabled, create a trigger area as part of spectate setup.";
                typeName = "BOOL";
                defaultValue = "false";
				expression = "_this setVariable ['ACAT_createTriggerArea', _value, true];";
            };
		
			class ModuleDescription : ModuleDescription {}; // Module description should be shown last
		};

		// 3DEN Attributes Menu Options
		canSetArea = 1;						// Allows for setting the area values in the Attributes menu in 3DEN
		canSetAreaShape = 1;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 1;				// Allows for setting height or Z value in Attributes menu in 3DEN
		class AttributeValues
		{
			// This section allows you to set the default values for the attributes menu in 3DEN
			size3[] = { 10, 10, -1 };		// 3D size (x-axis radius, y-axis radius, z-axis radius)
			isRectangle = 0;				// Sets if the default shape should be a rectangle or ellipse
		};
	};

	class ACAT_Module_AddSpectate_Zeus : Module_F
	{
	    scope = 1;            // not shown in Eden (optional)
	    scopeCurator = 2;     // shown in Zeus
		curatorInfoType      = "RscDisplayAttributesModule";
		curatorInfoTypeEmpty = "RscDisplayAttributesModuleEmpty";
	    displayName = "Add Spectate (ACAT) [Zeus] WIP";
		icon = "\ACAT_Core\data\icon_Spectate_ca.paa";
	    category = "ACAT_Modules";

	    function = "ACAT_fnc_addSpectateModule";
	    functionPriority = 1;
	    isGlobal = 2;         
	    isTriggerActivated = 0;
	    isDisposable = 1;     // Zeus modules are commonly disposable

	    class ModuleDescription : ModuleDescription
	    {
	        description = "Zeus: Adds ACAT spectate functionality. Place on an object to add spectate functionality around it.";
	        sync[] = {"AnyVehicle"};
	    };

	    class Attributes : AttributesBase
	    {
	        class ACAT_createTriggerArea
	        {
	            property = "ACAT_createTriggerArea";
	            control = "Checkbox";
	            displayName = "Create Trigger Area";
	            tooltip = "Always creates a new trigger area when used from Zeus.";
	            typeName = "BOOL";
	            defaultValue = "true";
	        };
			class ACAT_a
        	{
        	    property = "ACAT_a";
        	    control = "Edit";
        	    displayName = "Spectate Width (a)";
        	    tooltip = "Width of the Spectate area (half-size).";
        	    typeName = "NUMBER";
        	    defaultValue = "0";
				expression = "_this setVariable ['ACAT_a', _value, true];";
        	};

        	class ACAT_b
        	{
        	    property = "ACAT_b";
        	    control = "Edit";
        	    displayName = "Spectate Length (b)";
        	    tooltip = "Length of the Spectate area (half-size).";
        	    typeName = "NUMBER";
        	    defaultValue = "0";
				expression = "_this setVariable ['ACAT_b', _value, true];";
        	};

        	class ACAT_c
        	{
        	    property = "ACAT_c";
        	    control = "Edit";
        	    displayName = "Spectate Height (c)";
        	    tooltip = "Height of the Spectate area (half-size).";
        	    typeName = "NUMBER";
        	    defaultValue = "-1";
				expression = "_this setVariable ['ACAT_c', _value, true];";
        	};

        	class ACAT_angle
        	{
        	    property = "ACAT_angle";
        	    control = "Edit";
        	    displayName = "Angle";
        	    tooltip = "Area rotation in degrees.";
        	    typeName = "NUMBER";
        	    defaultValue = "0";
				expression = "_this setVariable ['ACAT_angle', _value, true];";
        	};

        	class ACAT_isRectangle
        	{
        	    property = "ACAT_isRectangle";
        	    control = "Checkbox";
        	    displayName = "Rectangle";
        	    tooltip = "If enabled, use rectangle shape; otherwise ellipse.";
        	    typeName = "BOOL";
        	    defaultValue = "false";
				expression = "_this setVariable ['ACAT_isRectangle', _value, true];";
        	};

	        class ModuleDescription : ModuleDescription {};
	    };
	};
};