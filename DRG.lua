-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    include('Display.lua')
	-- Load and initialize the include file.
	include('Mote-Include.lua')
	include('organizer-lib')

    organizer_items = {
        "Regis",
        "Airmid's Gorget",
        "Prime Sword",
        "Sword Strap",
        "Mafic Cudgel",
        "Angon",
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
    
end


-- Setup vars that are user-independent.
function job_setup()


    include('Mote-TreasureHunter')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.BrachyuraEarring = M(true,false)
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    send_command('wait 2;input /lockstyleset 152')
    -- list of weaponskills that make better use of Gavialis helm
    wsList = S{'Stardiver'}
    swordList = S{"Naegling", "Sangarius +1", "Malevolence", "Demers. Degen +1", "Reikiko", "Perun +1", "Tanmogayi", "Loxotic Mace +1", "Ternion Dagger +1", "Zantetsuken"}
    shields = S{'Regis'}
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    wyv_breath_spells = S{'Dia', 'Poison', 'Blaze Spikes', 'Protect', 'Sprout Smack', 'Head Butt', 'Cocoon',
        'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    wyv_elem_breath = S{'Flame Breath', 'Frost Breath', 'Sand Breath', 'Hydro Breath', 'Gust Breath', 'Lightning Breath'}

	state.Buff = {}
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Trishula', 'Shining', 'Naegling', 'TernionDagger', 'Staff', 'Club'}
    state.shield = M{['description']='Weapon Set', 'Normal', 'shield'}
    get_combat_form()
    update_melee_groups()
end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
	state.OffenseMode:options('Normal', 'Acc', 'STP', 'CRIT', 'SubtleBlow')
	state.IdleMode:options('Normal','Regen', 'HP', 'PDT', 'MDT', 'Evasion', 'EnemyCritRate')
	state.HybridMode:options('Normal', 'DT', 'Reraise')
	state.WeaponskillMode:options('Normal', 'SC', 'PDL')
	state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise')
	state.MagicalDefenseMode:options('MDT')
    
    war_sj = player.sub_job == 'WAR' or false

    --send_command('bind != gs c toggle CapacityMode')
	send_command('bind ^= gs c cycle treasuremode')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind f7 gs c cycle shield')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind delete gs c toggle BrachyuraEarring')
    send_command('wait 6;input /lockstyleset 152')
	select_default_macro_book()

    state.Auto_Kite = M(false, 'Auto_Kite')
    state.Moving  = M(false, "moving")
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
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
        if init_job_states then init_job_states({"WeaponLock","Auto_Kite"},{"IdleMode","OffenseMode","HybridMode","WeaponskillMode","WeaponSet","PhysicalDefenseMode","TreasureMode"}) 
        end
end


-- Called when this job file is unloaded (eg: job change)
function file_unload()
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind ^=')
	send_command('unbind !=')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
--Weaponsets
sets.Normal = {}
sets.Trishula = {main="Trishula", sub="Utu Grip"}
sets.Shining = {main="Shining One", sub="Utu Grip"}
sets.Naegling = {main="Naegling", sub="Demers. Degen +1",}
sets.TernionDagger = {main="Ternion Dagger +1", sub="Demers. Degen +1",}
sets.Staff = {main="Malignance Pole", sub="Utu Grip",}
sets.Club = {main="Mafic Cudgel", sub="Demers. Degen +1",}

sets.Normal = {}
sets.shield = {sub="Regis"}

    -- Precast Sets
	-- Precast sets to enhance JAs
sets.precast.JA.Angon = {ammo="Angon",hands="Pteroslaver Finger Gauntlets +3"}
--sets.CapacityMantle = {back="Mecistopins Mantle"}
    --sets.Berserker = {neck="Berserker's Torque"}
sets.WSDayBonus = {head="Gavialis Helm"}

sets.precast.JA.Jump = {
        ammo="Ginsen",
		head="Flamma Zucchetto +2",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        hands="Flamma Manopolas +2",
        --hands="Vishap Finger Gauntlets +1",
        body="Pelt. Plackart +3",
        ring1="Niqmaddu Ring",
        ring2="Petrov Ring",
        waist="Ioskeha Belt",
        legs="Pteroslaver Brais +3",
    }

	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +1"}
    sets.TreasureHunter = {
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }

	sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {
        legs="Vishap Brais +1",
    }) 
	sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jump, {
		--body="Vishap Mail +2",
        --legs="Peltast's Cuissots +1"
    })
	sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jump, {
        --legs="Peltast's Cuissots +1",
        --feet="Lancer's Schynbalds +2"
    })
	sets.precast.JA['Super Jump'] = sets.precast.JA.Jump

	sets.precast.JA['Spirit Link'] = {
        --hands="Lancer's Vambraces +2", 
        --head="Vishap Armet +1"
    }
	sets.precast.JA['Call Wyvern'] = {body="Pelt. Plackart +3"}
	sets.precast.JA['Deep Breathing'] = {--head="Wyrm Armet +1" or Petroslaver Armet +1
    }
    sets.precast.JA['Spirit Surge'] = { --body="Wyrm Mail +2"
        body="Pelt. Plackart +3"
    }
	
	-- Healing Breath sets
	sets.HB = {
        ammo="Ginsen",
		--head="Pteroslaver Armet +3",
        neck="Adad Amulet",
        ear1="Sherida Earring",
        ear2="Cessance Earring",
        hands="Flamma Manopolas +2",
        --back="Updraft Mantle",
        --ring1="Dreki Ring",
        --waist="Glassblower's Belt",
        --legs="Vishap Brais +3",
        --feet="Pteroslaver Greaves"
    }

    sets.MadrigalBonus = {
        --hands="Composer's Mitts"
    }
	-- Waltz set (chr and vit)
	sets.precast.Waltz = {
    }
		
	-- Don't need any special gear for Healing Waltz.
	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body="Sacro Breastplate",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Orunmila's Torque",
        waist="Plat. Mog. Belt",
        left_ear="Loquac. Earring",
        right_ear="Mendi. Earring",
        left_ring="Prolix Ring",
        right_ring="Rahab Ring",
        back="Moonlight Cape",
    }
    
	-- Midcast Sets
	sets.midcast.FastRecast = {
    }	
		
	sets.midcast.Breath = set_combine(sets.midcast.FastRecast, {})
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    }
    sets.precast.WS.SC = set_combine(sets.precast.WS, {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
	sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    hands="Gleti's Gauntlets",
    body="Pelt. Plackart +3",
    right_ear="Pel. Earring +1",
    left_ring="Sroda Ring", 
    })
	sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Sroda Ring", 
        right_ring="Niqmaddu Ring",
        back="Bleating Mantle",
    })
	sets.precast.WS['Stardiver'].SC = set_combine(sets.precast.WS['Stardiver'], {    head="Nyame Helm",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    left_ring="Begrudging Ring",
    })
	sets.precast.WS['Stardiver'].PDL = set_combine(sets.precast.WS.PDL, {
        head="Nyame Helm",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        right_ear="Pel. Earring +1",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS["Camlann's Torment"] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        waist="Fotia Belt",
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    })
	sets.precast.WS["Camlann's Torment"].SC = set_combine(sets.precast.WS["Camlann's Torment"], {    head="Nyame Helm",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
	sets.precast.WS["Camlann's Torment"].PDL = set_combine(sets.precast.WS["Camlann's Torment"], {
        head="Nyame Helm",
        body="Pelt. Plackart +3",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Gleti's Breeches",
        left_ear="Thrud Earring",
        right_ear="Pel. Earring +1",
        left_ring="Sroda Ring", 
    })
	sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Thereoid Greaves",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Pel. Earring +1",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back="Brigantia's Mantle",
    })
	sets.precast.WS['Drakesbane'].SC = set_combine(sets.precast.WS['Drakesbane'], {    head="Nyame Helm",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
	sets.precast.WS['Drakesbane'].PDL = set_combine(sets.precast.WS['Drakesbane'], {
        ammo="Crepuscular Pebble",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        right_ear="Pel. Earring +1",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Sherida Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back="Brigantia's Mantle",
    })
    sets.precast.WS['Geirskogul'].SC = set_combine(sets.precast.WS['Geirskogul'], {    head="Nyame Helm",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
	sets.precast.WS['Geirskogul'].PDL = set_combine(sets.precast.WS['Geirskogul'], {
        ammo="Crepuscular Pebble",
        hands="Gleti's Gauntlets",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        right_ear="Pel. Earring +1",
        right_ring="Cornelia's Ring",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Pel. Earring +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    })
	sets.precast.WS['Impulse Drive'].SC = set_combine(sets.precast.WS['Impulse Drive'], {    head="Nyame Helm",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
	sets.precast.WS['Impulse Drive'].PDL = set_combine(sets.precast.WS['Impulse Drive'], {
        head="Gleti's Mask",
        hands="Gleti's Gauntlets",
        body="Pelt. Plackart +3",
        feet="Gleti's Boots",
    right_ear="Pel. Earring +1",
    left_ring="Sroda Ring", 
    })
    sets.precast.WS['Thunder Thrust'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Pel. Earring +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    })
    sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Pel. Earring +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    })
    sets.precast.WS['Raiden Thrust'].PDL = set_combine(sets.precast.WS, {
    })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    })
    sets.precast.WS['Aeolian Edge'].PDL = set_combine(sets.precast.WS, {
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Rep. Plat. Medal",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS, {
        hands="Gleti's Gauntlets",
        body="Pelt. Plackart +3",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        right_ear="Pel. Earring +1",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS['Cataclysm'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        left_ring="Archon Ring",
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    })

    sets.precast.WS['Cataclysm'].PDL = set_combine(sets.precast.WS, {})

    sets.precast.WS['Myrkr'] = {
        ammo="Pemphredo Tathlum",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        left_ring="Cornelia's Ring",
        right_ring="Freke Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Black Halo'] = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Brutal Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    }
    sets.precast.WS['Judgment'] = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        waist="Fotia Belt",
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Brigantia's Mantle",
    }
    sets.precast.WS['Judgment'].SC = set_combine(sets.precast.WS['Judgment'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Judgment'], {
        hands="Gleti's Gauntlets",
        body="Pelt. Plackart +3",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        right_ear="Pel. Earring +1",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS["Flash Nova"] = sets.precast.WS["Myrkr"]
    sets.precast.WS['Starburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Cataclysm']

    sets.precast.WS['Shattersoul'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Brutal Earring",
        right_ear="Ishvara Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
	
	-- Sets to return to when not performing an action.
	
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
        back="Moonlight Cape",
    }


    sets.Reraise = {
		head="Crepuscular Helm",
		body="Crepuscular Mail",
    }

	-- Defense sets
	sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Moonlight Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

	sets.defense.MDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Shadow Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",   }

    sets.defense.HP = {
        ammo="Staunch Tathlum +1",
        head="Crepuscular Helm",
        body="Hjarrandi Breast.",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        right_ear="Tuisto Earring",
        left__ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Moonlight Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape", 
    }
    sets.defense.Evasion = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        right_ear="Infused Earring",
        left_ear="Eabani Earring",
        right_ring="Defending Ring",
        left_ring="Vengeful Ring",
        back="Moonlight Cape",
    }

        sets.defense.Reraise = set_combine(sets.defense.PDT, {
            head="Crepuscular Helm",
            body="Crepuscular Mail",
        })

	-- Idle sets
	sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Gleti's Mask",
        body="Adamantite Armor",
        hands="Gleti's Gauntlets",
        legs="Nyame Flanchard",
        feet="Gleti's Boots",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Moonlight Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle.Town = {
        legs="Carmine Cuisses +1",
        right_ear="Infused Earring",
    }
    sets.idle.PDT = sets.defense.PDT
    sets.idle.MDT = sets.defense.MDT
    sets.idle.Evasion = sets.defense.Evasion
    sets.idle.HP = sets.defense.HP

    sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
        ammo="Eluder's Sachet",
        left_ring="Warden's Ring",
        right_ring="Fortified Ring",
        back="Reiki Cloak",
    })

    --sets.idle.Sphere = set_combine(sets.idle, {  })

    sets.idle.Regen = set_combine(sets.idle, {
        head="Crepuscular Helm",
        body="Sacro Breastplate",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        right_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })

	sets.idle.Weak = set_combine(sets.idle.Field, {
		head="Crepuscular Helm",
		body="Crepuscular Mail",
    })

    sets.Adoulin = {body="Councilor's Garb",}
    sets.Kiting = {legs="Carmine Cuisses +1",}
    sets.MoveSpeed = {legs="Carmine Cuisses +1",}
	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Pelt. Plackart +3",
        hands="Gleti's Gauntlets",
        legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
        feet="Flam. Gambieras +2",
        neck="Anu Torque",
        waist="Ioskeha Belt +1",
        left_ear="Sherida Earring",
        right_ear="Brutal Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Petrov Ring",
        back="Tactical Mantle",
    }

	sets.engaged.Acc = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Pelt. Plackart +3",
        hands="Flam. Manopolas +2",
        legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
        feet="Flam. Gambieras +2",
        neck="Anu Torque",
        waist="Ioskeha Belt +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })

    sets.engaged.STP = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Pelt. Plackart +3",
        hands="Gleti's Gauntlets",
        legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
        feet="Flam. Gambieras +2",
        neck="Anu Torque",
        waist="Ioskeha Belt +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })

    sets.engaged.CRIT = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Flam. Manopolas +2",
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet="Thereoid Greaves",
        neck={ name="Dgn. Collar +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Sherida Earring",
        right_ear="Brutal Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Hetairoi Ring",
        back="Annealed Mantle",    })

        sets.engaged.SubtleBlow = set_combine(sets.engaged, {        
            body="Dagon Breast.",
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            left_ear={ name="Schere Earring", augments={'Path: A',}},
            left_ring="Chirich Ring +1",
            right_ring="Niqmaddu Ring",
        })
