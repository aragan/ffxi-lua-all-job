-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
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


-- Setup vars that are user-independent.
function job_setup()
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    customize_idle_set(idleSet)
    customize_melee_set(meleeSet)
    send_command('wait 2;input /lockstyleset 172')
    state.CapacityMode = M(false, 'Capacity Point Mantle')

    state.YoichiAM = M(false, 'Cancel Yoichi AM Mode')
    -- list of weaponskills that make better use of otomi helm in low acc situations
    wsList = S{'Tachi: Shoha'}

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
    state.OffenseMode:options('Normal', 'Mid', 'Acc','MaxAcc', 'PDL', 'PD', 'polearm', 'Range', 'CRIT' , 'Counter')
    state.HybridMode:options('Normal', 'PDT', 'STP', 'triple', 'PDLATT')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc', 'PDL')
    state.IdleMode:options('Normal', 'Evasion')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Reraise')
    state.MagicalDefenseMode:options('MDT')
    
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^[ input /lockstyle on')
    send_command('bind ![ input /lockstyle off')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind ^/ gs disable all')
    send_command('bind ^- gs enable all')
    send_command('bind f5 gs c cycle WeaponskillMode')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^[')
    send_command('unbind !=')
    send_command('unbind ![')
    send_command('unbind ^/')

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
    Valorous = {}
    Valorous.Hands = {}
    Valorous.Hands.TP = { name="Valorous Mitts", augments={'Accuracy+26','"Store TP"+6','AGI+10',}}
    Valorous.Hands.WS = { name="Valorous Mitts", augments={'Accuracy+27','Weapon skill damage +4%','Accuracy+5 Attack+5','Mag. Acc.+14 "Mag.Atk.Bns."+14',}}


    Valorous.Feet = {}
    Valorous.Feet.WS ={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+9','Accuracy+15','Attack+11',}}
    Valorous.Feet.TH = { name="Valorous Greaves", augments={'CHR+13','INT+1','"Treasure Hunter"+2','Accuracy+12 Attack+12','Mag. Acc.+1 "Mag.Atk.Bns."+1',}}

    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
    sets.precast.JA['Provoke'] = { 
        -- ear1="Cryptic Earring",
    }
    
    Smertrios = {}
    Smertrios.TP = { name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}}
    Smertrios.WS = {name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    -- Precast Sets
    -- Precast sets to enhance JAs
    sets.precast.JA.Meditate = {
        head="Wakido Kabuto +1",
        hands="Sakonji Kote +3",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Occ. inc. resist. to stat. ailments+10',}},
    }
    sets.precast.JA.Sekkanoki = {hands="Unkai Kote +2" }
    sets.precast.JA.Seigan = {head="Unkai Kabuto +2"}
    sets.precast.JA['Warding Circle'] = {head="Wakido Kabuto +1"}
    sets.precast.JA['Third Eye'] = {legs="Sakonji Haidate +3"}
    --sets.precast.JA['Blade Bash'] = {hands="Saotome Kote +2"}
   
    sets.precast.FC = {
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        hands="Leyline Gloves",
        ring1="Prolix Ring",
    }
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {body="Passion Jacket",}

    sets.Organizer = {

    }
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
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},

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
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    }	
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.CapacityMantle  = { back="Mecistopins Mantle" }
    --sets.Berserker       = { neck="Berserker's Torque" }
    sets.WSDayBonus      = { head="Gavialis Helm" }
    sets.LugraMoonshade  = { ear1="Lugra Earring +1", ear2="Moonshade Earring" }
    sets.BrutalMoonshade = { ear1="Brutal Earring", ear2="Moonshade Earring" }
    --sets.LugraFlame      = { ear1="Lugra Earring +1", ear2="Flame Pearl" }
    --sets.FlameFlame      = { ear1="Flame Pearl", ear2="Flame Pearl" }
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
    ammo="Knobkierrie",
    head="Mpaca's Cap",
    body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
    hands="Nyame Gauntlets",
    legs="Wakido Haidate +3",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Occ. inc. resist. to stat. ailments+10',}},
    }
    sets.precast.WS.Mid = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
    })
    
    sets.precast.WS['Namas Arrow'] = {
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    sets.precast.WS['Namas Arrow'].Mid = set_combine(sets.precast.WS['Namas Arrow'], {
    })
    sets.precast.WS['Namas Arrow'].Acc = set_combine(sets.precast.WS['Namas Arrow'], {
    })
    
    sets.precast.WS['Apex Arrow'] = set_combine(sets.precast.WS['Namas Arrow'], {
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Apex Arrow'].Mid = sets.precast.WS['Apex Arrow']
    sets.precast.WS['Apex Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
    })

    sets.precast.WS['Empyreal Arrow'] = set_combine(sets.precast.WS['Namas Arrow'], {
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Empyreal Arrow'].Mid = sets.precast.WS['Apex Arrow']
    sets.precast.WS['Empyreal Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
    })
    
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Fudo'].Mid = set_combine(sets.precast.WS['Tachi: Fudo'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Fudo'].Acc = set_combine(sets.precast.WS['Tachi: Fudo'], {

    })

    sets.precast.WS['Tachi: Kaiten'] = set_combine(sets.precast.WS, {
        main={ name="Amanomurakumo", augments={'Path: A',}},
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS['Tachi: Kaiten'].Mid = set_combine(sets.precast.WS['Tachi: Kaiten'], {
        ammo="Crepuscular Pebble",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear="Ishvara Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Kaiten'].Mid = set_combine(sets.precast.WS['Tachi: Fudo'], {
        ammo="Crepuscular Pebble",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS['Tachi: Kaiten'].Acc = set_combine(sets.precast.WS['Tachi: Kaiten'], {

    })

    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
        main="Shining One",
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Impulse Drive'].Mid = set_combine(sets.precast.WS['Impulse Drive'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS['Impulse Drive'], {
    })

    sets.precast.WS['Sonic Thrust'] = set_combine(sets.precast.WS['Impulse Drive'], {
    })
    
    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {
        main={ name="Masamune", augments={'Path: A',}},
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Shoha'].Mid = set_combine(sets.precast.WS['Tachi: Shoha'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Niqmaddu Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Shoha'].Acc = set_combine(sets.precast.WS['Tachi: Shoha'], {})

    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS['Tachi: Shoha'], {
        neck="Samurai's Nodowa +2",
      
    })
    sets.precast.WS['Stardiver'].Mid = set_combine(sets.precast.WS['Stardiver'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS['Stardiver'], {

    })
    
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Rana'].Mid = set_combine(sets.precast.WS['Tachi: Rana'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
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
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Tachi: Ageha'].Mid = set_combine(sets.precast.WS['Tachi: Ageha'], {
        left_ear="Handler's Earring",
        right_ear={ name="Handler's Earring +1", augments={'Path: A',}},
    })
    
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })

    sets.precast.WS['Tachi: Kasha'].Mid = set_combine(sets.precast.WS['Tachi: Kasha'], {
        ammo="Crepuscular Pebble",
            body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Kas. Sune-Ate +2",
        left_ring="Regal Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS['Tachi: Kasha'].Acc = sets.precast.WS['Tachi: Kasha']

    
    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })
    
    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Mpaca's Cap",
        body={ name="Sakonji Domaru +3", augments={'Enhances "Overwhelm" effect',}},
        hands="Nyame Gauntlets",
        legs="Wakido Haidate +3",
        feet="Nyame Sollerets",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
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
        left_ear="Friomisi Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })      
    sets.precast.WS['Tachi: Jinpu'].Mid =  {
        ammo="Crepuscular Pebble",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    }
    
    sets.midcast['Blue Magic'] = set_combine(sets.precast.WS['Tachi: Ageha'], {

    })
    -- Midcast Sets
    sets.midcast.FastRecast = {
 
        
    }
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        neck="Sanctity Necklace",
        ring2="Paguroidea Ring",
        ear2="Infused Earring",
   	    body="Hizamaru Haramaki +2",
    }
    
    sets.idle.Town = {        

    ear2="Infused Earring",
       feet="Danzo Sune-Ate",


    }
    -- sets.idle.Town.Adoulin = set_combine(sets.idle.Town, {
    --     body="Councilor's Garb"
    -- })
    
    sets.idle.Field = {        
    head="Valorous Mask",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Danzo Sune-Ate",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear="Infused Earring",
    left_ring="Purity Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",

    }

    sets.idle.Regen = set_combine(sets.idle.Field, {

    })

    sets.idle.Evasion = set_combine(sets.idle, {
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
    
    sets.idle.Weak = set_combine(sets.idle.Field, {
        head="Twilight Helm",
    	body="Twilight Mail",
    })
    
    -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
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
    	head="Twilight Helm",
    	body="Twilight Mail"
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
    
    sets.Kiting = {feet="Danzo Sune-ate"}
    
    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}
    
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
    right_ear="Kasuga Earring",
    left_ear="Dedition Earring",
    right_ring="Chirich Ring +1",
    left_ring="Niqmaddu Ring",
    back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    }
    
    sets.engaged.Mid = set_combine(sets.engaged, {range=empty,
        ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Kasuga Domaru +2",
    hands="Wakido Kote +3",
    legs="Kasuga Haidate +2",
    feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
    neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Kasuga Earring",
    left_ear="Dedition Earring",
    right_ring="Chirich Ring +1",
    left_ring="Niqmaddu Ring",
    back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    })

    sets.engaged.Acc = set_combine(sets.engaged.Mid, { range=empty,
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Kasuga Domaru +2",
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Kasuga Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    })
    sets.engaged.MaxAcc = set_combine(sets.engaged.Acc, { range=empty,
        ammo="Amar Cluster",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Telos Earring",
        right_ear="Kasuga Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.engaged.PDL = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Kasuga Domaru +2",
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Kasuga Haidate +2",
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Kasuga Earring",
        left_ear="Dedition Earring",
        right_ring="Chirich Ring +1",
        left_ring="Niqmaddu Ring",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
         })
        sets.engaged.PDLATT = set_combine(sets.engaged, {
            ammo="Crepuscular Pebble",
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Kasuga Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
         })

    sets.engaged.polearm = set_combine(sets.engaged, {range=empty,
         main="Shining One",
         sub="Utu Grip",
         ammo="Coiste Bodhar",
         head="Flam. Zucchetto +2",
         body="Kasuga Domaru +2",
         hands="Wakido Kote +3",
         legs="Kasuga Haidate +2",
         feet="Flam. Gambieras +2",
         neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
         waist={ name="Sailfi Belt +1", augments={'Path: A',}},
         left_ear="Telos Earring",
         right_ear="Kasuga Earring",
         left_ring="Niqmaddu Ring",
         right_ring="Petrov Ring",
         back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
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
            back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
        }

    sets.engaged.PD = set_combine(sets.engaged, {range=empty,
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Kasuga Domaru +2",
        hands="Wakido Kote +3",
        legs="Kasuga Haidate +2",
        feet={ name="Ryuo Sune-Ate +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Dedition Earring",
        right_ear="Kasuga Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},

    })
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
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},

    })

    sets.engaged.CRIT = set_combine(sets.engaged, {range=empty,
    main={ name="Masamune", augments={'Path: A',}},
    sub="Utu Grip",
    ammo="Aurgelmir Orb +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mpaca's Doublet",
    hands="Flam. Manopolas +2",
    legs="Mpaca's Hose",
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Schere Earring",
    right_ear="Brutal Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Hetairoi Ring",
    back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Accuracy+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},

    })
    sets.engaged.PDT = set_combine(sets.engaged.Acc, {
        ammo="Coiste Bodhar",
        head="Mpaca's Cap",
        body="Kasuga Domaru +2",
        hands="Mpaca's Gloves",
        legs="Kasuga Haidate +2",
        feet="Mpaca's Boots",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Kasuga Earring",
        left_ear="Dedition Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},

    })

    sets.engaged.Mid.PDT = set_combine(sets.engaged.PDT, {
        ammo="Coiste Bodhar",
        head="Mpaca's Cap",
        body="Kasuga Domaru +2",
        hands="Mpaca's Gloves",
        legs="Kasuga Haidate +2",
        feet="Mpaca's Boots",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        right_ear="Kasuga Earring",
        left_ear="Dedition Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    })
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Mid.PDT, {
        ammo="Coiste Bodhar",
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Kasuga Haidate +2",
        feet="Mpaca's Boots",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Telos Earring",
        right_ear="Kasuga Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
    })
    sets.engaged.STP = {range=empty,
        ammo="Aurgelmir Orb +1",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body="Kasuga Domaru +2",
        hands="Wakido Kote +3",
        legs="Kasuga Haidate +2",
        feet="Kas. Sune-Ate +2",
        neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Dedition Earring",
        right_ear="Kasuga Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Takaha Mantle", augments={'STR+1','"Zanshin"+2','"Store TP"+2',}},
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
    
    sets.engaged.Amanomurakumo = set_combine(sets.engaged, {
    })
    sets.engaged.Amanomurakumo.AM = set_combine(sets.engaged, {
    })
    sets.engaged.Kogarasumaru = set_combine(sets.engaged, {
    })
    sets.engaged.Kogarasumaru.AM = set_combine(sets.engaged, {
    })
    sets.engaged.Kogarasumaru.AM3 = set_combine(sets.engaged, {
    })
    sets.engaged.Reraise = set_combine(sets.engaged, {		head="Twilight Helm",
    body="Twilight Mail",})
    
    sets.buff.Sekkanoki = {hands="unkai kote +2"}
    sets.buff.Sengikori = {feet="Kas. Sune-Ate +2",}
    sets.buff['Meikyo Shisui'] = {feet="Sakonji Sune-ate +3"}
    
    sets.thirdeye = {head="Unkai Kabuto +2", legs="Sakonji Haidate +3"}
    --sets.seigan = {hands="Otronif Gloves +1"}
    sets.bow = {ammo=gear.RAarrow}
    
    sets.MadrigalBonus = {hands="Composer's Mitts"}
    sets.Terror = {feet={ name="Founder's Greaves", augments={'VIT+8','Accuracy+13','"Mag.Atk.Bns."+14','Mag. Evasion+14',}},}
    sets.Stun = {
        feet={ name="Founder's Greaves", augments={'VIT+8','Accuracy+13','"Mag.Atk.Bns."+14','Mag. Evasion+14',}},}
    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
end

function job_precast(spell, action, spellMap, eventArgs)
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
        if (spell) then
            if wsList:contains(spell.english) then
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
    customize_idle_set(idleSet)
    customize_melee_set(meleeSet)
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.hpp < 90 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    end
    if player.hpp < 10 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        idleSet = set_combine(idleSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
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
    if player.hpp < 10 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        meleeSet = set_combine(meleeSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
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


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Engaged' then
        if player.inventory['Eminent Arrow'] then
            gear.RAarrow.name = 'Eminent Arrow'
        elseif player.inventory['Tulfaire Arrow'] then
            gear.RAarrow.name = 'Tulfaire Arrow'
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

    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'Acc' then
            equip(sets.MadrigalBonus)
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
    if buff == "terror" then
        if gain then
            equip(sets.Terror)
             disable('feet')
            else
             enable('feet')
        end
    end
    if buff == "weakness" then
        if gain then
            equip(sets.Reraise)
             disable('body','head')
            else
             enable('body','head')
        end
        return meleeSet
    end
    
    if not midaction() then
        handle_equipping_gear(player.status)
    end

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    --get_combat_weapon()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

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
add_to_chat(159,'Author Aragan SAM.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
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

end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
    	set_macro_page(8, 1)
    elseif player.sub_job == 'DNC' then
    	set_macro_page(8, 1)
    else
    	set_macro_page(8, 1)
    end
end