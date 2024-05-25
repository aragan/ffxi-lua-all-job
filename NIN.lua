---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
-- Haste/DW Detection Requires Gearinfo Addon
-- for Rune Fencer sub, you need to create two macros. One cycles runes, and gives you descrptive text in the log.
-- The other macro will use the actual rune you cycled to. 
-- Macro #1 //console gs c cycle Runes
-- Macro #2 //console gs c toggle UseRune
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
    include('organizer-lib')
    organizer_items = {
        "Airmid's Gorget",
        "Toolbag (Shihe)",
        "Chonofuda",
        "Shikanofuda",
        "Inoshishinofuda",
        "Sanjaku-Tenugui",
        "Toolbag (Cho)",   
        "Toolbag (Shika)",
        "Toolbag (Ino)",
        "Shihei",
        "Toolbag (Shihe)",
        "Gyudon",
        "Reraiser",
        "Hi-Reraiser",
        "Vile Elixir",
        "Vile Elixir +1",
        "Miso Ramen",
        "Carbonara",
        "Silent Oil",
        "Salt Ramen",
        "Panacea",
        "Sublime Sushi",
        "Sublime Sushi 1+",
        "Prism Powder",
        "Antacid",
        "Icarus Wing",
        "Warp Cudgel",
        "Holy Water",
        "Remedy",
        "Emporox's Ring",
        "Red Curry Bun",
        "Instant Reraise",
        "Black Curry Bun",
        "Rolan. Daifuku",
        "Qutrub Knife",
        "Wind Knife +1",
        "Reraise Earring",}
end


-- Setup vars that are user-independent.
function job_setup()
    include('Mote-TreasureHunter')
    state.Buff.Migawari = buffactive.migawari or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.Buff.Innin = buffactive.innin or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.BrachyuraEarring = M(true,false)



    state.HasteMode = M{['description']='Haste Mode', 'Hi', 'Normal'}
    state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
    state.UseRune = M(false, 'Use Rune')
    state.UseWarp = M(false, 'Use Warp')
    state.Adoulin = M(false, 'Adoulin')
    state.Moving  = M(false, "moving")
    send_command('wait 2;input /lockstyleset 144')
    run_sj = player.sub_job == 'RUN' or false
    elemental_ws = S{"Aeolian Edge", "Blade: Teki", "Blade: To", "Blade: Chi", "Blade: Ei", "Blade: Yu"}

    select_ammo()
    LugraWSList = S{'Blade: Ku', 'Blade: Jin'}
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.Proc = M(false, 'Proc')
    state.unProc = M(false, 'unProc')


    swordList = S{'Naegling'}
    GKList = S{'Hachimonji','Zanmato +1'}
    daggerList = S{'Tauret'}
    katanaList = S{'Heishi Shorinken','Kunimitsu'}

    wsList = S{'Blade: Hi', 'Blade: Kamu', 'Blade: Ten'}
    nukeList = S{'Katon: San', 'Doton: San', 'Suiton: San', 'Raiton: San', 'Hyoton: San', 'Huton: San'}

    state.warned = M(false)
    options.ammo_warning_limit = 25
    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1", "Reraise Earring", "Reraise Gorget", "Airmid's Gorget",}
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'TP', 'ZANISH', 'DOUBLE','CRIT')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'SIRD')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC', 'vagary')
    state.IdleMode:options('Normal', 'Evasion', 'PDT', 'MDT', 'Regen', 'HP', 'EnemyCritRate')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'HP', 'Enmity')
    state.MagicalDefenseMode:options('MDT')
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Heishi', 'Tauret', 'Naegling', 'Hachimonji', 'Zanmato', 'CLUB', 'H2H'}

    
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^[ gs c toggle UseWarp')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c cycle HasteMode')
    send_command('bind f4 gs c cycle Runes')
    send_command('bind f3 gs c cycleback Runes')
    send_command('bind f2 input //gs c toggle UseRune')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind delete gs c toggle BrachyuraEarring')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('wait 6;input /lockstyleset 144')
    -- send_command('bind !- gs equip sets.crafting')
    select_default_macro_book()
    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
        -- 'Out of Range' distance; WS will auto-cancel
    range_mult = {
            [0] = 0,
            [2] = 1.70,
            [3] = 1.490909,
            [4] = 1.44,
            [5] = 1.377778,
            [6] = 1.30,
            [7] = 1.20,
            [8] = 1.30,
            [9] = 1.377778,
            [10] = 1.45,
            [11] = 1.490909,
            [12] = 1.70,
        }
    update_combat_form()
    determine_haste_group()
end


function file_unload()
    send_command('unbind ^[')
    send_command('unbind @f9')
    send_command('unbind @[')
    send_command('unbind ^=')

end