---------------------------------------- DW-HASTE ------------------------------------------
sets.DW =  {
    left_ear="Suppanomimi",  --5
    right_ear="Eabani Earring",
}
sets.engaged.DW = set_combine(sets.engaged, sets.DW)

sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, sets.DW)
sets.engaged.DW.STP = set_combine(sets.engaged.STP, sets.DW)
sets.engaged.DW.DA = set_combine(sets.engaged.DA, sets.DW)
sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT, sets.DW)
sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.SubtleBlow, sets.DW)



------------------------------------------------------------------------------------------------
---------------------------------------- Hybrid Sets -------------------------------------------
------------------------------------------------------------------------------------------------
sets.engaged.Hybrid = {
    head="Hjarrandi Helm",
    hands="Gleti's Gauntlets",
    body="Gleti's Cuirass",
    waist="Tempus Fugit +1",
    left_ring="Moonlight Ring",
    right_ring="Defending Ring",
}

sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
--sets.engaged.DA.DT = set_combine(sets.engaged.DA, sets.engaged.Hybrid)
sets.engaged.CRIT.DT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)
sets.engaged.SubtleBlow.DT = set_combine(sets.engaged.SubtleBlow, sets.engaged.Hybrid)

sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)
--sets.engaged.DW.DA.DT = set_combine(sets.engaged.DW.DA, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)
sets.engaged.DW.SubtleBlow.DT = set_combine(sets.engaged.DW.SubtleBlow, sets.engaged.Hybrid)

    sets.engaged.PDT = set_combine(sets.engaged, {
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sulev. Gauntlets +2",
        left_ring="Moonlight Ring",
        waist="Tempus Fugit +1",
    })
	sets.engaged.STP.PDT = set_combine(sets.engaged.STP, {
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sulev. Gauntlets +2",
        left_ring="Moonlight Ring",
        right_ring="Defending Ring",
        waist="Tempus Fugit +1",

    })
	sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, {
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sulev. Gauntlets +2",
        left_ring="Moonlight Ring",
        right_ring="Defending Ring",
        waist="Tempus Fugit +1",

    })

    sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT, sets.engaged.PDT)
    sets.engaged.SubtleBlow.PDT = set_combine(sets.engaged.SubtleBlow, sets.engaged.PDT)

    sets.engaged.Reraise = set_combine(sets.engaged, {		
    head="Crepuscular Helm",
    body="Crepuscular Mail",})
    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

    sets.buff.Sleep = {neck="Vim Torque +1",left_ear="Infused Earring",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.english == "Spirit Jump" then
        if not pet.isvalid then
            cancel_spell()
            send_command('Jump')
        end
    elseif spell.english == "Soul Jump" then
        if not pet.isvalid then
            cancel_spell()
            send_command("High Jump")
        end
    end
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
end

-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_post_precast(spell, action, spellMap, eventArgs)
	--[[if player.hpp < 51 then
		classes.CustomClass = "Breath" 
	end]]
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Stardiver' and state.WeaponskillMode.current == 'Normal' then
            if world.day_element == 'Earth' or world.day_element == 'Light' or world.day_element == 'Dark' then
                equip(sets.WSDayBonus)
           end
        end
    end
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Ishvara Earring"})
		end
	end
end
    --[[if spell.type == 'WeaponSkill' then
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)

        end
    end]]



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
	    equip(sets.midcast.FastRecast)
	    if player.hpp < 51 then
		    classes.CustomClass = "Breath" 
	    end
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
end

