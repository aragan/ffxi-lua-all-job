-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

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
    state.BrachyuraEarring = M(true,false)

end
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
 
-- Setup vars that are user-dependent.  Setup which sets you want to contain which sets of gear. 
-- By default my sets are: Normal is bursting gear, Occult_Acumen is Conserve MP/MP return body, FreeNuke_Effect self explanatory.
-- If you're new to gearswap, the F9~12 keys and CTRL keys in combination is how you activate this stuff.

function user_setup()
    state.OffenseMode:options('None','Normal','TP', 'CRIT', 'Locked')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'OccultAcumen', 'FreeNuke', 'Proc')
    state.IdleMode:options('Normal', 'PDT', 'MDT', 'DT', 'HB', 'MB', 'Evasion', 'EnemyCritRate')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
	state.VorsealMode = M('Normal', 'Vorseal')
	state.Enfeebling = M('None', 'Effect')
	--Vorseal mode is handled simply when zoning into an escha zone--
    state.Moving  = M(false, "moving")
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.AutoEquipBurst = M(true)
    state.DeathMode = M(false, 'Death Mode')

    --state.RP = M(false, "Reinforcement Points Mode")
    send_command('wait 6;input /lockstyleset 174')
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}
    state.StaffMode = M{['description']='Staff Mode', 'normal','Mpaca', 'Marin', 'Drepanum', 'Maliya'} 

	Elemental_Aja = S{'Stoneja', 'Waterja', 'Aeroja', 'Firaja', 'Blizzaja', 'Thundaja', 'Comet'}
	Elemental_Debuffs = S {'Shock', 'Rasp', 'Choke', 'Frost', 'Burn', 'Drown'}
    element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}
	Absorb = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}
    degrade_array = {['Aspirs'] = {'Aspir','Aspir II','Aspir III'}}
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
    send_command('bind f3 input //Sublimator')
	--send_command('bind f10 gs c cycle IdleMode')
	send_command('bind f11 gs c cycle CastingMode')
	send_command('bind ^f11 gs c cycle Enfeebling')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind @q gs c toggle AutoEquipBurst')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^/ gs disable all')
    send_command('bind ^; gs enable all')
    --send_command('bind !- gs c toggle RP')  
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind f7 gs c cycle StaffMode')
    send_command('bind delete gs c toggle BrachyuraEarring')
    send_command('bind f4 gs c toggle DeathMode')

    select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
	--send_command('unbind f10')
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
	
    sets.precast.JA['Mana Wall'] = {back="Taranus's cape",feet="Wicce Sabots +2"}
 
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
    head={ name="Merlinic Hood", augments={'Mag. Acc.+9','"Fast Cast"+6','INT+1',}},
    body="Agwu's Robe",
    hands={ name="Agwu's Gages", augments={'Path: A',}},
    legs="Agwu's Slops",
    feet={ name="Regal Pumps +1", augments={'Path: A',}},
    left_ear="Malignance Earring",
    right_ear="Loquac. Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
	}
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    sets.precast.Storm = set_combine(sets.precast.FC, {ring2="Stikini Ring +1"})
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak", waist="Shinjutsu-no-Obi +1"})
    sets.precast.FC.Impact.DeathMode = set_combine(sets.precast.FC.DeathMode, {head=empty, body="Twilight Cloak", waist="Shinjutsu-no-Obi +1"})

	sets.precast.FC.HighMP = set_combine(sets.precast.FC, {})
	sets.precast.FC.DeathMode = {
        ammo="Sapience Orb",
        head={ name="Merlinic Hood", augments={'Mag. Acc.+9','"Fast Cast"+6','INT+1',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet={ name="Regal Pumps +1", augments={'Path: A',}},
        neck="Baetyl Pendant",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Loquac. Earring",
        left_ring="Mephitas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
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
            hands="Regal Cuffs",
            legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
            feet="Nyame Sollerets",
            neck="Sanctity Necklace",
            waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Etiolation Earring",
            left_ring="Mephitas's Ring",
            right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
        }
        sets.precast.WS['Spinning Scythe'] = {
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

    sets.precast.WS['Starburst'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Vidohunir'] = sets.precast.WS['Cataclysm']
    sets.precast.WS['Dark Harvest'] = sets.precast.WS['Cataclysm']

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

    sets.precast.WS['Vorpal Scythe'] = set_combine(sets.precast.WS['Spinning Scythe'], {
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        neck="Nefarious Collar +1",
        left_ring="Hetairoi Ring",
        })
    
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
        main="Oranyan",
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        waist="Embla Sash",
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
		feet="Wicce Sabots +2",
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
        neck="Nodens Gorget",
		})
 
    sets.midcast['Enfeebling Magic'] = {
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Cohort Cloak +1",
        hands="Regal Cuffs",
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet="Jhakri Pigaches +2",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist="Rumination Sash",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Kishar Ring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }   

    sets.midcast['Enfeebling Magic'].Effect = set_combine(sets.midcast['Enfeebling Magic'],{
        main="Contemplator +1",
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Cohort Cloak +1",
        hands="Regal Cuffs",
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet="Jhakri Pigaches +2",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist="Rumination Sash",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Kishar Ring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })
	
	sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'],{
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Cohort Cloak +1",
        hands="Amalric Gages +1",
        legs="Arch. Tonban +3",
        feet="Arch. Sabots +3",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Kishar Ring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })
 
    sets.midcast['Dark Magic'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
        body="Shango Robe",
        hands="Amalric Gages +1",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
        neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
	}
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        head={ name="Agwu's Cap", augments={'Path: A',}},
        body={ name="Agwu's Robe", augments={'Path: A',}},
        hands={ name="Agwu's Gages", augments={'Path: A',}},
        legs={ name="Agwu's Slops", augments={'Path: A',}},
        feet={ name="Agwu's Pigaches", augments={'Path: A',}},
        neck="Erra Pendant",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
    -- Elemental Magic sets
     
    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
	}
    sets.magic_burst = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
    }


    sets.midcast['Elemental Magic'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Wicce Coat +3",
    hands="Amalric Gages +1",
    legs="Wicce Chausses +3",
    feet="Jhakri Pigaches +2",
    neck={ name="Src. Stole +2", augments={'Path: A',}},
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Freke Ring",
    back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].OccultAcumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Mujin Band",
        back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {
        ammo="Pemphredo Tathlum",
        head="Agwu's Cap",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Agwu's Pigaches",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
    })
	
    sets.midcast['Elemental Magic'].HighTierNuke.FreeNuke = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Wicce Coat +3",
    hands="Amalric Gages +1",
    legs="Wicce Chausses +3",
    feet="Jhakri Pigaches +2",
    neck={ name="Src. Stole +2", augments={'Path: A',}},
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Freke Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Taranus's Cape",
    })
		
    sets.midcast['Elemental Magic'].HighTierNuke.OccultAcumen = set_combine(sets.midcast['Elemental Magic'].HighTierNuke, {
        ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Jhakri Pigaches +2",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Taranus's Cape",
    })

    sets.midcast['Elemental Magic'].Proc = set_combine(sets.midcast['Elemental Magic'], {
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
 
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		head=empty,
        body="Twilight Cloak",
        hands="Amalric Gages +1",
        legs="Arch. Tonban +3",
        feet="Arch. Sabots +3",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring2="Kishar Ring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Taranus's Cape"})
	
	sets.midcast['Comet'] = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    })
    sets.midcast['Comet'].magic_burst = set_combine(sets.midcast['Elemental Magic'], {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    })
	sets.midcast['Comet'].FreeNuke = set_combine(sets.midcast['Elemental Magic'], {
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Jhakri Robe +2",
    hands="Amalric Gages +1",
    legs="Jhakri Slops +2",
    feet="Jhakri Pigaches +2",
    neck={ name="Src. Stole +2", augments={'Path: A',}},
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Freke Ring",
    back="Taranus's Cape",
    })
	-- Midcast set for Death, Might as well only have one set, unless you plan on free-nuking death for some unexplainable reason.

    sets.midcast['Death'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Barkaro. Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    }
    sets.midcast['Death'].magic_burst = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Pixie Hairpin +1",
        body="Wicce Coat +3",
        hands="Amalric Gages +1",
        legs="Wicce Chausses +3",
        feet="Ea Pigaches +1",
        neck={ name="Src. Stole +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Barkaro. Earring",
		left_ring="Archon Ring",
		right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
    }
	sets.midcast.Klimaform = {
		ammo="Pemphredo Tathlum",
        body="Shango Robe",
        hands="Amalric Gages +1",
        legs="Agwu's Slops",
        feet="Agwu's Pigaches",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet="Medium's Sabots",
        neck="Erra Pendant",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		right_ear="Digni. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}}
	
	sets.midcast.Flash = {}
	
-- These next two sets are used later in the functions to determine what gear will be used in High MP and Low MP situations
-- SPECIFICALLY for Aspir spells.  In the LowMP set, put your best Aspir+ gear, in the other set put your best Max MP gear.
-- Find out how much your maximum MP is in each set, and adjust the MP values in the function area accordingly
-- (CTRL+F: Aspir Handling)
sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
    head="Pixie Hairpin +1",
    feet={ name="Agwu's Pigaches", augments={'Path: A',}},
    neck="Erra Pendant",
    ring1="Evanescence Ring",
    ring2="Archon Ring",
    waist="Fucho-no-obi",
    })

sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.HighMP = {}
	sets.midcast.LowMP = {}
    --Set to be equipped when Day/Weather match current spell element

	sets.Obi = {waist="Hachirin-no-Obi",}
	
	-- I actually have two references to equip this item, just in case your globals are out of date.
 
    -- Resting sets
	
    sets.resting = {      
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
        feet="Nyame Sollerets",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Etiolation Earring",
        right_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
		back="Taranus's Cape",
	}
    --sets.idle.Field = sets.idle
    sets.idle.ManaWall = {
        feet="Wicce Sabots +2",
		back="Taranus's Cape",
    }
    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Shamash Robe",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Eabani Earring",
    right_ear="Ethereal Earring",
    right_ring="Stikini Ring +1",
    right_ring="Shadow Ring",
    back="Moonlight Cape",
	}
    sets.idle.MDT = {
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

    sets.idle.MB = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Wicce Chausses +3",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sanctity Necklace",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Evans Earring",
        left_ring="Mephitas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.idle.DeathMode = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Wicce Chausses +3",
        feet="Wicce Sabots +2",
        neck="Sanctity Necklace",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Evans Earring",
        left_ring="Mephitas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
		back="Taranus's Cape",
        }
    sets.idle.HB = {
        main="Malignance Pole",
        sub="Alber Strap",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.idle.DT = {
        sub="Alber Strap",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Shamash Robe",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear="Ethereal Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    }
    sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
        ammo="Eluder's Sachet",
        left_ring="Warden's Ring",
        right_ring="Fortified Ring",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        back="Reiki Cloak",
    })

    sets.idle.Evasion = set_combine(sets.idle.PDT, { 
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Eabani Earring",
        right_ear="Ethereal Earring",
        left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
        right_ring="Vengeful Ring",
        back="Moonlight Cape",
    })

    sets.idle.Town = {
        feet="Herald's Gaiters",
        left_ear="Infused Earring",
        right_ring="Stikini Ring +1",}

    sets.Adoulin = {body="Councilor's Garb", feet="Herald's Gaiters"}
    sets.MoveSpeed = {feet="Herald's Gaiters"}
    sets.TreasureHunter = {ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt"} 
    -- Set for Conserve MP toggle, convert damage to MP body.
	
    --sets.AFBody = {body="Spaekona's Coat +2", right_ear="Regal Earring"}
 
    --- PDT set is designed to be used for MP total set, MDT can be used for whatever you like but in MDT mode
	--- the player.mp arguments will likely stop working properly
	
    sets.defense.PDT = {
        main="Malignance Pole",
        sub="Alber Strap",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Adamantite Armor",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Ethereal Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
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
        ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Wicce Sabots +2",
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
        feet="Nyame Sollerets",
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
        neck="Combatant's Torque",
        waist="Cornelia's Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.CRIT = set_combine(sets.engaged.TP, {
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        neck="Nefarious Collar +1",
        left_ring="Hetairoi Ring",
    })
    sets.engaged.TH = {
        ammo="Per. Lucky Egg",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
        waist="Cornelia's Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
}


