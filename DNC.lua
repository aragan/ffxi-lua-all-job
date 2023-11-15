-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[-- Haste/DW Detection Requires Gearinfo Addon

    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')

end
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
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.ClosedPosition = M(false, 'Closed Position')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')
    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')
    state.Moving  = M(false, "moving")
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1", "Reraise Earring", "Reraise Gorget", "Airmid's Gorget",}
    send_command('wait 6;input /lockstyleset 164')

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'CRIT')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'PDL')
    state.PhysicalDefenseMode:options('Evasion', 'PDT', 'Enmity', 'HP')
    state.MagicalDefenseMode:options('MDT')
    state.IdleMode:options('Normal', 'PDT', 'HP', 'Evasion', 'EnemyCritRate')
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Twashtar', 'Tauret', 'Aeneas'}

    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    gear.AugQuiahuiz = {}
    send_command('wait 2;input /lockstyleset 164')

    -- Additional local binds
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind f4 input //fillmode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    --send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')
    --send_command('bind != gs c toggle CapacityMode')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {}

    sets.precast.JA['Trance'] = {}

    sets.CapacityMantle  = {}
    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
    }
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Yamarang",
    head="Mummu Bonnet +1",
    body="Gleti's Cuirass",
    legs="Dashing Subligar",}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {ammo="Yamarang",
    head="Mummu Bonnet +1",
    body="Gleti's Cuirass",
    legs="Dashing Subligar",}
    
    sets.precast.Samba = {head="Maxixi Tiara +2",}

    sets.precast.Jig = {}

    sets.precast.Step = {    ammo="C. Palug Stone",
    head="Maxixi Tiara +2",
    body="Malignance Tabard",
    hands="Maxixi Bangles +2",
    legs="Malignance Tights",
    feet="Horos T. Shoes +3",
    neck="Subtlety Spec.",
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Step['Feather Step'] = {    ammo="C. Palug Stone",
    head="Maxixi Tiara +2",
    body="Malignance Tabard",
    hands="Maxixi Bangles +2",
    legs="Malignance Tights",
    feet="Horos T. Shoes +3",
    neck="Subtlety Spec.",
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Sacro Mantle",
}
     -- magic accuracy

    sets.precast.Flourish1 = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Flourish1['Violent Flourish'] = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}
-- acc gear
    sets.precast.Flourish1['Desperate Flourish'] = {    
    ammo="C. Palug Stone",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Horos T. Shoes +3",
    neck="Subtlety Spec.",
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Sacro Mantle",
} 

    sets.precast.Flourish2 = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Flourish2['Reverse Flourish'] = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Flourish3 = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Flourish3['Striking Flourish'] = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    sets.precast.Flourish3['Climactic Flourish'] = {    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Digni. Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Sacro Mantle",
}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Sapience Orb",
    body="Taeon Tabard",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    neck="Baetyl Pendant",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    right_ring="Rahab Ring",
    left_ring="Prolix Ring",
}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket",})
    -- Ranged snapshot gear
    sets.precast.RA = {        range="Trollbane",  
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},        feet="Meg. Jam. +2",
        waist="Yemaya Belt",}

        sets.precast.RA.Acc = {       
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},        feet="Meg. Jam. +2",
        waist="Yemaya Belt",}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {  
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",    
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Odr Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back="Sacro Mantle",
}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    right_ring="Mujin Band",})
    
    sets.precast.WS.Critical = {body="Meg. Cuirie +2"}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
    ammo="C. Palug Stone",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Meg. Chausses +2",
    feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Ishvara Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",})

    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    right_ring="Mujin Band",})
    sets.precast.WS['Exenterator'].Fodder = set_combine(sets.precast.WS['Exenterator'], {})

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Meg. Chausses +2",
        feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear="Brutal Earring",
        left_ring="Gere Ring",
        right_ring="Regal Ring",
        back="Bleating Mantle",
    })
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS.Acc, {    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    right_ring="Mujin Band",})

    sets.precast.WS['Pyrrhic Kleos'].PDL = set_combine(sets.precast.WS.Acc, {
        ammo="Crepuscular Pebble",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Anu Torque",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Bleating Mantle",
    })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Aurgelmir Orb +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Meg. Cuirie +2",
        hands="Mummu Wrists +2",
        legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear="Odr Earring",
        left_ring="Ilabrat Ring",
        right_ring="Regal Ring",
    })
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {  
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    right_ring="Mujin Band",})

    sets.precast.WS['Evisceration'].PDL = set_combine(sets.precast.WS['Evisceration'], {})


    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    right_ring="Mujin Band",})

    sets.precast.WS["Rudra's Storm"].PDL = set_combine(sets.precast.WS["Rudra's Storm"], {
        ammo="Crepuscular Pebble",
        body="Gleti's Cuirass",
        waist={ name="Kentarch Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Sherida Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Sacro Mantle",
    })

    sets.precast.WS['Aeolian Edge'] = {   
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back="Sacro Mantle",
}
    
    sets.precast.Skillchain = {   }
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
    ammo="Sapience Orb",
    body="Taeon Tabard",
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

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Meghanada Visor +2",
    body="Meg. Cuirie +2",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Meg. Jam. +2",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Moonlight Cape", }
    sets.ExtraRegen = {eft_ear="Infused Earring",}
    

    -- Idle sets

    sets.idle = {ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
}