-- Define sets and vars used by this job file.
-- sets.engaged[state.CombatForm][state.CombatWeapon][state.OffenseMode][state.HybridMode][classes.CustomMeleeGroups (any number)

-- Ninjutsu tips
-- To stick Slow (Hojo) lower earth resist with Raiton: Ni
-- To stick poison (Dokumori) or Attack down (Aisha) lower resist with Katon: Ni
-- To stick paralyze (Jubaku) lower resistence with Huton: Ni

function init_gear_sets()

    sets.Normal = {}
    sets.Heishi = {main="Heishi Shorinken", sub="Kunimitsu"}
    sets.Tauret = {main="Tauret", sub="Kunimitsu"}
    sets.Naegling = {main="Naegling", sub="Kunimitsu"}
    sets.Hachimonji = {main="Hachimonji", sub="Alber Strap",}
    sets.Zanmato = {main="Zanmato +1",sub="Sword Strap",}
    sets.CLUB = {main="Mafic Cudgel",sub="Kunimitsu",}
    sets.H2H = {main="Karambit"}


    --------------------------------------
    -- Job Abilties
    --------------------------------------
    sets.precast.JA['Mijin Gakure'] = { legs="Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { hands="Hattori Tekko +2" }
    sets.precast.JA['Sange'] = {body="Mochi. Chainmail +3"}
    sets.precast.JA['Innin'] = {head="Mochi. Hatsuburi +3"}
    sets.precast.JA['Yonin'] = {head="Mochi. Hatsuburi +3"}
    sets.precast.JA['Provoke'] = set_combine(sets.midcast.enmity , {
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    })
    sets.precast.JA.Sange = { }

    -- Waltz (chr and vit)
    sets.precast.Waltz = {    ammo="Yamarang",   
    head="Mummu Bonnet +2",
    body="Passion Jacket",
    legs="Dashing Subligar",}
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {   

}
    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {
        body="Hattori Ningi +1",
        waist="Olseni Belt",
    }
    sets.MadrigalBonus = {
    }
    -- sets.midcast.Trust =  {
    --     head="Hattori Zukin +1",
    --     hands="Ryuo Tekko",
    --     feet="Hachiya Kyahan +1"
    -- }
    sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
        body="Apururu Unity shirt",
    })
    sets.Warp = { ring1="Warp Ring" }

    --------------------------------------
    -- Utility Sets for rules below
    --------------------------------------
    sets.TreasureHunter = {ammo="Per. Lucky Egg", head="Wh. Rarab Cap +1",
    waist="Chaac Belt"}
    sets.CapacityMantle = {}
    sets.WSDayBonus     = {head="Gavialis Helm"}
    -- sets.WSBack         = { back="Trepidity Mantle" }
    sets.OdrLugra    = { ear2="Odr Earring", ear1="Lugra Earring +1" }
    sets.OdrIshvara  = { ear2="Odr Earring", ear1="Ishvara Earring" }
    sets.OdrBrutal  = { ear2="Odr Earring", ear1="Brutal Earring" }
    sets.OdrMoon     = { ear2="Odr Earring", ear1="Moonshade Earring" }



    -- sets.NightAccAmmo   = { ammo="Ginsen" }
    -- sets.DayAccAmmo     = { ammo="Seething Bomblet +1" }

    --------------------------------------
    -- Ranged
    --------------------------------------

    sets.precast.RA = { 
    ammo=empty,
    range="Trollbane",  
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    }
    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
    })
    sets.midcast.RA.TH = set_combine(sets.midcast.RA, set.TreasureHunter)

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Herculean Helm", augments={'"Triple Atk."+4','STR+7','Accuracy+5','Attack+8',}},
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Rahab Ring",
        right_ring="Kishar Ring",
        neck="Orunmila's Torque",        
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {    neck="Magoraga Beads",
        body="Passion Jacket",
        feet="Hattori Kyahan +2",
    })
     -- Waltz set (chr and vit)
     sets.precast.Waltz = {
    body="Passion Jacket",     
}