sets.buff.Doom = {    neck="Nicander's Necklace",
waist="Gishdubar Sash",
left_ring="Purity Ring",
right_ring="Blenmot's Ring +1",}

    --sets.RP = {neck="Src. Stole +2"}

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
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_precast(spell, action, spellMap, eventArgs)
    local spell_recasts = windower.ffxi.get_spell_recasts()
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        equip(sets.precast.FC.DeathMode)
        if spell.english == "Impact" then
            equip(sets.precast.FC.Impact.DeathMode)
        end
    end
    if spell.english == "Impact" then
        equip(sets.precast.FC.Impact)
    end
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
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
    if spell.skill == 'Dark Magic' then
        if Absorb:contains(spell.english) then	
            equip(sets.midcast.Absorb)
        end
    end

end


-- Aspir Handling
 
-- This section is for you to define at what value your Aspir sets will change. This is to let your aspirs
-- get you into your death idle and higher MP values. This number should be around 100 MP lower than the
-- Fast cast argument above this to prevent looping. The intent is to ensure that if you use aspir while you
-- are already above a value defined in this section then it will put on your highest MP set, capping you off
-- rather than simply capping you to whatever your Aspir potency set's max MP value happens to be.

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and (state.MagicBurst.value or AEBurst) then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        elseif spell.english == "Death" then
            equip(sets.midcast['Death'])
        end
    end
	if (spell.skill == 'Elemental Magic' or spell.skill == 'Healing Magic') and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
	end
    if spell.skill == 'Dark Magic' then
        if Absorb:contains(spell.english) then	
            equip(sets.midcast.Absorb)
        end
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
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
	
	if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
	end
