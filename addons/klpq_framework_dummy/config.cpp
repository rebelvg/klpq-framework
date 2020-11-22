class CfgPatches
{
    class klpq_framework
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1;
        requiredAddons[] = {};
        version = "1.5.0";
        name = "KLPQ Framework";
        author = "KLPQ";
        url = "http://arma.klpq.men/";
    };
};

class CfgVehicles
{
    class Logic;
    class KLPQ_framework: Logic {
        displayName = "KLPQ Framework";
    };
};
