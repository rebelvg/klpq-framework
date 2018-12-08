murshun_spectator_keydown_fnc = {
    params ["", "_key"];

    if (!(_key in murshun_spectator_keysDownArray)) then {
        murshun_spectator_keysDownArray = murshun_spectator_keysDownArray + [_key];
    };
};

murshun_spectator_keyup_fnc = {
    params ["", "_key"];

    murshun_spectator_keysDownArray = murshun_spectator_keysDownArray - [_key];
};

gcam_fnc_ChangeModeFollow = {
    gcam_var_fo = !(gcam_var_fo);

    if (gcam_var_fo) then
    {
        if (SHOWNOTICETEXT) then { titleText [ "Follow Mode Enabled", "plain down", gcam_var_w*15 ] };

        gcam_var_cfalt = 1.0;

        private _allUnits = allUnits select {!isObjectHidden _x && _x != player};

        {
            if ((gcam_var_c distance _x) < (gcam_var_c distance gcam_var_o)) then {
                gcam_var_o = _x;
            };
        } foreach _allUnits;

        if (gcam_var_be) then
        {
            gcam_var_be_odr = ((getdir gcam_var_o) -90.0) * -1;
            if (gcam_var_be_odr >= 360.0) then { gcam_var_be_odr = gcam_var_be_odr - 360.0 };
            if (gcam_var_be_odr < 0.0) then { gcam_var_be_odr = gcam_var_be_odr + 360.0 };

            gcam_var_be_cods_t = gcam_var_fo_camobjdis_last;
            gcam_var_be_codv_t = gcam_var_fo_camobjdive_last;
            gcam_var_cp_r = [ gcam_var_be_cods_t * cos(gcam_var_be_odr+180.0-gcam_var_fo_camobjdir_rel_last) * (cos gcam_var_be_codv_t), gcam_var_be_cods_t * sin(gcam_var_be_odr+180.0-gcam_var_fo_camobjdir_rel_last) * (cos gcam_var_be_codv_t), -gcam_var_be_cods_t * (sin gcam_var_be_codv_t) + gcam_var_be_ofz];

            gcam_var_dr = gcam_var_fo_dir_last;
            gcam_var_dv = gcam_var_fo_dive_last;
        }
        else
        {
            gcam_var_cp_r = [ cos(gcam_var_dr+180) * gcam_var_fo_cods, sin(gcam_var_dr+180) * gcam_var_fo_cods, gcam_var_fo_cods_z ];

            gcam_var_dv = gcam_var_fo_dive_last;
        };

        call gcam_fnc_ResetCamera;
    }
    else
    {
        if (SHOWNOTICETEXT) then { titleText [ "Follow Mode Disabled", "plain down", gcam_var_w*15 ] };

        gcam_var_fo_camobjdis_last = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2);
        gcam_var_fo_camobjdive_last = ( ((gcam_var_cp_r select 2) - gcam_var_be_ofz) atan2 ((sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2))) ) * -1;

        gcam_var_fo_objdir = ((getdir gcam_var_o) -90.0) * -1;
        if (gcam_var_fo_objdir >= 360.0) then { gcam_var_fo_objdir = gcam_var_fo_objdir - 360.0 };
        if (gcam_var_fo_objdir < 0.0) then { gcam_var_fo_objdir = gcam_var_fo_objdir + 360.0 };

        gcam_var_fo_camobjdir_rel_last = gcam_var_fo_objdir - (( ((gcam_var_cp_r select 0) atan2 (gcam_var_cp_r select 1)) + 90.0 ) * -1);
        if (gcam_var_fo_camobjdir_rel_last >= 360.0) then { gcam_var_fo_camobjdir_rel_last = gcam_var_fo_camobjdir_rel_last - 360.0 };
        if (gcam_var_fo_camobjdir_rel_last < 0.0) then { gcam_var_fo_camobjdir_rel_last = gcam_var_fo_camobjdir_rel_last + 360.0 };

        gcam_var_fo_dive_last = gcam_var_dv;
        gcam_var_fo_dir_last = gcam_var_dr;

        if (gcam_var_be) then
        {
            if (gcam_var_fc) then
            {
                gcam_var_fc_cdr_a = gcam_var_be_cdr_a;
            };
        }
        else
        {
            if (gcam_var_fc) then
            {
                gcam_var_fc_cdr_a = ( ( ((getPosASLVisual gcam_var_o select 0) - (getPosASLVisual gcam_var_c select 0)) atan2 ((getPosASLVisual gcam_var_o select 1) - (getPosASLVisual gcam_var_c select 1)) ) -90.0 ) * -1;
                if ( gcam_var_fc_cdr_a >= 360.0 ) then { gcam_var_fc_cdr_a = gcam_var_fc_cdr_a - 360.0 };
                if ( gcam_var_fc_cdr_a < 0.0 ) then { gcam_var_fc_cdr_a = gcam_var_fc_cdr_a + 360.0 };
                gcam_var_fc_cdr_a = gcam_var_dr - gcam_var_fc_cdr_a;
                if ( gcam_var_fc_cdr_a >= 360.0 ) then { gcam_var_fc_cdr_a = gcam_var_fc_cdr_a - 360.0 };
                if ( gcam_var_fc_cdr_a < 0.0 ) then { gcam_var_fc_cdr_a = gcam_var_fc_cdr_a + 360.0 };
            };
        };
    };
};

gcam_fnc_ChangeModeBehind = {
    gcam_var_be = !(gcam_var_be);

    if (gcam_var_be) then
    {
        if (SHOWNOTICETEXT) then { titleText [ "Behind Mode Enabled", "plain down", gcam_var_w*15 ] };

        if (gcam_var_fo) then
        {
            gcam_var_be_cods_t = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2);
            gcam_var_be_cods = gcam_var_be_cods_t;

            gcam_var_be_codv_t = ( ((gcam_var_cp_r select 2) - gcam_var_be_ofz) atan2 ((sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2))) ) * -1;
            gcam_var_be_codv = gcam_var_be_codv_t;

            gcam_var_be_odr = ((getdir gcam_var_o) -90.0) * -1;
            if (gcam_var_be_odr >= 360.0) then { gcam_var_be_odr = gcam_var_be_odr - 360.0 };
            if (gcam_var_be_odr < 0.0) then { gcam_var_be_odr = gcam_var_be_odr + 360.0 };

            gcam_var_dr = gcam_var_be_odr;

            gcam_var_be_cdr_a = 0.0;
            gcam_var_be_codr_a = 0.0;

            gcam_var_cp_r = [ gcam_var_be_cods_t * cos(gcam_var_be_odr+180.0), gcam_var_be_cods_t * sin(gcam_var_be_odr+180.0), gcam_var_cp_r select 2 ];
        }
        else
        {
            gcam_var_be_cdr_a = 0.0;
            gcam_var_be_codr_a = 0.0;

            gcam_var_fo_camobjdir_rel_last = 0.0;

            gcam_var_fo_dir_last = ((getdir gcam_var_o) -90.0) * -1;
        };
    }
    else
    {
        if (SHOWNOTICETEXT) then { titleText [ "Behind Mode Disabled", "plain down", gcam_var_w*15 ] };
    };
};