end
 
-- Duration arguments
-- Below you can include wait inputs for all spells that you are interested in having timers for
-- For the sake of brevity, I've only included crowd control spells into this list, but following
-- the same general format you should be able to intuitively include whatever you like.
 
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if buffactive['Mana Wall'] then
        enable('back')
        equip(sets.buff['Mana Wall'])
        disable('back')
    end
    if spell.action_type == 'Magic' then
        if Elemental_Aja:contains(spell.english) then	
            send_command('timers create "'.. spell.english .. '" 105 down spells/01015.png')
            send_command("@wait 105;input /echo <----- All Cumulative Magic Duration Effects Have Expired ----->")
        end
    end
    if not spell.interrupted then
        if spell.english == "Sleep" then
            send_command('timers create "Sleep ' ..tostring(spell.target.name).. ' " 60 down spells/00235.png')
        elseif spell.english == "Sleepga" then
            send_command('timers create "Sleepga ' ..tostring(spell.target.name).. ' " 60 down spells/00273.png')
        elseif spell.english == "Sleep II" then
            send_command('timers create "Sleep II ' ..tostring(spell.target.name).. ' " 90 down spells/00259.png')
        elseif spell.english == "Sleepga II" then
            send_command('timers create "Sleepga II ' ..tostring(spell.target.name).. ' " 90 down spells/00274.png')
        elseif spell.english == 'Impact' then
                send_command('timers create "Impact ' ..tostring(spell.target.name).. ' " 180 down spells/00502.png')
        elseif Elemental_Debuffs:contains(spell.english) then
            if spell.english == 'Burn' then
                send_command('timers create "Burn ' ..tostring(spell.target.name).. ' " 180 down spells/00235.png')
            elseif spell.english == 'Choke' then
                send_command('timers create "Choke ' ..tostring(spell.target.name).. ' " 180 down spells/00237.png')
            elseif spell.english == 'Shock' then
                send_command('timers create "Shock ' ..tostring(spell.target.name).. ' " 180 down spells/00239.png')
            elseif spell.english == 'Frost' then
                send_command('timers create "Frost ' ..tostring(spell.target.name).. ' " 180 down spells/00236.png')
            elseif spell.english == 'Drown' then
                send_command('timers create "Drown ' ..tostring(spell.target.name).. ' " 180 down spells/00240.png')
            elseif spell.english == 'Rasp' then
                send_command('timers create "Rasp ' ..tostring(spell.target.name).. ' " 180 down spells/00238.png')
            end
        elseif spell.english == "Bind" then
            send_command('timers create "Bind" 60 down spells/00258.png')
        elseif spell.english == "Break" then
            send_command('timers create "Break Petrification" 33 down spells/00255.png')
        elseif spell.english == "Breakga" then
            send_command('timers create "Breakga Petrification" 33 down spells/00365.png') 
        end
    end
