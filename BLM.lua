



---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

	
-- This file should be treated as a work in progress, check back to The Black Sacrament Guide or Github for updates


	
	
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
 
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
     
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
    include('Mote-TreasureHunter')
 
end

 
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    send_command('wait 2;input /lockstyleset 174')
end
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Setup which sets you want to contain which sets of gear. 
-- By default my sets are: Normal is bursting gear, Occult_Acumen is Conserve MP/MP return body, FreeNuke_Effect self explanatory.
-- If you're new to gearswap, the F9~12 keys and CTRL keys in combination is how you activate this stuff.

function job_setup()
    state.OffenseMode:options('None', 'Locked')
    state.CastingMode:options('Normal', 'OccultAcumen', 'FreeNuke', 'Proc')
    state.IdleMode:options('Normal', 'PDT')
	state.VorsealMode = M('Normal', 'Vorseal')
	state.ManawallMode = M('Swaps', 'No_Swaps')
	state.Enfeebling = M('None', 'Effect')
	--Vorseal mode is handled simply when zoning into an escha zone--
    state.Moving  = M(false, "moving")
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    send_command('wait 6;input /lockstyleset 174')


    element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}

 
    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}
 
    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V','Fire VI'},
        ['Firega'] = {'Firaga','Firaga II','Firaga III','Firaja'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V','Blizzard VI'},
        ['Icega'] = {'Blizzaga','Blizzaga II','Blizzaga III','Blizzaja'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V','Aero VI'},
        ['Windga'] = {'Aeroga','Aeroga II','Aeroga III','Aeroja'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V','Stone VI'},
        ['Earthga'] = {'Stonega','Stonega II','Stonega III','Stoneja'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V','Thunder VI'},
        ['Lightningga'] = {'Thundaga','Thundaga II','Thundaga III','Thundaja'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V','Water VI'},
        ['Waterga'] = {'Waterga','Waterga II','Waterga III','Waterja'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        ['Sleepgas'] = {'Sleepga','Sleepga II'}
    }
	send_command('bind f10 gs c cycle IdleMode')
	send_command('bind f11 gs c cycle CastingMode')
	send_command('bind ^f11 gs c cycle Enfeebling')
	send_command('bind f12 gs c cycle ManawallMode')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^/ gs disable all')
    send_command('bind ^; gs enable all')

    select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
	send_command('unbind f10')
	send_command('unbind ^`f11')
	send_command('unbind @`f11')
	send_command('unbind ^f11')
end
organizer_items = {
    "Grape Daifuku",
    "Moogle Amp.",
    "Pear Crepe",
    "Prime Sword",
    "Marin Staff +1",
    "Drepanum",
    "Lentus Grip",
    "Mafic Cudgel",
    "Maliya Sickle +1",
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
 
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
     
    ---- Precast Sets ----
     
    -- Precast sets to enhance JAs
	
    sets.precast.JA['Mana Wall'] = {back="Taranus's cape",feet="Wicce Sabots +1"}
 
    sets.precast.JA.Manafont = {body={ name="Arch. Coat", augments={'Enhances "Manafont" effect',}},}
     
    -- Can put HP/MP set here for convert
	
    sets.precast.JA.Convert = {}
    sets.precast.JA['Sublimation'] = {
        waist="Embla Sash",
    }
 
    -- Base precast Fast Cast set, this set will have to show up many times in the function section of the lua
	-- So dont forget to do that.
 
    sets.precast.FC = {
	    ammo="Sapience Orb",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+9 "Mag.Atk.Bns."+9','Magic burst dmg.+11%','Mag. Acc.+9',}},
        body="Agwu's Robe",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'Magic burst dmg.+9%','Mag. Acc.+9',}},
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
	}
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})


	sets.precast['Impact'] = {
	    ammo="Sapience Orb",
    head={ name="Merlinic Hood", augments={'Mag. Acc.+9 "Mag.Atk.Bns."+9','Magic burst dmg.+11%','Mag. Acc.+9',}},
        body="Agwu's Robe",
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'Magic burst dmg.+9%','Mag. Acc.+9',}},
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
	}

		
	
	sets.precast.FC.HighMP = {
		ammo="Sapience Orb",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+9 "Mag.Atk.Bns."+9','Magic burst dmg.+11%','Mag. Acc.+9',}},
		body="Shango Robe",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Merlinic Crackows", augments={'Magic burst dmg.+9%','Mag. Acc.+9',}},
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
	}
		
		
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC['Enfeebling Magic'] = sets.precast.FC
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})
    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        left_ear="Mendi. Earring",
    })
 
    -- Midcast set for Death, Might as well only have one set, unless you plan on free-nuking death for some unexplainable reason.

    sets.midcast['Death'] = {
		main="Marin Staff +1",
		sub="Alber Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
		neck="Mizu. Kubikazari",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    }
    sets.midcast.Dispelga = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak", sub="Ammurapi Shield"})

    -- Sets for WS, Feel free to add one for Vidohunir if you have Laevateinn

   sets.precast.WS = {
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
        left_ring="Rufescent Ring",
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},}
        
        sets.precast.WS['Myrkr'] = {
            ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
            head="Pixie Hairpin +1",
            body={ name="Ros. Jaseran +1", augments={'Path: A',}},
            legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
            neck="Sanctity Necklace",
            waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
            left_ear="Etiolation Earring",
            right_ear="Evans Earring",
            left_ring="Mephitas's Ring",
            right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
        }
        sets.precast.WS['Spinning Scythe'] = {
            ammo="Oshasha's Treatise",
            head="Jhakri Coronal +2",
            body="Jhakri Robe +2",
            hands="Jhakri Cuffs +2",
            legs="Jhakri Slops +2",
            feet="Jhakri Pigaches +2",
            neck="Fotia Gorget",
            waist="Fotia Belt",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Ishvara Earring",
            left_ring="Rufescent Ring",
            right_ring="Cornelia's Ring",
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
            right_ear="Regal Earring",
            left_ring="Cornelia's Ring",
            right_ring="Archon Ring",
            back="Taranus's Cape",}
       
            sets.precast.WS['Infernal Scythe'] = {
            ammo="Pemphredo Tathlum",
            head="Pixie Hairpin +1",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Sibyl Scarf",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Regal Earring",
            left_ring="Cornelia's Ring",
            right_ring="Archon Ring",
            back="Taranus's Cape",}
        
            sets.precast.WS['Cross Reaper']	= {
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
                left_ring="Epaminondas's Ring",
                right_ring="Cornelia's Ring",
                back={ name="Aurist's Cape +1", augments={'Path: A',}},
            }
     sets.precast.WS['Black Halo'] = {
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
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.precast.WS['Starburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Vidohunir'] = sets.precast.WS['Cataclysm']

    sets.precast.WS['Shattersoul'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Malignance Earring",
        right_ear="Brutal Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    ---- Midcast Sets ----
    sets.midcast.FastRecast = {}
 
    sets.midcast['Healing Magic'] = {
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        hands="Inyan. Dastanas +2",
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Incanter's Torque",
        left_ear="Mendi. Earring",
        right_ear="Etiolation Earring",
        left_ring="Kishar Ring",
        right_ring="Naji's Loop",
    }

    sets.midcast['Enhancing Magic'] = {
		main="Gada",
		sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Mendi. Earring",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
	
	sets.midcast.Mana_Wall_No_Swap = {
		main="Malignance Pole",
		sub="Alber Strap",
		ammo="Amar Cluster",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Wicce Sabots +1",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Ethereal Earring",
		left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		right_ring="Shadow Ring",
		back="Taranus's Cape",
	}
	
	-- I personally do not have gear to alter these abilities as of the time of disseminating this file, but 
	-- definitely add them here if you have them.
 
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {feet="Inspirited Boots",waist="Gishdubar Sash"})
	
    sets.midcast.Haste = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {})
	
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",})
 
    sets.midcast['Enfeebling Magic'] = {
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
        body="Shango Robe",
        hands="Regal Cuffs",
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Digni. Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }   

    sets.midcast['Enfeebling Magic'].Effect = set_combine(sets.midcast['Enfeebling Magic'],{
        
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
        body="Shango Robe",
        hands="Regal Cuffs",
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Digni. Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })

	sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Enfeebling Magic'],{
        
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
        body="Shango Robe",
        hands="Regal Cuffs",
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Digni. Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })
	
	sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']
 
    sets.midcast['Dark Magic'] = {
		main="Marin Staff +1",
		sub="Alber Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
        body="Shango Robe",
        hands="Amalric Gages +1",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
		neck="Mizu. Kubikazari",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
	}
 
    -- Elemental Magic sets
     
    sets.midcast['Elemental Magic'] = {
        main="Marin Staff +1",
		sub="Alber Strap",
        ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
        neck="Mizu. Kubikazari",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
	}
    sets.magic_burst = {
		main="Marin Staff +1",
		sub="Alber Strap",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck="Mizu. Kubikazari",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Mujin Band",
        back="Taranus's Cape",
    }


    sets.midcast['Elemental Magic'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
	main="Marin Staff +1",
    sub="Alber Strap",
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Wicce Coat +3",
    hands="Amalric Gages +1",
    legs="Wicce Chausses +3",
    feet="Jhakri Pigaches +2",
    neck="Sibyl Scarf",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Freke Ring",
    back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].OccultAcumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
		main="Marin Staff +1",
		sub="Alber Strap",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck="Mizu. Kubikazari",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Mujin Band",
        back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {
		main="Marin Staff +1",
		sub="Alber Strap",
        ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
        neck="Sibyl Scarf",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
    })
	
    sets.midcast['Elemental Magic'].HighTierNuke.FreeNuke = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
	main="Marin Staff +1",
    sub="Alber Strap",
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Wicce Coat +3",
    hands="Amalric Gages +1",
    legs="Wicce Chausses +3",
    feet="Jhakri Pigaches +2",
    neck="Sibyl Scarf",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Freke Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].HighTierNuke.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
		main="Marin Staff +1",
		sub="Alber Strap",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck="Mizu. Kubikazari",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Mujin Band",
        back="Taranus's Cape",
    })

    sets.midcast['Elemental Magic'].Proc = set_combine(sets.midcast['Elemental Magic'], {
        main=empty,
        ammo=empty,
        head=empty,
        body=empty,
        hands=empty,
        legs=empty,
        feet=empty,
        neck=empty,
        waist=empty,
        left_ear=empty,
        right_ear=empty,
        left_ring=empty,
        right_ring=empty,
        back=empty,
    })

    sets.midcast['Elemental Magic'].HighTierNuke.Proc = set_combine(sets.midcast['Elemental Magic'], {
        main=empty,
        ammo=empty,
        head=empty,
        body=empty,
        hands=empty,
        legs=empty,
        feet=empty,
        neck=empty,
        waist=empty,
        left_ear=empty,
        right_ear=empty,
        left_ring=empty,
        right_ring=empty,
        back=empty,
    })
 
    sets.midcast['Impact'] = {
		head=empty,
        body="Twilight Cloak",
		hands="Amalric Gages +1",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','Magic burst dmg.+8%','Mag. Acc.+11',}},
		neck="Sanctity Necklace",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Dignitary's Earring",
        right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
	
	sets.midcast['Comet'] = set_combine(sets.midcast['Elemental Magic'], {
		main="Marin Staff +1",
		sub="Alber Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'"Mag.Atk.Bns."+8','Magic burst dmg.+8%','CHR+10','Mag. Acc.+4',}},
		hands={ name="Merlinic Dastanas", augments={'Pet: "Mag.Atk.Bns."+22','Blood Pact Dmg.+6','Pet: DEX+9',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+10 "Mag.Atk.Bns."+10','Magic burst dmg.+8%','"Mag.Atk.Bns."+4',}},
		feet={ name="Merlinic Crackows", augments={'Magic burst dmg.+9%','Mag. Acc.+9',}},
		neck="Mizu. Kubikazari",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    })
 
	sets.midcast['Comet'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
		main="Marin Staff +1",
    sub="Alber Strap",
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Jhakri Robe +2",
    hands="Amalric Gages +1",
    legs="Jhakri Slops +2",
    feet="Jhakri Pigaches +2",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Freke Ring",
    back="Taranus's Cape",
    })
	
	sets.midcast.Klimaform = {main="Grioavolr",
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		body="Vanya Robe",
		hands="Lurid Mitts",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Medium's Sabots", augments={'MP+50','MND+8','"Conserve MP"+6','"Cure" potency +3%',}},
		neck="Henic Torque",
		waist="Eschan Stone",
		left_ear="Barkaro. Earring",
		right_ear="Digni. Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}}
	
	sets.midcast.Flash = {
		ammo="Sapience Orb",
		head={ name="Kaabnax Hat", augments={'Phys. dmg. taken -2%','Magic dmg. taken -2%','Phys. dmg. taken -2%',}},
		body="Mallquis Saio +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Hagondes Pants +1", augments={'Phys. dmg. taken -4%',}},
		feet="Mallquis Clogs +2",
		neck="Unmoving Collar",
		waist="Goading Belt",
		left_ear="Regal Earring",
		right_ear="Merman's Earring",
		left_ring="Petrov Ring",
		right_ring="Begrudging Ring",
		back={ name="Taranus's Cape", augments={'Enmity+10',}},}
	
-- These next two sets are used later in the functions to determine what gear will be used in High MP and Low MP situations
-- SPECIFICALLY for Aspir spells.  In the LowMP set, put your best Aspir+ gear, in the other set put your best Max MP gear.
-- Find out how much your maximum MP is in each set, and adjust the MP values in the function area accordingly
-- (CTRL+F: Aspir Handling)

	sets.midcast.HighMP = {

    }
 
	sets.midcast.LowMP = {

    }
		
	
		
    --Set to be equipped when Day/Weather match current spell element

	sets.Obi = {waist="Hachirin-no-Obi",}
	
	-- I actually have two references to equip this item, just in case your globals are out of date.
 
    -- Resting sets
	
    sets.resting = {        main="Contemplator +1",
        head="Befouled Crown",
        body="Shamash Robe",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
    }
 
    -- Idle sets: Make general idle set a max MP set, later hooks will handle the rest of your refresh sets, but
	-- remember to alter the refresh sets (Ctrl+F to find them)

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        feet="Inyan. Crackows +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
		back="Taranus's Cape",
		}
        --sets.idle.Field = sets.idle

    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Shamash Robe",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Warder's Charm +1",
    waist="Carrier's Sash",
    left_ear="Eabani Earring",
    right_ear="Ethereal Earring",
    right_ring="Stikini Ring +1",
    right_ring="Shadow Ring",
    back="Moonlight Cape",
	}
    sets.idle.Town = {
        feet="Herald's Gaiters",left_ear="Infused Earring",
        right_ring="Stikini Ring +1",
}

    sets.Adoulin = {body="Councilor's Garb", feet="Herald's Gaiters"}

    sets.MoveSpeed = {feet="Herald's Gaiters"}
    
    sets.TreasureHunter = {ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt"} 
    -- Set for Conserve MP toggle, convert damage to MP body.
	
    sets.AFBody = {body="Spaekona's Coat +2", right_ear="Regal Earring"}
 
    --- PDT set is designed to be used for MP total set, MDT can be used for whatever you like but in MDT mode
	--- the player.mp arguments will likely stop working properly
	
    sets.defense.PDT = {
        main="Malignance Pole",
        sub="Alber Strap",
        ammo="Staunch Tathlum +1",
        body="Shamash Robe",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Warder's Charm +1",
        waist="Carrier's Sash",
        left_ear="Eabani Earring",
        right_ear="Ethereal Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Shadow Ring",
        back="Moonlight Cape",
    }
 
    sets.defense.MDT = {
		main="Malignance Pole",
    sub="Alber Strap",
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Warder's Charm +1",
    waist="Carrier's Sash",
    left_ear="Eabani Earring",
    right_ear="Ethereal Earring",
    left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    right_ring="Shadow Ring",
    back="Moonlight Cape",
	}
 
    sets.Kiting = {feet="Herald's Gaiters"}
	
	sets.latent_refresh = {waist="Fucho-no-Obi"}
	
	sets.auto_refresh = {
        body="Shamash Robe",
        legs="Assid. Pants +1",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    }
 
    -- Mana Wall idle set

    sets.buff['Mana Wall'] = {
		main="Malignance Pole",
		sub="Alber Strap",
		ammo="Amar Cluster",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Wicce Sabots +1",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Ethereal Earring",
		left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		right_ring="Shadow Ring",
		back="Taranus's Cape",
	}
	
	sets.midcast.Cure = {
	    ammo="Sapience Orb",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Annoint. Kalasiris",
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Incanter's Torque",
    waist="Austerity Belt +1",
    left_ear="Malignance Earring",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    }
	
	sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {waist="Gishdubar Sash"})
    
	-- Engaged sets
 
    -- Set is designed for engaging a monster before pop to ensure you are at maximum MP value when Geas Fete triggers an MP refill.
	-- This is mostly used in this lua in situations where a fight is about to be initiated and you arent above whatever the maximum
	-- value for your idle set is.  Another simple way around this is to simply make a macro to equip the gear before the fight starts.
	
    sets.engaged.None = {}
    sets.engaged = {
        ammo="Staunch Tathlum +1",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        feet="Inyan. Crackows +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
		back="Taranus's Cape",
    }

	sets.engaged.TP = {
        ammo="Amar Cluster",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Battlecast Gaiters",
        neck="Sanctity Necklace",
        waist="Cornelia's Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.TH = {
        ammo="Per. Lucky Egg",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        waist="Chaac Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.Locked = {
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        waist="Cornelia's Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
 
--- Define MP and buff specific Fast Cast and Midcast sets for conservation of MP for death sets, most will be
--- handled on thier own. What you need to change is the player.mp value to match slightly under what your max
--- MP is in your standard fast cast set. The set is designed to Dynamically switch fast cast sets to sets that
--- preserve your MP total if you are above the amount at which equiping your standard set would decrease your
--- maximum MP. Due to a rework in how these arguments are organised, all gearsets are being handled above the
--- function block for this file.
 
function job_precast(spell, action, spellMap, eventArgs)
    enable('feet','back')	
	if spell.english == "Impact" then
		sets.precast.FC = sets.precast['Impact']
    end
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_post_precast(spell, action, spellMap, eventArgs)
	if player.mp > 2000 and state.VorsealMode.value == 'Vorseal' then
	equip(sets.precast.FC.HighMP)
	elseif player.mp < 2000 and state.VorsealMode.value == 'Vorseal' then
	equip(sets.precast.FC)
	elseif player.mp > 1650 and state.VorsealMode.value == 'Normal' then
	equip(sets.precast.FC.HighMP)
	elseif player.mp < 1650 and state.VorsealMode.value == 'Normal' then
	equip(sets.precast.FC)
    end
end


 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

	
	if spell.english == 'Jettatura' or spell.english == 'Geist Wall' 
	or spell.english == 'Soporific' or spell.english == 'Blank Gaze' 
	or spell.english == 'Sheep Song' or spell.english == 'Chaotic Eye' 
	or spell.english == 'Cursed Sphere' or spell.english == 'Flash' then
	equip(sets.midcast.Flash)
	end
	
    if spell.english == 'Death' then
        equip(sets.midcast['Death'])
	end
	
	if spell.english == "Impact" then
        equip({head=empty,body="Twilight Cloak"})
    end
end


-- Aspir Handling
 
-- This section is for you to define at what value your Aspir sets will change. This is to let your aspirs
-- get you into your death idle and higher MP values. This number should be around 100 MP lower than the
-- Fast cast argument above this to prevent looping. The intent is to ensure that if you use aspir while you
-- are already above a value defined in this section then it will put on your highest MP set, capping you off
-- rather than simply capping you to whatever your Aspir potency set's max MP value happens to be.

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        end
    end
	if (spell.skill == 'Elemental Magic' or spell.skill == 'Healing Magic') and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
	end
	
	
	if spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Vorseal' and player.mp > 1765 then
		equip(sets.midcast.HighMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Vorseal' and player.mp < 1765 then
		equip(sets.midcast.LowMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Normal' and player.mp > 1580 then
		equip(sets.midcast.HighMP)
	elseif spell.english == 'Aspir' or spell.english == 'Aspir II' or spell.english == 'Aspir III' and state.VorsealMode.value == 'Normal' and player.mp < 1580 then
		equip(sets.midcast.LowMP)
	end
	
    if spell.element == world.day_element or spell.element == world.weather_element then
        if string.find(spell.english,'helix') then
            equip(sets.midcast.Helix)
        else 
            equip(sets.Obi)
        end
    end
	--[[if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and (player.mp-spell.mp_cost) < 436 then
		equip(sets.AFBody)
	end]]
		
	if spell.skill == 'Enfeebling Magic' and state.Enfeebling.Value == 'Effect' then
		equip(sets.midcast['Enfeebling Magic'].Effect)
	end
	
	--[[if spell.skill == 'Elemental Magic' and (string.find(spell.english,'ga') or string.find(spell.english,'ja') or string.find(spell.english,'ra')) then
            equip(sets.AFBody)
	end]]
	
	if spellMap == 'Cure' and state.ManawallMode.Value == 'No_Swaps' then
		equip(sets.midcast.Mana_Wall_No_Swap)
	elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
	end
	
	if spell.skill == 'Enhancing Magic' and state.ManawallMode.Value == 'No_Swaps' then
		equip(sets.midcast.Mana_Wall_No_Swap)
	end
end
 
-- Duration arguments
-- Below you can include wait inputs for all spells that you are interested in having timers for
-- For the sake of brevity, I've only included crowd control spells into this list, but following
-- the same general format you should be able to intuitively include whatever you like.
 
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if buffactive['Mana Wall'] then
        enable('feet','back')
        equip(sets.buff['Mana Wall'])
        disable('feet','back')
    end
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then -- Sleep II Countdown --
            send_command('wait 60;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('wait 30;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Break" or spell.english == "Breakga" then -- Break Countdown --
            send_command('wait 25;input /echo Break Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Paralyze" then -- Paralyze Countdown --
             send_command('wait 115;input /echo Paralyze Effect: [WEARING OFF IN 5 SEC.]')
        elseif spell.english == "Slow" then -- Slow Countdown --
            send_command('wait 115;input /echo Slow Effect: [WEARING OFF IN 5 SEC.]')        
        end
    end
	--if buffactive['poison'] then
	--send_command('input /item "antidote" <me>')
	--end
end
 
function nuke(spell, action, spellMap, eventArgs)
    if player.target.type == 'MONSTER' then
        if state.AOE.value then
            send_command('input /ma "'..degrade_array[element_table:append('ga')][#degrade_array[element_table:append('ga')]]..'" '..tostring(player.target.name))
        else
            send_command('input /ma "'..degrade_array[element_table][#degrade_array[element_table]]..'" '..tostring(player.target.name))
        end
    else 
        add_to_chat(5,'A Monster is not targetted.')
    end
end
 
function job_self_command(commandArgs, eventArgs)
    if commandArgs[1] == 'element' then
        if commandArgs[2] then
            if element_table:contains(commandArgs[2]) then
                element_table = commandArgs[2]
                add_to_chat(5, 'Current Nuke element ['..element_table..']')
            else
                add_to_chat(5,'Incorrect Element value')
                return
            end
        else
            add_to_chat(5,'No element specified')
        end
    elseif commandArgs[1] == 'nuke' then
        nuke()
    end
end
 
 
function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}
 
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
 
    local spell_index
 
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
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
 
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	--if buff == "poison" and gain then
	--send_command('input /item "antidote" <me>')
	--end
	if buff == "Vorseal" then
	send_command('gs c cycle VorsealMode')
	elseif buff == "Vorseal" and not gain then
	send_command('gs c cycle VorsealMode')
	end
	--[[if buff == "Visitant" then
	send_command('gs l blm3.lua')
	end]]
    -- Unlock feet when Mana Wall buff is lost.
	if buff == "Mana Wall" then
	send_command('wait 0.5;gs c update')
	end
    if buff == "Mana Wall" and not gain then
        enable('feet','back')
        handle_equipping_gear(player.status)
    end
    if buff == "Commitment" and not gain then
        equip({ring2="Capacity Ring"})
        if player.equipment.right_ring == "Capacity Ring" then
            disable("ring2")
        else
            enable("ring2")
        end
    end
	if buff == "Vorseal" and gain then
	send_command('input //setbgm 75')
	elseif buff == "Vorseal" and not gain then
	send_command('input //setbgm 251')
	end
end
 
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

 
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
--[[function job_update(cmdParams, eventArgs)
    job_display_current_state(eventArgs)
    eventArgs.handled = true
end]]
 
function display_current_job_state(eventArgs)
    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.DeathMode.value then
        msg = msg .. ' Death: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

 
-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
    end
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if buffactive['Mana Wall'] then
        idleSet = sets.buff['Mana Wall']
	elseif player.mpp < 51 and state.IdleMode.value == 'PDT' then
			idleSet = sets.idle.PDT
	elseif player.mpp < 51 and state.IdleMode.value == 'Normal' then
		idleSet = set_combine(sets.auto_refresh, sets.latent_refresh)		
	elseif player.mp < 1765 and state.VorsealMode.value == 'Vorseal' and state.IdleMode.value == 'PDT' then
			idleSet = sets.idle.PDT
	elseif player.mp < 1765 and state.VorsealMode.value == 'Vorseal' and state.IdleMode.value == 'Normal' then
			idleSet = sets.auto_refresh
	elseif player.mp < 1580 and state.VorsealMode.value == 'Normal' and state.IdleMode.value == 'PDT' then
			idleSet = sets.idle.PDT
	elseif player.mp < 1580 and state.VorsealMode.value == 'Normal' and state.IdleMode.value == 'Normal' then
			idleSet = sets.auto_refresh
	end
    return idleSet
end
--- This is where I handle Death Mode Melee set modifications
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.buff['Mana Wall'])
    end
    return meleeSet
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 174')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 9)

end

--{{Emulator Backend: log_filter=*:Info}}
