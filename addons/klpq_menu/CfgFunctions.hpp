class klpq_menu
{
    class functions
    {
        file = "klpq_menu\functions";

        class menuFunctions {preInit = 1;};
        class spectatorFunctions {preInit = 1;};
        class menuInit {postInit = 1;};
        class handleDisconnect {postInit = 1;};
        class checkAddons {postInit = 1;};
        class gcamInit {preInit = 1;};
        class spectatorInit {postInit = 1;};
    };

    class initEvents
    {
        file = "klpq_menu\initEvents";

        class unit {};
        class vehicle {};
    };
};
