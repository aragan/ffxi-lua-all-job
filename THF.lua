-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end
    include('organizer-lib')
    organizer_items = {       
        "Mafic Cudgel",
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
        "Sanjaku-Tenugui",
        "Shinobi-Tabi",
        "Shihei",
        "Remedy",
        "Wh. Rarab Cap +1",
        "Emporox's Ring",
        "Red Curry Bun",
        "Instant Reraise",
        "Black Curry Bun",
        "Rolan. Daifuku",
        "Qutrub Knife",
        "Wind Knife +1",
        "Reraise Earring",}
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    state.WeaponLock = M(false, 'Weapon Lock')
    send_command('wait 6;input /lockstyleset 164')
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'CRIT', 'Ranger')
    state.HybridMode:options('Normal', 'PDT', 'HP', 'Evasion')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')
    state.TreasureMode:options('None','Tag','SATA','Fulltime')


    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    gear.AugQuiahuiz = {}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')
    send_command('wait 2;input /lockstyleset 164')
    send_command('bind f5 gs c cycle WeaponskillMode')


    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {hands={ name="Plun. Armlets +2", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +1", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
}
    sets.ExtraRegen = {neck="Sanctity Necklace",
    left_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",}
    sets.Kiting = {feet="Jute Boots +1"}

    sets.buff['Sneak Attack'] = {hands={ name="Plun. Armlets +2", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +1", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
}

    sets.buff['Trick Attack'] = {hands={ name="Plun. Armlets +2", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +1", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +2",}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +2",}
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = {} -- {body="Raider's Vest +2"}
    sets.precast.JA['Steal'] = {head="Plunderer's Bonnet",hands="Pillager's Armlets +1",}
    sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Skulk. Poulaines +1",}
    sets.precast.JA['Perfect Dodge'] = {hands={ name="Plun. Armlets +2", augments={'Enhances "Perfect Dodge" effect',}},}
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Yamarang",
    head="Mummu Bonnet +1",
    body="Gleti's Cuirass",
    legs="Dashing Subligar",}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {ammo="Yamarang",
    head="Mummu Bonnet +1",
    body="Gleti's Cuirass",
    legs="Dashing Subligar",
    }


    -- Fast cast sets for spells
    sets.precast.FC = {ammo="Sapience Orb",
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    feet="Jute Boots +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket",})


    -- Ranged snapshot gear
    sets.precast.RA = {        range="Trollbane",  
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},        feet="Meg. Jam. +2",
        waist="Yemaya Belt",}

        sets.precast.RA.Acc = {       
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},        feet="Meg. Jam. +2",
        waist="Yemaya Belt",}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {range=empty,
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    head="Nyame Helm",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Epona's Ring",
    right_ring="Ilabrat Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
    }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {range=empty,
        ammo="C. Palug Stone",
    head="Nyame Helm",
    body="Gleti's Cuirass",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Ishvara Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
    })
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {range=empty,
    ammo="Crepuscular Pebble",
    head="Skulker's Bonnet +2",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 

    })
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'].Acc, {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1"})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1"})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {ammo="Yetshila +1"})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS.Acc, {range=empty})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Yetshila +1"})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Yetshila +1"})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {ammo="Yetshila +1"})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear="Odr Earring",
        left_ring="Ilabrat Ring",
        right_ring="Regal Ring",
        back="Bleating Mantle",
    })
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {range=empty,
    ammo="Crepuscular Pebble",
    head="Skulker's Bonnet +2",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 
    })
    sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'].Acc, {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {range=empty,
        ammo="Yetshila +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Odr Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"].Acc)
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Ilabrat Ring",
    right_ring="Beithir Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},

    })
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'].Acc, {})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {range=empty,
        ammo="Yetshila +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Odr Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},

    })
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'].Acc, {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {ammo="Yetshila +1",
        body="Pillager's Vest +3",})

    sets.precast.WS['Aeolian Edge'] = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},}

    sets.precast.WS['Aeolian Edge'].Acc = set_combine(sets.precast.WS['Aeolian Edge'])

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {range=empty,
    ammo="Yetshila +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Telos Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {range=empty,
    ammo="Crepuscular Pebble",
    head="Skulker's Bonnet +2",
    hands="Gleti's Gauntlets",
    left_ring="Sroda Ring", 
})  
   sets.precast.WS['Judgment'] = set_combine(sets.precast.WS, {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
    })
