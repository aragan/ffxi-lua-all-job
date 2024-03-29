-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
-- Haste/DW Detection Requires Gearinfo Addon


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
end


organizer_items = {
	"Sacro Bulwark",
	"Prime Sword",
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
	include('Mote-TreasureHunter')
	state.Enfeeb = M('None', 'Macc', 'Potency', 'Skill')
    state.Moving = M(false, "moving")
    state.MagicBurst = M(false, 'Magic Burst')
	state.Buff.Composure = buffactive.Composure or false
    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Stymie = buffactive.Stymie or false
	state.AutoEquipBurst = M(true)
    send_command('wait 6;input /lockstyleset 152')
	state.WeaponLock = M(false, 'Weapon Lock')
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1", "Reraise Earring", "Reraise Gorget", "Airmid's Gorget",}
	absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II',  'Gravity', 'Gravity II', 'Silence'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Blind', 'Blind II'}
    enfeebling_magic_sleep = S{'Sleep', 'Sleep II', 'Sleepga'}
    enfeebling_magic = S{'Bind', 'Break', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II', 'Gravity', 'Gravity II', 'Silence','Sleep', 'Sleep II', 'Sleepga', 'Distract III', 'Frazzle III', 'Poison II'}
    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Acc', 'CRIT', 'Enspell')
	state.HybridMode:options('Normal', 'PDT')
	state.WeaponskillMode:options('Normal', 'PDL', 'SC')
    state.IdleMode:options('Normal', 'PDT', 'MDT', 'HP', 'Enmity')
	state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
	state.CastingMode:options('Normal', 'Burst', 'Duration', 'SIRD')

	state.WeaponSet = M{['description']='Weapon Set', 'normal', 'SWORDS', 'Crocea', 'DAGGERS', 'IDLE'}
	state.shield = M{['description']='Weapon Set', 'Normal', 'shield'}
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}
    state.EnSpell = M{['description']='EnSpell', 'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater'}
    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}
    state.GainSpell = M{['description']='GainSpell', 'Gain-STR', 'Gain-INT', 'Gain-AGI', 'Gain-VIT', 'Gain-DEX', 'Gain-MND', 'Gain-CHR'}
    state.SleepMode = M{['description']='Sleep Mode', 'Normal', 'MaxDuration'}
    state.EnspellMode = M(false, 'Enspell Melee Mode')
	state.NM = M(false, 'NM')

	select_default_macro_book()
	send_command('bind f10 gs c cycle IdleMode')
	send_command('bind f5 gs c cycle WeaponskillMode')
	send_command('bind f11 gs c cycle Enfeeb')
	send_command('bind f12 gs c cycle CastingMode')
	send_command('bind f6 gs c cycle WeaponSet')
	send_command('bind f7 gs c cycle shield')
	send_command('bind f1 gs c cycle HippoMode')
	send_command('bind !w gs c toggle WeaponLock')
    send_command('bind ^= gs c cycle treasuremode')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind @q gs c toggle AutoEquipBurst')
	send_command('bind !delete gs c cycle EnSpell')
    send_command('bind ^delete gs c cycle GainSpell')
    send_command('bind ^end gs c cycle BarElement')
    send_command('bind ^pagedown gs c cycle BarStatus')
    send_command('bind @a gs c toggle NM')

	send_command('wait 2;input /lockstyleset 152')
    state.Auto_Kite = M(false, 'Auto_Kite')

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
	DW_needed = 0
    DW = false

    update_combat_form()
end
 