gcam_fnc_SelectCycleUnits = {
    gcam_var_cy_ol_g = [];
    gcam_var_cy_vl = [];
    gcam_var_cy_n = 0;
    gcam_var_cy_i = 0;

    private _players = (switchableUnits + playableUnits) select {!isObjectHidden _x};

    {
        if ( alive _x and !(_x isKindOf "BIS_alice_emptydoor") ) then
        {
            gcam_var_cy_ol_g = gcam_var_cy_ol_g + [_x];
            gcam_var_cy_vl = gcam_var_cy_vl + [_x];
            if (gcam_var_o == _x) then { gcam_var_cy_n = gcam_var_cy_i };
            gcam_var_cy_i = gcam_var_cy_i + 1;
        };
    } foreach _players;
};

gcam_fnc_SwitchAdjustDistance = {
    switch (true) do
    {
    case (gcam_var_o isKindOf "Car"):
        {
            gcam_var_cp_r set [ 2, 1.2 + 1.2 ];
            gcam_var_fo_cods = 6.6;
            gcam_var_fo_cods_z = 2.4;
            gcam_var_be_ofz = 2.4;
        };
    case (gcam_var_o isKindOf "Tank"):
        {
            gcam_var_cp_r set [ 2, 1.2 + 1.75 ];
            gcam_var_fo_cods = 7.5;
            gcam_var_fo_cods_z = 2.95;
            gcam_var_be_ofz = 2.95;
        };
    case (gcam_var_o isKindOf "Helicopter"):
        {
            gcam_var_cp_r set [ 2, 1.2 + 2.3 ];
            gcam_var_fo_cods = 10.0;
            gcam_var_fo_cods_z = 3.5;
            gcam_var_be_ofz = 3.5;
        };
    case (gcam_var_o isKindOf "Air"):
        {
            gcam_var_cp_r set [ 2, 1.2 + 2.7 ];
            gcam_var_fo_cods = 15.0;
            gcam_var_fo_cods_z = 2.9;
            gcam_var_be_ofz = 2.8;
        };
    case (gcam_var_o isKindOf "Ship"):
        {
            gcam_var_cp_r set [ 2, 1.2 + 1.5 ];
            gcam_var_fo_cods = 7.5;
            gcam_var_fo_cods_z = 2.7;
            gcam_var_be_ofz = 2.7;
        };
        default
        {
            gcam_var_cp_r set [ 2, 1.2 + 0.5 ];
            gcam_var_fo_cods = 2.6;
            gcam_var_fo_cods_z = 1.7;
            gcam_var_be_ofz = 1.57;
        };
    };

    if ( gcam_var_be ) then
    {
        gcam_var_be_cods_t = sqrt((gcam_var_fo_cods * (cos gcam_var_be_codr) * (-1))^2 + (gcam_var_fo_cods * (sin gcam_var_be_codr) * (-1))^2 + (gcam_var_cp_r select 2)^2);
        gcam_var_be_cods = gcam_var_be_cods_t;
    };

    if ( gcam_var_fo and !(gcam_var_be) ) then
    {
        gcam_var_re_camobjdir = ( ( (gcam_var_re_cp_r_l select 0) atan2 (gcam_var_re_cp_r_l select 1) ) -90.0 ) * -1;
        gcam_var_cp_r = [ cos(gcam_var_re_camobjdir) * gcam_var_fo_cods, sin(gcam_var_re_camobjdir) * gcam_var_fo_cods, gcam_var_fo_cods_z ];
    };
};

gcam_fnc_ResetCamera = {
    gcam_var_acx = 0;
    gcam_var_acy = 0;
    gcam_var_acz = 0;
    gcam_var_acdr = 0;
    gcam_var_acdv = 0;
    gcam_var_aczm = 0;

    gcam_var_re_cp_r_l = gcam_var_cp_r;

    if ( SWITCHADJDIS ) then
    {
        call gcam_fnc_SwitchAdjustDistance;
    };


    if (!(gcam_var_o isKindOf "Man")) then
    {
        gcam_var_be_crt = 0.0;
        gcam_var_fc_crt = 0.0;
    };

    if ( SWITCHCENTER or gcam_var_cs_change ) then
    {
        if ( gcam_var_be ) then
        {
            gcam_var_be_cdr_a = 0.0;
        };
        if ( !(gcam_var_fo) and gcam_var_fc ) then
        {
            gcam_var_fc_cdr_a = 0.0;
            gcam_var_fc_cdv_a = 0.0;
        };
    };

    if ( gcam_var_fo and gcam_var_be ) then
    {
        gcam_var_be_odr = ((getdir gcam_var_o) -90.0) * -1;
        if (gcam_var_be_odr >= 360.0) then { gcam_var_be_odr = gcam_var_be_odr - 360.0 };
        if (gcam_var_be_odr < 0.0) then { gcam_var_be_odr = gcam_var_be_odr + 360.0 };

        gcam_var_dr = gcam_var_be_odr + gcam_var_be_cdr_a;
        if (gcam_var_dr >= 360.0) then { gcam_var_dr = gcam_var_dr - 360.0 };
        if (gcam_var_dr < 0.0) then { gcam_var_dr = gcam_var_dr + 360.0 };

        gcam_var_dr = gcam_var_dr + gcam_var_be_codr_a;
        if ( gcam_var_dr >= 360.0 ) then { gcam_var_dr = gcam_var_dr - 360.0 };
        if ( gcam_var_dr < 0.0 ) then { gcam_var_dr = gcam_var_dr + 360.0 };

        gcam_var_cp_r = [ gcam_var_be_cods_t * cos(gcam_var_be_odr+180.0+gcam_var_be_codr_a) * (cos gcam_var_be_codv_t), gcam_var_be_cods_t * sin(gcam_var_be_odr+180.0+gcam_var_be_codr_a) * (cos gcam_var_be_codv_t), -gcam_var_be_cods_t * (sin gcam_var_be_codv_t) + gcam_var_be_ofz];
    };

    if ( gcam_var_cs_change and gcam_var_fo and !(gcam_var_be) ) then
    {
        gcam_var_cp_r = [ cos(gcam_var_dr+180.0) * gcam_var_fo_cods, sin(gcam_var_dr+180.0) * gcam_var_fo_cods, gcam_var_fo_cods_z ];
    };

    if ( !(gcam_var_fo) and gcam_var_fc ) then
    {
        if ( gcam_var_be ) then
        {
            gcam_var_fc_odr = ((getdir gcam_var_o) -90.0) * -1;
            if (gcam_var_fc_odr >= 360.0) then { gcam_var_fc_odr = gcam_var_fc_odr - 360.0 };
            if (gcam_var_fc_odr < 0.0) then { gcam_var_fc_odr = gcam_var_fc_odr + 360.0 };

            gcam_var_dr = gcam_var_fc_odr + gcam_var_fc_cdr_a;
            if (gcam_var_dr >= 360.0) then { gcam_var_dr = gcam_var_dr - 360.0 };
            if (gcam_var_dr < 0.0) then { gcam_var_dr = gcam_var_dr + 360.0 };

            gcam_var_dr = gcam_var_dr + gcam_var_be_codr_a;
            if ( gcam_var_dr >= 360.0 ) then { gcam_var_dr = gcam_var_dr - 360.0 };
            if ( gcam_var_dr < 0.0 ) then { gcam_var_dr = gcam_var_dr + 360.0 };

            gcam_var_cp_r = [ cos(gcam_var_fc_odr+180.0+gcam_var_be_codr_a) * gcam_var_fo_cods, sin(gcam_var_fc_odr+180.0+gcam_var_be_codr_a) * gcam_var_fo_cods, gcam_var_fo_cods_z ];
        };
    };

    if ( !(gcam_var_fo) and !(gcam_var_fc) ) then
    {
        gcam_var_cp_r = [ cos(gcam_var_dr+180.0) * gcam_var_fo_cods, sin(gcam_var_dr+180.0) * gcam_var_fo_cods, gcam_var_fo_cods_z ];
    };


    gcam_var_op = getPosASLVisual gcam_var_o;
    gcam_var_cp = [ (gcam_var_op select 0) + (gcam_var_cp_r select 0) , (gcam_var_op select 1) + (gcam_var_cp_r select 1), (gcam_var_op select 2) + (gcam_var_cp_r select 2) ];
    gcam_var_c setPosASL [ gcam_var_cp select 0, gcam_var_cp select 1, (gcam_var_cp select 2) + gcam_var_be_crt ];
    gcam_var_c camSetTarget [ (gcam_var_cp select 0) + (cos gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 1) + (sin gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 2) + (sin gcam_var_dv) * 100000.0];
    gcam_var_c cameraEffect ["Internal", "Back"];
    gcam_var_c camCommit 0;
    cameraEffectEnableHUD true;

    [] call murshun_drawSpectatorHud_fnc;
};

