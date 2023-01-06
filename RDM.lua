--[[
▒█▀▀█ ▒█▀▀▀ ▒█▀▀▄ 　 ▒█▀▄▀█ ░█▀▀█ ▒█▀▀█ ▒█▀▀▀ 
▒█▄▄▀ ▒█▀▀▀ ▒█░▒█ 　 ▒█▒█▒█ ▒█▄▄█ ▒█░▄▄ ▒█▀▀▀ 
▒█░▒█ ▒█▄▄▄ ▒█▄▄▀ 　 ▒█░░▒█ ▒█░▒█ ▒█▄▄█ ▒█▄▄▄ 
]]


---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
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
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Enspell', 'ACC', 'CRIT')
    state.IdleMode:options('Normal', 'PDT', 'MDT', 'Town')
	state.CastingMode:options('Normal', 'Burst')
	state.Enfeeb = M('None', 'Potency', 'Skill')

    state.Moving = M(false, "moving")
    
    select_default_macro_book()


	send_command('bind f10 gs c cycle IdleMode')
	send_command('bind f11 gs c cycle Enfeeb')
	send_command('bind f12 gs c cycle CastingMode')
	
    select_default_macro_book()
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
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Vitivation Tabard +3"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

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
	
	sets.precast.FC = {
		ammo="Incantor Stone",
        head="Carmine Mask +1",
		ear2="Loquacious Earring",
        body="Vitivation Tabard +3",
		hands="Leyline Gloves",
		ring1="Prolix Ring",
		ring2="Kishar Ring",
        back="Swith Cape +1",
		waist="Witful Belt",
		legs="Psycloth Lappas",
		feet="Carmine Greaves +1"}
		

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {})
       
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
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Weapon skill damage +10%',}},
	}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = {
		ammo="Regal Gem",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Bunzi's Gloves",
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Malignance Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
    }

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
		right_ear="Hecate's Earring",
		left_ring="Archon Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
    }

    sets.precast.WS['Savage Blade'] = {
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
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Weapon skill damage +10%',}},
	}
		
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
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Freke Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		}


	sets.precast.WS['Aeolian Edge']	= {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Freke Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
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
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Epaminondas's Ring",
    back={ name="Sucellos's Cape", augments={'Weapon skill damage +10%',}},
	}
	
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
		left_ear="Mache Earring +1",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}

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
		left_ear="Mache Earring +1",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}
	

	
    -- Midcast Sets
    
    sets.midcast.FastRecast = {}

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

    sets.midcast.Cursna = {
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		hands="Serpentes Cuffs",
		ring1="Ephedra Ring",
		ring2="Ephedra Ring",
 
	}
        
    sets.midcast.Curaga = sets.midcast.Cure
	
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
		
    sets.midcast['Enhancing Magic'] = {
		head="Befouled Crown",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},
	}
		
	sets.midcast['Enhancing Magic'].SelfDuration = {
		head="Befouled Crown",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},
	}

	sets.midcast['Enhancing Magic'].Skill = {
		head="Befouled Crown",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},
	}
	
	sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'].Skill, {})
		
	sets.midcast['Enhancing Magic'].GainSpell = set_combine(sets.midcast['Enhancing Magic'].SelfDuration, {hands="Vitiation gloves +3"})
		
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		body="Atrophy Tabard +3",
		head="Amalric Coif",
		legs="Lethargy Fuseau +1",
		waist="Gishdubar sash"})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		neck="Nodens Gorget",
		hands="Stone Mufflers",
		legs="Haven hose",
		ear2="Earthcry Earring"})
	
	
	-- If you have them, add Shedir Seraweels, Regal Cuffs, Amalric Coif (+1), or Chironic Hat
	sets.midcast.Aquaveil = {
		head="Befouled Crown",
		hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Fi Follet Cape +1", augments={'Path: A',}},
	}
	
    sets.midcast['Enfeebling Magic'] = {

		
        ammo="Regal Gem",
        head={ name="Viti. Chapeau +1", augments={'Enfeebling Magic duration','Magic Accuracy',}},
        body="Shango Robe",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet="Skaoi Boots",
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Malignance Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Kishar Ring",
        back="Sucellos's Cape",
    }
	
	sets.midcast['Enfeebling Magic'].Macc = set_combine(sets.midcast['Enfeebling Magic'], {
		body="Atrophy Tabard +3"})
		
	sets.midcast['Enfeebling Magic'].Skill = {    

		
		ammo="Regal Gem",
		head="Viti. Chapeau +3",
		body="Atrophy Tabard +3",
		hands="Lethargy Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
		feet="Vitiation Boots +3",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

	sets.midcast['Enfeebling Magic'].Potency = {    

		
		ammo="Regal Gem",
		head="Viti. Chapeau +3",
		body="Lethargy Sayon +1",
		hands="Lethargy Gantherots +1",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
		feet="Vitiation Boots +3",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Gwati Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		}
    
	sets.Saboteur = set_combine(sets.midcast['Enfeebling Magic'].Potency, {hands="Lethargy Gantherots +1"})

	
	sets.midcast['Enfeebling Magic'].ParalyzeDuration = {feet="Vitiation Boots +3",}
	
    sets.midcast['Elemental Magic'] = {
		
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. Acc.+12','"Mag.Atk.Bns."+10',}},
		hands={ name="Amalric Gages", augments={'MP+60','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Mag. crit. hit dmg. +4%','MND+4','Mag. Acc.+11','"Mag.Atk.Bns."+14',}},
		feet="Vitiation Boots +3",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Shiva Ring +1",
		right_ring="Shiva Ring +1",
		back="Izdubar Mantle",}
		
	sets.midcast['Elemental Magic'].Burst = {    

		
		ammo="Pemphredo Tathlum",
		head="Ea Hat",
		body="Ea Houppelande",
		hands="Ea Cuffs",
		legs="Ea Slops",
		feet="Ea Pigaches",
		neck="Mizu. Kubikazari",
		waist="Eschan Stone",
		left_ear="Hecate's Earring",
		right_ear="Friomisi Earring",
		left_ring="Mujin Band",
		right_ring="Shiva Ring +1",
		back="Izdubar Mantle",}
    
	sets.Obi = {waist="Hachirin-no-Obi",}
	
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    sets.midcast['Dark Magic'] = {

		
		ammo="Regal Gem",
		head={ name="Chironic Hat", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+2','MND+5','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
		body="Atrophy Tabard +3",
		hands="Jhakri Cuffs +2",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
		feet={ name="Medium's Sabots", augments={'MP+50','MND+10','"Conserve MP"+7','"Cure" potency +5%',}},
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring1="Evanescence ring",
		ring2="Archon Ring",
		waist="Fucho-no-Obi",
		head="Pixie Hairpin +1",
		neck="Erra Pendant",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','Magic burst dmg.+8%','Mag. Acc.+11',}}})

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {

		
		ammo="Regal Gem",
		head={ name="Chironic Hat", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+2','MND+5','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
		body="Atrophy Tabard +3",
		hands="Jhakri Cuffs +2",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
	
	sets.midcast['Stun'] = {
		ammo="Regal Gem",
		head={ name="Chironic Hat", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','"Conserve MP"+2','MND+5','Mag. Acc.+15','"Mag.Atk.Bns."+2',}},
		body="Atrophy Tabard +3",
		hands="Jhakri Cuffs +2",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','MND+6','Mag. Acc.+14',}},
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}
	
    -- Sets for special buff conditions on spells
        
    sets.buff.ComposureOther = set_combine(sets.midcast['Enhancing Magic'], {
		head="Lethargy Chappel +1",
        body="Vitiation Tabard +3",
		hands="Atrophy Gloves +3",
        legs="Lethargy Fuseau +1",
		feet="Lethargy Houseaux +1"})

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
		head="Befouled Crown",
        body="Jhakri Robe +2",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		right_ear="Musical Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
	}
 
    -- Idle sets
    sets.idle.Normal = {
		ammo="Staunch Tathlum +1",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands="Nyame Gauntlets",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",}

    sets.idle.Town = {
		ammo="Staunch Tathlum +1",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands="Nyame Gauntlets",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Nyame Sollerets",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Genmei Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonlight Cape",}
    
    sets.idle.Weak = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
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
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
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
		back="Moonlight Cape",
	}
    
    
    -- Defense sets
    sets.defense.PDT = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
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
		

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
	
    sets.engaged = {
                ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear="Cessance Earring",
		left_ring="Hetairoi Ring",
		right_ring="Petrov Ring",
		back="Atheling Mantle",
    }

	sets.engaged.DW = {
                ammo="Aurgelmir Orb +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Hetairoi Ring",
		right_ring="Petrov Ring",
		back="Atheling Mantle",
		}

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
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}       
	sets.engaged.DW.CRIT = {
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
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
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
			right_ear="Cessance Earring",
			left_ring="Chirich Ring +1",
			right_ring="Chirich Ring +1",
			back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		}
	sets.engaged.DW.Acc = {
	ammo="Aurgelmir Orb +1",
	head="Malignance Chapeau",
	body="Malignance Tabard",
	hands="Malignance Gloves",
	legs="Malignance Tights",
	feet="Malignance Boots",
	neck="Anu Torque",
	waist={ name="Sailfi Belt +1", augments={'Path: A',}},
	left_ear="Sherida Earring",
	right_ear="Cessance Earring",
	left_ring="Chirich Ring +1",
	right_ring="Chirich Ring +1",
	back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
    }


	sets.engaged.Enspell = {   
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
		back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		}
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
			back={ name="Sucellos's Cape", augments={'Accuracy+20 Attack+20','Weapon skill damage +10%',}},
			}


		
    sets.engaged.Defense = {
                ammo="Aurgelmir Orb +1",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Taeon Boots", augments={'Accuracy+23','"Triple Atk."+2','Crit. hit damage +2%',}},
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		left_ear="Cessance Earring",
		right_ear="Suppanomimi",
		left_ring="Petrov Ring",
	}

	sets.Adoulin = {}

    sets.MoveSpeed = {legs = "Carmine Cuisses +1",}
		
	sets.ConsMP = {body="Seidr Cotehardie"}
	sets.Doom = {    neck="Nicander's Necklace",
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

function job_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Refresh' then
		equip(sets.midcast['Enhancing Magic'])
		
	end
	if spell.english == 'Aeolian Edge' then
		equip(sets.precast.WS['Aeolian Edge'])
	end
	
	if spell.english == "Impact" then
		sets.precast.FC = sets.precast['Impact']
    end
end
	


function job_midcast(spell, action, spellMap, eventArgs)
	if spell.english == "Impact" then
        equip({head=empty,body="Twilight Cloak"})
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

	if spell.skill == 'Enfeebling Magic' and buffactive['Saboteur'] then
        equip(sets.Saboteur)
	elseif spell.skill == 'Enfeebling Magic' and state.Enfeeb.Value == 'None' then
		equip(sets.midcast['Enfeebling Magic'])
	elseif spell.skill == 'Enfeebling Magic' and state.Enfeeb.Value == 'Potency' then
		equip(sets.midcast['Enfeebling Magic'].Potency)
	end
	
	if spell.english == "Dia III" then
		equip(set_combine(sets.midcast['Enfeebling Magic'].Potency, sets.Dia))
	end
	
	if spell.skill == 'Enfeebling Magic' and (spell.english:startswith('Paralyze') and state.Enfeeb.Value == 'Potency') then
		equip(sets.midcast['Enfeebling Magic'].Potency)
	elseif spell.skill == 'Enfeebling Magic' and (spell.english:startswith('Paralyze') and (state.Enfeeb.Value == 'None' or state.Enfeeb.Value == 'Skill')) then
		equip(set_combine(sets.midcast['Enfeebling Magic'], sets.midcast['Enfeebling Magic'].ParalyzeDuration))
	end
	
	if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and (player.mp-spell.mp_cost) < 600 then
		equip(sets.ConsMP)
	end		
	
	if spell.skill == 'Elemental Magic' and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
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
		equip(sets.midcast['Enhancing Magic'])
	end
	
	if spell.skill == 'Enhancing Magic' and buffactive['Composure'] and spell.target.type == 'PLAYER' then
		equip(sets.buff.ComposureOther)
	end	
	
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
	
	if spell.skill == 'Enfeebling Magic' and buffactive['Stymie'] then
		equip(sets.midcast['Enfeebling Magic'].Potency, {feet="Uk'uxkaj Boots",})
	end
	
	if spell.english == "Refresh" or spell.english == "Refresh II" or spell.english == "Refresh III" then
		equip(sets.midcast.Refresh)
	end
end


function job_aftercast(spell, action, spellMap, eventArgs)
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


function customize_melee_set(meleeSet)
    if (buffactive['Embrava'] or buffactive['March'] or buffactive[580] or buffactive['Mighty Guard']) then
        meleeSet = set_combine(sets.engaged, sets.engaged.Haste_43)
    end
	return meleeSet
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = sets.idle.PDT
        elseif state.IdleMode.value == 'MDT' then
            idleSet = sets.idle.MDT
        elseif state.IdleMode.value == 'Normal' then
            idleSet = sets.idle.Normal
        end

    
    return idleSet
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
    eventArgs.handled = true
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

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
add_to_chat(159,'Author Aragan RDM.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
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


organizer_items = {
echo="Echo Drops",
echo2="Echo Drops",
pana="Panacea",
pana2="Panacea",
reme="Remedy",
reme2="Remedy",
sush2="Sublime Sushi +1",
sush1="Sublime Sushi",
stew="Marine Stewpot",
hall="Hallowed Water",
shih="Shihei"}