-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind f12')
    send_command('unbind f11')
	send_command('unbind f10')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
	sets.DefaultShield = {sub="Sacro Bulwark"}

    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Vitivation Tabard +3"}
	sets.precast.JA['Sublimation'] = {
        waist="Embla Sash",
    }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {    legs="Dashing Subligar",
}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {    legs="Dashing Subligar",
}

    -- Fast cast sets for spells
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    
	sets.precast['Impact'] = {
		head=empty,
		body="Twilight Cloak",
		hands="Gendewitha Gages +1",
		ring1="Prolix Ring",
		ring2="Kishar Ring",
        back="Swith Cape +1",
		waist="Witful Belt",
		legs="Psycloth Lappas",
		feet="Carmine Greaves +1"}

	sets.SIRD = {
			ammo="Staunch Tathlum +1",
			body={ name="Ros. Jaseran +1", augments={'Path: A',}},
			hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
			legs="Bunzi's Pants",
			neck={ name="Loricate Torque +1", augments={'Path: A',}},
			waist="Rumination Sash",
			right_ring="Freke Ring",
	}
	sets.midcast.SIRD = {
		ammo="Staunch Tathlum +1",
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs="Bunzi's Pants",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Rumination Sash",
		right_ring="Freke Ring",
}
	sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+9','"Fast Cast"+6','INT+1',}},
		body="Shango Robe",
		hands="Leyline Gloves",
		legs="Psycloth Lappas",
		feet="Merlinic Crackows",
		waist="Witful Belt",
		neck="Baetyl Pendant",
		ear1="Loquacious Earring",
		ear2="Leth. Earring +1",
		ring1="Prolix Ring",
		ring2="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},	}
		
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {    neck="Magoraga Beads",
     })
    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {})
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		ammo="Aurgelmir Orb +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
	}
	sets.precast.WS.PDL = set_combine(sets.precast.WS, {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})
	sets.precast.WS.SC = set_combine(sets.precast.WS, {
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
	})
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = {
		ammo="Regal Gem",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Bunzi's Gloves",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Rufescent Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Sucellos's Cape",
    }
	sets.precast.WS['Requiescat'].PDL = set_combine(sets.precast.WS['Requiescat'], {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})

    sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Nyame Mail",
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Archon Ring",
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
    }

    sets.precast.WS['Savage Blade'] = {
		ammo="Aurgelmir Orb +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		right_ear="Sherida Earring",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
	}
	sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})
		
    	sets.precast.WS['Seraph Blade']	= {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
		}


	sets.precast.WS['Aeolian Edge']	= {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		right_ear="Regal Earring",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Freke Ring",
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
    }
		
	sets.precast.WS['Death Blossom'] = {
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back="Sucellos's Cape",
	}
	sets.precast.WS['Death Blossom'].PDL = set_combine(sets.precast.WS['Death Blossom'], {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})
	
	sets.precast.WS['Chant Du Cygne'] = {
		ammo="Yetshila +1",
		ammo="Staunch Tathlum +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Jhakri Robe +2",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		right_ear="Mache Earring +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
	}
	sets.precast.WS['Chant Du Cygne'].PDL = set_combine(sets.precast.WS['Chant Du Cygne'], {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})

	sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		ammo="Staunch Tathlum +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Jhakri Robe +2",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		right_ear="Mache Earring +1",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring="Cornelia's Ring",
		back="Sucellos's Cape",
	} 
	sets.precast.WS['Evisceration'].PDL = set_combine(sets.precast.WS['Evisceration'], {
		ammo="Crepuscular Pebble",
		hands="Malignance Gloves",
		left_ring="Sroda Ring", 
	})
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
		back="Sucellos's Cape",
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

	
 sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
})
sets.precast.WS['Black Halo'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
	ammo="Crepuscular Pebble",
	hands="Malignance Gloves",
	left_ring="Sroda Ring", 
})

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
sets.precast.WS['Shattersoul'].PDL = set_combine(sets.precast.WS['Shattersoul'], {
	ammo="Crepuscular Pebble",
	hands="Malignance Gloves",
	left_ring="Sroda Ring", 
})
	
