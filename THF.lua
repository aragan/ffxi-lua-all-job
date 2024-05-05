-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
--[[-- Haste/DW Detection Requires Gearinfo Addon

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
        "Airmid's Gorget", 
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
        -- for Rune Fencer sub, you need to create two macros. One cycles runes, and gives you descrptive text in the log.
-- The other macro will use the actual rune you cycled to. 
-- Macro #1 //console gs c cycle Runes
-- Macro #2 //console gs c toggle UseRune
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.BrachyuraEarring = M(true,false)
    state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
    state.UseRune = M(false, 'Use Rune')
    send_command('wait 2;input /lockstyleset 164')
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1", "Reraise Earring", "Reraise Gorget", "Airmid's Gorget",}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'CRIT', 'Ranger')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'Mod')
    state.IdleMode:options('Normal', 'PDT', 'HP', 'Evasion', 'MDT', 'Regen', 'EnemyCritRate')
    state.PhysicalDefenseMode:options('Evasion', 'PDT', 'HP')
    state.MagicalDefenseMode:options('MDT')
    state.TreasureMode:options('None','Tag','SATA','Fulltime')
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Twashtar', 'Tauret', 'Aeneas', 'Naegling'}
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}

    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    gear.AugQuiahuiz = {}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')
    send_command('wait 6;input /lockstyleset 164')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind f4 gs c cycle Runes')
    send_command('bind f3 gs c cycleback Runes')
    send_command('bind f2 input //gs c toggle UseRune')
    send_command('bind delete gs c toggle BrachyuraEarring')
    select_default_macro_book()
    Panacea = T{
        'Bind',
        'Bio',
        'Dia',
        'Accuracy Down',
        'Attack Down',
        'Evasion Down',
        'Defense Down',
        'Magic Evasion Down',
        'Magic Def. Down',
        'Magic Acc. Down',
        'Magic Atk. Down',
        'Max HP Down',
        'Max MP Down',
        'slow',
        'weight'}
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
    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
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

    sets.TreasureHunter = {hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +2", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    sets.ExtraRegen = {neck="Sanctity Necklace",
    left_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",}
    sets.Kiting = {feet="Jute Boots +1"}

    sets.buff['Sneak Attack'] = {hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +2", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}

    sets.buff['Trick Attack'] = {hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}}, waist="Chaac Belt", feet="Skulk. Poulaines +2", 
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
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
    sets.precast.JA['Steal'] = {hands="Thief's Kote",neck="Pentalagus Charm",}
    sets.precast.JA['Despoil'] = {legs="Raider's Culottes +2",feet="Skulk. Poulaines +2",}
    sets.precast.JA['Perfect Dodge'] = {hands={ name="Plun. Armlets +3", augments={'Enhances "Perfect Dodge" effect',}},}
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
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Epona's Ring",
    right_ring="Ilabrat Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
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
    sets.precast.WS['Exenterator'].PDL = set_combine(sets.precast.WS['Exenterator'], {range=empty,
    ammo="Crepuscular Pebble",
    head="Skulker's Bonnet +2",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 

    })
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'], {ammo="Yetshila +1"})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'], {ammo="Yetshila +1"})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'], {ammo="Yetshila +1"})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS.Acc, {range=empty})
    sets.precast.WS['Dancing Edge'].PDL = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Yetshila +1"})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Yetshila +1"})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'], {ammo="Yetshila +1"})

    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Dancing Edge'], {})

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
    sets.precast.WS['Evisceration'].PDL = set_combine(sets.precast.WS['Evisceration'], {range=empty,
    ammo="Crepuscular Pebble",
    head="Skulker's Bonnet +2",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 
    })
    sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'], {})

    sets.precast.WS['True Strike'] = set_combine(sets.precast.WS['Evisceration'], {})


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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
    sets.precast.WS["Rudra's Storm"].PDL = set_combine(sets.precast.WS["Rudra's Storm"], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"])
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Yetshila +1",
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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })
    sets.precast.WS['Shark Bite'].PDL = set_combine(sets.precast.WS['Shark Bite'], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {})
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'], {ammo="Yetshila +1",
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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })
    sets.precast.WS['Mandalic Stab'].PDL = set_combine(sets.precast.WS['Mandalic Stab'], {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {})
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Yetshila +1",
        body="Pillager's Vest +3",})
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'], {ammo="Yetshila +1",
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
    right_ear="Friomisi Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

    sets.precast.WS['Aeolian Edge'].PDL = set_combine(sets.precast.WS['Aeolian Edge'])

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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {range=empty,
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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Black Halo'], {
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
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    sets.precast.WS["Empyreal Arrow"].PDL = set_combine(sets.precast.WS["Empyreal Arrow"], {
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


    -- Defense sets

    sets.defense.Evasion = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",
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
        body="Adamantite Armor",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ring="Defending Ring",
        left_ring="Moonlight Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }

    sets.defense.HP = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Adamantite Armor",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
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


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {range=empty,
        ammo="Staunch Tathlum +1",
        head="Gleti's Mask",
        body="Adamantite Armor",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        left_ring="Moonlight Ring",
        back="Moonlight Cape",

}
sets.idle.PDT = sets.defense.PDT
sets.idle.HP = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Adamantite Armor",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Moonlight Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.idle.MDT = sets.defense.MDT
sets.idle.Evasion = sets.defense.Evasion
sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})
sets.idle.Regen = set_combine(sets.idle, {
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
    sets.idle.Town = {
        feet="Jute Boots +1",
        left_ear="Infused Earring",
    }
    sets.Adoulin = {body="Councilor's Garb",}

    sets.idle.Weak = set_combine(sets.idle, {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })

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
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Dedition Earring",
    right_ear="Skulk. Earring +1",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Tactical Mantle",
    }
    sets.engaged.Acc = {range=empty,
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Pillager's Vest +3",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Clotharius Torque",
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    }
        
    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Ainia Collar",
        waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ear="Dedition Earring",
        right_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
 })

        sets.engaged.CRIT = {range=empty,
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Meg. Cuirie +2",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Nefarious Collar +1",
        waist="Windbuffet Belt +1",
        left_ear="Sherida Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Gere Ring",
        right_ring="Hetairoi Ring",
        back="Bleating Mantle",
    }


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
        back="Tactical Mantle",
    }