end


function job_handle_equipping_gear(playerStatus, eventArgs)
    if state.StaffMode.value == "Marin" then
        equip({main="Marin Staff +1",sub="Enki Strap"})
    elseif state.StaffMode.value == "Mpaca" then
        equip({main="Mpaca's Staff",sub="Enki Strap"})
    elseif state.StaffMode.value == "Drepanum" then
        equip({main="Drepanum",sub="Alber Strap"})
    elseif state.StaffMode.value == "Maliya" then
        equip({main="Maliya Sickle +1",sub="Alber Strap"})
    elseif state.StaffMode.value == "normal" then
        equip({})
    end
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
    gearinfo(cmdParams, eventArgs)
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

function gearinfo(cmdParams, eventArgs)

end
 
function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
 
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
    if state.HippoMode.value == "Hippo" then
        moving = false
	elseif buffactive['Mana Wall'] then
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
    if buff == "Sleep" then
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
    if buff == "curse" then
        if gain then  
        send_command('input /item "Holy Water" <me>')
        end
    end
    if not midaction() then
        job_update()
    end
end
 
-- Handle notifications of general user state change.
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
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function job_update(cmdParams, eventArgs)

end
 
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

    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end
    if state.AutoEquipBurst.value then
        msg = msg ..'Auto Equip Magic Burst Set: On'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-- Auto toggle Magic burst set.
MB_Window = 0
time_start = 0
AEBurst = false

if player and player.index and windower.ffxi.get_mob_by_index(player.index) then

    windower.raw_register_event('action', function(act)
        for _, target in pairs(act.targets) do
            local battle_target = windower.ffxi.get_mob_by_target("t")
            if battle_target ~= nil and target.id == battle_target.id then
                for _, action in pairs(target.actions) do
                    if action.add_effect_message > 287 and action.add_effect_message < 302 then
                        --last_skillchain = skillchains[action.add_effect_message]
                        MB_Window = 11
                        MB_Time = os.time()
                    end
                end
            end
        end
    end)

    windower.raw_register_event('prerender', function()
        --Items we want to check every second
        if os.time() > time_start then
            time_start = os.time()
            if MB_Window > 0 then
                MB_Window = 11 - (os.time() - MB_Time)
                if state.AutoEquipBurst.value then
                    AEBurst = true
                end
            else
                AEBurst = false
            end
        end
    end)
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
        idleSet = set_combine(idleSet, sets.precast.JA['Mana Wall'])
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.DeathMode.value then
        idleSet = sets.idle.DeathMode
    end
    --[[if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end]]
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
    end
    return idleSet
end
--- This is where I handle Death Mode Melee set modifications
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.buff['Mana Wall'])
    end
    --[[if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end]]
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