sets.TreasureHunter = { 
	ammo="Per. Lucky Egg",
	head="White rarab cap +1", 
	waist="Chaac Belt",
 }
	
    -- Midcast Sets
    
    sets.midcast.FastRecast = {}
    sets.midcast.Dispelga =  {
		main="Daybreak",
	    sub="Ammurapi Shield",
		ammo=empty,
		range="Ullr",
        head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
		left_ear="Regal Earring",
        right_ear="Snotra Earring",
        left_ring="Stikini Ring +1",
        right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        waist="Acuity Belt +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
	sets.Duration={
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +3','Mag. Acc.+20','DMG:+6',}},
		sub="Ammurapi Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		right_ear="Leth. Earring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}

    sets.midcast.Cure = {
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Halasz Earring",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Solemnity Cape",
	}
	sets.midcast.Cure.SIRD = set_combine(sets.midcast.Cure, {
		ammo="Staunch Tathlum +1",
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs="Bunzi's Pants",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Rumination Sash",
		right_ring="Freke Ring",
	})
        
    sets.midcast.Curaga = sets.midcast.Cure
	sets.midcast.Curaga.SIRD = set_combine(sets.midcast.Cure, {
		ammo="Staunch Tathlum +1",
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs="Bunzi's Pants",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Rumination Sash",
		right_ring="Freke Ring",
	})
	
    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
		ammo="Staunch Tathlum +1",
		head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
		body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Halasz Earring",
		right_ear="Mendi. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Solemnity Cape",
	})
	sets.midcast.CureSelf.SIRD = set_combine(sets.midcast.Cure, {
		ammo="Staunch Tathlum +1",
		body={ name="Ros. Jaseran +1", augments={'Path: A',}},
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs="Bunzi's Pants",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Rumination Sash",
		right_ring="Freke Ring",
	})
	sets.midcast.Cursna = {
		legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		neck="Debilis Medallion",
		left_ring="Haoma's Ring",
		right_ring="Haoma's Ring",
	}
    sets.midcast['Enhancing Magic'] = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +3','Mag. Acc.+20','DMG:+6',}},
		sub="Ammurapi Shield",
		head="Befouled Crown",
		body="Telchine Chas.",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Telchine Pigaches",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Leth. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast['Enhancing Magic'].SelfDuration = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +3','Mag. Acc.+20','DMG:+6',}},
		sub="Ammurapi Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
        waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Leth. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast['Enhancing Magic'].Duration = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +3','Mag. Acc.+20','DMG:+6',}},
		sub="Ammurapi Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
        waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Leth. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast['Enhancing Magic'].Skill = {
		main={ name="Colada", augments={'Enh. Mag. eff. dur. +3','Mag. Acc.+20','DMG:+6',}},
		sub="Ammurapi Shield",
		head="Befouled Crown",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Leth. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	
	sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'].Skill, {})
	sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'].Duration, {})
	sets.midcast['Enhancing Magic'].GainSpell = set_combine(sets.midcast['Enhancing Magic'].SelfDuration, {hands="Vitiation gloves +3"})
		
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'].Duration, {})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		neck="Nodens Gorget",
    })
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'].Duration, {
		waist="Siegel Sash",
		neck="Nodens Gorget",
    })
	
	
	-- If you have them, add Shedir Seraweels, Regal Cuffs, Amalric Coif (+1), or Chironic Hat
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'].Duration, {
		head="Befouled Crown",
		hands="Regal Cuffs",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Leth. Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	})
	
    sets.midcast['Enfeebling Magic'] = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo=empty,
		range="Ullr",
        head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
		left_ear="Regal Earring",
        right_ear="Snotra Earring",
        left_ring="Stikini Ring +1",
        right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
	
	sets.midcast['Enfeebling Magic'].Macc = set_combine(sets.midcast['Enfeebling Magic'], {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo=empty,
		range="Ullr",
        head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Regal Earring",
        right_ear="Snotra Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},
	})
		
	sets.midcast['Enfeebling Magic'].Skill = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo=empty,
		range="Ullr",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
        left_ear="Regal Earring",
        right_ear="Snotra Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},
	}
	sets.midcast['Enfeebling Magic'].Potency = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +3",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Obstin. Sash",
        left_ear="Regal Earring",
        right_ear="Snotra Earring",
		left_ring="Stikini Ring",
        right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
    
	sets.Saboteur = set_combine(sets.midcast['Enfeebling Magic'].Potency, {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		--hands="Lethargy Gantherots +1"
	})

	sets.midcast['Enfeebling Magic'].ParalyzeDuration = set_combine(sets.midcast['Enfeebling Magic'].Potency,{})
	sets.Dia = set_combine(sets.midcast['Enfeebling Magic'].Potency,{
		--main="Daybreak",
        --sub="Ammurapi Shield",
		legs="Malignance Tights",
	})
    sets.midcast['Elemental Magic'] = {
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body="Lethargy Sayon +3",
        hands="Amalric Gages +1",
		legs="Jhakri Slops +2",
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back="Argocham. Mantle",}
		
		sets.midcast.nuking = {		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body="Lethargy Sayon +3",
        hands="Amalric Gages +1",
		legs="Jhakri Slops +2",
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear="Regal Earring",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Freke Ring",
		back="Argocham. Mantle",}

		sets.midcast.MB = {		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Ea Houppelande",
        hands="Amalric Gages +1",
		legs="Ea Slops",
		feet="Bunzi's Sabots",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Argocham. Mantle",}
		
    sets.magic_burst = {    
		ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
		head="Ea Hat +1",
		body="Ea Houppelande",
        hands="Amalric Gages +1",
		legs="Ea Slops",
		feet="Bunzi's Sabots",
		neck="Sibyl Scarf",
		waist={ name="Acuity Belt +1", augments={'Path: A',}},
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Mujin Band",
		right_ring="Freke Ring",
		back="Argocham. Mantle",
    }
	
	sets.Obi = {waist="Hachirin-no-Obi", back="Twilight Cape",}
	
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    sets.midcast['Dark Magic'] = {
		ammo="Regal Gem",
		body="Cohort Cloak +1",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},
	}
    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		ring1="Evanescence ring",
		ring2="Archon Ring",
		waist="Fucho-no-Obi",
		head="Pixie Hairpin +1",
		neck="Erra Pendant",
		feet="Merlinic Crackows",
	})
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
		ammo="Regal Gem",
		body="Cohort Cloak +1",
		hands="Jhakri Cuffs +2",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},
	}
	sets.midcast['Stun'] = {
		ammo="Regal Gem",
		        head=empty;
        body="Cohort Cloak +1",
		hands="Jhakri Cuffs +2",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Aurist's Cape +1", augments={'Path: A',}},
	}
	
    -- Sets for special buff conditions on spells
        
    sets.buff.ComposureOther = set_combine(sets.midcast['Enhancing Magic'], {
		body="Lethargy Sayon +3",
	})

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
		head="Befouled Crown",
        body="Shamash Robe",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
 
    -- Idle sets
    sets.idle.Normal = {
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Shamash Robe",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",}

        sets.idle.Town ={legs="Carmine Cuisses +1",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",}
    
    sets.idle.Weak = {
		ammo="Homiliary",
		head="Nyame Helm",
		body="Shamash Robe",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Paguroidea Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonlight Cape",}

    sets.idle.PDT = {
		ammo="Homiliary",
		head="Nyame Helm",
		body="Shamash Robe",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Paguroidea Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonlight Cape",
	} 

    sets.idle.MDT = {
		ammo="Homiliary",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Bunzi's Gloves",
		legs="Malignance Tights",
		feet="Nyame Sollerets",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Sanare Earring",
		right_ear="Eabani Earring",
		left_ring="Purity Ring",
		right_ring="Vengeful Ring",
		back="Moonlight Cape",
	}

	sets.idle.HP={
		main="Naegling",
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Tuisto Earring",
		left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		right_ring="Ilabrat Ring",
		back="Moonlight Cape",
	}

	sets.idle.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body={ name="Emet Harness +1", augments={'Path: A',}},
		hands="Merlinic Dastanas",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Trux Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
		back="Reiki Cloak",
	}
    
    
    -- Defense sets
    sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Shamash Robe",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		left_ring="Paguroidea Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonlight Cape",}
 
    sets.defense.MDT = {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Bunzi's Gloves",
		legs="Malignance Tights",
		feet="Nyame Sollerets",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Sanare Earring",
		right_ear="Eabani Earring",
		left_ring="Purity Ring",
		right_ring="Vengeful Ring",
		back="Moonlight Cape",}
		

    sets.latent_refresh = {waist="Fucho-no-obi",}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
	
    sets.engaged = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
		back="Tactical Mantle",
    }
	sets.engaged.Acc = {
		ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Tactical Mantle",		}
		
		sets.engaged.CRIT = {
			ammo="Coiste Bodhar",
			head={ name="Blistering Sallet +1", augments={'Path: A',}},
			body="Ayanmo Corazza +2",
			hands="Bunzi's Gloves",
			legs={ name="Zoar Subligar +1", augments={'Path: A',}},
			feet="Thereoid Greaves",
			neck="Nefarious Collar +1",
			waist="Gerdr Belt",
			left_ear="Sherida Earring",
			right_ear="Brutal Earring",
			left_ring="Hetairoi Ring",
			right_ring="Petrov Ring",
			back="Annealed Mantle",	} 

		sets.engaged.Enspell = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		ammo="Coiste Bodhar",
		head="Umuthi Hat",
		body="Malignance Tabard",
		ands="Aya. Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Orpheus's Sash",
		left_ear="Eabani Earring",
		right_ear="Suppanomimi",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
		}

		
    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

         --DW cap all set haste capped

		sets.engaged.DW = set_combine(sets.engaged ,{
			ammo="Coiste Bodhar",
			head="Malignance Chapeau",
			body="Malignance Tabard",
			hands="Malignance Gloves",
			legs="Malignance Tights",
			feet="Malignance Boots",
			neck="Anu Torque",
			waist="Reiki Yotai",
			left_ear="Suppanomimi",
			right_ear="Telos Earring",
			left_ring="Petrov Ring",
			right_ring="Chirich Ring +1",
			back="Tactical Mantle",
		})
	sets.engaged.DW.Acc = set_combine(sets.engaged.Acc ,{
		ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Tactical Mantle",    })

	sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT ,{
		ammo="Coiste Bodhar",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Bunzi's Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Nefarious Collar +1",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Brutal Earring",
		left_ring="Hetairoi Ring",
		right_ring="Petrov Ring",
		back="Annealed Mantle",	})

		sets.engaged.DW.Enspell = {   
			ammo="Coiste Bodhar",
			head="Umuthi Hat",
			body="Malignance Tabard",
			hands="Aya. Manopolas +2",
			legs="Malignance Tights",
			feet="Malignance Boots",
			neck="Sanctity Necklace",
			waist="Orpheus's Sash",
			left_ear="Eabani Earring",
			right_ear="Suppanomimi",
			left_ring="Chirich Ring +1",
			right_ring="Chirich Ring +1",
			back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
			}
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------
	sets.engaged.Hybrid = {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		}

	sets.engaged.PDT = set_combine(sets.engaged , {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		left_ring="Defending Ring",
		})
		sets.engaged.Acc.PDT = set_combine(sets.engaged , {
			ammo="Staunch Tathlum +1",
			head="Malignance Chapeau",
			body="Malignance Tabard",
			hands="Malignance Gloves",
			legs="Malignance Tights",
			feet="Malignance Boots",
			neck={ name="Loricate Torque +1", augments={'Path: A',}},
			left_ring="Defending Ring",
			})
			sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT , {
				ammo="Staunch Tathlum +1",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
				feet="Malignance Boots",
				neck={ name="Loricate Torque +1", augments={'Path: A',}},
				left_ring="Defending Ring",
				})
		sets.engaged.DW.PDT = set_combine(sets.engaged.DW , {
			ammo="Staunch Tathlum +1",
			head="Malignance Chapeau",
			body="Malignance Tabard",
			hands="Malignance Gloves",
			legs="Malignance Tights",
			feet="Malignance Boots",
			neck={ name="Loricate Torque +1", augments={'Path: A',}},
			waist="Reiki Yotai",
			left_ear="Suppanomimi",
			left_ring="Defending Ring",
			})
			sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.Acc , {
				ammo="Staunch Tathlum +1",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
				feet="Malignance Boots",
				neck={ name="Loricate Torque +1", augments={'Path: A',}},
				waist="Reiki Yotai",
				left_ear="Suppanomimi",
				left_ring="Defending Ring",
				})
			sets.engaged.DW.CRIT.PDT = set_combine(sets.engaged.CRIT , {
				ammo="Staunch Tathlum +1",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
				feet="Malignance Boots",
				neck={ name="Loricate Torque +1", augments={'Path: A',}},
				waist="Reiki Yotai",
				left_ear="Suppanomimi",
				left_ring="Defending Ring",
				})

    sets.engaged.Defense = {
                ammo="Aurgelmir Orb +1",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		left_ear="Cessance Earring",
		right_ear="Suppanomimi",
		left_ring="Petrov Ring",
	}

	sets.Adoulin = {body="Councilor's Garb",}
	sets.Kiting = {legs = "Carmine Cuisses +1",}
    sets.MoveSpeed = {legs = "Carmine Cuisses +1",}
		
	sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local aspirs = S{'Aspir','Aspir II','Aspir III'}
    local sleeps = S{'Sleep','Sleep II'}
    local sleepgas = S{'Sleepga','Sleepga II'}
	local slows = S{'Slow','Slow II'}
 
    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
 
    local spell_index
 
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_precast(spell, action, spellMap, eventArgs)
	--[[if spell.english == 'Refresh' then
		equip(sets.midcast['Enhancing Magic'].Duration)
	end]]
	if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
	if spell.english == 'Aeolian Edge' then
		equip(sets.precast.WS['Aeolian Edge'])
	end
	
	if spell.english == "Impact" then
		sets.precast.FC = sets.precast['Impact']
    end
