#include "gcam\gcam_component.hpp"

class CfgPatches
{
    class klpq_menu
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1;
        requiredAddons[] = {
            "ace_common",
            "ace_aircraft"
        };
        version = "2.2.0";
    };
};

class CfgFunctions
{
    #include "CfgFunctions.hpp"
};

class Extended_InitPost_EventHandlers
{
    #include "Extended_InitPost_EventHandlers.hpp"
};