sets.precast.FC.Cure = set_combine(sets.precast.FC, {
    waist="Acerbic Sash +1",
    right_ear="Mendi. Earring",
 })
    -- Midcast Sets
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.enmity = {
        ammo="Iron Gobbet",
        hands="Kurys Gloves",
        body={ name="Emet Harness +1", augments={'Path: A',}},
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Moonlight Necklace",
        waist="Flume Belt +1",
        left_ear="Trux Earring",
        right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
        right_ring="Vengeful Ring",
        back="Reiki Cloak",
         }
    -- skill ++ 
    sets.midcast.Ninjutsu = {
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
        neck="Incanter's Torque",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        waist="Cimmerian Sash",
    }
    sets.midcast['Enhancing Magic'] = {
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Brachyura Earring",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
	}
    sets.midcast.Phalanx = sets.midcast['Enhancing Magic'] 
    sets.midcast.Cure = {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Macabre Gaunt. +1", augments={'Path: A',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
        neck="Reti Pendant",
        waist="Plat. Mog. Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Mendi. Earring",
        left_ring="Naji's Loop",
        right_ring="Defending Ring",
        back="Solemnity Cape",
	}
    sets.midcast.EnfeeblingNinjutsu = {
        ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    }

    -- any ninjutsu cast on self
    sets.midcast.SelfNinjutsu = {    neck="Incanter's Torque",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
sets.midcast.SelfNinjutsu.SIRD = {       sub="Tancho",
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Halasz Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Evanescence Ring",
    back="Moonlight Cape",
}
    sets.midcast.Utsusemi = set_combine(sets.midcast.Ninjutsu, {    
        feet="Hattori Kyahan +2",
        back="Andartia's Mantle",
    })
    sets.midcast.Utsusemi.SIRD = set_combine(sets.midcast.Ninjutsu, {        sub="Tancho",
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        legs="Malignance Tights",
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Evanescence Ring",
        feet="Hattori Kyahan +2",
        back="Andartia's Mantle",
    })
    sets.midcast.Migawari = set_combine(sets.midcast.Ninjutsu, {    neck="Incanter's Torque",
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
        back="Andartia's Mantle",
    })
    sets.midcast.Migawari.SIRD = set_combine(sets.midcast.Ninjutsu, {     sub="Tancho",
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Evanescence Ring",
        back="Moonlight Cape",
    })

    -- Nuking Ninjutsu (skill & magic attack)
    sets.midcast.ElementalNinjutsu = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Hattori Tekko +2",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
     left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
     right_ring="Dingir Ring",
     left_ear="Hecate's Earring",
     right_ear="Friomisi Earring",
     back="Argocham. Mantle",
    }
    sets.magic_burst = set_combine(sets.midcast.ElementalNinjutsu, { 
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Hattori Tekko +2",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Mujin Band",
        back="Argocham. Mantle",
})
sets.midcast.Absorb = {
    ammo="Pemphredo Tathlum",
    neck="Erra Pendant",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Kishar Ring",
}
    -- Effusions
    sets.precast.Effusion = {}
    sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
    sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

         -- Resting sets
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body="Hiza. Haramaki +2",
        hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
            neck={ name="Bathy Choker +1", augments={'Path: A',}},
            left_ear="Infused Earring",
            left_ring="Chirich Ring +1",
            right_ring="Chirich Ring +1",
    }

    -- Weaponskills 
    sets.precast.WS = {
        ammo="Yamarang",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        right_ring="Regal Ring",
        left_ring="Cornelia's Ring",
        back="Andartia's Mantle",
    }
        
    sets.precast.WS.SC = set_combine(sets.precast.WS, { 
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS.vagary =  {}

    sets.Kamu = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, sets.Kamu)
    sets.precast.WS['Blade: Kamu'].SC = set_combine(sets.precast.WS, sets.Kamu, {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},    })
    sets.precast.WS['Blade: Kamu'].PDL = set_combine(sets.precast.WS, sets.Kamu, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring",     })
    
    -- BLADE: JIN
    sets.Jin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, sets.Jin)
    sets.precast.WS['Blade: Jin'].SC = set_combine(sets.precast.WS['Blade: Jin'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Jin'].PDL = set_combine(sets.precast.WS['Blade: Jin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},    
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: HI
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Hi'].SC = set_combine(sets.precast.WS['Blade: Hi'], {
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Hi'].PDL = set_combine(sets.precast.WS['Blade: Hi'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        right_ear="Hattori Earring +1", 
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: SHUN
    sets.Shun = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Malignance Tabard",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Hattori Earring +1", 
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, sets.Shun)
    sets.precast.WS['Blade: Shun'].PDL = set_combine(sets.Shun, {
        ammo="Crepuscular Pebble",
        head="Malignance Chapeau",
        hands="Malignance Gloves",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        feet="Malignance Boots",    
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},

    })
    sets.precast.WS['Blade: Shun'].SC = set_combine(sets.Shun, {
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Exenterator'] = set_combine(sets.Shun, {})
    sets.precast.WS['Viper Bite'] = set_combine(sets.Shun, {})

    
    -- BLADE: Rin
    sets.Rin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Rin)
    sets.precast.WS['Blade: Rin'].SC = set_combine(sets.precast.WS.SC, sets.Rin)
    sets.precast.WS['Blade: Rin'].PDL = set_combine(sets.precast.WS['Blade: Rin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},        
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    
    -- BLADE: KU 
    sets.Ku = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Brutal Earring",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, sets.Ku)
    sets.precast.WS['Blade: Ku'].SC = sets.precast.WS['Blade: Ku']
    sets.precast.WS['Blade: Ku'].PDL = set_combine(sets.precast.WS['Blade: Ku'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},       
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    
    sets.Ten = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    }
    
    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, sets.Ten)
    sets.precast.WS['Blade: Ten'].SC = set_combine(sets.precast.WS['Blade: Ten'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Ten'].PDL = set_combine(sets.precast.WS['Blade: Ten'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], { 
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'].SC = set_combine(sets.precast.WS['Savage Blade'], { 
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'],{})
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Savage Blade'].PDL,{})


    sets.precast.WS.Evisceration = {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Odr Earring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle", 
    }
    sets.precast.WS.Evisceration.PDL = set_combine(sets.precast.WS.Evisceration, {
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    })

    sets.precast.WS["True Strike"] = set_combine(sets.precast.WS.Evisceration, {})
    sets.precast.WS["True Strike"].PDL= set_combine(sets.precast.WS.Evisceration, {})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.vagary =  {}
    sets.precast.WS['Aeolian Edge'].vagary = {}
    sets.precast.WS['Aeolian Edge'].PDL = set_combine(sets.precast.WS['Aeolian Edge'],{
    --range="Wingcutter +1",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS['Aeolian Edge'],{})
    sets.precast.WS['Cyclone'].PDL = set_combine(sets.precast.WS['Aeolian Edge'].PDL,{})
    sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS['Aeolian Edge'],{})
    sets.precast.WS['Gust Slash'].PDL = set_combine(sets.precast.WS['Aeolian Edge'].PDL,{})
    sets.precast.WS['Burning Blade'] = set_combine(sets.precast.WS['Aeolian Edge'],{})
    sets.precast.WS['Burning Blade'].PDL = set_combine(sets.precast.WS['Aeolian Edge'],{
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Shining Blade'] = set_combine(sets.precast.WS['Aeolian Edge'], {
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    })
    sets.precast.WS['Shining Blade'].PDL = set_combine(sets.precast.WS['Aeolian Edge'], {
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS['Aeolian Edge'], {})
    sets.precast.WS["Shining Strike"] = set_combine(sets.precast.WS['Aeolian Edge'], {})
    sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS['Aeolian Edge'], {})

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Nyame Helm", augments={'Path: B',}},
        neck="Fotia Gorget",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring",
        right_ring="Gere Ring",
    })
    sets.precast.WS['Tachi: Jinpu'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'], {
        --range="Wingcutter +1",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Tachi: Jinpu'].SC = set_combine(sets.precast.WS['Tachi: Jinpu'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Tachi: Jinpu'].vagary =  {}
    sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Kagero'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Koki'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Goten'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {
    ammo="Pemphredo Tathlum",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Sacro Mantle",
    })

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Gere Ring",
        back="Sacro Mantle",
       })
       
    sets.precast.WS['Blade: Chi'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}},
    })

    sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: Teki'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
    head="Genmei Kabuto",    
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: To'].PDL = sets.precast.WS['Blade: Teki'].PDL
    
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Yu'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: Yu'].PDL = sets.precast.WS['Blade: Yu'].PDL

    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Archon Ring",
        right_ring="Cornelia's Ring",
        back="Sacro Mantle",
    })
       sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Asuran Fists'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Spinning Attack'].PDL= set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 
       sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Backhand Blow'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Combo'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 


    -- Defense sets
    sets.defense.PDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
    }
    sets.defense.Enmity = {
        ammo="Iron Gobbet",
        head="Malignance Chapeau",
        body={ name="Emet Harness +1", augments={'Path: A',}},
        hands="Kurys Gloves",
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Trux Earring",
        right_ear="Cryptic Earring",
        left_ring="Defending Ring",
        right_ring="Vengeful Ring",
        back="Reiki Cloak",
    }
    sets.defense.HP = {
        ammo="Coiste Bodhar",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        right_ear="Tuisto Earring",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Eihwaz Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }
    sets.defense.MDT = set_combine(sets.defense.PDT, {
        ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Purity Ring",
        back="Moonlight Cape",
    })
    sets.defense.Evasion = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        left_ear="Eabani Earring",
        right_ear="Infused Earring",
        left_ring="Vengeful Ring",
        right_ring="Hizamaru Ring",
        back="Moonlight Cape",
    }

