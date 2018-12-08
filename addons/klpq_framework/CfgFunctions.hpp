class functions
{
    file = "klpq_framework\functions";

    class frameworkInit {preInit = 1;};
    class frameworkPostInit {postInit = 1;};
    class giveLoadout {};
    class fillBox {};
    class fillBoxMedical {};
    class handleBox {};
    class onlyPilotsCanFlyPlayer {};
    class onlyPilotsCanFlyVehicle {};
};

class ai
{
    file = "klpq_framework\ai";

    class spawnerInit {preInit = 1;};
    class spawnerPostInit {postInit = 1;};
    class garbageCollectionLoop {};
};

class initEvents
{
    file = "klpq_framework\initEvents";

    class unitInit {};
    class vehicleInit {};
    class boxInit {};
};

class scripts
{
    file = "klpq_framework\scripts";

    class frameworkBriefing {};
    class acreSettings {};
    class radioBriefing {};
    class teamRoster {};
};
