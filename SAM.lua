-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
--Ionis Zones
--Anahera Blade (4 hit): 52
--Tsurumaru (4 hit): 49
--Kogarasumaru (or generic 450 G.katana) (5 hit): 40
--Amanomurakumo/Masamune 437 (5 hit): 46
--
--Non Ionis Zones:
--Anahera Blade (4 hit): 52
--Tsurumaru (5 hit): 24
--Kogarasumaru (5 hit): 40
--Amanomurakumo/Masamune 437 (5 hit): 46
--
--Aftermath sets
-- Koga AM1/AM2 = sets.engaged.Kogarasumaru.AM
-- Koga AM3 = sets.engaged.Kogarasumaru.AM3
-- Amano AM = sets.engaged.Amanomurakumo.AM
-- Using Namas Arrow while using Amano will cancel STPAM set

-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
function get_sets()
	-- Load and initialize the include file.
    mote_include_version = 2
	include('Mote-Include.lua')
	include('organizer-lib')
end
organizer_items = {     
    "Airmid's Gorget",
    "Tumult's Blood",
    "Sarama's Hide",
    "Hidhaegg's Scale",
    "Sovereign's Hide",
    "Grape Daifuku",
    "Soy Ramen",
    "G. Curry Bun +1",
    "Pukatrice Egg",
    "Moogle Amp.",
    "Popo. con Queso",
    "Pear Crepe",
    "Crab Sushi",
    "Om. Sandwich",
    "Red Curry Bun",   
    "Drepanum",
    "Sword Strap",
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

-- Setup vars that are user-independent.
function job_setup()
    include('Mote-TreasureHunter')
    state.WeaponLock = M(false, 'Weapon Lock')
	send_command('bind @w gs c toggle WeaponLock')
    get_combat_form()
    --get_combat_weapon()
    update_melee_groups()
    send_command('wait 2;input /lockstyleset 172')
    state.Moving  = M(false, "moving")
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.BrachyuraEarring = M(true,false)

    state.YoichiAM = M(false, 'Cancel Yoichi AM Mode')
    -- list of weaponskills that make better use of otomi helm in low acc situations
    wsList = S{'Tachi: Shoha', 'Tachi: Jinpu', 'Tachi: Enpi'}

    gear.RAarrow = {name="Eminent Arrow"}
    LugraWSList = S{'Tachi: Fudo', 'Tachi: Shoha', 'Namas Arrow', 'Impulse Drive', 'Stardiver'}

    state.Buff.Sekkanoki = buffactive.sekkanoki or false
    state.Buff.Sengikori = buffactive.sengikori or false
    state.Buff['Third Eye'] = buffactive['Third Eye'] or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc','MaxAcc', 'CRIT' )
    state.HybridMode:options('Normal', 'PDT', 'STP', 'triple', 'Fullhaste', 'SubtleBlow', 'Counter', 'Range')
    state.WeaponskillMode:options('Normal', 'Mid', 'SC', 'Acc', 'PDL')
    state.IdleMode:options('Normal','PDT' ,'Regen', 'MDT', 'HP', 'Evasion', 'EnemyCritRate')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
    state.MagicalDefenseMode:options('MDT')

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
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^[ input /lockstyle on')
    send_command('bind ![ input /lockstyle off')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind ^/ gs disable all')
    send_command('bind ^; gs enable all')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind delete gs c toggle BrachyuraEarring')
    send_command('wait 6;input /lockstyleset 172')
    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^[')
    send_command('unbind !=')
    send_command('unbind ![')
    send_command('unbind ^/')
    send_command('unbind ^-')
    send_command('unbind ^=')

end

--[[
-- SC's
Rana > Shoha > Fudo > Kasha > Shoha > Fudo - light
Rana > Shoha > Fudo > Kasha > Rana > Fudo - dark

Kasha > Shoha > Fudo
Fudo > Kasha > Shoha > fudo
Shoha > Fudo > Kasha > Shoha > Fudo

--]]
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
    sets.precast.JA['Provoke'] = { 
        -- ear1="Cryptic Earring",
    }
    
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {
        head="Wakido Kabuto +1",
        hands="Sakonji Kote +3",
        back="Smertrios's Mantle",
    }
    sets.precast.JA.Sekkanoki = {hands="Unkai Kote +2" }
    sets.precast.JA.Seigan = {head="Kasuga Kabuto +2"}
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +1"}
    sets.precast.JA['Third Eye'] = {legs="Sakonji Haidate +3"}
    sets.precast.JA['Blade Bash'] = {hands="Saotome Kote +3"}
   
    sets.precast.FC = {
        neck="Orunmila's Torque",
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        hands="Leyline Gloves",
        ring1="Prolix Ring",
    }
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {legs="Dashing Subligar"}

    sets.precast.RA = { ammo=empty,
        range="Trollbane",  
        head={ name="Sakonji Kabuto +3", augments={'Enhances "Ikishoten" effect',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Yemaya Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Purity Ring",
        right_ring="Ilabrat Ring",
        back="Takaha Mantle",

    }
    sets.midcast.RA = { ammo=empty,
        range="Trollbane",  
        head={ name="Sakonji Kabuto +3", augments={'Enhances "Ikishoten" effect',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Yemaya Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Purity Ring",
        right_ring="Ilabrat Ring",
        back="Takaha Mantle",
    }	
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    --sets.CapacityMantle  = { back="Mecistopins Mantle" }
    --sets.Berserker       = { neck="Berserker's Torque" }
    sets.WSDayBonus      = { head="Gavialis Helm" }
    sets.LugraMoonshade  = { ear2="Lugra Earring +1", ear1="Moonshade Earring" }
    sets.BrutalMoonshade = { ear2="Brutal Earring", ear1="Moonshade Earring" }
    --sets.LugraFlame      = { ear1="Lugra Earring +1", ear2="Flame Pearl" }
    --sets.FlameFlame      = { ear1="Flame Pearl", ear2="Flame Pearl" }
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
    ammo="Knobkierrie",
    head={ name="Mpaca's Cap", augments={'Path: A',}},
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back="Smertrios's Mantle",
    }
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Sroda Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
    })
    sets.precast.WS.SC = set_combine(sets.precast.WS, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    
    sets.precast.WS['Namas Arrow'] = {
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    }
    sets.precast.WS['Namas Arrow'].PDL = set_combine(sets.precast.WS['Namas Arrow'], {
        feet="Kas. Sune-Ate +2",
        left_ring="Sroda Ring", 
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Namas Arrow'].Acc = set_combine(sets.precast.WS['Namas Arrow'], {
    })
    
    sets.precast.WS['Apex Arrow'] = set_combine(sets.precast.WS['Namas Arrow'], {
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Apex Arrow'].PDL = set_combine(sets.precast.WS['Apex Arrow'], {
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    } )
    sets.precast.WS['Apex Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
    })

    sets.precast.WS['Empyreal Arrow'] = set_combine(sets.precast.WS['Namas Arrow'], {
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Empyreal Arrow'].PDL = set_combine(sets.precast.WS['Apex Arrow'], {
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    })
    sets.precast.WS['Empyreal Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
    })
    
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Fudo'].PDL = set_combine(sets.precast.WS['Tachi: Fudo'], {
        ammo="Crepuscular Pebble",
        body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS['Tachi: Fudo'], {

    })

    sets.precast.WS['Tachi: Kaiten'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        body="Nyame Mail",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        ear2="Thrud Earring",
        ear1="Lugra Earring +1", 
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })

    sets.precast.WS['Tachi: Kaiten'].Mid = set_combine(sets.precast.WS['Tachi: Kaiten'], {
        ammo="Knobkierrie",
        body="Nyame Mail",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        ear2="Thrud Earring",
        ear1="Lugra Earring +1", 
        LEFT_ring="Sroda Ring", 
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Kaiten'].PDL = set_combine(sets.precast.WS['Tachi: Kaiten'], {
        ammo="Crepuscular Pebble",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Kas. Sune-Ate +2",
        ear1="Lugra Earring +1", 
        left_ring="Niqmaddu Ring",
        right_ring="Regal Ring",
        back="Smertrios's Mantle",
    })

    sets.precast.WS['Tachi: Kaiten'].Acc = set_combine(sets.precast.WS['Tachi: Kaiten'], {

    })

    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Impulse Drive'].PDL = set_combine(sets.precast.WS['Impulse Drive'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    })
    sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS['Impulse Drive'], {
    })

    sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS['Impulse Drive'], {
    })
    
    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Shoha'].PDL = set_combine(sets.precast.WS['Tachi: Shoha'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS['Tachi: Shoha'], {})

    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS['Tachi: Shoha'], {
        neck="Samurai's Nodowa +2",
      
    })
    sets.precast.WS['Stardiver'].PDL = set_combine(sets.precast.WS['Stardiver'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
    left_ring="Sroda Ring", 
    back="Smertrios's Mantle",
    })
    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS['Stardiver'], {

    })
    
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Rana'].PDL = set_combine(sets.precast.WS['Tachi: Rana'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Sroda Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Rana'].Acc = set_combine(sets.precast.WS, {

    })
    -- CHR Mod
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Kasuga Domaru +2",
        hands="Flam. Manopolas +2",
        legs="Kasuga Haidate +2",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Eschan Stone",
        left_ear="Digni. Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Ageha'].PDL = set_combine(sets.precast.WS['Tachi: Ageha'], {
        ammo="Crepuscular Pebble",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Kas. Sune-Ate +2",
        left_ring="Sroda Ring",
        back="Smertrios's Mantle",
    })
    
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",

    })

    sets.precast.WS['Tachi: Kasha'].PDL = set_combine(sets.precast.WS['Tachi: Kasha'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
      hands="Nyame Gauntlets",
      legs="Nyame Flanchard",
      feet="Kas. Sune-Ate +2",
        left_ring="Sroda Ring",
        back="Smertrios's Mantle",
    })

    sets.precast.WS['Tachi: Kasha'].Acc = sets.precast.WS['Tachi: Kasha']

    
    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",

    })
    
    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    
    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })      
    sets.precast.WS['Tachi: Jinpu'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'], {
        ammo="Crepuscular Pebble",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    sets.precast.WS['Tachi: Jinpu'].Acc = set_combine(sets.precast.WS['Tachi: Jinpu'], {
    })
    sets.precast.WS['Tachi: Jinpu'].SC = set_combine(sets.precast.WS['Tachi: Jinpu'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back="Smertrios's Mantle",
    })
    
    sets.midcast['Blue Magic'] = set_combine(sets.precast.WS['Tachi: Ageha'], {
    })
    -- Midcast Sets
    sets.midcast.FastRecast = {
        ammo="Staunch Tathlum +1",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ear="Halasz Earring",
        right_ear="Mendi. Earring",
        right_ring="Evanescence Ring",
    }
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast['Dark Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Sakpata's Helm",
        body="Nyame Mail",
    hands="Sakpata's Gauntlets",
    legs="Nyame Flanchard",
    feet="Sakpata's Leggings",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Dignitary's Earring",
    left_ring="Evanescence Ring",
    right_ring="Archon Ring",
}
         -- Drain spells 
    sets.midcast.Drain = {
            left_ring="Evanescence Ring",
        }
    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Locus Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Argocham. Mantle",
    }
    sets.midcast['Enfeebling Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Incanter's Torque",
        waist="Eschan Stone",
        left_ear="Malignance Earring",
        right_ear="Crep. Earring",
        left_ring="Kishar Ring",
        right_ring="Stikini Ring +1",
        back="Solemnity Cape",
        }
    -- Sets to return to when not performing an action.
    
    -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Adamantite Armor",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear="Infused Earring",
    left_ring="Purity Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
    }
    
    sets.defense.Reraise = set_combine(sets.defense.PDT, {
    	head="Crepuscular Helm",
    	body="Crepuscular Mail"
    })
    
    sets.defense.MDT = set_combine(sets.defense.PDT, {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Sanare Earring",
        right_ear="Eabani Earring",
        left_ring="Purity Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    })
    sets.defense.Evasion = set_combine(sets.defense.PDT, {
        ammo="Amar Cluster",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Vengeful Ring",
        back="Moonlight Cape",
    })
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        neck="Sanctity Necklace",
        ring2="Paguroidea Ring",
        ear2="Infused Earring",
   	    body="Hizamaru Haramaki +2",
    }
    
    sets.idle.Town = {        
        head="Valorous Mask",
        ear2="Infused Earring",
        feet="Danzo Sune-Ate",
}
    -- sets.idle.Town.Adoulin = set_combine(sets.idle.Town, {
    --     body="Councilor's Garb"
    -- })
    
    sets.idle = {        
    head="Valorous Mask",
    body="Adamantite Armor",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear="Infused Earring",
    left_ring="Purity Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
}

    sets.idle.Regen = set_combine(sets.idle, { 
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.idle.EnemyCritRate = set_combine(sets.defense.PDT, { 
        ammo="Eluder's Sachet",
        left_ring="Warden's Ring",
        right_ring="Fortified Ring",
        back="Reiki Cloak",
    })
    sets.idle.MDT = set_combine(sets.defense.MDT, {})
    sets.idle.Enmity = set_combine(sets.defense.Enmity, {})
    sets.idle.Evasion = set_combine(sets.defense.Evasion, {})
    sets.idle.Weak = set_combine(sets.idle, {
        head="Crepuscular Helm",
    	body="Crepuscular Mail",
    })

    sets.Kiting = {feet="Danzo Sune-ate"}
    sets.Adoulin = {body="Councilor's Garb"}
    sets.MoveSpeed = {feet="Danzo Sune-ate"}
    sets.Reraise = {head="Crepuscular Helm",body="Crepuscular Mail"}
    
    -- Engaged sets
    
    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- I generally use Anahera outside of Adoulin areas, so this set aims for 47 STP + 5 from Anahera (52 total)
    -- Note, this set assumes use of Cibitshavore (hence the arrow as ammo)
    sets.engaged = {range=empty,
    ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Kasuga Domaru +2",
    hands="Wakido Kote +3",
    legs="Kasuga Haidate +2",
    feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
    neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Kasuga Earring +1",
    left_ear="Dedition Earring",
    right_ring="Chirich Ring +1",
    left_ring="Niqmaddu Ring",
    back="Takaha Mantle",
    }

    sets.engaged.Acc = set_combine(sets.engaged.Mid, { range=empty,
        ammo="Coiste Bodhar",
        head="Kasuga Kabuto +2",
        body="Kasuga Domaru +2",
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Kasuga Haidate +2",
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Kasuga Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
        back="Takaha Mantle",
    })
    sets.engaged.MaxAcc = set_combine(sets.engaged.Acc, { range=empty,
    ammo="Amar Cluster",
    head="Kasuga Kabuto +2",
    body="Kasuga Domaru +2",
    hands="Wakido Kote +3",
    legs="Kasuga Haidate +2",
    feet="Wakido Sune. +3",
    neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear={ name="Schere Earring", augments={'Path: A',}},
    right_ear={ name="Kasuga Earring +1", augments={'System: 1 ID: 1676 Val: 0','Accuracy+11','Mag. Acc.+11','Weapon skill damage +2%',}},
    left_ring="Regal Ring",
    right_ring="Chirich Ring +1",
    back="Takaha Mantle",
    })

    sets.engaged.Fullhaste = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head="Kasuga Kabuto +2",
        body="Kasuga Domaru +2",
        hands="Wakido Kote +3",
        legs="Kasuga Haidate +2",
        feet="Wakido Sune. +3",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Gerdr Belt",
        right_ear="Kasuga Earring +1",
        left_ear="Dedition Earring",
        right_ring="Chirich Ring +1",
        left_ring="Niqmaddu Ring",
        back="Takaha Mantle",
         })
    sets.engaged.SubtleBlow = set_combine(sets.engaged, {        
        body="Dagon Breast.",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Digni. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
    })

    sets.engaged.Acc.SubtleBlow = set_combine(sets.engaged.Acc, {        
        body="Dagon Breast.",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Digni. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
    })
    sets.engaged.MaxAcc.SubtleBlow = set_combine(sets.engaged.MaxAcc, {        
        body="Dagon Breast.",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Digni. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
    })
         sets.engaged.Range = {
            head={ name="Sakonji Kabuto +3", augments={'Enhances "Ikishoten" effect',}},
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
            waist="Yemaya Belt",
            left_ear="Crep. Earring",
            right_ear="Telos Earring",
            left_ring="Purity Ring",
            right_ring="Ilabrat Ring",
            back="Takaha Mantle",
        }

    sets.engaged.Counter = set_combine(sets.engaged, {
        ammo="Amar Cluster",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body="Mpaca's Doublet",
        hands="Hizamaru Kote +2",
        legs="Kasuga Haidate +2",
        feet="Hiza. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Genmei Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Hizamaru Ring",
        back="Takaha Mantle",

    })

    sets.engaged.CRIT = set_combine(sets.engaged, {range=empty,
    ammo="Aurgelmir Orb +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mpaca's Doublet",
    hands="Flam. Manopolas +2",
    legs={ name="Mpaca's Hose", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Schere Earring",
    right_ear="Brutal Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Hetairoi Ring",
    back="Smertrios's Mantle",
    })
    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Kasuga Kabuto +2",
        body="Kasuga Domaru +2",
        hands="Mpaca's Gloves",
        legs="Kasuga Haidate +2",
        feet="Mpaca's Boots",
        right_ring="Defending Ring",
    }
    sets.engaged.PDT = set_combine(sets.engaged,sets.engaged.Hybrid)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc,sets.engaged.Hybrid)
    sets.engaged.MaxAcc.PDT = set_combine(sets.engaged.MaxAcc,sets.engaged.Hybrid)
    sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)
    sets.engaged.SubtleBlow.PDT = set_combine(sets.engaged.SubtleBlow, sets.engaged.Hybrid)

    sets.engaged.STP = {range=empty,
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body="Kasuga Domaru +2",
        hands="Wakido Kote +3",
        legs="Kasuga Haidate +2",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Gerdr Belt",
        left_ear="Dedition Earring",
        right_ear="Kasuga Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Takaha Mantle",
    }
    sets.engaged.triple = {range=empty,
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Kasuga Haidate +2",
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Schere Earring",
        right_ear="Balder Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Hetairoi Ring",
        back="Bleating Mantle",
    }
    
    sets.engaged.Amanomurakumo = set_combine(sets.engaged, {})
    sets.engaged.Amanomurakumo.AM = set_combine(sets.engaged, {})
    sets.engaged.Kogarasumaru = set_combine(sets.engaged, {})
    sets.engaged.Kogarasumaru.AM = set_combine(sets.engaged, {})
    sets.engaged.Kogarasumaru.AM3 = set_combine(sets.engaged, {})
    sets.engaged.Reraise = set_combine(sets.engaged, {
    head="Crepuscular Helm",
    body="Crepuscular Mail",})
    
    sets.buff.Sekkanoki = {hands="unkai kote +2"}
    sets.buff.Sengikori = {feet="Kas. Sune-Ate +2",}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate +3"}
    
    sets.thirdeye = {head="Kasuga Kabuto +2", legs="Sakonji Haidate +3"}
    --sets.seigan = {hands="Otronif Gloves +1"}
    sets.bow = {ammo=gear.RAarrow}
    
    sets.Terror = {feet={ name="Founder's Greaves", augments={'VIT+8','Accuracy+13','"Mag.Atk.Bns."+14','Mag. Evasion+14',}},}
    sets.Stun = {feet={ name="Founder's Greaves", augments={'VIT+8','Accuracy+13','"Mag.Atk.Bns."+14','Mag. Evasion+14',}},}
    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}
    sets.Sleep = {neck="Vim Torque +1",left_ear="Infused Earring",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
    --if spell.english == 'Third Eye' and not buffactive.Seigan then
    --    cancel_spell()
    --    send_command('@wait 0.5;input /ja Seigan <me>')
    --    send_command('@wait 1;input /ja "Third Eye" <me>')
    --end
end
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)

	if spell.type:lower() == 'weaponskill' then
		if state.Buff.Sekkanoki then
			equip(sets.buff.Sekkanoki)
		end
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        if is_sc_element_today(spell) then
            if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
                equip(sets.WSDayBonus)
            end
        end
        -- if LugraWSList:contains(spell.english) then
        --     if world.time >= (17*60) or world.time <= (7*60) then
        --         if spell.english:lower() == 'namas arrow' then
        --             equip(sets.LugraFlame)
        --         else
        --             equip(sets.LugraMoonshade)
        --         end
        --     else
        --         if spell.english:lower() == 'namas arrow' then
        --             equip(sets.FlameFlame)
        --         else
        --             equip(sets.BrutalMoonshade)
        --         end
        --     end
        -- end
		if state.Buff['Meikyo Shisui'] then
			equip(sets.buff['Meikyo Shisui'])
		end
	end
    -- Replace Moonshade Earring if we're at cap TP
    if spell.type == 'Weaponskill' and player.tp == 3000 then
        equip({left_ear="Lugra Earring +1"})
    end
    if spell.type == 'WeaponSkill' then
        -- Replace TP-bonus gear if not needed.
        if spell.english == 'Aeolian Edge' and player.tp > 2900 then
            equip({ear1="Crematio Earring"})
        end
    end
    if spell.english == "Seigan" then
        -- Third Eye gearset is only called if we're in PDT mode
        if state.HybridMode.value == 'PDT' or state.PhysicalDefenseMode.value == 'PDT' then
            equip(sets.thirdeye)
        else
            equip(sets.seigan)
        end
    end
    if spell.name == 'Spectral Jig' and buffactive.sneak then
            -- If sneak is active when using, cancel before completion
            send_command('cancel 71')
    end
    update_am_type(spell)
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		equip(sets.midcast.FastRecast)
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Effectively lock these items in place.
	if state.HybridMode.value == 'Reraise' or
    (state.HybridMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
		equip(sets.Reraise)
	end
    if state.Buff['Seigan'] then
        if state.DefenseMode.value == 'PDT' then
            equip(sets.thirdeye)
        else
            equip(sets.seigan)
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
	end
end
function job_handle_equipping_gear(player,status, eventArgs)

end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    --if player.hpp < 90 then
        --idleSet = set_combine(idleSet, sets.idle.Regen)
    --end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    --[[if player.hpp < 5 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        idleSet = set_combine(idleSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end]]
	return idleSet
end

windower.register_event('hpp change',
function(new_hpp,old_hpp)
    if new_hpp < 5 then
        equip(sets.Reraise)
    end
end
)

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff['Seigan'] then
        if state.DefenseMode.value == 'PDT' then
    	    meleeSet = set_combine(meleeSet, sets.thirdeye)
        else
            meleeSet = set_combine(meleeSet, sets.seigan)
        end
    end
    if player.equipment.range == 'Yoichinoyumi' then
        meleeSet = set_combine(meleeSet, sets.bow)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if player.hpp < 5 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        meleeSet = set_combine(meleeSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    if state.Buff.Sleep and player.hp > 120 and player.status == "Engaged" then -- Equip Vim Torque When You Are Asleep
        meleeSet = set_combine(meleeSet,{neck="Vim Torque +1"})
    end
    return meleeSet
end
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
function job_state_change(stateField, newValue, oldValue)
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
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Engaged' then
        if not buffactive['hasso '] then
            send_command('@input /ja "hasso " <me>')
        elseif player.inventory['Eminent Arrow'] then
            gear.RAarrow.name = 'Eminent Arrow'
        elseif player.inventory['Eminent Arrow'] then
            gear.RAarrow.name = 'Eminent Arrow'
        elseif player.equipment.ammo == 'empty' then
            add_to_chat(122, 'No more Arrows!')
        end
    elseif newStatus == 'Idle' then
        determine_idle_group()
    end
end
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
    	state.Buff[buff] = gain
        handle_equipping_gear(player.status)
    end
    if buff == "Protect" then
        if gain then
            enable('ear1')
            state.BrachyuraEarring:set(false)
        end
    end
    if not buffactive.hasso then
        if player.status == 'Engaged' then
            send_command('@wait 0.2;input /ja "hasso" <me>')
        end
    end
    if S{'aftermath'}:contains(buff:lower()) then
        classes.CustomMeleeGroups:clear()
       
        if player.equipment.main == 'Amanomurakumo' and state.YoichiAM.value then
            classes.CustomMeleeGroups:clear()
        elseif player.equipment.main == 'Kogarasumaru'  then
            if buff == "Aftermath: Lv.3" and gain or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
            end
        elseif buff == "Aftermath" and gain or buffactive.Aftermath then
            classes.CustomMeleeGroups:append('AM')
        end
    end
    if buff == "Yaegasumi" then
        if gain then  			
            send_command('input /p "Yaegasumi" [ON]')		
        else	
            send_command('input /p "Yaegasumi" [OFF]')
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
    if buff == "terror" then
        if gain then
            equip(sets.Terror)
             disable('feet')
            else
             enable('feet')
             handle_equipping_gear(player.status)    
        end
    end
    if S{'terror','petrification','sleep','stun'}:contains(name) then
        if gain then
            equip(sets.defense.PDT)
        elseif not gain then 
            handle_equipping_gear(player.status)
        end
    end
    if name == 'sleep' then
        if gain and player.hp > 120 and player.status == 'Engaged' then -- Equip Vim Torque When You Are Asleep   
            equip(sets.Sleep)
            send_command('input /p ZZZzzz, please cure.')		
            disable('neck')
        else
            enable('neck')
            send_command('input /p '..player.name..' is no longer Sleep Thank you !')
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
    --[[if buff == "weakness" then
        if gain then
            equip(sets.Reraise)
             disable('body','head')
            else
             enable('body','head')
        end
        return meleeSet
    end]]
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
    if not midaction() then
        job_update()
    end

end
function check_buffs(check)
     
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 172')
    end
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_self_command(cmdParams, eventArgs)

end
function job_update(cmdParams, eventArgs)
	get_combat_form()
    update_melee_groups()
    job_self_command()
    --get_combat_weapon()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    --[[if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end]]
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
--function get_combat_weapon()
--    if player.equipment.range == 'Yoichinoyumi' then
--        if player.equipment.main == 'Amanomurakumo' then
--            state.CombatWeapon:set('AmanoYoichi')
--        else
--            state.CombatWeapon:set('Yoichi')
--        end
--    else
--        state.CombatWeapon:set(player.equipment.main)
--    end
--end
-- Handle zone specific rules
-- windower.register_event('Zone change', function(new,old)
--     determine_idle_group()
-- end)

function determine_idle_group()
    classes.CustomIdleGroups:clear()
    -- if areas.Adoulin:contains(world.area) then
    -- 	classes.CustomIdleGroups:append('Adoulin')
    -- end
end

function get_combat_form()
    -- if areas.Adoulin:contains(world.area) and buffactive.ionis then
    -- 	state.CombatForm:set('Adoulin')
    -- else
    --     state.CombatForm:reset()
    -- end
end

function seigan_thirdeye_active()
    return state.Buff['Seigan'] or state.Buff['Third Eye']
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()

    if player.equipment.main == 'Amanomurakumo'  then
        -- prevents using Amano AM while overriding it with Yoichi AM
        classes.CustomMeleeGroups:clear()
    elseif player.equipment.main == 'Kogarasumaru' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
    else
        if buffactive['Aftermath'] then
            classes.CustomMeleeGroups:append('AM')
        end
    end
end
-- call this in job_post_precast() 
function update_am_type(spell)
    if spell.type == 'WeaponSkill' and spell.skill == 'Archery' and spell.english == 'Namas Arrow' then
        if player.equipment.main == 'Amanomurakumo' then
            -- Yoichi AM overwrites Amano AM
            state.YoichiAM:set(true)
        end
    else
        state.YoichiAM:set(false)
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


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
    	set_macro_page(3, 31)
    elseif player.sub_job == 'DRK' then
    	set_macro_page(4, 31)
    elseif player.sub_job == 'NIN' then
    	set_macro_page(5, 31)
    elseif player.sub_job == 'DNC' then
    	set_macro_page(6, 31)
    else
    	set_macro_page(1, 31)
    end
end