--idle - defense

sets.idle = {
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Adamantite Armor",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Eabani Earring",
    right_ear="Infused Earring",
    left_ring="Vengeful Ring",
    right_ring="Hizamaru Ring",
    back="Andartia's Mantle",

}
sets.idle.PDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
    }
sets.idle.MDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Shadow Ring",
    right_ring="Defending Ring",
    right_ring="Purity Ring",
    back="Moonlight Cape",
}
sets.idle.HP = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Adamantite Armor",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    right_ear="Tuisto Earring",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Eihwaz Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})
sets.idle.Regen = set_combine(sets.idle, {
    head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body="Hizamaru Haramaki +2",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    ear2="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    })

sets.idle.Town = {
    feet="Danzo Sune-Ate",
    ear2="Infused Earring",
}
sets.idle.Evasion = sets.defense.Evasion
sets.idle.Weak = sets.idle

    sets.DayMovement = {feet="Danzo sune-ate"}
    sets.NightMovement = {feet="Danzo sune-ate"}
    sets.Adoulin = {body="Councilor's Garb",}
    sets.MoveSpeed = {feet="Danzo Sune-Ate",}
    


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
        sets.engaged = {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle",
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo="Yamarang",
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        left_ear="Crep. Earring",
        ear2="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        waist="Olseni Belt",
    })
    sets.engaged.TP = {
        ammo="Coiste Bodhar",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle",
    }
    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })
    sets.engaged.ZANISH = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Ryuo Hakama", augments={'Accuracy+20','"Store TP"+4','Phys. dmg. taken -3',}},
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
        waist="Sailfi Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })
    sets.engaged.DOUBLE = set_combine(sets.engaged,{
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Clotharius Torque",
        waist="Sailfi Belt +1",
        left_ear="Balder Earring +1",
        right_ear="Cessance Earring",
        right_ring="Gere Ring",
        left_ring="Epona's Ring",
        back="Andartia's Mantle", 
    })
    sets.engaged.CRIT = {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Nefarious Collar +1",
        waist="Gerdr Belt",
        left_ear="Brutal Earring",
        right_ear="Odr Earring",
        left_ring="Mummu Ring",
        right_ring="Hetairoi Ring",
        back="Andartia's Mantle",
    }

