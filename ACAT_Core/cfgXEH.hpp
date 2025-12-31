class Extended_PreInit_EventHandlers
{
    class ACAT_Core_PreInit
    {
        init = "call compile preprocessFileLineNumbers '\ACAT_Core\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers
{
    class ACAT_Core_PostInit_Client
    {
        // Client-only init: runs after mission init, on each client
        clientInit = "call ACAT_fnc_clientInit;";
    };
};