sets.idle.PDT = {        
    ammo="Eluder's Sachet",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Fortified Ring",
    back="Moonlight Cape",
}

sets.idle.Evasion = {
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

sets.idle.HP = {
    main={ name="Twashtar", augments={'Path: A',}},
    sub={ name="Aeneas", augments={'Path: A',}},
    ammo="Eluder's Sachet",
    head="Nyame Helm",
    body="Nyame Mail",
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
sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})

    sets.idle.Town = {   
    feet="Tandava Crackows",
    left_ear="Infused Earring",
}
    
    sets.idle.Weak = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
}
    
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
    ammo="Eluder's Sachet",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Fortified Ring",
    back="Moonlight Cape",
}

sets.defense.HP = {
    main={ name="Twashtar", augments={'Path: A',}},
    sub={ name="Aeneas", augments={'Path: A',}},
    ammo="Eluder's Sachet",
    head="Nyame Helm",
    body="Nyame Mail",
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

sets.defense.Enmity = {
    ammo="Iron Gobbet",
    head="Malignance Chapeau",
    body={ name="Emet Harness +1", augments={'Path: A',}},
    hands="Kurys Gloves",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Ahosi Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Cryptic Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Eihwaz Ring",
    right_ring="Petrov Ring",
    back="Reiki Cloak",
}

    sets.defense.MDT = {     
    ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Engraved Belt",
    left_ear="Etiolation Earring",
    right_ear="Sanare Earring",
    left_ring="Shadow Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",}

    sets.MoveSpeed = {feet="Tandava Crackows",}
    sets.Kiting = {feet="Tandava Crackows",}
    sets.Adoulin = {body="Councilor's Garb",}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Bleating Mantle",}

    sets.engaged.Acc = {      ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Lissome Necklace",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Bleating Mantle",}

sets.engaged.STP = {    
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Ainia Collar",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Dedition Earring",
    right_ear="Balder Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}
sets.engaged.CRIT = {  
    ammo="Staunch Tathlum +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs={ name="Gleti's Breeches", augments={'Path: A',}},
    feet="Gleti's Boots",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Sherida Earring",
    right_ear="Eabani Earring",
    left_ring="Mummu Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
 }

 ------------------------------------------------------------------------------------------------
    ---------------------------------------- DW ------------------------------------------
------------------------------------------------------------------------------------------------

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)

    sets.engaged.DW = {    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Bleating Mantle",}

    sets.engaged.DW.Acc = {      ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Lissome Necklace",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Bleating Mantle",}

sets.engaged.DW.STP = {    
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Dedition Earring",
    right_ear="Balder Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}
sets.engaged.DW.CRIT = {  
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Herculean Gloves", augments={'"Triple Atk."+4',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Clotharius Torque",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Sherida Earring",
    right_ear="Balder Earring +1",
    left_ring="Epona's Ring",
    right_ring="Gere Ring",
    back="Bleating Mantle",
 }

    ------------------------------------------------------------------------------------------------
      ---------------------------------------- DW-HASTE ------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    })-- 22%
    sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 22%
    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 22%
    sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    }) -- 22%

    -- 30% Magic Haste (56% DW to cap)

    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    })-- 16%
    sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    })-- 16%
    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    })-- 16%
    sets.engaged.DW.CRIT.MidHaste = set_combine(sets.engaged.DW, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
    })-- 16%


    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW)
    sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc)
    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.STP)
    sets.engaged.DW.CRIT.MaxHaste = set_combine(sets.engaged.DW.CRIT)


    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW)

    sets.engaged.DW.Acc.HighHaste = set_combine(sets.engaged.DW.Acc, {
        left_ear="Suppanomimi",  --5
    })-- 5%
    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.STP, {
        left_ear="Suppanomimi",  --5
    })-- 5%
    sets.engaged.DW.CRIT.HighHaste = set_combine(sets.engaged.DW.CRIT)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.engaged.Hybrid = { ammo="Staunch Tathlum +1",--3
        body="Malignance Tabard",--9/9
        legs="Malignance Tights",--7
        neck="Loricate Torque +1", --6/6
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
    }--40% dt

    sets.engaged.PDT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
    sets.engaged.STP.PDT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
    sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
    sets.engaged.DW.CRIT.PDT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)
    sets.engaged.DW.STP.PDT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.PDT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.PDT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.CRIT.PDT.LowHaste = set_combine(sets.engaged.DW.CRIT.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.PDT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.PDT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid, {
        left_ear="Suppanomimi",  --5
    })-- 5%
    sets.engaged.DW.Acc.PDT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid, {
        left_ear="Suppanomimi",  --5
    })-- 5%
    sets.engaged.DW.CRIT.PDT.MidHaste = set_combine(sets.engaged.DW.CRIT.MidHaste, sets.engaged.Hybrid, {
        left_ear="Suppanomimi",  --5
    })-- 5%
    sets.engaged.DW.STP.PDT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid, {
        left_ear="Suppanomimi",  --5
    })-- 5%)
    sets.engaged.DW.PDT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Acc.PDT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.CRIT.PDT.MaxHaste = set_combine(sets.engaged.DW.CRIT.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.PDT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)

    --SubtleBlow 50% set

    sets.engaged.SubtleBlow = set_combine(sets.engaged, {  
        ammo="Staunch Tathlum +1",  
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Loricate Torque +1",     
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.engaged.Acc.SubtleBlow = set_combine(sets.engaged.Acc, {   
        ammo="Staunch Tathlum +1",  
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1",     
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",
    })
    sets.engaged.CRIT.SubtleBlow = set_combine(sets.engaged.CRIT, { 
        ammo="Staunch Tathlum +1",  
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1",     
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",
    })
    sets.engaged.STP.SubtleBlow = set_combine(sets.engaged.STP, {  
        ammo="Staunch Tathlum +1",  
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1",     
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",
    })
    --SubtleBlow 75% set

    sets.engaged.SubtleBlow75 = set_combine(sets.engaged, { 
        ammo="Staunch Tathlum +1",         
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1", 
        waist="Sarissapho. Belt",
        left_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Sokolski Mantle",
    })

    sets.engaged.Acc.SubtleBlow75 = set_combine(sets.engaged.Acc, {        
        ammo="Staunch Tathlum +1",         
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1", 
        waist="Sarissapho. Belt",
        left_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Sokolski Mantle",
    })
    sets.engaged.CRIT.SubtleBlow75 = set_combine(sets.engaged.CRIT, {        
        ammo="Staunch Tathlum +1",         
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1", 
        waist="Sarissapho. Belt",
        left_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Sokolski Mantle",
    })
    sets.engaged.STP.SubtleBlow75 = set_combine(sets.engaged.STP, {        
        ammo="Staunch Tathlum +1",         
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Malignance Tabard",
        legs="Malignance Tights",
        neck="Loricate Torque +1", 
        waist="Sarissapho. Belt",
        left_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Sokolski Mantle",
    })

    sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.DW, sets.engaged.SubtleBlow)
    sets.engaged.DW.Acc.SubtleBlow = set_combine(sets.engaged.DW.Acc, sets.engaged.SubtleBlow)
    sets.engaged.DW.CRIT.SubtleBlow = set_combine(sets.engaged.DW.CRIT, sets.engaged.SubtleBlow)
    sets.engaged.DW.STP.SubtleBlow = set_combine(sets.engaged.DW.STP, sets.engaged.SubtleBlow)

    sets.engaged.DW.SubtleBlow75 = set_combine(sets.engaged.DW, sets.engaged.SubtleBlow75)
    sets.engaged.DW.Acc.SubtleBlow75 = set_combine(sets.engaged.DW.Acc, sets.engaged.SubtleBlow75)
    sets.engaged.DW.CRIT.SubtleBlow75 = set_combine(sets.engaged.DW.CRIT, sets.engaged.SubtleBlow75)
    sets.engaged.DW.STP.SubtleBlow75 = set_combine(sets.engaged.DW.STP, sets.engaged.SubtleBlow75)

------------------------------------------------------------------------------------------------
---------------------------------------- Special Sets ------------------------------------------
------------------------------------------------------------------------------------------------

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {aist="Windbuffet Belt +1",}
    sets.buff['Climactic Flourish'] = {}
    sets.buff['Closed Position'] = {feet="Horos T. Shoes +1"}

    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",} -- +65%

    sets.Normal = {}
    sets.Twashtar = {main={ name="Twashtar", augments={'Path: A',}}, sub={ name="Gleti's Knife", augments={'Path: A',}},}
    sets.Aeneas = {main={ name="Aeneas", augments={'Path: A',}}, sub={ name="Ternion Dagger +1", augments={'Path: A',}},}
    sets.Tauret = {main="Tauret", sub={ name="Gleti's Knife", augments={'Path: A',}},}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    --[[if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end]]
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
        handle_equipping_gear(player.status)
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
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    check_weaponset()
end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
end

function customize_idle_set(idleSet)
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
        if state.CapacityMode.value then
            meleeSet = set_combine(meleeSet, sets.CapacityMantle)
        end
        if state.ClosedPosition.value == true then
            meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
        end
        if state.TreasureMode.value == 'Fulltime' then
            meleeSet = set_combine(meleeSet, sets.TreasureHunter)
        end
    end

    check_weaponset()

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end

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
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 9 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 9 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 21 and DW_needed <= 39 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 39 then
            classes.CustomMeleeGroups:append('')
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

-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 164')
    end
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
	if buffactive['Mana Wall'] then
		moving = false
    elseif mov.counter>15 then
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

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(3, 28)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 28)
    elseif player.sub_job == 'SAM' then
        set_macro_page(3, 28)
    else
        set_macro_page(3, 28)
    end
end