------------------------------------------------------------------------------------------------
    ---------------------------------------- DW ------------------------------------------
------------------------------------------------------------------------------------------------
    -- * NIN Native DW Trait: 35% DW

    -- No Magic Haste (74% DW to cap)

sets.engaged.DW = {
    ammo="Seki Shuriken",
    head="Ryuo Somen +1", --9
    body={ name="Tatena. Harama. +1", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Malignance Boots",
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    waist="Sailfi Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    right_ring="Gere Ring",
    left_ring="Epona's Ring",
    back="Andartia's Mantle",
}

sets.engaged.DW.Acc = set_combine(sets.engaged, {
    ammo="Seki Shuriken",
    neck={ name="Ninja Nodowa +2", augments={'Path: A',}},
    left_ear="Crep. Earring",
    ear2="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    waist="Olseni Belt",
})
sets.engaged.DW.STP = set_combine(sets.engaged, {
    ammo="Seki Shuriken",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    waist="Gerdr Belt",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
    })

sets.engaged.DW.CRIT =  {
    ammo="Yetshila +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mummu Jacket +2",
    hands="Mummu Wrists +2",
    legs="Mummu Kecks +2",
    feet="Mummu Gamash. +2",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Brutal Earring",
    right_ear="Odr Earring",
    left_ring="Mummu Ring",
    right_ring="Hetairoi Ring",
    back="Andartia's Mantle",
}

------------------------------------------------------------------------------------------------
    ---------------------------------------- DW-HASTE ------------------------------------------
------------------------------------------------------------------------------------------------
sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
    head="Ryuo Somen +1", --9
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    feet="Hiza. Sune-Ate +2", --8
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
})-- 39%
sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
    head="Ryuo Somen +1", --9
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    feet="Hiza. Sune-Ate +2", --8
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
})-- 39%
sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
    head="Ryuo Somen +1", --9
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    feet="Hiza. Sune-Ate +2", --8
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
})-- 39%
sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
    head="Ryuo Somen +1", --9
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    feet="Hiza. Sune-Ate +2", --8
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
})-- 39%

--MID-HASTE

sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 16%
sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW.Acc, {
    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 16%
sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.STP, {
    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 16%
sets.engaged.DW.CRIT.MidHaste = set_combine(sets.engaged.DW.CRIT, {
    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 16%

--HIGH-HASTE

sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
    waist="Reiki Yotai", --7
}) -- 7%
sets.engaged.DW.Acc.HighHaste = set_combine(sets.engaged.DW.Acc, {
    waist="Reiki Yotai", --7
}) -- 7%
sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.STP, {
    waist="Reiki Yotai", --7
}) -- 7%
sets.engaged.DW.CRIT.HighHaste = set_combine(sets.engaged.DW.CRIT, {
    waist="Reiki Yotai", --7
}) -- 7%

sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW)
sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc)
sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.STP)
sets.engaged.DW.CRIT.MaxHaste = set_combine(sets.engaged.DW.CRIT)