gcam_fnc_perFrameEvent = {
    if (!(isNil "GCam_MD")) then { gcam_var_md = GCam_MD select 1 };
    if (!(isNil "GCam_MU")) then { gcam_var_mu = GCam_MU select 1 };
    if (gcam_var_md == 0 and gcam_var_mu != 0 and !(gcam_var_cs_m)) then
    {
        gcam_var_cs_m = true;
        GCam_MM = [controlNull,0.0,0.0];
    };
    if ( (gcam_var_mu == 0) or (gcam_var_mu == 1 and gcam_var_md == 1) ) then
    {
        gcam_var_cs_m = false;
        private _mbld = false;

        GCam_MD set [1, -1];
        GCam_MU set [1, -1];
    };
    if (gcam_var_mu == 1) then
    {
        gcam_var_aczm = 0.0;
        gcam_var_zm = 0.7;
        gcam_var_c camSetFov gcam_var_zm;
        gcam_var_cfzm = sin ((gcam_var_zm / 1.8) * 90.0);
    };

    if (!(gcam_var_li) and gcam_var_vm == 0) then
    {
        gcam_var_mm = [ GCam_MM select 1, GCam_MM select 2 ];
        gcam_var_acm = accTime^1.5 + 0.007;
        gcam_var_acdr = gcam_var_acdr + (gcam_var_mm select 0) * -MOUSEMOVEACCX * CFTRK * gcam_var_cfzm / (cos abs(gcam_var_dv / (1.0 + gcam_var_cfzm))) * gcam_var_acm;
        gcam_var_acdv = gcam_var_acdv + (gcam_var_mm select 1) * -MOUSEMOVEACCY * CFTRK * gcam_var_cfzm * gcam_var_acm;

        gcam_var_dr = gcam_var_dr + gcam_var_acdr;
        if (gcam_var_dr >= 360.0) then { gcam_var_dr = gcam_var_dr - 360.0 };
        if (gcam_var_dr < 0.0) then { gcam_var_dr = gcam_var_dr + 360.0 };

        gcam_var_dv = gcam_var_dv + gcam_var_acdv;
        if (gcam_var_dv > 89.9) then
        {
            gcam_var_dv = 89.9;
            gcam_var_acdv = 0.0;
        };
        if (gcam_var_dv < -89.9) then
        {
            gcam_var_dv = -89.9;
            gcam_var_acdv = 0.0;
        };

        GCam_MM set [ 1, 0.0 ];
        GCam_MM set [ 2, 0.0 ];
    };

    gcam_var_wl = GCam_MW select 1;
    if ((gcam_var_wl > 0.00001 or gcam_var_wl < -0.00001)) then
    {
        gcam_var_aczm = gcam_var_aczm - gcam_var_wl * 0.12 * CFWHEEL * sin((gcam_var_zm / 2.0) * 90.0);
        GCam_MW set [1, 0];
    };
    if ((abs gcam_var_aczm) > 0.00001) then
    {
        gcam_var_zm = gcam_var_zm + gcam_var_aczm;
        if (gcam_var_zm < 0.01) then
        {
            gcam_var_zm = 0.01;
            gcam_var_aczm = 0.0;
        };
        if (gcam_var_zm > 2.0) then
        {
            gcam_var_zm = 2.0;
            gcam_var_aczm = 0.0;
        };
        gcam_var_c camSetFov gcam_var_zm;
        gcam_var_cfzm = sin ((gcam_var_zm / 1.8) * 90);
    };


    if (!(isNil "GCam_KD")) then { gcam_var_kd = GCam_KD select 1 };
    if (!(isNil "GCam_KU")) then { gcam_var_ku = GCam_KU select 1 };
    GCam_KD set [1,-1];
    GCam_KU set [1,-1];
    if (gcam_var_kd != -1 or gcam_var_ku != -1) then {gcam_var_kt = diag_tickTime};
    if (count gcam_var_k == 0 and gcam_var_kd != -1) then { gcam_var_k = gcam_var_k + [gcam_var_kd] };
    if (count gcam_var_k == 1 and gcam_var_kd != gcam_var_k select 0) then { gcam_var_k = gcam_var_k + [gcam_var_kd] };
    if (gcam_var_ku in gcam_var_k) then { gcam_var_k = gcam_var_k - [gcam_var_ku] };

    if (diag_tickTime - gcam_var_kt > 1.0) then { gcam_var_k = [] };

    if (42 in murshun_spectator_keysDownArray) then {
        CFMOVE = 0.6 * 4 * (60 / diag_fps);
    } else {
        CFMOVE = 0.6 * (60 / diag_fps);
    };

    if (KEYMOVEFRONT in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            gcam_var_acx = gcam_var_acx + 0.035 * CFMOVE * (cos gcam_var_be_codr) * (cos gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_acy = gcam_var_acy + 0.035 * CFMOVE * (sin gcam_var_be_codr) * (cos gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_acz = gcam_var_acz + 0.035 * CFMOVE * (sin gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_be_cods_t = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2) - 0.5;
        }
        else
        {
            gcam_var_acx = gcam_var_acx + 0.05 * (cos gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy + 0.05 * (sin gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVEBACK in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            gcam_var_acx = gcam_var_acx - 0.035 * CFMOVE * (cos gcam_var_be_codr) * (cos gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_acy = gcam_var_acy - 0.035 * CFMOVE * (sin gcam_var_be_codr) * (cos gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_acz = gcam_var_acz - 0.035 * CFMOVE * (sin gcam_var_be_codv) * gcam_var_cfzm;
            gcam_var_be_cods_t = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2) + 0.5;
        }
        else
        {
            gcam_var_acx = gcam_var_acx - 0.05 * (cos gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy - 0.05 * (sin gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVELEFT in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            if ( (180 - abs(180 - gcam_var_be_codr_d)) < 170 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a - CFMOVE * 2.6 * gcam_var_cfzm };
            if ( gcam_var_be_codr_a >= 360.0 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a - 360.0 };
            if ( gcam_var_be_codr_a < 0.0 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a + 360.0 };
        }
        else
        {
            gcam_var_acx = gcam_var_acx - 0.05 * (sin gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy + 0.05 * (cos gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVERIGHT in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            if ( (180 - abs(180 - gcam_var_be_codr_d)) < 170 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a + CFMOVE * 2.6 * gcam_var_cfzm };
            if ( gcam_var_be_codr_a >= 360.0 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a - 360.0 };
            if ( gcam_var_be_codr_a < 0.0 ) then { gcam_var_be_codr_a = gcam_var_be_codr_a + 360.0 };
        }
        else
        {
            gcam_var_acx = gcam_var_acx + 0.05 * (sin gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy - 0.05 * (cos gcam_var_dr) * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVEUP in murshun_spectator_keysDownArray) then
    {
        if ( gcam_var_fo ) then
        {
            if ( gcam_var_be ) then
            {
                gcam_var_be_codv_t = gcam_var_be_codv_t - 1.0;
                if (gcam_var_be_codv_t < -89.0) then
                {
                    gcam_var_be_codv_t = -89.0;
                    gcam_var_acdv = 0.0;
                };
            }
            else
            {
                gcam_var_acz = gcam_var_acz + 0.05 * CFMOVE * gcam_var_cfzm;
            };
        }
        else
        {
            gcam_var_acz = gcam_var_acz + 0.05 * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVEDOWN in murshun_spectator_keysDownArray) then
    {
        if ( gcam_var_fo ) then
        {
            if ( gcam_var_be ) then
            {
                gcam_var_be_codv_t = gcam_var_be_codv_t + 1.0;
                if (gcam_var_be_codv_t > 89.0) then
                {
                    gcam_var_be_codv_t = 89.0;
                    gcam_var_acdv = 0.0;
                };
            }
            else
            {
                gcam_var_acz = gcam_var_acz - 0.05 * CFMOVE * gcam_var_cfzm;
            };
        }
        else
        {
            gcam_var_acz = gcam_var_acz - 0.05 * CFMOVE * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVESTRFRONT in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            gcam_var_acx = gcam_var_acx + 0.075 * CFMOVE * (cos gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm;
            gcam_var_acy = gcam_var_acy + 0.075 * CFMOVE * (sin gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm;
            gcam_var_acz = gcam_var_acz + 0.075 * CFMOVE * (sin gcam_var_dv) * gcam_var_cfzm;
            gcam_var_be_cods_t = sqrt(((gcam_var_cp_r select 0)+gcam_var_acx)^2 + ((gcam_var_cp_r select 1)+gcam_var_acy)^2 + (((gcam_var_cp_r select 2)+gcam_var_acz)-gcam_var_be_ofz)^2);
            gcam_var_be_codr_a = (( (((gcam_var_cp_r select 0)+gcam_var_acx) atan2 ((gcam_var_cp_r select 1)+gcam_var_acy)) + 90.0 ) * -1) - gcam_var_be_odr;
            gcam_var_be_codv_t = ( (((gcam_var_cp_r select 2)+gcam_var_acz) - gcam_var_be_ofz) atan2 ((sqrt(((gcam_var_cp_r select 0)+gcam_var_acx)^2 + ((gcam_var_cp_r select 1)+gcam_var_acy)^2))) ) * (-1);
            gcam_var_be_cdr_d = gcam_var_be_cdr_d - gcam_var_be_codr_a;
        }
        else
        {
            gcam_var_acx = gcam_var_acx + 0.075 * CFMOVE * (cos gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy + 0.075 * CFMOVE * (sin gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acz = gcam_var_acz + 0.075 * CFMOVE * (sin gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (KEYMOVESTRBACK in murshun_spectator_keysDownArray) then
    {
        if (gcam_var_be and gcam_var_fo) then
        {
            gcam_var_acx = gcam_var_acx - 0.075 * CFMOVE * (cos gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm;
            gcam_var_acy = gcam_var_acy - 0.075 * CFMOVE * (sin gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm;
            gcam_var_acz = gcam_var_acz - 0.075 * CFMOVE * (sin gcam_var_dv) * gcam_var_cfzm;
            gcam_var_be_cods_t = sqrt(((gcam_var_cp_r select 0)+gcam_var_acx)^2 + ((gcam_var_cp_r select 1)+gcam_var_acy)^2 + (((gcam_var_cp_r select 2)+gcam_var_acz)-gcam_var_be_ofz)^2);
            gcam_var_be_codr_a = (( (((gcam_var_cp_r select 0)+gcam_var_acx) atan2 ((gcam_var_cp_r select 1)+gcam_var_acy)) + 90.0 ) * -1) - gcam_var_be_odr;
            gcam_var_be_codv_t = ( (((gcam_var_cp_r select 2)+gcam_var_acz) - gcam_var_be_ofz) atan2 ((sqrt(((gcam_var_cp_r select 0)+gcam_var_acx)^2 + ((gcam_var_cp_r select 1)+gcam_var_acy)^2))) ) * (-1);
            gcam_var_be_cdr_d = gcam_var_be_cdr_d - gcam_var_be_codr_a;
        }
        else
        {
            gcam_var_acx = gcam_var_acx - 0.075 * CFMOVE * (cos gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acy = gcam_var_acy - 0.075 * CFMOVE * (sin gcam_var_dr) * (cos gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
            gcam_var_acz = gcam_var_acz - 0.075 * CFMOVE * (sin gcam_var_dv) * gcam_var_cfzm * gcam_var_cfalt;
        };
    };

    if (gcam_var_ku == KEYMODEFOLLOW) then { call gcam_fnc_ChangeModeFollow };
    if (gcam_var_ku == KEYMODEBEHIND) then { call gcam_fnc_ChangeModeBehind };

    if (gcam_var_kd == KEYUNITNEXT) then
    {
        call gcam_fnc_SelectCycleUnits;

        if (count gcam_var_cy_ol_g > 0) then
        {
            gcam_var_cy_n = gcam_var_cy_n + 1;
            if ((count gcam_var_cy_ol_g) == gcam_var_cy_n) then { gcam_var_cy_n = 0 };
            gcam_var_o = gcam_var_cy_ol_g select gcam_var_cy_n;

            while {gcam_var_o isKindOf "BIS_alice_emptydoor"} do
            {
                gcam_var_cy_n = gcam_var_cy_n + 1;
                if ((count gcam_var_cy_ol_g) == gcam_var_cy_n) then { gcam_var_cy_n = 0 };
                gcam_var_o = gcam_var_cy_ol_g select gcam_var_cy_n;
            };

            gcam_var_cgk = gcam_var_kd;
            call gcam_fnc_ResetCamera;
            gcam_var_o_l = gcam_var_o;
        };
    };
    if (gcam_var_kd == KEYUNITPREVIOUS) then
    {
        call gcam_fnc_SelectCycleUnits;

        if (count gcam_var_cy_ol_g > 0) then
        {
            gcam_var_cy_n = gcam_var_cy_n - 1;
            if (gcam_var_cy_n < 0) then { gcam_var_cy_n = (count gcam_var_cy_ol_g) - 1 };
            gcam_var_o = gcam_var_cy_ol_g select gcam_var_cy_n;

            while {gcam_var_o isKindOf "BIS_alice_emptydoor"} do
            {
                gcam_var_cy_n = gcam_var_cy_n - 1;
                if (gcam_var_cy_n < 0) then { gcam_var_cy_n = (count gcam_var_cy_ol_g) - 1 };
                gcam_var_o = gcam_var_cy_ol_g select gcam_var_cy_n;
            };

            gcam_var_cgk = gcam_var_kd;
            call gcam_fnc_ResetCamera;
            gcam_var_o_l = gcam_var_o;
        };
    };

    if (gcam_var_ku == KEYFLIR) then
    {
        gcam_var_nvg = (gcam_var_nvg + 1) mod 5;

        switch (gcam_var_nvg) do
        {
        case (0):
            {
                false setCamUseTi 0;
            };
        case (1):
            {
                camUseNVG true;
            };
        case (2):
            {
                camUseNVG false;
                true setCamUseTi 0;
            };
        case (3):
            {
                true setCamUseTi 1;
            };
        case (4):
            {
                true setCamUseTi 2;
            };
        };
    };

    if (gcam_var_ku == KEYLIST) then
    {
        murshun_spectator_showHUD = murshun_spectator_showHUD + 1;

        if (murshun_spectator_showHUD > 2) then {
            murshun_spectator_showHUD = 0;
        };
    };

    if (serverCommandAvailable "#unlock") then {
        KEYQUIT = 57;
    } else {
        KEYQUIT = -57;
    };

    if ( gcam_var_ku == KEYQUIT or !(alive player) or GCamKill ) exitWith
    {
        ["gcam_eh_id", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

        titleText ["","plain down",0.0];
        camUseNVG false;
        false setCamUseTi 0;
        enableTeamSwitch gcam_var_initteamswitch;

        (findDisplay 46) displayRemoveEventHandler ["KeyDown", gcam_var_murshun_ehid_keydown];
        (findDisplay 46) displayRemoveEventHandler ["KeyUp", gcam_var_murshun_ehid_keyup];
        (findDisplay 46) displayRemoveEventHandler ["KeyDown", gcam_var_ehid_keydown];
        (findDisplay 46) displayRemoveEventHandler ["KeyUp", gcam_var_ehid_keyup];
        (findDisplay 46) displayRemoveEventHandler ["MouseMoving", gcam_var_ehid_mousemove];
        (findDisplay 46) displayRemoveEventHandler ["MouseZChanged", gcam_var_ehid_mousezchange];
        (findDisplay 46) displayRemoveEventHandler ["MouseButtonDown", gcam_var_ehid_mousebd];
        (findDisplay 46) displayRemoveEventHandler ["MouseButtonUp", gcam_var_ehid_mousebu];

        murshun_spectator_keysDownArray = [];

        gcam_var_c cameraEffect ["Terminate", "BACK"];
        camDestroy gcam_var_c;

        player switchCamera "INTERNAL";

        GCamKill = false;
    };


    if (!(gcam_var_fo)) then
    {
        gcam_var_cfalt = 1.0 + 100.0 * (getPosATLVisual gcam_var_c select 2) / 1000.0;
        if (gcam_var_cfalt > 100.0) then { gcam_var_cfalt = 100.0 };
    };

    if ( (isNull gcam_var_o) or (count(crew gcam_var_o)) == 0 ) then
    {
        {
            if ((gcam_var_c distance _x) < (gcam_var_c distance gcam_var_o)) then {
                gcam_var_o = _x;
            };
        } foreach allUnits;

        call gcam_fnc_ResetCamera;
        gcam_var_o_l = gcam_var_o;
    };


    if ( gcam_var_fo and gcam_var_be ) then
    {
        gcam_var_be_cods = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2);
        if ( gcam_var_be_cods > 2.0 ) then { gcam_var_be_cftn = 1.0 + (9.0/(gcam_var_c distance gcam_var_o)) };

        gcam_var_be_odr = ((getdir gcam_var_o) -90.0) * -1;
        gcam_var_be_codr = ( ((gcam_var_cp_r select 0) atan2 (gcam_var_cp_r select 1)) + 90.0 ) * -1;
        gcam_var_be_codr_d = gcam_var_be_odr + gcam_var_be_codr_a - gcam_var_be_codr;

        if (gcam_var_be_codr < 0.0) then { gcam_var_be_codr = gcam_var_be_codr + 360.0 };
        if (gcam_var_be_codr_d > 360.0) then { gcam_var_be_codr_d = gcam_var_be_codr_d - 360.0 };
        if (gcam_var_be_codr_d < 0.0) then { gcam_var_be_codr_d = gcam_var_be_codr_d + 360.0 };

        if (gcam_var_be_codr_d > 180.0) then
        {
            gcam_var_acx = gcam_var_acx - (sin gcam_var_be_codr) * (abs(sin(gcam_var_be_codr_d/2))) * gcam_var_be_cftn * BEHINDSPDAROUND;
            gcam_var_acy = gcam_var_acy + (cos gcam_var_be_codr) * (abs(sin(gcam_var_be_codr_d/2))) * gcam_var_be_cftn * BEHINDSPDAROUND;
        }
        else
        {
            gcam_var_acx = gcam_var_acx + (sin gcam_var_be_codr) * (abs(sin(gcam_var_be_codr_d/2))) * gcam_var_be_cftn * BEHINDSPDAROUND;
            gcam_var_acy = gcam_var_acy - (cos gcam_var_be_codr) * (abs(sin(gcam_var_be_codr_d/2))) * gcam_var_be_cftn * BEHINDSPDAROUND;
        };


        gcam_var_be_codv = ( ((gcam_var_cp_r select 2) - gcam_var_be_ofz) atan2 ((sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2))) ) * -1;
        gcam_var_be_codv_d = gcam_var_be_codv_t - gcam_var_be_codv;

        gcam_var_be_odv = asin((vectorDir gcam_var_o) select 2) * (cos gcam_var_be_codr_a);
        gcam_var_be_codv_r = gcam_var_be_codv_t + gcam_var_be_odv;

        if ((abs gcam_var_be_odv_mx) > (abs gcam_var_be_odv)) then
        {
            gcam_var_be_codv_c = gcam_var_be_codv_c - (gcam_var_be_odv_mx - gcam_var_be_odv);
            gcam_var_be_codv_t = gcam_var_be_codv_t - (gcam_var_be_odv_mx - gcam_var_be_odv);
            gcam_var_be_odv_mx = gcam_var_be_odv;
        }
        else
        {
            if ( (gcam_var_be_codv_r - gcam_var_be_codv_c) < -89.0) then
            {
                gcam_var_be_codv_c = gcam_var_be_codv_t + gcam_var_be_odv + 89.0;
                gcam_var_be_odv_mx = gcam_var_be_odv;
            };
            if ( (gcam_var_be_codv_r - gcam_var_be_codv_c) > 89.0) then
            {
                gcam_var_be_codv_c = gcam_var_be_codv_t + gcam_var_be_odv - 89.0;
                gcam_var_be_odv_mx = gcam_var_be_odv;
            };
        };
        gcam_var_be_codv_d = gcam_var_be_codv_d - gcam_var_be_codv_c + gcam_var_be_odv;

        gcam_var_acx = gcam_var_acx - (sin gcam_var_be_codv_d) * (cos gcam_var_be_codr) * (sin(gcam_var_be_codv - 180.0)) * gcam_var_be_cftn * BEHINDSPDAROUND * 0.5;
        gcam_var_acy = gcam_var_acy - (sin gcam_var_be_codv_d) * (sin gcam_var_be_codr) * (sin(gcam_var_be_codv - 180.0)) * gcam_var_be_cftn * BEHINDSPDAROUND * 0.5;
        gcam_var_acz = gcam_var_acz - (sin gcam_var_be_codv_d) * (cos gcam_var_be_codv) * gcam_var_be_cftn * BEHINDSPDAROUND * 0.5;

        gcam_var_acx = gcam_var_acx - (sin(gcam_var_be_cods_t - gcam_var_be_cods)) * (cos gcam_var_be_codr) * (cos gcam_var_be_codv) * 0.5;
        gcam_var_acy = gcam_var_acy - (sin(gcam_var_be_cods_t - gcam_var_be_cods)) * (sin gcam_var_be_codr) * (cos gcam_var_be_codv) * 0.5;
        gcam_var_acz = gcam_var_acz - (sin(gcam_var_be_cods_t - gcam_var_be_cods)) * (sin gcam_var_be_codv) * 0.5;

        if ( [gcam_var_cp select 0, gcam_var_cp select 1] distance [gcam_var_op select 0, gcam_var_op select 1] < 0.4 ) then
        {
            gcam_var_cp_r = [ -0.41 * (cos gcam_var_be_codr), -0.41 * (sin gcam_var_be_codr), -gcam_var_be_cods * (sin gcam_var_be_codv) + gcam_var_be_ofz];
            gcam_var_be_cods_t = sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2)-gcam_var_be_ofz)^2);

            if (gcam_var_be_codv_t > 0.0) then
            { gcam_var_be_codv_t = gcam_var_be_codv_t - 1.0 }
            else
            { gcam_var_be_codv_t = gcam_var_be_codv_t + 1.0 };

            gcam_var_acx = 0.0;
            gcam_var_acy = 0.0;
            gcam_var_acz = 0.0;

        };


        gcam_var_be_cdr_a = gcam_var_be_cdr_a + gcam_var_acdr;
        gcam_var_be_cdr_d = gcam_var_be_odr - gcam_var_dr + gcam_var_be_cdr_a + gcam_var_be_codr_a;
        gcam_var_be_cdr_d = gcam_var_be_cdr_d - 360.0 * floor(gcam_var_be_cdr_d/360.0);

        if (gcam_var_be_cdr_d < 180.0) then
        { gcam_var_dr = gcam_var_dr + (abs(sin(gcam_var_be_cdr_d/2))) * gcam_var_cfzm * (gcam_var_be_cftn^BEHINDSPDROTATE) }
        else
        { gcam_var_dr = gcam_var_dr - (abs(sin(gcam_var_be_cdr_d/2))) * gcam_var_cfzm * (gcam_var_be_cftn^BEHINDSPDROTATE) };
        if ( gcam_var_dr >= 360.0 ) then { gcam_var_dr = gcam_var_dr - 360.0 };
        if ( gcam_var_dr < 0.0 ) then { gcam_var_dr = gcam_var_dr + 360.0 };


        gcam_var_be_cdv_a = gcam_var_be_cdv_a + gcam_var_acdv;
        gcam_var_be_codv_d = gcam_var_be_codv - gcam_var_dv + gcam_var_be_cdv_a;

        if (gcam_var_be_codv_d > 0.0) then
        { gcam_var_dv = gcam_var_dv + abs(sin(gcam_var_be_codv_d/2)) * gcam_var_be_cftn * 5.0 }
        else
        { gcam_var_dv = gcam_var_dv - abs(sin(gcam_var_be_codv_d/2)) * gcam_var_be_cftn * 5.0 };
        gcam_var_dv = (gcam_var_dv min 89.0) max -89.0;

        if ( gcam_var_o isKindOf "Man" ) then { gcam_var_be_crt = (((gcam_var_o selectionPosition "head_axis") select 2) - 1.57) * (abs sin(30.0/(gcam_var_be_cods+0.1))) };
    };

    if ( !(gcam_var_fo) and gcam_var_fc ) then
    {
        gcam_var_fc_op = getPosASLVisual gcam_var_o;
        private _fc_cp = getPosASLVisual gcam_var_c;

        gcam_var_fc_cdr_a = gcam_var_fc_cdr_a + gcam_var_acdr;
        gcam_var_fc_codr_d = gcam_var_dr - (( ( ((gcam_var_fc_op select 0) - (_fc_cp select 0)) atan2 ((gcam_var_fc_op select 1) - (_fc_cp select 1)) ) -90.0 ) * -1) - gcam_var_fc_cdr_a;
        if (gcam_var_fc_codr_d >= 360.0) then { gcam_var_fc_codr_d = gcam_var_fc_codr_d - 360.0 };
        if (gcam_var_fc_codr_d < 0.0) then { gcam_var_fc_codr_d = gcam_var_fc_codr_d + 360.0 };

        if (gcam_var_fc_codr_d < 180.0) then
        { gcam_var_dr = gcam_var_dr - (abs(sin(gcam_var_fc_codr_d/2))) * 20.0 }
        else
        { gcam_var_dr = gcam_var_dr + (abs(sin(gcam_var_fc_codr_d/2))) * 20.0 };
        if ( gcam_var_dr >= 360.0 ) then { gcam_var_dr = gcam_var_dr - 360.0 };
        if ( gcam_var_dr < 0.0 ) then { gcam_var_dr = gcam_var_dr + 360.0 };

        gcam_var_fc_cdv_a = gcam_var_fc_cdv_a + gcam_var_acdv;
        gcam_var_fc_codv_d = ((sqrt(((gcam_var_fc_op select 0) - (_fc_cp select 0))^2.0 + ((gcam_var_fc_op select 1) - (_fc_cp select 1))^2.0) atan2 (((gcam_var_fc_op select 2) - (_fc_cp select 2)) + gcam_var_be_ofz + gcam_var_fc_crt) - 90.0) * -1) - gcam_var_dv + gcam_var_fc_cdv_a;

        if (gcam_var_fc_codv_d > 0.0) then
        { gcam_var_dv = gcam_var_dv + abs(sin(gcam_var_fc_codv_d/2)) * 20.0 }
        else
        { gcam_var_dv = gcam_var_dv - abs(sin(gcam_var_fc_codv_d/2)) * 20.0 };
        gcam_var_dv = (gcam_var_dv min 89.0) max -89.0;

        gcam_var_fc_cods = [_fc_cp select 0, _fc_cp select 1] distance [gcam_var_fc_op select 0, gcam_var_fc_op select 1];
        if ( gcam_var_o isKindOf "Man" ) then { gcam_var_fc_crt = (((gcam_var_o selectionPosition "head_axis") select 2) - 1.57) * (abs sin(30/(gcam_var_fc_cods+0.1))) };
    };

    gcam_var_cp_r = [ (gcam_var_cp_r select 0) + gcam_var_acx, (gcam_var_cp_r select 1) + gcam_var_acy, (gcam_var_cp_r select 2) + gcam_var_acz ];
    if (gcam_var_fo) then { gcam_var_op = getPosASLVisual gcam_var_o };
    gcam_var_cp = [ (gcam_var_op select 0) + (gcam_var_cp_r select 0) , (gcam_var_op select 1) + (gcam_var_cp_r select 1), (gcam_var_op select 2) + (gcam_var_cp_r select 2) ];
    gcam_var_c setPosASL [ gcam_var_cp select 0, gcam_var_cp select 1, (gcam_var_cp select 2) + gcam_var_be_crt ];
    gcam_var_c camSetTarget [ (gcam_var_cp select 0) + (cos gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 1) + (sin gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 2) + (sin gcam_var_dv) * 100000.0];
    gcam_var_c cameraEffect ["Internal", "Back"];
    gcam_var_c camCommit 0;
    cameraEffectEnableHUD true;

    if ( (getPosATL gcam_var_c select 2) < 0.5 ) then
    {
        gcam_var_c setPosATL [ gcam_var_cp select 0, gcam_var_cp select 1, 0.5 ];

        if (gcam_var_fo) then
        {
            gcam_var_cp_r set [ 2, (getPosASL gcam_var_c select 2) - gcam_var_be_crt - (getPosASL gcam_var_o select 2) ];

            if (gcam_var_be) then
            {
                gcam_var_be_codv_t = gcam_var_be_codv_t - 1.0;
                gcam_var_be_codv = gcam_var_be_codv_t;
            }
            else
            {
                gcam_var_be_codv_t = ( ((gcam_var_cp_r select 2) - gcam_var_be_ofz) atan2 ((sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2))) ) * (-1);
                gcam_var_be_codv = gcam_var_be_codv_t;
                gcam_var_be_cods_t =  sqrt((gcam_var_cp_r select 0)^2 + (gcam_var_cp_r select 1)^2 + ((gcam_var_cp_r select 2) - gcam_var_be_ofz)^2);
                gcam_var_be_cods = gcam_var_be_cods_t;
            };
        }
        else
        {
            gcam_var_op set [ 2 , getPosASL gcam_var_o select 2];
            gcam_var_cp_r set [ 2, (getPosASL gcam_var_c select 2) - gcam_var_be_crt - (gcam_var_op select 2) ];
        };

        gcam_var_acz = gcam_var_acz max 0.0;
    };

    gcam_var_acx = gcam_var_acx * MOVEATTEN;
    gcam_var_acy = gcam_var_acy * MOVEATTEN;
    gcam_var_acz = gcam_var_acz * MOVEATTEN;
    gcam_var_acdr = gcam_var_acdr * TURNATTEN;
    gcam_var_acdv = gcam_var_acdv * TURNATTEN;
    gcam_var_aczm = gcam_var_aczm * ZOOMATTEN;

    [] call murshun_drawSpectatorHud_fnc;

    gcam_var_w = accTime / (diag_fps * 2);
};

gcam_fnc_gcamInit = {
    if (isNil "GCamKill") then {
        GCamKill = false;
    };

    CFMOVE = 0.6;
    CFTRK = 0.2;
    CFWHEEL = 0.2;

    SHOWNOTICETEXT = true;
    SWITCHSMOOTH = false;
    SWITCHADJDIS = true;
    SWITCHCENTER = false;

    KEYMOVEFRONT = 17;
    KEYMOVEBACK = 31;
    KEYMOVELEFT = 30;
    KEYMOVERIGHT = 32;
    KEYMOVEUP = 16;
    KEYMOVEDOWN = 44;
    KEYMOVESTRFRONT = 3;
    KEYMOVESTRBACK = 45;
    KEYMODEFOLLOW = 33;
    KEYMODEBEHIND = 48;
    KEYMODEFOCUS = 46;
    KEYUNITNEXT = 205;
    KEYUNITPREVIOUS = 203;
    KEYFLIR = 49;
    KEYLIST = 38;
    KEYQUIT = 57;

    INITFOLLOWMODE = true;
    INITBEHINDMODE = false;
    INITFOCUSMODE = false;

    INITCAMDISY = 7.5;
    INITCAMDISZ = 2.5;
    INITCAMAGL = -8;
    INITCAMZOOM = 0.7;

    MOUSEMOVEACCX = 0.9;
    MOUSEMOVEACCY = 2.6;

    MOUSEDRAGACCX = 1.35;
    MOUSEDRAGACCY = 3.9;

    MOVEATTEN = 0.8;
    TURNATTEN = 0.8;
    ZOOMATTEN = 0.8;

    BEHINDSPDAROUND = 0.056;
    BEHINDSPDROTATE = 2.7;

    GCam_KD = [controlNull,-1,false,false,false];
    GCam_KU = [controlNull,-1,false,false,false];
    GCam_MD = [controlNull,-1,0.5,0.5,false,false,false];
    GCam_MU = [controlNull,-1,0.5,0.5,false,false,false];
    GCam_MM = [controlNull,0.0,0.0];
    GCam_MW = [controlNull,0];

    murshun_spectator_keysDownArray = [];

    gcam_var_w = accTime / (diag_fps * 2);

    gcam_var_o = objnull;
    gcam_var_o_l = objnull;
    gcam_var_c = objnull;
    gcam_var_dr = 0.0;
    gcam_var_dv = 0.0;
    gcam_var_zm = INITCAMZOOM;
    gcam_var_acdr = 0.0;
    gcam_var_acdv = 0.0;
    gcam_var_aczm = 0.0;
    gcam_var_acx = 0.0;
    gcam_var_acy = 0.0;
    gcam_var_acz = 0.0;
    gcam_var_op = getPosASLVisual player;
    gcam_var_cp = [0.0,0.0,0.0];
    gcam_var_cp_r = [0.0,0.0,0.0];
    gcam_var_cfzm = sin((gcam_var_zm / 1.8) * 90);
    camUseNVG false;
    gcam_var_nvg = 0;
    gcam_var_cfalt = 1.0;

    gcam_var_initcamview = cameraView;
    gcam_var_initteamswitch = teamSwitchEnabled;
    enableTeamSwitch false;

    gcam_var_cgk = -1;

    gcam_var_be = INITBEHINDMODE;
    gcam_var_fo = INITFOLLOWMODE;
    gcam_var_fc = INITFOCUSMODE;

    gcam_var_murshun_ehid_keydown = -1;
    gcam_var_murshun_ehid_keyup = -1;
    gcam_var_ehid_keydown = -1;
    gcam_var_ehid_keyup = -1;
    gcam_var_ehid_mousemove = -1;
    gcam_var_ehid_mousezchange = -1;
    gcam_var_ehid_mousebd = -1;
    gcam_var_ehid_mousebu = -1;

    gcam_var_k = [];
    gcam_var_kt = diag_ticktime;
    gcam_var_kd = -1;
    gcam_var_ku = 0;
    gcam_var_md = -1;
    gcam_var_mu = -1;
    gcam_var_wl = 0.0;
    gcam_var_oc = false;
    gcam_var_cs_m = false;
    gcam_var_mm = [0.0,0.0];
    gcam_var_acm = accTime^1.5 + 0.007;

    gcam_var_cy_ol_g = [];
    gcam_var_cy_vl = [];
    gcam_var_cy_n = 0;
    gcam_var_cy_i = 0;

    gcam_var_li = false;

    gcam_var_sm_l = false;
    gcam_var_sm_n = 0;
    gcam_var_sm_d = 0.0;
    gcam_var_sm_cp = [0.0,0.0,0.0];
    gcam_var_sm_op = [0.0,0.0,0.0];
    gcam_var_sm_cods = [0.0,0.0,0.0];
    gcam_var_sm_cods_h = 0.0;
    gcam_var_sm_crt = 0.0;
    gcam_var_sm_codv = 0.0;
    gcam_var_sm_dv_d = 0.0;
    gcam_var_sm_cp_t = [0.0,0.0,0.0];
    gcam_var_sm_cp_t_l = [0.0,0.0,0.0];

    gcam_var_re_camobjdir = 0.0;
    gcam_var_re_cp_r_l = [0.0,0.0,0.0];

    gcam_var_fo_objdir = 0.0;
    gcam_var_fo_cods = 0.0;
    gcam_var_fo_cods_z = 0.0;
    gcam_var_fo_camobjdis_last = sqrt(INITCAMDISY^2 + INITCAMDISZ^2);
    gcam_var_fo_camobjdive_last = 0.0;
    gcam_var_fo_camdir_add = 0.0;
    gcam_var_fo_camobjdir_rel_last = 0.0;
    gcam_var_fo_dir_last = 0.0;
    gcam_var_fo_dive_last = 0.0;

    gcam_var_be_crt = 0.0;
    gcam_var_be_odr = 0.0;
    gcam_var_be_odv = 0.0;
    gcam_var_be_odv_mx = 0.0;
    gcam_var_be_cdr_a = 0.0;
    gcam_var_be_cdr_t = 0.0;
    gcam_var_be_cdr_d = 0.0;
    gcam_var_be_codr = 0.0;
    gcam_var_be_codr_t = 0.0;
    gcam_var_be_codr_d = 0.0;
    gcam_var_be_codr_a = 0.0;
    gcam_var_be_cdv_a = 0.0;
    gcam_var_be_codv = 0.0;
    gcam_var_be_codv_t = 0.0;
    gcam_var_be_codv_d = 0.0;
    gcam_var_be_codv_c = 0.0;
    gcam_var_be_codv_r = 0.0;
    gcam_var_be_cods_t = sqrt(INITCAMDISY^2 + INITCAMDISZ^2);
    gcam_var_be_cods = gcam_var_be_cods_t;
    gcam_var_be_cftn = 0.0;
    gcam_var_be_ofz = 0.0;

    gcam_var_fc_op = [0.0,0.0,0.0];
    gcam_var_fc_cods = 0.0;
    gcam_var_fc_odr = 0.0;
    gcam_var_fc_codr = 0.0;
    gcam_var_fc_codr_d = 0.0;
    gcam_var_fc_codv_d = 0.0;
    gcam_var_fc_cdr_a = 0.0;
    gcam_var_fc_cdv_a = 0.0;
    gcam_var_fc_crt = 0.0;

    gcam_var_cs_change = false;

    gcam_var_vm = 0;

    gcam_var_murshun_ehid_keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call murshun_spectator_keydown_fnc; false;"];
    gcam_var_murshun_ehid_keyup = (findDisplay 46) displayAddEventHandler ["KeyUp", "_this call murshun_spectator_keyup_fnc; false;"];
    gcam_var_ehid_keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", "GCam_KD = _this"];
    gcam_var_ehid_keyup = (findDisplay 46) displayAddEventHandler ["KeyUp", "GCam_KU = _this"];
    gcam_var_ehid_mousemove = (findDisplay 46) displayAddEventHandler ["MouseMoving", "GCam_MM = _this"];
    gcam_var_ehid_mousezchange = (findDisplay 46) displayAddEventHandler ["MouseZChanged", "GCam_MW = _this"];
    gcam_var_ehid_mousebd = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", "GCam_MD = _this"];
    gcam_var_ehid_mousebu = (findDisplay 46) displayAddEventHandler ["MouseButtonUp", "GCam_MU = _this"];

    gcam_var_o = player;

    private _pos = player getVariable ["murshun_spectator_diedPosition", getPos player];

    private _allUnits = allUnits select {!isObjectHidden _x && _x != player};
    _allUnits = _allUnits apply { [_x distance _pos, _x] };
    _allUnits sort true;

    if (count _allUnits > 0) then {
        gcam_var_o = (_allUnits select 0) select 1;
    };

    gcam_var_o_l = gcam_var_o;

    gcam_var_dr = ((getdir gcam_var_o)-90)*-1;
    gcam_var_dv = INITCAMAGL;
    gcam_var_cp_r = [ cos(gcam_var_dr+180) * INITCAMDISY, sin(gcam_var_dr+180) * INITCAMDISY, INITCAMDISZ ];
    gcam_var_op = getPosASLVisual gcam_var_o;
    gcam_var_cp = [ (gcam_var_op select 0) + (gcam_var_cp_r select 0), (gcam_var_op select 1) + (gcam_var_cp_r select 1), (gcam_var_op select 2) + (gcam_var_cp_r select 2)];

    gcam_var_c = "camera" camCreate [0.0,0.0,0.0];
    gcam_var_c setPosASL [gcam_var_cp select 0, gcam_var_cp select 1, gcam_var_cp select 2];
    gcam_var_c camSetTarget [ (gcam_var_cp select 0) + (cos gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 1) + (sin gcam_var_dr) * (cos gcam_var_dv) * 100000.0, (gcam_var_cp select 2) + (sin gcam_var_dv) * 100000.0];
    gcam_var_c cameraEffect ["Internal", "Back"];
    gcam_var_c camSetFov gcam_var_zm;
    gcam_var_c camCommit 0;
    cameraEffectEnableHUD true;

    showCinemaBorder false;

    call gcam_fnc_ResetCamera;

    ["gcam_eh_id", "onEachFrame", {
        [] call gcam_fnc_perFrameEvent;
    }] call BIS_fnc_addStackedEventHandler;
};
