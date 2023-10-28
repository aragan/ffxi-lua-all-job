                        -- 

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

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    indi_timer = ''
    indi_duration = 180
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-ACC', 'Absorb-TP'}
    --state.CapacityMode = M(false, 'Capacity Point Mantle')
    send_command('wait 6;input /lockstyleset 178')

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.Buff.Poison = buffactive['Poison'] or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}

    state.OffenseMode:options('None', 'Normal', 'Melee', 'Shield')
    state.CastingMode:options('Normal', 'MB')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    gear.default.weaponskill_waist = "Windbuffet Belt +1"

    geo_sub_weapons = S{"", ""}

    select_default_macro_book()
    --send_command('bind != gs c toggle CapacityMode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('wait 2;input /lockstyleset 178')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind ^- gs enable all')
    send_command('bind ^/ gs disable all')
    send_command('bind f4 input //fillmode')
end

function file_unload()
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga', 
        'Stonera', 'Watera', 'Aerora', 'Fira', 'Blizzara', 'Thundara',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic"}
    sets.precast.JA['Life Cycle'] = {head="Azimuth Hood +1", body="Geomancy Tunic +1", back="Nantosuelta's Cape"}
    sets.precast.JA['Full Circle'] = {hands="Bagua Mitaines"}
    sets.precast.JA['Radial Arcana'] = {legs="Bagua Pants +1"}
    sets.precast.JA['Sublimation'] = {
        waist="Embla Sash",
    }
    --sets.CapacityMantle  = { back="Mecistopins Mantle" }
    organizer_items = {
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
        "Prime Sword",
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

    -- Fast cast sets for spells

    sets.precast.FC = {
        main="Sucellus",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        ear1="Malignance Earring",
        ear2="Loquacious Earring",
        hands="Agwu's Gages",
        body="Shango Robe",
        ring1="Prolix Ring",
        ring2="Kishar Ring",
        back="Lifestream Cape",
        waist="Witful Belt",
        legs="Geomancy Pants +2",
        feet="Merlinic Crackows"
    }

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        --main="Tamaxchi",
        --sub="Genbu's Shield",
        --back="Pahtli Cape"
    })
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        head="Umuthi Hat",
        legs="Doyen Pants",
        neck="Nodens Gorget",
        waist="Siegel Sash",})
    sets.precast.JA['Concentric Pulse'] = sets.midcast.HightTierNuke

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        ring1="Mallquis Ring",
    })

    
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        waist="Grunfeld Rope",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Brutal Earring",
        left_ring="Rufescent Ring",
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }


    sets.precast.WS['Flash Nova'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    }

            sets.precast.WS['Myrkr'] = {
            ammo="Pemphredo Tathlum",
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Baetyl Pendant",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Friomisi Earring",
            left_ring="Cornelia's Ring",
            right_ring="Freke Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},}

        sets.precast.WS['Cataclysm'] = {
            ammo="Pemphredo Tathlum",
            head="Pixie Hairpin +1",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Sibyl Scarf",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Friomisi Earring",
            left_ring="Cornelia's Ring",
            right_ring="Archon Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
        }
        
     sets.precast.WS['Black Halo'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        waist="Grunfeld Rope",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Exudation'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Rep. Plat. Medal",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.precast.WS['Starburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Myrkr']

    sets.precast.WS['Shattersoul'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Brutal Earring",
        right_ear="Ishvara Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        left_ring="Rufescent Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.precast.WS['Starlight'] = sets.precast.WS
    sets.precast.WS['Moonlight'] = sets.precast.WS


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {

    }

     sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
         body="Apururu Unity shirt",
     })

    sets.midcast.Geomancy = {
        main="Solstice",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Azimuth Hood +1",
        body="Geo. Tunic +1",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +2",
        feet="Bagua Sandals +3",
        neck="Incanter's Torque",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Azimuth Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back="Lifestream Cape",
    }

    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        main="Solstice",
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Azimuth Hood +1",
        body="Geo. Tunic +1",
        hands="Geo. Mitaines +3",
        legs={ name="Bagua Pants +1", augments={'Enhances "Mending Halation" effect',}},
        feet="Azimuth Gaiters +1",
        neck="Incanter's Torque",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Azimuth Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back="Nantosuelta's Cape",
    })

    sets.midcast.Cure = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        sub="Sors Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Annoint. Kalasiris",
        hands="Inyan. Dastanas +2",
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Incanter's Torque",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Gifted Earring",
        right_ear="Mendi. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Naji's Loop",
        back="Solemnity Cape",
    }
    
    sets.midcast.Curaga = sets.midcast.Cure

    --sets.midcast.Protectra = sets.midcast['Enhancing Magic']
    --sets.midcast.Shellra = sets.midcast['Enhancing Magic']

    sets.midcast.HighTierNuke = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Bagua Sandals +3",
        neck="Sibyl Scarf",
		waist="Hachirin-no-Obi",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Freke Ring",
        back="Nantosuelta's Cape",
    }
    
    sets.midcast.HighTierNuke.MB = set_combine(sets.midcast.HighTierNuke, {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Twilight Cape",
    })
    --sets.midcast['Elemental Magic'].Mindmelter = set_combine(sets.midcast.HighTierNuke, {
    --    main="Mindmelter"
    --})
    sets.magic_burst = {       main="Bunzi's Rod",
    sub="Ammurapi Shield", 
		ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Twilight Cape",
    }


    sets.midcast.LowTierNuke = set_combine(sets.midcast.HighTierNuke, {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
        neck="Sibyl Scarf",
        waist="Eschan Stone",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Freke Ring",
		back="Twilight Cape",
    })
    
    sets.midcast.LowTierNuke.MB = set_combine(sets.midcast.LowTierNuke, {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Agwu's Robe",
        hands="Agwu's Gages",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Friomisi Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Twilight Cape",
    })

    sets.midcast.Macc = { 
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Ea Hat",
        body="Ea Houppelande",
        hands="Ea Cuffs",
        legs="Ea Slops",
        feet="Ea Pigaches",
        neck="Incanter's Torque",
        waist="Luminary Sash",
        left_ear="Crep. Earring",
        right_ear="Malignance Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
    })
    sets.midcast.Absorb = set_combine(sets.midcast.Macc, {
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Evanescence Ring",
        ring2="Kishar Ring",
        body="Geomancy tunic +1",
    })
    
    sets.midcast.Aspir = set_combine(sets.midcast.Macc, { 
        head="Pixie Hairpin +1",
        feet="Agwu's Pigaches",
        neck="Erra Pendant",
        waist="Fucho-no-Obi",
        ring1="Evanescence Ring",

    })
    sets.midcast.Drain = sets.midcast.Aspir
    sets.midcast.Stun = sets.midcast.Macc
    
    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast.Macc, {
        main="Daybreak",
        head="C. Palug Crown",
        body="Geo. Tunic +1",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +2",
        feet="Bagua Sandals +3",
        neck="Incanter's Torque",
        waist="Luminary Sash",
        left_ear="Crep. Earring",
        right_ear="Malignance Earring",
        left_ring="Kishar Ring",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })
    sets.midcast.ElementalEnfeeble = set_combine(sets.midcast.Macc, {
        main="Daybreak",
        waist="Luminary Sash",
        ring1="Kishar Ring",
    })

    sets.midcast['Enhancing Magic'] = {
    main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Telchine Gloves",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Gifted Earring",
    right_ring="Stikini Ring",
    left_ring="Stikini Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {        main="Daybreak",
        head="Befouled Crown",
        body="Shamash Robe",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		waist="Fucho-no-Obi",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
    }

    -- Idle sets
    sets.idle = {
        main="Daybreak",
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Geo. Mitaines +3",
        legs="Assid. Pants +1",
        feet="Geo. Sandals +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    }
    sets.idle.PDT = set_combine(sets.idle, {
        main="Daybreak",
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Geo. Mitaines +3",
        legs="Assid. Pants +1",
        feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
    })
        sets.idle.Refresh = set_combine(sets.idle, {
            main="Daybreak",
            sub="Genmei Shield",
            range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
            head="Befouled Crown",
            body="Shamash Robe",
            hands="Geo. Mitaines +3",
            legs="Assid. Pants +1",
            feet="Geo. Sandals +2",
            neck={ name="Loricate Torque +1", augments={'Path: A',}},
            waist="Carrier's Sash",
            left_ear="Etiolation Earring",
            right_ear="Infused Earring",
            left_ring="Stikini Ring +1",
            right_ring="Stikini Ring +1",
        })


    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {
    main="Solstice",
    sub="Genmei Shield",
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head="Azimuth Hood +1",
    body="Shamash Robe",
    hands="Geo. Mitaines +3",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet="Bagua Sandals +1",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Isa Belt",
    left_ear="Handler's Earring +1",
    right_ear="Handler's Earring",
    left_ring="Stikini Ring +1",
    right_ring="Defending Ring",
    back="Nantosuelta's Cape",
    })

    sets.idle.PDT.Pet = set_combine(sets.idle.Pet, {
    main="Solstice",
    sub="Genmei Shield",
    range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
    head="Azimuth Hood +1",
    body="Shamash Robe",
    hands="Geo. Mitaines +3",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet="Bagua Sandals +1",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Isa Belt",
    left_ear="Handler's Earring +1",
    right_ear="Handler's Earring",
    left_ring="Stikini Ring +1",
    right_ring="Defending Ring",
    back="Nantosuelta's Cape",
    })

    --sets.idle.Melee = set_combine(sets.idle, {})

    -- .Indi sets are for when an Indi-spell is active.
    --sets.idle.Indi = set_combine(sets.idle, {
    --    legs="Bagua Pants", 
    --    feet="Geomancy Sandals",
    --    back="Lifestream Cape",
    --    --feet="Azimuth Gaiters"
    --})
    --sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {
    --    legs="Bagua Pants", 
    --})
    --sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {
    --    legs="Bagua Pants", 
    --    feet="Azimuth Gaiters"
    --})
    --sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {
    --    legs="Bagua Pants", 
    --})

    sets.idle.Town = set_combine(sets.idle, {
        feet="Geo. Sandals +2",
    })

    sets.idle.Weak = sets.idle

    -- Defense sets

    sets.defense.PDT = {
        range="Dunna",
        sub="Genmei Shield",
        head="Nyame Helm",
        body="Shamash Robe",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    }

    sets.defense.MDT = {
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        sub="Genmei Shield",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Sanare Earring",
        right_ear="Eabani Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    }

    sets.Kiting = {feet="Geo. Sandals +2",}
    sets.Adoulin = {body="Councilor's Garb",}

	sets.latent_refresh = {waist="Fucho-no-Obi"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {    
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Battlecast Gaiters",
        neck="Lissome Necklace",
        waist="Olseni Belt",
        left_ear="Telos Earring",
        right_ear="Crep. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.Melee = set_combine(sets.engaged, {    ammo="Amar Cluster",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        waist="Grunfeld Rope",
        left_ear="Telos Earring",
        right_ear="Mache Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},    })
       
        sets.engaged.Shield = set_combine(sets.engaged, { 
            main="Maxentius",
            sub="Genmei Shield",
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Lissome Necklace",
        waist="Grunfeld Rope",
        left_ear="Telos Earring",
        right_ear="Mache Earring +1",
        left_ring="Defending Ring",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},    })
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
	refine_various_spells(spell, action, spellMap, eventArgs)
    --if state.Buff.Poison then
    --    classes.CustomClass = 'Mindmelter'
    --end
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_post_precast(spell, action, spellMap, eventArgs)
    -- Make sure abilities using head gear don't swap 
	if spell.type:lower() == 'weaponskill' then
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
--function job_status_change(newStatus, oldStatus, eventArgs)
--    if newStatus == 'Engaged' then
--        -- nothing yet
--        elseif newStatus == 'Idle' then
--            determine_idle_group()
--    end
--end

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
            return 'Absorb'
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
            if lowTierNukes:contains(spell.english) then
                return 'LowTierNuke'
            else
                return 'HighTierNuke'
            end
        elseif spell.type == 'Trust' then
            return 'Trust'

        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
    end
    --if state.CapacityMode.value then
        --idleSet = set_combine(idleSet, sets.CapacityMantle)
    --end
    --if state.OffenseMode.value == 'Melee' then
        --idleSet = set_combine(sets.idle, sets.idle.Melee)
    --end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    return meleeSet
end
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    
    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
add_to_chat(159,'Author Aragan GEO.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(5, 34)
end
--Refine Nuke Spells
function refine_various_spells(spell, action, spellMap, eventArgs)
	aspirs = S{'Aspir','Aspir II','Aspir III'}
	sleeps = S{'Sleep II','Sleep'}
	sleepgas = S{'Sleepga II','Sleepga'}
	nukes = S{'Fire', 'Blizzard', 'Aero', 'Stone', 'Thunder', 'Water',
	'Fire II', 'Blizzard II', 'Aero II', 'Stone II', 'Thunder II', 'Water II',
	'Fire III', 'Blizzard III', 'Aero III', 'Stone III', 'Thunder III', 'Water III',
	'Fire IV', 'Blizzard IV', 'Aero IV', 'Stone IV', 'Thunder IV', 'Water IV',
	'Fire V', 'Blizzard V', 'Aero V', 'Stone V', 'Thunder V', 'Water V',
	'Fire VI', 'Blizzard VI', 'Aero VI', 'Stone VI', 'Thunder VI', 'Water VI',
	'Firaga', 'Blizzaga', 'Aeroga', 'Stonega', 'Thundaga', 'Waterga',
	'Firaga II', 'Blizzaga II', 'Aeroga II', 'Stonega II', 'Thundaga II', 'Waterga II',
	'Firaga III', 'Blizzaga III', 'Aeroga III', 'Stonega III', 'Thundaga III', 'Waterga III',	
	'Firaja', 'Blizzaja', 'Aeroja', 'Stoneja', 'Thundaja', 'Waterja',
	}
	cures = S{'Cure IV','Cure V','Cure IV','Cure III','Curaga III','Curaga II', 'Curaga',}
	
	if spell.skill == 'Healing Magic' then
		if not cures:contains(spell.english) then
			return
		end
		
		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
		
		if spell_recasts[spell.recast_id] > 0 then
			if cures:contains(spell.english) then
				if spell.english == 'Cure' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Cure IV' then
					newSpell = 'Cure V'
				elseif spell.english == 'Cure V' then
					newSpell = 'Cure IV'
				elseif spell.english == 'Cure IV' then
					newSpell = 'Cure III'
				end
			end
		end
		
		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	elseif spell.skill == 'Dark Magic' then
		if not aspirs:contains(spell.english) then
			return
		end
		
		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'

		if spell_recasts[spell.recast_id] > 0 then
			if aspirs:contains(spell.english) then
				if spell.english == 'Aspir' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Aspir II' then
					newSpell = 'Aspir'
				elseif spell.english == 'Aspir III' then
					newSpell = 'Aspir II'
				end
			end
		end
		
		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	elseif spell.skill == 'Elemental Magic' then
		if not sleepgas:contains(spell.english) and not sleeps:contains(spell.english) and not nukes:contains(spell.english) then
			return
		end

		local newSpell = spell.english
		local spell_recasts = windower.ffxi.get_spell_recasts()
		local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'

		if spell_recasts[spell.recast_id] > 0 then
			if sleeps:contains(spell.english) then
				if spell.english == 'Sleep' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Sleep II' then
					newSpell = 'Sleep'
				end
			elseif sleepgas:contains(spell.english) then
				if spell.english == 'Sleepga' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
					return
				elseif spell.english == 'Sleepga II' then
					newSpell = 'Sleepga'
				end
			elseif nukes:contains(spell.english) then	
				if spell.english == 'Fire' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Fire VI' then
					newSpell = 'Fire V'
				elseif spell.english == 'Fire V' then
					newSpell = 'Fire IV'
				elseif spell.english == 'Fire IV' then
					newSpell = 'Fire III'	
				elseif spell.english == 'Fire II' then
					newSpell = 'Fire'
				elseif spell.english == 'Firaja' then
					newSpell = 'Firaga III'
				elseif spell.english == 'Firaga II' then
					newSpell = 'Firaga'
				end 
				if spell.english == 'Blizzard' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Blizzard VI' then
					newSpell = 'Blizzard V'
				elseif spell.english == 'Blizzard V' then
					newSpell = 'Blizzard IV'
				elseif spell.english == 'Blizzard IV' then
					newSpell = 'Blizzard III'	
				elseif spell.english == 'Blizzard II' then
					newSpell = 'Blizzard'
				elseif spell.english == 'Blizzaja' then
					newSpell = 'Blizzaga III'
				elseif spell.english == 'Blizzaga II' then
					newSpell = 'Blizzaga'	
				end 
				if spell.english == 'Aero' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Aero VI' then
					newSpell = 'Aero V'
				elseif spell.english == 'Aero V' then
					newSpell = 'Aero IV'
				elseif spell.english == 'Aero IV' then
					newSpell = 'Aero III'	
				elseif spell.english == 'Aero II' then
					newSpell = 'Aero'
				elseif spell.english == 'Aeroja' then
					newSpell = 'Aeroga III'
				elseif spell.english == 'Aeroga II' then
					newSpell = 'Aeroga'	
				end 
				if spell.english == 'Stone' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Stone VI' then
					newSpell = 'Stone V'
				elseif spell.english == 'Stone V' then
					newSpell = 'Stone IV'
				elseif spell.english == 'Stone IV' then
					newSpell = 'Stone III'	
				elseif spell.english == 'Stone II' then
					newSpell = 'Stone'
				elseif spell.english == 'Stoneja' then
					newSpell = 'Stonega III'
				elseif spell.english == 'Stonega II' then
					newSpell = 'Stonega'	
				end 
				if spell.english == 'Thunder' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Thunder VI' then
					newSpell = 'Thunder V'
				elseif spell.english == 'Thunder V' then
					newSpell = 'Thunder IV'
				elseif spell.english == 'Thunder IV' then
					newSpell = 'Thunder III'	
				elseif spell.english == 'Thunder II' then
					newSpell = 'Thunder'
				elseif spell.english == 'Thundaja' then
					newSpell = 'Thundaga III'
				elseif spell.english == 'Thundaga II' then
					newSpell = 'Thundaga'	
				end 
				if spell.english == 'Water' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Water VI' then
					newSpell = 'Water V'
				elseif spell.english == 'Water V' then
					newSpell = 'Water IV'
				elseif spell.english == 'Water IV' then
					newSpell = 'Water III'	
				elseif spell.english == 'Water II' then
					newSpell = 'Water'
				elseif spell.english == 'Waterja' then
					newSpell = 'Waterga III'
				elseif spell.english == 'Waterga II' then
					newSpell = 'Waterga'	
				end 
			end
		end

		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	end
end

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 178')
    end
end