sets.precast.WS['Judgment'].Acc = set_combine(sets.precast.WS['Black Halo'], {
        ammo="Crepuscular Pebble",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Aeolian Edge"], {})
    sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS["Aeolian Edge"], {})


    sets.precast.WS["Empyreal Arrow"] = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Telos Earring",
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
}
    sets.precast.WS["Empyreal Arrow"].Acc = set_combine(sets.precast.WS["Empyreal Arrow"], {
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })




    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
        ammo="Sapience Orb",
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    feet="Jute Boots +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",}

    -- Specific spells
    sets.midcast.Utsusemi = {
        ammo="Sapience Orb",
    body="Passion Jacket",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    feet="Jute Boots +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",}

    -- Ranged gear
    sets.midcast.RA = {ammo=empty,
        range="Trollbane",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        waist="Yemaya Belt",
        left_ear="Telos Earring",
        right_ear="Crep. Earring",
        left_ring="Dingir Ring",
        right_ring="Cacoethic Ring",
    }

    sets.midcast.RA.Acc = {
        range="Ullr",
        ammo="Beryllium Arrow",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        waist="Yemaya Belt",
        left_ear="Telos Earring",
        right_ear="Crep. Earring",
        left_ring="Dingir Ring",
        right_ring="Cacoethic Ring",
    }


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
        head="Meghanada Visor +2",
        body="Meg. Cuirie +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Meg. Jam. +2",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",    }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {range=empty,
        
        ammo="Staunch Tathlum +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Jute Boots +1",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Moonlight Ring",
        back="Moonlight Cape",

}

    sets.idle.Town = {
        feet="Jute Boots +1",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
    }
    sets.Adoulin = {body="Councilor's Garb",}

    sets.idle.Weak = {neck="Sanctity Necklace",
    left_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",}


    -- Defense sets

    sets.defense.Evasion = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Gleti's Cuirass",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Vengeful Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Gleti's Cuirass",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Reiki Yotai",
        left_ear="Tuisto Earring",
        left_ring="Defending Ring",
        right_ring="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Damage taken-5%',}},
    }

    sets.defense.HP = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Reiki Yotai",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Moonlight Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.defense.MDT = {ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Plat. Mog. Belt",
    left_ear="Eabani Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Vengeful Ring",
    right_ring="Purity Ring",
    back="Engulfer Cape +1",}


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {range=empty,
    ammo="Aurgelmir Orb +1",
    head="Skulker's Bonnet +2",
    body="Pillager's Vest +3",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Ainia Collar",
    waist="Reiki Yotai",
    left_ear="Dedition Earring",
    right_ear="Skulk. Earring +1",
    left_ring="Gere Ring",
    right_ring="Hetairoi Ring",
    back="Bleating Mantle",
    }
    sets.engaged.Acc = {range=empty,
        ammo="Yamarang",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Pillager's Vest +3",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Meg. Chausses +2",
        feet="Malignance Boots",
        neck="Clotharius Torque",
        waist="Reiki Yotai",
        left_ear="Telos Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Bleating Mantle",
    }
        
        sets.engaged.CRIT = {range=empty,
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Meg. Cuirie +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Nefarious Collar +1",
        waist="Reiki Yotai",
        left_ear="Sherida Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Gere Ring",
        right_ring="Hetairoi Ring",
        back="Bleating Mantle",
    }

    -- Mod set for trivial mobs (Skadi+1)
    --sets.engaged.Mod = {hands={ name="Plun. Armlets +2", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +1"}

    -- Mod set for trivial mobs (Thaumas)
    --sets.engaged.Mod2 = {}

    sets.engaged.Ranger = {
        main="Kustawi +1",
        sub={ name="Aeneas", augments={'Path: A',}},
        range="Ullr",
        ammo="Beryllium Arrow",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        waist="Yemaya Belt",
        left_ear="Telos Earring",
        right_ear="Crep. Earring",
        left_ring="Dingir Ring",
        right_ring="Cacoethic Ring",
    }


    sets.engaged.Evasion = {range=empty,
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Gleti's Cuirass",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    waist="Reiki Yotai",
    left_ear="Sherida Earring",
    right_ear="Skulk. Earring +1",
    left_ring="Gere Ring",
    right_ring="Hetairoi Ring",
    back="Bleating Mantle",

    }
    sets.engaged.Acc.Evasion = set_combine(sets.engaged.Evasion ,{ range=empty,
    right_ring="Defending Ring",
    })

    sets.engaged.PDT = { range=empty,
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Pillager's Vest +3",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Reiki Yotai",
        left_ear="Sherida Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Gere Ring",
        right_ring="Defending Ring",
        back="Bleating Mantle",
        
    }
    sets.engaged.Acc.PDT = set_combine(sets.engaged.PDT ,{   range=empty,
    body="Malignance Tabard",
    })
    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}


end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    --[[if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)]]
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
    if buff == "doom" then
        if gain then
            equip(sets.Doom)
            send_command('@input /p Doomed, please Cursna.')
            send_command('@input /item "Holy Water" <me>')	
             disable('ring1','ring2','waist','neck')
        else
            enable('ring1','ring2','waist','neck')
            send_command('input /p Doom removed.')
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).



function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
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
        then return true
    end
end

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 164')
    end
end
-- Function to lock the ranged slot if we have a ranged weapon equipped.



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    --[[if player.sub_job == 'DNC' then
        set_macro_page(3, 3)
    elseif player.sub_job == 'WAR' then
        set_macro_page(3, 3)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 3)
    else]]
        set_macro_page(3, 3)
    --end
end