------------------------------------------------------------------------------------------------
---------------------------------------- Hybrid Sets -------------------------------------------
------------------------------------------------------------------------------------------------


sets.engaged.Hybrid = {
    head="Malignance Chapeau", --6/6
    body="Malignance Tabard", --9/9
    hands="Malignance Gloves", --5/5
    legs="Malignance Tights", --7/7
    feet="Malignance Boots", --4/4
    --ring2="Defending Ring", --10/10
}

sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
sets.engaged.CRIT.DT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)

sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)

sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.LowHaste = set_combine(sets.engaged.DW.CRIT.LowHaste, sets.engaged.Hybrid)

sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.MidHaste = set_combine(sets.engaged.DW.CRIT.MidHaste, sets.engaged.Hybrid)

sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.HighHaste = set_combine(sets.engaged.DW.Acc.HighHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.STP.HighHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.HighHaste = set_combine(sets.engaged.DW.CRIT.HighHaste, sets.engaged.Hybrid)

sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.MaxHaste = set_combine(sets.engaged.DW.CRIT.MaxHaste, sets.engaged.Hybrid)

------------------------------------------------------------------------------------------------
---------------------------------------- Special Sets ------------------------------------------
------------------------------------------------------------------------------------------------
    
sets.buff.Migawari = {     neck="Incanter's Torque",
feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
left_ring="Stikini Ring +1",
right_ring="Stikini Ring +1",
back="Andartia's Mantle",
}
    
    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}
    
    sets.Kiting = {feet="Danzo Sune-ate"}

end



-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    if (spell.type:endswith('Magic') or spell.type == "Ninjutsu") and buffactive.silence then
        --cancel_spell()
        send_command('input /item "Remedy" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "" then
        if spell.english == "Migawari" then
            classes.CustomClass = "Migawari"
        else
            classes.CustomClass = "SelfNinjutsu"
        end
    end
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end

    if spell.name == 'Spectral Jig' and buffactive.sneak then
        -- If sneak is active when using, cancel before completion
        -- send_command('cancel 71')
    end
    --[[if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end]]

end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- Ranged Attacks 
    if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'Acc' then
        equip(  )
    end
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Lugra Earring +1"})
		end
	end
    -- protection for lag
    if spell.type == 'WeaponSkill' then
        -- Mecistopins Mantle rule (if you kill with ws)
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        if spell.english == 'Blade: Yu' and (world.weather_element == 'Water' or world.day_element == 'Water') then
            equip({waist="Hachirin-no-Obi"})
        end
        if elemental_ws:contains(spell.name) and player.tp > 2900 then
            equip({ear1="Crematio Earring"})
        end
        if is_sc_element_today(spell) then
            if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
                equip(sets.WSDayBonus)
            end
        end
        -- Lugra Earring for some WS
        if LugraWSList:contains(spell.english) then
            if world.time >= (17*60) or world.time <= (7*60) then
                equip(sets.OdrLugra)
            else
                equip(sets.OdrBrutal)
            end
        elseif spell.english == 'Blade: Ten' then
            equip(sets.OdrMoon)
            
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.english == "Provoke" then
		equip(sets.midcast.enmity)
	end

	if spell.english == "Warcry" then
		equip(sets.midcast.enmity)
	end

	if spell.english == "Animated Flourish" then
		equip(sets.midcast.enmity)
	end
    -- if spell.english == "Monomi: Ichi" then
    --     if buffactive['Sneak'] then
    --         send_command('@wait 2.7;cancel sneak')
    --     end
    -- end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    --if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
    --    equip(sets.TreasusreHunter)
    --end
    if spellMap == 'ElementalNinjutsu' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip({waist="Hachirin-no-Obi"})
        end
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
        end
    end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
    if midaction() then
        return
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
    -- Aftermath timer creation
    aw_custom_aftermath_timers_aftercast(spell)
    --if spell.type == 'WeaponSkill' then
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------



-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    -- if state.CraftingMode then
    --     idleSet = set_combine(idleSet, sets.crafting)
    -- end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end
    --local res = require('resources')
    --local info = windower.ffxi.get_info()
    --local zone = res.zones[info.zone].name
    --if zone:match('Adoulin') then
    --    idleSet = set_combine(idleSet, sets.Adoulin)
    --end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.HybridMode.value == 'Proc' then
        meleeSet = set_combine(meleeSet, sets.NoDW)
    end

    meleeSet = set_combine(meleeSet, select_ammo())

    check_weaponset()

    return meleeSet
end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
end
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Migawari" and not gain then
        add_to_chat(123, "*** MIGAWARI DOWN ***")
    end
    if buff == "Protect" then
        if gain then
            enable('ear1')
            state.BrachyuraEarring:set(false)
        end
    end
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed, please Cursna.')
            send_command('@input /item "Holy Water" <me>')	
             disable('ring1','ring2','waist','neck')
        else
            enable('ring1','ring2','waist','neck')
            send_command('input /p Doom removed.')
            handle_equipping_gear(player.status)
        end
    end
    if buff == "petrification" then
        if gain then    
            equip(sets.defense.PDT)
            send_command('input /p Petrification, please Stona.')		
        else
        send_command('input /p '..player.name..' is no longer Petrify!')
        handle_equipping_gear(player.status)
        end
    end
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
           handle_equipping_gear(player.status)
        end
    end
    if buff == "Defense Down" then
        if gain then  			
            send_command('input /item "Panacea" <me>')
        end
    elseif buff == "Magic Def. Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Max HP Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Evasion Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Magic Evasion Downn" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Dia" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end  
    elseif buff == "Bio" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Bind" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "slow" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "weight" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Attack Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "Accuracy Down" then
        if gain then  			
            send_command('@input /item "panacea" <me>')
        end
    end

    if buff == "VIT Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "INT Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "MND Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "STR Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    elseif buff == "AGI Down" then
        if gain then
            send_command('@input /item "panacea" <me>')
        end
    end


    if buff == "curse" then
        if gain then  
        send_command('input /item "Holy Water" <me>')
        end
    end
    if buff == "poison" then
        if gain then  
        send_command('input /item "remedy" <me>')
        end
    end
    if buff == "Sleep" then
        if gain then    
            send_command('input /p ZZZzzz, please cure.')		
        else
            send_command('input /p '..player.name..' is no longer Sleep!')
        end
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(newStatus, oldStatus, eventArgs)

end

mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
    mov.x = windower.ffxi.get_mob_by_index(player.index).x
    mov.y = windower.ffxi.get_mob_by_index(player.index).y
    mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
    mov.counter = mov.counter + 1;
    if mov.counter>15 then
        local pl = windower.ffxi.get_mob_by_index(player.index)
        if pl and pl.x and mov.x then
            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
            if dist > 1 and not moving then
                state.Moving.value = true
                send_command('gs c update')
				if world.area:contains("Adoulin") then
                send_command('gs equip sets.Adoulin')
				else
                send_command('gs equip sets.MoveSpeed')
                end

        moving = true

            elseif dist < 1 and moving then
                state.Moving.value = false
                send_command('gs c update')
                moving = false
            end
        end
        if pl and pl.x then
            mov.x = pl.x
            mov.y = pl.y
            mov.z = pl.z
        end
        mov.counter = 0
    end
end)
 



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------



