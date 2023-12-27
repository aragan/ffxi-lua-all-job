-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
    include('organizer-lib')
    res = require 'resources'
end
organizer_items = {
"Reikiko",
"Prime Sword",
"Lycurgos",
"Foreshock Sword",
"Hepatizon Axe +1",
    "Aettir",
    "Lentus Grip",
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
    state.WeaponLock = M(false, 'Weapon Lock')
    state.Knockback = M(false, 'Knockback')

    send_command('wait 6;input /lockstyleset 165')
	include('Mote-TreasureHunter')
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    rune_enchantments = S{'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda',
        'Lux','Tenebrae'}

    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1",}

    rayke_duration = 35
    gambit_duration = 96
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'DD', 'CRIT', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'PDL')
    state.HybridMode:options('Normal', 'DT', 'MDT')
    state.PhysicalDefenseMode:options('PDT','PDH', 'HP', 'Evasion', "Resist", 'Enmity')
    state.MagicalDefenseMode:options('MDT')
    state.CastingMode:options('Normal', 'SIRD') 
    state.IdleMode:options('Normal', 'PDH', 'PDT', "EnemyCritRate", "Resist", 'Regen', 'Refresh')
    send_command('wait 2;input /lockstyleset 165')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind ^- gs enable all')
    send_command('bind ^/ gs disable all')
    send_command('bind f4 gs c cycle Runes')
    send_command('bind f3 gs c cycleback Runes')
    send_command('bind f2 input //gs c rune')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind f6 gs c cycle WeaponSet')

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.Knockback = M(false, 'Knockback')
    state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}

    state.WeaponSet = M{['description']='Weapon Set', 'normal', 'Aettir', 'Naegling', 'Lycurgos'}

    select_default_macro_book()
end


function init_gear_sets()

    --sets.Epeolatry = {main="Epeolatry", sub="Refined Grip +1",}
    sets.Naegling = {main="Naegling", sub="Chanter's Shield"}
    sets.Aettir = {main="Aettir", sub="Refined Grip +1",}
    sets.Lycurgos = {main="Lycurgos", sub="Refined Grip +1",}

    sets.Enmity =    { 
    ammo="Iron Gobbet",
    head="Halitus Helm",
    body={ name="Emet Harness +1", augments={'Path: A',}},
    hands="Kurys Gloves",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Ahosi Leggings",
    neck="Moonlight Necklace",
    left_ear="Cryptic Earring",
    right_ear="Trux Earring",
    left_ring="Vengeful Ring",
    right_ring="Petrov Ring",
    back="Reiki Cloak",
    }
    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = {body="Runeist coat +3", legs="Futhark Trousers +3"}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist bottes"}
    sets.precast.JA['Battuta'] = {head="Fu. Bandeau +3"}
    sets.precast.JA['Liement'] = {body="Futhark Coat +1"}
    sets.precast.JA['Lunge'] = {
    head="Agwu's Cap",
    body="Agwu's Robe",
    hands="Agwu's Gages",
    legs="Agwu's Slops",
    feet="Agwu's Pigaches",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear="Crematio Earring",
    left_ring="Mujin Band",
    right_ring="Locus Ring",
    back="Argocham. Mantle",
    }
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons +1"}
    sets.precast.JA['Rayke'] = {feet="Futhark Bottes +1"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat 1"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +1"}
    sets.precast.JA['Embolden'] = {back="Evasionist's Cape"}
    sets.precast.JA['Vivacious Pulse'] = {
    head="Erilaz Galea +2",
    legs="Rune. Trousers +3",
    neck="Incanter's Torque",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
    sets.precast.JA['One For All'] = {}
    sets.precast.JA['Provoke'] = sets.Enmity


	-- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb",
        head="Rune. Bandeau +3",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        body="Agwu's Robe",
        neck="Baetyl Pendant",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Prolix Ring",
        right_ring="Kishar Ring",}

        sets.precast.FC.Cure = set_combine(sets.precast.FC,{
        legs="Doyen Pants",
        })
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        legs="Futhark Trousers +3",
        waist="Siegel Sash",
    })
sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
    legs="Doyen Pants",
    waist="Siegel Sash",
})
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'})
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})


	-- Weaponskill sets
    sets.precast.WS = {
    ammo="Knobkierrie",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Cornelia's Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
}
    sets.precast.WS.PDL = {
        ammo="Crepuscular Pebble",
        left_ring="Sroda Ring",
    }

    sets.precast.WS['Resolution'] = {  
        ammo="Coiste Bodhar",
           head="Nyame Helm",
           body="Nyame Mail",
           hands="Nyame Gauntlets",
           legs="Nyame Flanchard",
           feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back="Bleating Mantle",
}
    sets.precast.WS['Resolution'].PDL = set_combine(sets.precast.WS['Resolution'], {
        ammo="Crepuscular Pebble",
        left_ring="Sroda Ring",})

    sets.precast.WS['Dimidiation'] = {  
        ammo="Coiste Bodhar",
           head="Nyame Helm",
           body="Nyame Mail",
           hands="Nyame Gauntlets",
           legs="Nyame Flanchard",
           feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
}
    sets.precast.WS['Dimidiation'].PDL = set_combine(sets.precast.WS['Dimidiation'], {
    ammo="Crepuscular Pebble",
    left_ring="Sroda Ring",})
    sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {hands="Umuthi Gloves"})
    sets.precast.WS['Herculean Slash'].PDL = set_combine(sets.precast.WS['Herculean Slash'], {})
    sets.precast.WS['Ground Strike'] = set_combine(sets.precast.WS, { 
           ammo="Knobkierrie",
           head="Nyame Helm",
           body="Nyame Mail",
           hands="Nyame Gauntlets",
           legs="Nyame Flanchard",
           feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Cornelia's Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
})
    sets.precast.WS['Ground Strike'].PDL = set_combine(sets.precast.WS['Ground Strike'], { 
        ammo="Crepuscular Pebble",
        left_ring="Sroda Ring",
})
sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back="Bleating Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Crepuscular Pebble",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Judgment'], {
        ammo="Crepuscular Pebble",
        left_ring="Sroda Ring",
    })


	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
    sets.midcast.FastRecast = {    ammo="Staunch Tathlum +1",
    head="Erilaz Galea +2",
    body="Nyame Mail",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet="Nyame Sollerets",
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Halasz Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Evanescence Ring",
    back="Ogma's Cape",}

    sets.midcast.SIRD = {    ammo="Staunch Tathlum +1",
    head="Erilaz Galea +2",
    body="Nyame Mail",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet="Nyame Sollerets",
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Halasz Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Evanescence Ring",
    back="Ogma's Cape",}

    sets.midcast['Enhancing Magic'] = {    ammo="Staunch Tathlum +1",
    head="Erilaz Galea +2",
    body="Nyame Mail",
    hands="Regal Gauntlets",
    legs="Futhark Trousers +3",
    feet="Nyame Sollerets",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Ogma's Cape",
}

    sets.midcast['Enhancing Magic'].SIRD = sets.midcast.SIRD
    sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
        head="Fu. Bandeau +3",
        body={ name="Herculean Vest", augments={'Phys. dmg. taken -1%','Accuracy+11 Attack+11','Phalanx +2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
        hands={ name="Herculean Gloves", augments={'Accuracy+11','Pet: Phys. dmg. taken -5%','Phalanx +4',}},
    })
    sets.midcast['Phalanx'].SIRD = sets.midcast.SIRD
    sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {
        head="Rune. Bandeau +3",
        neck="Sacro Gorget",
        right_ear="Erilaz Earring +2",
    })
    sets.midcast['Regen'].SIRD = set_combine(sets.midcast.SIRD, {
        head="Rune. Bandeau +3",
        right_ear="Erilaz Earring +2",
    })
    sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'], {
    ammo="Staunch Tathlum +1",
    head="Erilaz Galea +2",
    body="Nyame Mail",
    hands="Regal Gauntlets",
    legs="Futhark Trousers +3",
    feet="Nyame Sollerets",
    neck="Incanter's Torque",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Ogma's Cape",})
    sets.midcast['Stoneskin'].SIRD = sets.midcast.SIRD

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head="Erilaz Galea +2",
		waist="Gishdubar sash"})
    sets.midcast.Cure = set_combine(sets.defense.PDT, {
        feet="Skaoi Boots",
        right_ear="Mendi. Earring",
        right_ring="Naji's Loop",
        neck="Sacro Gorget",
        waist="Gishdubar sash",
        back="Solemnity Cape",
    })
    sets.midcast.Cure.SIRD = sets.midcast.SIRD
    sets.midcast.Flash = sets.Enmity

    sets.midcast['Elemental Magic'] = set_combine(sets.precast.JA['Lunge'],{})
    sets.midcast.Pet["Enfeebling Magic"] = set_combine(sets.midcast['Elemental Magic'],{})
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        waist="Acuity Belt +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.idle = {   
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Genmei Earring",
        right_ear="Infused Earring",
        left_ring="Defending Ring",
        right_ring="Fortified Ring",
        back="Ogma's Cape",}

    sets.idle.Town = {
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
    
    sets.Adoulin = {body="Councilor's Garb",}

    sets.idle.Refresh = set_combine(sets.idle, {
    ammo="Homiliary",
    body="Agwu's Robe",
    hands="Regal Gauntlets",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Erilaz Earring +2",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Fucho-no-Obi",
    })

    sets.idle.Regen = set_combine(sets.idle, {
        hands="Regal Gauntlets",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.idle.PDH = {
        ammo="Staunch Tathlum +1",
        main="Aettir",
        sub="Refined Grip +1",
        head="Erilaz Galea +2",
        body="Erilaz Surcoat +3",
        hands="Erilaz Gauntlets +2",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Ogma's Cape",
    }

    sets.idle.PDT = {   
        ammo="Staunch Tathlum +1",
        main="Aettir",
        sub="Refined Grip +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Ogma's Cape",}

    sets.idle.Resist = set_combine(sets.idle.PDT, {
        main="Malignance Sword",
        sub="Chanter's Shield",
        ammo="Staunch Tathlum +1",
        hands="Erilaz Gauntlets +2",
        legs="Rune. Trousers +3",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
    })
    sets.idle.EnemyCritRate = set_combine(sets.idle.PDH, {
        ammo="Eluder's Sachet",
        left_ring="Warden's Ring",
        right_ring="Fortified Ring",
        back="Reiki Cloak",
     })

	sets.defense.PDT = {   
    ammo="Staunch Tathlum +1",
    main="Aettir",
    sub="Refined Grip +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Ogma's Cape",}

    sets.defense.PDH = {
    ammo="Staunch Tathlum +1",
    main="Aettir",
    sub="Refined Grip +1",
    head="Erilaz Galea +2",
    body="Erilaz Surcoat +3",
    hands="Erilaz Gauntlets +2",
    legs="Eri. Leg Guards +2",
    feet="Erilaz Greaves +2",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Ogma's Cape",
    }
    sets.defense.Enmity = { 
        ammo="Iron Gobbet",
        main="Aettir",
        sub="Alber Strap",
        head="Halitus Helm",
        body={ name="Emet Harness +1", augments={'Path: A',}},
        hands="Kurys Gloves",
        legs="Eri. Leg Guards +2",
        feet="Erilaz Greaves +2",
        neck="Moonlight Necklace",
        waist="Plat. Mog. Belt",
        left_ear="Cryptic Earring",
        right_ear="Trux Earring",
        left_ring="Vengeful Ring",
        right_ring="Petrov Ring",
        back="Reiki Cloak",
    }
    sets.defense.Evasion = {    
        ammo="Yamarang",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        right_ear="Infused Earring",
        left_ear="Eabani Earring",
        right_ring="Ilabrat Ring",
        left_ring="Vengeful Ring",
        back="Ogma's Cape",
    }
    sets.defense.HP = {
        ammo="Staunch Tathlum +1",
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
    sets.defense.Resist = set_combine(sets.defense.MDT, {
        main="Malignance Sword",
        sub="Chanter's Shield",
        ammo="Staunch Tathlum +1",
        head={ name="Founder's Corona", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Magic dmg. taken -5%',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands="Erilaz Gauntlets +2",
        legs="Rune. Trousers +3",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
    })
	sets.defense.MDT = {
    main="Aettir",
    sub="Refined Grip +1",
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Runeist Coat +3",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Engraved Belt",
    left_ear="Eabani Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Moonlight Ring",
    right_ring="Shadow Ring",
    back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
}

	sets.Kiting = {legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    }
    sets.defense.Parry = {
        --hands="Turms Mittens +1",
        legs="Eri. Leg Guards +1",
        --feet="Turms Leggings +1",
        back="Ogma's Cape",
    }

	--------------------------------------
	-- Engaged sets
	--------------------------------------

    sets.engaged = { }
    sets.engaged.DD = {     
        ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Anu Torque",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back="Tactical Mantle",
}
    sets.engaged.CRIT = set_combine(sets.engaged.DD, {       ammo="Yetshila +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Sherida Earring",
    right_ear="Brutal Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Hetairoi Ring",
    back="Tactical Mantle",
})
    sets.engaged.PDT = {  ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Ayanmo Corazza +2",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Anu Torque",
    waist="Ioskeha Belt +1",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Moonlight Ring",
    back="Ogma's Cape",
}

    sets.engaged.repulse = {}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.Hybrid = {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Anu Torque",
        waist="Ioskeha Belt +1",
        left_ear="Telos Earring",
        right_ear="Sherida Earring",
        left_ring="Defending Ring",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
    }
    sets.MDT = {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
        left_ear="Telos Earring",
        right_ear="Sherida Earring",
        left_ring="Defending Ring",
        right_ring="Moonlight Ring",
        back={ name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},
    }
    sets.engaged.DT = set_combine(sets.engaged, sets.Hybrid)
    sets.engaged.MDT = set_combine(sets.engaged, sets.MDT)



    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}


end
sets.Obi = {waist="Hachirin-no-Obi"}

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
    if spell.name == 'Rayke' and not spell.interrupted then
        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
        send_command('wait '..rayke_duration..';input /echo [Rayke just wore off!];')
    elseif spell.name == 'Gambit' and not spell.interrupted then
        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
        send_command('wait '..gambit_duration..';input /echo [Gambit just wore off!];')
    end
end
function job_buff_change(buff,gain)
    if buff == "terror" then
        if gain then
            equip(sets.defense.PDT)
        end
    end
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
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
    if buff == 'Embolden' then
        if gain then
            equip(sets.Embolden)
            disable('head','legs','back')
        else
            enable('head','legs','back')
            status_change(player.status)
        end
    end
    
    if buff == 'Battuta' and not gain then
        status_change(player.status)
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_precast(spell, action, spellMap, eventArgs)

    if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
        add_to_chat(167, 'Action stopped due to status.')
        eventArgs.cancel = true
        return
    end
    if rune_enchantments:contains(spell.english) then
        eventArgs.handled = true
    end
    if spell.english == 'Lunge' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Swipe" <t>')
--            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
            eventArgs.cancel = true
            return
        end
    end
    if spell.english == 'Valiance' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Vallation" <me>')
            eventArgs.cancel = true
            return
        elseif spell.english == 'Valiance' and buffactive['vallation'] then
            cast_delay(0.2)
            send_command('cancel Vallation') -- command requires 'cancel' add-on to work
        end
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
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Knockback.value == true then
        idleSet = set_combine(idleSet, sets.defense.Knockback)
    end
    --if state.CP.current == 'on' then
    --    equip(sets.CP)
    --    disable('back')
    --else
    --    enable('back')
    --end
    if state.IdleMode.current == 'EnemyCritRate' then
        idleSet = set_combine(idleSet, sets.idle.EnemyCritRate )
    end
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
    if world.area:contains("Adoulin") then
       idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
        and state.DefenseMode.value == 'None' then
        if state.HybridMode.value == "DT" then
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)
        else
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
        end
    end
    if state.Knockback.value == true then
        meleeSet = set_combine(meleeSet, sets.defense.Knockback)
    end

    check_weaponset()

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Battuta'] then
        defenseSet = set_combine(defenseSet, sets.defense.Parry)
    end
    if state.Knockback.value == true then
        defenseSet = set_combine(defenseSet, sets.defense.Knockback)
    end

    return defenseSet
end
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_moving()
    check_gear()
end
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
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
    if no_swap_gear:contains(player.equipment.waist) then
        disable("waist")
    else
        enable("waist")
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
        if no_swap_gear:contains(player.equipment.waist) then
            enable("waist")
            equip(sets.idle)
        end
    end
)

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(3, 19)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 19)
	elseif player.sub_job == 'SAM' then
		set_macro_page(3, 19)
	else
		set_macro_page(3, 19)
	end
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end
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
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        equip(sets.DefaultShield)
    elseif player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 then
        equip(sets.DefaultShield)
    end
end
------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 165')
    end
end
function display_current_job_state(eventArgs)
    local r_msg = state.Runes.current
    local r_color = ''
    if state.Runes.current == 'Ignis' then r_color = 167
    elseif state.Runes.current == 'Gelus' then r_color = 210
    elseif state.Runes.current == 'Flabra' then r_color = 204
    elseif state.Runes.current == 'Tellus' then r_color = 050
    elseif state.Runes.current == 'Sulpor' then r_color = 215
    elseif state.Runes.current == 'Unda' then r_color = 207
    elseif state.Runes.current == 'Lux' then r_color = 001
    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    --local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Knockback.value == true then
        msg = msg .. ' Knockback Resist |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)
        ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'
      --  ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060)
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end
function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
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
------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)