function job_pet_precast(spell, action, spellMap, eventArgs)
end
-- Runs when a pet initiates an action.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Healing Breath') or spell.english == 'Restoring Breath' or spell.english == 'Steady Wing' or spell.english == 'Smiting Breath' then
		equip(sets.HB)
	end
end

-- Run after the default pet midcast() is done.
-- eventArgs is the same one used in job_pet_midcast, in case information needs to be persisted.
function job_pet_post_midcast(spell, action, spellMap, eventArgs)
	
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if state.HybridMode.value == 'Reraise' or
    (state.HybridMode.value == 'Physical' and state.PhysicalDefenseMode.value == 'Reraise') then
		equip(sets.Reraise)
	end
    check_weaponset()

end

-- Run after the default aftercast() is done.
-- eventArgs is the same one used in job_aftercast, in case information needs to be persisted.
function job_post_aftercast(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_pet_aftercast(spell, action, spellMap, eventArgs)

end

-- Run after the default pet aftercast() is done.
-- eventArgs is the same one used in job_pet_aftercast, in case information needs to be persisted.
function job_pet_post_aftercast(spell, action, spellMap, eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)

end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, action, spellMap)

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
    if update_job_states then update_job_states() 
    end
    check_weaponset()

end

windower.register_event('zone change',
    function()
        --add that at the end of zone change
        if update_job_states then update_job_states() end
    end
)