function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 7 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 7 and DW_needed <= 16 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 16 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 34 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'UseRune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
    --check_moving()
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end


windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
            send_command('gs c update')

        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
            send_command('gs c update')

        end
    end
end
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        eventArgs.handled = true
    end
end
function sub_job_change(new,old)
    send_command('wait 6;input /lockstyleset 144')
end
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then 
            return true
    end
end

--function select_movement()
    -- world.time is given in minutes into each day
    -- 7:00 AM would be 420 minutes
    -- 17:00 PM would be 1020 minutes
    --if world.time >= (17*60) or world.time <= (7*60) then
        --return sets.NightMovement
    --else
        --return sets.DayMovement
    --end
--end



-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.BrachyuraEarring .value == true then
        equip({left_ear="Brachyura Earring"})
        disable('ear1')
    else 
        enable('ear1')
        state.BrachyuraEarring:set(false)
    end
    if stateField == 'Capacity Point Mantle' then
        gear.Back = newValue
    elseif stateField == 'Proc' then
        --send_command('@input /console gs enable all')
        equip(sets.Proc)
        --send_command('@input /console gs disable all')
    elseif stateField == 'unProc' then
        send_command('@input /console gs enable all')
        equip(sets.unProc)
    elseif stateField == 'Runes' then
        local msg = ''
        if newValue == 'Ignis' then
            msg = msg .. 'Increasing resistence against ICE and deals FIRE damage.'
        elseif newValue == 'Gelus' then
            msg = msg .. 'Increasing resistence against WIND and deals ICE damage.'
        elseif newValue == 'Flabra' then
            msg = msg .. 'Increasing resistence against EARTH and deals WIND damage.'
        elseif newValue == 'Tellus' then
            msg = msg .. 'Increasing resistence against LIGHTNING and deals EARTH damage.'
        elseif newValue == 'Sulpor' then
            msg = msg .. 'Increasing resistence against WATER and deals LIGHTNING damage.'
        elseif newValue == 'Unda' then
            msg = msg .. 'Increasing resistence against FIRE and deals WATER damage.'
        elseif newValue == 'Lux' then
            msg = msg .. 'Increasing resistence against DARK and deals LIGHT damage.'
        elseif newValue == 'Tenebrae' then
            msg = msg .. 'Increasing resistence against LIGHT and deals DARK damage.'
        end
        add_to_chat(123, msg)
   -- elseif stateField == 'moving' then
   --     if state.Moving.value then
   --         local res = require('resources')
   --         local info = windower.ffxi.get_info()
   --         local zone = res.zones[info.zone].name
   --         if zone:match('Adoulin') then
   --             equip(sets.Adoulin)
   --         end
   --         equip(select_movement())
   --     end
        
    elseif stateField == 'Use Rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    elseif stateField == 'Use Warp' then
        add_to_chat(8, '------------WARPING-----------')
        --equip({ring1="Warp Ring"})
        send_command('input //gs equip sets.Warp;@wait 10.0;input /item "Warp Ring" <me>;')
    end
    --[[if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end]]
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    check_weaponset()