------------------------------------------------------------------------------------------------
    ---------------------------------------- DW ------------------------------------------
------------------------------------------------------------------------------------------------

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    --DW cap all set haste capped

    sets.engaged.DW = {range=empty,
    ammo="Aurgelmir Orb +1",
    head="Skulker's Bonnet +2",
    body="Pillager's Vest +3",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Anu Torque",
    waist="Reiki Yotai",
    left_ear="Dedition Earring",
    right_ear="Skulk. Earring +1",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Tactical Mantle",
    }

    sets.engaged.DW.Acc = {range=empty,
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Pillager's Vest +3",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Clotharius Torque",
        waist="Reiki Yotai",
        left_ear="Telos Earring",
        right_ear="Skulk. Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    }
        
    sets.engaged.DW.STP = {
        ammo="Aurgelmir Orb +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Ainia Collar",
        waist="Reiki Yotai",
        left_ear="Dedition Earring",
        right_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
        }

        sets.engaged.DW.CRIT = {range=empty,
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

------------------------------------------------------------------------------------------------
    ---------------------------------------- DW-HASTE ------------------------------------------
------------------------------------------------------------------------------------------------

  -- 15% Magic Haste (67% DW to cap)
  sets.engaged.DW.LowHaste = {range=empty,
    ammo="Aurgelmir Orb +1",
    head="Skulker's Bonnet +2",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, -- 6
    hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}}, --5
    legs="Samnuha Tights",
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Anu Torque",
    left_ear="Suppanomimi", --5
    right_ear="Eabani Earring", --4
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    waist="Reiki Yotai", --7
    } -- 27%
    sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}}, --5
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 27%
    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}}, --5
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 27%
    sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}}, --5
        left_ear="Suppanomimi", --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 27%

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
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 11%
sets.engaged.DW.Acc.HighHaste = set_combine(sets.engaged.DW.Acc, {
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 11%
sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.STP, {
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 11%
sets.engaged.DW.CRIT.HighHaste = set_combine(sets.engaged.DW.CRIT, {
    right_ear="Eabani Earring", --4
    waist="Reiki Yotai", --7
}) -- 11%

--MAX-HASTE

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
    ring2="Defending Ring", --10/10
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
    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

    sets.Normal = {}
    sets.Twashtar = {main="Twashtar", sub="Gleti's Knife"}
    sets.Tauret = {main="Tauret", sub="Ternion Dagger +1"}
    sets.Aeneas = {main="Aeneas", sub="Malevolence"}
    sets.Naegling = {main="Naegling", sub="Ternion Dagger +1"}



end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
end
-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Ishvara Earring"})
		end
	end
    if spell.type == 'WeaponSkill' then
        -- Replace TP-bonus gear if not needed.
        if spell.english == 'Aeolian Edge' and player.tp > 2900 then
            equip({ear1="Crematio Earring"})
        end  
    end
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
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
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
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
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
    if buff == "sleep" then
        if gain then    
            send_command('input /p ZZZzzz, please cure.')		
        else
            send_command('input /p '..player.name..' is no longer Sleep!')
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
    if not midaction() then
        job_update()
    end
end
function check_buffs(check)
     
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
    if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
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

    check_weaponset()

    return meleeSet
end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
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
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 7 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 10 and DW_needed <= 15 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 15 and DW_needed <= 19 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 19 and DW_needed <= 29 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 29 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
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
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
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
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Runes' then
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

    elseif stateField == 'Use Rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    elseif stateField == 'Use Warp' then
        add_to_chat(8, '------------WARPING-----------')
        --equip({ring1="Warp Ring"})
        send_command('input //gs equip sets.Warp;@wait 10.0;input /item "Warp Ring" <me>;')
    end
    
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if state.BrachyuraEarring .value == true then
        equip({left_ear="Brachyura Earring"})
        disable('ear1')
    else 
        enable('ear1')
        state.BrachyuraEarring:set(false)
    end
    check_weaponset()

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
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
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