function check_weaponset()
    equip(sets[state.WeaponSet.current])
    equip(sets[state.shield.current])
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)   
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
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.Buff.Sleep and player.hp > 120 and player.status == "Engaged" then -- Equip Vim Torque When You Are Asleep
        meleeSet = set_combine(meleeSet,{neck="Vim Torque +1"})
    end
    check_weaponset()

	return meleeSet

end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when the player's pet's status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)

end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Dragon Breaker" then
        if gain then  			
            send_command('input /p "Dragon Breaker" [ON]')		
        else	
            send_command('input /p "Dragon Breaker" [OFF]')
        end
    end
    if buff == "Ancient Circle" then
        if gain then  			
            send_command('input /p "Ancient Circle" [ON]')		
        else	
            send_command('input /p "Ancient Circle" [OFF]')
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
    if S{'terror','petrification','sleep','stun'}:contains(name) then
        if gain then
            equip(sets.defense.PDT)
        elseif not gain then 
            handle_equipping_gear(player.status)
        end
    end
    if name == 'sleep' then
        if gain and player.hp > 120 and player.status == 'Engaged' then -- Equip Vim Torque When You Are Asleep   
            equip(sets.buff.Sleep)
            send_command('input /p ZZZzzz, please cure.')		
            disable('neck')
        else
            enable('neck')
            send_command('input /p '..player.name..' is no longer Sleep Thank you !')
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
    --[[if buff == "weakness" then
        if gain then
            equip(sets.Reraise)
             disable('body','head')
            else
             disable('body','head')
        end
        return
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
    if state.CombatForm.current ~= 'DW' and state.CombatForm.current ~= 'SW' then
        state.CombatForm:reset()
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
    if not midaction() then
        job_update()
    end
end
function check_buffs(check)
     
end
function job_update(cmdParams, eventArgs)
    --handle_equipping_gear(player.status)
	get_combat_form()
    update_melee_groups()
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if player.hpp < 5 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        equip(sets.Reraise)
        send_command('input //gs equip sets.Reraise')
        eventArgs.handled = true
    end
    return
end
function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end

    return idleSet
end
function get_combat_form()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and swordList:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    elseif player.equipment.sub == '' or player.equipment.sub == 'Regis' then
        state.CombatForm:set("SW")
    else
        state.CombatForm:reset()
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

function update_melee_groups()
    classes.CustomMeleeGroups:clear()

end
-- Job-specific toggles.
function job_toggle(field)

end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)

end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
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
        send_command('wait 6;input /lockstyleset 152')
    end
end
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then

        if not midaction() then
            job_update()
        end
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
    	set_macro_page(8, 38)
    elseif player.sub_job == 'WHM' then
    	set_macro_page(8, 38)
    else
    	set_macro_page(8, 38)
    end
end