end

--- Custom spell mapping.
--function job_get_spell_map(spell, default_spell_map)
--    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
--        return 'HighTierNuke'
--    end
--end
-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
    if spell.type == 'Trust' then
        return 'Trust'
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.HasteMode.value ~= 'Normal' then
        msg = msg .. ', Haste: '..state.HasteMode.current
    end
    if state.RangedMode.value ~= 'Normal' then
        msg = msg .. ', Rng: '..state.RangedMode.current
    end
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

-- Call from job_precast() to setup aftermath information for custom timers.
function aw_custom_aftermath_timers_precast(spell)
    if spell.type == 'WeaponSkill' then
        info.aftermath = {}

        local empy_ws = "Blade: Hi"

        info.aftermath.weaponskill = empy_ws
        info.aftermath.duration = 0

        info.aftermath.level = math.floor(player.tp / 1000)
        if info.aftermath.level == 0 then
            info.aftermath.level = 1
        end

        if spell.english == empy_ws and player.equipment.main == 'Kannagi' then
            -- nothing can overwrite lvl 3
            if buffactive['Aftermath: Lv.3'] then
                return
            end
            -- only lvl 3 can overwrite lvl 2
            if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
                return
            end

            -- duration is based on aftermath level
            info.aftermath.duration = 30 * info.aftermath.level
        end
    end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
    -- prevent gear being locked when it's currently impossible to cast 
    if not spell.interrupted and spell.type == 'WeaponSkill' and
        info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then

        local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
        send_command('timers d "Aftermath: Lv.1"')
        send_command('timers d "Aftermath: Lv.2"')
        send_command('timers d "Aftermath: Lv.3"')
        send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')

        info.aftermath = {}
    end
end
-- Determine whether we have sufficient tools for the spell being attempted.
function do_ninja_tool_checks(spell, spellMap, eventArgs)
    local ninja_tool_name
    local ninja_tool_min_count = 1

    -- Only checks for universal tools and shihei
    if spell.skill == "Ninjutsu" then
        if spellMap == 'Utsusemi' then
            ninja_tool_name = "Shihei"
        elseif spellMap == 'ElementalNinjutsu' then
            ninja_tool_name = "Inoshishinofuda"
        elseif spellMap == 'EnfeeblingNinjutsu' then
            ninja_tool_name = "Chonofuda"
        elseif spellMap == 'EnhancingNinjutsu' then
            ninja_tool_name = "Shikanofuda"
        else
            return
        end
    end

    local available_ninja_tools = player.inventory[ninja_tool_name] or player.wardrobe[ninja_tool_name]

    -- If no tools are available, end.
    if not available_ninja_tools then
        if spell.skill == "Ninjutsu" then
            return
        end
    end

    -- Low ninja tools warning.
    if spell.skill == "Ninjutsu" and state.warned.value == false
        and available_ninja_tools.count > 1 and available_ninja_tools.count <= options.ninja_tool_warning_limit then
        local msg = '*****  LOW TOOLS WARNING: '..ninja_tool_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_ninja_tools.count > options.ninja_tool_warning_limit and state.warned then
        state.warned:reset()
    end
end

function select_ammo()
    if state.Buff.Sange then
        return sets.SangeAmmo
    else
        return sets.RegularAmmo
    end
end

-- function select_ws_ammo()
--     if world.time >= (18*60) or world.time <= (6*60) then
--         return sets.NightAccAmmo
--     else
--         return sets.DayAccAmmo
--     end
-- end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(8, 27)
    --[[if player.sub_job == 'DNC' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'WAR' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'RUN' then
        set_macro_page(8, 27)
    else
        set_macro_page(8, 27)
    end]]
end