end
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
end
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.english == "Impact" then
        equip({head=empty,body="Twilight Cloak"})
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' and (state.MagicBurst.value or AEBurst) then
		equip(sets.magic_burst)
		if spell.english == "Impact" then
			equip(sets.midcast.Impact)
		end
	end
	--[[if spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
        equip(sets.Saboteur)]]
	if spell.skill == 'Enfeebling Magic' and state.Enfeeb.Value == 'None' then
		equip(sets.midcast['Enfeebling Magic'])
	elseif spell.skill == 'Enfeebling Magic' and state.Enfeeb.Value == 'Potency' then
		equip(sets.midcast['Enfeebling Magic'].Potency)
	elseif spell.skill == 'Elemental Magic' and (state.MagicBurst.value or AEBurst) then
        equip(sets.magic_burst)
	elseif spell.skill == 'Elemental Magic' and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
	
    end
	
	
	if spell.english == "Dia III" then
		equip(set_combine(sets.midcast['Enfeebling Magic'].Potency, sets.Dia))
	end
	
	if spell.skill == 'Enfeebling Magic' and (spell.english:startswith('Paralyze') and state.Enfeeb.Value == 'Potency') then
		equip(sets.midcast['Enfeebling Magic'].Potency)
	elseif spell.skill == 'Enfeebling Magic' and (spell.english:startswith('Paralyze') and (state.Enfeeb.Value == 'None' or state.Enfeeb.Value == 'Skill')) then
		equip(set_combine(sets.midcast['Enfeebling Magic'], sets.midcast['Enfeebling Magic'].ParalyzeDuration))
	end

	
	if spell.skill == 'Healing Magic' and (spell.element == world.weather_element or spell.element == world.day_element) and spell.target.type == 'PLAYER' then
		equip(set_combine(sets.midcast.Cure, sets.Obi))
	end
	
	if spell.english == "Temper" or spell.english == "Temper II" or spell.english:startswith('Protect') or spell.english:startswith('Shell') then
		equip(sets.midcast['Enhancing Magic'].Skill)
	end
	
	if spell.english == "Frazzle II" or spell.english == "Frazzle" then
		equip(sets.midcast['Enfeebling Magic'].Macc)
	end
	
	if spell.english == "Frazzle III" or (spell.english == "Distract III" and (state.Enfeeb.Value == 'None' or state.Enfeeb.Value == 'Potency')) then
		equip(sets.midcast['Enfeebling Magic'].Potency)
	end
	
	if spell.english:startswith('En') then
		equip(sets.midcast['Enhancing Magic'].Skill)
	end
	
	if spell.english == "Invisible" or spell.english == "Sneak" then 
		equip(sets.midcast['Enhancing Magic'].Duration)
	end
	
	--[[if spell.skill == 'Enhancing Magic' and buffactive['Composure'] and spell.target.type == 'PLAYER' then
		equip(sets.buff.ComposureOther)
	end]]
	
	if spell.action_type == "Magic" and spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
	end
	
	if spell.skill == "Enhancing Magic" and 
		spell.english:startswith('Gain') then
		equip(sets.midcast['Enhancing Magic'].GainSpell)
		elseif ((spell.english:startswith('Haste') or spell.english:startswith("Flurry")
		or spell.english == 'Sneak' or spell.english == 'Invisible' or 
		spell.english == 'Deodorize' or spell.english:startswith('Regen')) and spell.target.type == 'SELF') then
        equip(sets.midcast['Enhancing Magic'].SelfDuration)
	end
	
	--[[if spell.skill == 'Enfeebling Magic' and buffactive['Stymie'] then
		equip(sets.midcast['Enfeebling Magic'].Potency, {})
	end]]
	
	if spell.english == "Refresh" or spell.english == "Refresh II" or spell.english == "Refresh III" then
		equip(sets.midcast.Refresh)
	end
end


function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:lower(enfeebling_magic) and not spell.interrupted then
        set_debuff_timer(spell)
    end
end

function refine_various_spells(spell, action, spellMap, eventArgs)
    local refreshes = S{'Refresh','Refresh II','Refresh III'}
	local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
	local spell_index
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
	end
	if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end


function job_get_spell_map(spell, default_spell_map)
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff, gain)
	if (buff and gain) or (buff and not gain) then
	send_command('gs c update')
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

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

	return meleeSet
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
    end
	if state.Auto_Kite.value == true then
		idleSet = set_combine(idleSet, sets.Kiting)
	end
    --[[if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = sets.idle.PDT
        elseif state.IdleMode.value == 'MDT' then
            idleSet = sets.idle.MDT
        elseif state.IdleMode.value == 'Normal' then
            idleSet = sets.idle.Normal
        end]]
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    
    return idleSet
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
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function set_debuff_timer(spell)
    local self = windower.ffxi.get_player()
	base = 90

    if spell.en == "Sleep II" then
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then
        base = 60
    end
    if spell.en == "Gravity" then
        base = 120
    end
    if spell.en == "Gravity II" then
        base = 120
    end
	if spell.en == "Bind" then
        base = 60
    end
    if state.Buff.Saboteur then
        if state.NM.value then
            base = base * 1.25
        else
            base = base * 2
        end
    end

    -- Merit Points Duration Bonus
    base = base + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
    if not ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        base = base + self.merits.enfeebling_magic_duration*3
    end

    -- Job Points Duration Bonus
    base = base + self.job_points.rdm.enfeebling_magic_duration

    --Enfeebling duration non-augmented gear total
    gear_mult = 1.40
    --Enfeebling duration augmented gear total
    aug_mult = 1.25
    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    empy_mult = 1 --from sets.midcast.Sleep

    if ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        if buffactive.Stymie then
            base = base + self.job_points.rdm.stymie_effect
        end
        empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    end

    totalDuration = math.floor(base * gear_mult * aug_mult * empy_mult)

    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..'] ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..'] ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00253.png')
	elseif spell.english == "Gravity" then
        send_command('@timers c "Gravity ' ..tostring(spell.target.name).. ' ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00216.png')
	elseif spell.english == "Gravity II" then
        send_command('@timers c "Gravity II ' ..tostring(spell.target.name).. ' ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00217.png')
	elseif spell.english == "Bind" then
        send_command('@timers c "Bind ' ..tostring(spell.target.name).. ' ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00258.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)

end

function job_update(cmdParams, eventArgs)
    --if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        --state.OffenseMode:set('Ranged')
    --end
	--handle_equipping_gear(player.status)
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
    update_combat_form()
	check_gear()
	check_moving()
	if state.WeaponSet.value == "SWORDS" then
        equip({main="Naegling", sub="Demers. Degen +1",})
	elseif state.WeaponSet.value == "Crocea" then
        equip({main="Crocea Mors", sub="Naegling",})
    elseif state.WeaponSet.value == "DAGGERS" then
        equip({main="Tauret", sub="Gleti's Knife",})
	elseif state.WeaponSet.value == "IDLE" then
        equip({main="Daybreak", sub="Sacro Bulwark",})
    elseif state.WeaponSet.value == "normal" then
        equip({})
    end
	if state.shield.value == "shield" then
        equip({sub="Sacro Bulwark",})
    elseif state.shield.value == "normal" then
        equip({})
    end
end
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end 
end
function equip_gear_by_status(status)
	if status == 'Engaged' then
		send_command('gs c cycle OffenseMode')
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

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()

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

function midcast(spell)
    if spell.english == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
end
 
function aftercast(spell)
    if not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = false
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 152')
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'BLM' then
        set_macro_page(5, 22)
    elseif player.sub_job == 'WHM' then
        set_macro_page(5, 22)
    elseif player.sub_job == 'THF' then
        set_macro_page(5, 22)
    else
        set_macro_page(5, 22)
    end
end
