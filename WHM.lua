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
end
organizer_items = {
    item="Gyudon",
    item="Reraiser",
    item="Hi-Reraiser",
    item="Vile Elixir",
    item="Vile Elixir +1",
    item="Miso Ramen",
    item="Carbonara",
    item="Silent Oil",
    item="Salt Ramen",
    item="Panacea",
    item="Toolbag (Shika)",
    item="Sublime Sushi",
    item="Sublime Sushi 1+",
    item="Prism Powder",
    item="Antacid",
    item="Icarus Wing",
    sub="Warp Cudgel",
    item="Holy Water",
    item="Sanjaku-Tenugui",
    item="Shinobi-Tabi",
    item="Shihei",
    item="Remedy",
    head="Wh. Rarab Cap +1",
    ring="Emporox's Ring",
    item="Red Curry Bun",
    item="Instant Reraise",
    item="Black Curry Bun",
    item="Rolan. Daifuku",
    sub="Qutrub Knife",
    sub="Wind Knife +1",
    ear="Reraise Earring",
    }

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal','Club', 'Staff', 'MaxAcc', 'Shield')
    state.HybridMode:options('Normal', 'MaxAcc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @w gs c toggle WeaponLock')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.CapacityMantle  = { back="Mecistopins Mantle" }

    sets.precast.FC = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Incantor Stone",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Inyanga Jubbah +1",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Aya. Cosciales +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    left_ear="Loquac. Earring",
    right_ear="Malignance Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        head="Umuthi Hat",
        neck="Nodens Gorget",
        waist="Siegel Sash",})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pant. +1",})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    legs="Ebers Pant. +1",
    left_ear="Mendi. Earring",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    })
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {}
    sets.precast.JA['Afflatus Solace'] = {back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
    sets.precast.WS = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Caro Necklace",
        waist="Grunfeld Rope",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Brutal Earring",
        left_ring="Freke Ring",
        right_ring="Epaminondas's Ring",
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
        right_ring="Epaminondas's Ring",
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
            left_ring="Epaminondas's Ring",
            right_ring="Freke Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},}

        sets.precast.WS['Cataclysm'] = {
            ammo="Pemphredo Tathlum",
            head="Pixie Hairpin +1",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Baetyl Pendant",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Friomisi Earring",
            left_ring="Epaminondas's Ring",
            right_ring="Archon Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
        }
        
     sets.precast.WS['Black Halo'] = {
        ammo="Crepuscular Pebble",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Caro Necklace",
        waist="Luminary Sash",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Epaminondas's Ring",
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
    -- Midcast Sets
    
    sets.midcast.FastRecast = {

    }
    sets.midcast.Resistant = {
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
        sub="Genmei Shield",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
        hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Halasz Earring",
        left_ring="Evanescence Ring",
        right_ring="Freke Ring",
        back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},
    }
    
    -- Cure sets
    gear.default.obi_waist = "Hachirin-no-Obi"
    gear.default.obi_back = "Alaunus's Cape"

    sets.midcast.CureSolace = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
    legs="Ebers Pant. +1",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Nodens Gorget",
    waist="Hachirin-no-Obi",
    left_ear="Mendi. Earring",
    right_ear="Nourish. Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}

    sets.midcast.Cure = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +1",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist="Hachirin-no-Obi",
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}

    sets.midcast.Curaga = { main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +1",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist="Hachirin-no-Obi",
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back="Solemnity Cape",}

    sets.midcast.CureMelee = {}

    sets.midcast.Cursna = {
        ammo="Pemphredo Tathlum",
        body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        neck="Debilis Medallion",
        waist="Gishdubar Sash",
        left_ring="Haoma's Ring",
        right_ring="Haoma's Ring",
        back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},
    }
    sets.midcast.Refresh = {waist="Gishdubar Sash",}

    sets.midcast.StatusRemoval = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Debilis Medallion",
        left_ring="Ephedra Ring",
        right_ring="Haoma's Ring",
        back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},    }

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands="Inyan. Dastanas +2",
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Gifted Earring",
    right_ring="Stikini Ring",
    left_ring="Stikini Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}

    sets.midcast.Stoneskin = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        hands="Inyan. Dastanas +2",
        neck="Nodens Gorget",
        waist="Siegel Sash",
        left_ear="Andoaa Earring",
        right_ear="Gifted Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
    sets.midcast.Blink = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
        hands="Inyan. Dastanas +2",
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Andoaa Earring",
        right_ear="Gifted Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
    sets.midcast.Aquaveil = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Gifted Earring",
        left_ear="Andoaa Earring",
        left_ring="Mephitas's Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Auspice = sets.midcast['Enhancing Magic']

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
    main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    ammo="Pemphredo Tathlum",
    hands="Inyan. Dastanas +2",
    neck="Nodens Gorget",
    legs="Ebers Pant. +1",
    left_ear="Andoaa Earring",
    right_ring="Stikini Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},
    })

    sets.midcast.Regen =set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        ammo="Incantor Stone",
        head="Inyanga Tiara +2",
        waist="Embla Sash",    })

    sets.midcast.Protectra = sets.midcast['Enhancing Magic']
    sets.midcast.Shellra = sets.midcast['Enhancing Magic']


    sets.midcast['Divine Magic'] = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head="Inyanga Tiara +2",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Inyan. Dastanas +2",
    legs="Ebers Pant. +1",
    feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
    neck="Erra Pendant",
    waist="Kobo Obi",
    left_ear="Malignance Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast['Dark Magic'] = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head="Inyanga Tiara +2",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Inyan. Dastanas +2",
    legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
    feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
    neck="Erra Pendant",
    waist="Luminary Sash",
    left_ear="Malignance Earring",
    right_ear="Crep. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    -- Custom spell classes
    sets.midcast.MndEnfeebles = sets.midcast['Divine Magic']
    sets.midcast.IntEnfeebles = sets.midcast['Dark Magic']
    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        head="Befouled Crown",
		body="Shamash Robe",
		hands="Aya. Manopolas +2",
		legs="Assid. Pants +1",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Fucho-no-Obi",
		left_ear="Infused Earring",
		left_ring="Stikini Ring +1",
		right_ring="Inyanga Ring",
    }
    

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
        sub="Genmei Shield",
        ammo="Incantor Stone",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        feet="Inyan. Crackows +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Fucho-no-Obi",
        left_ear="Genmei Earring",
        right_ear="Etiolation Earring",
        left_ring="Stikini Ring +1",
        right_ring="Inyanga Ring",
        back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},
    }
    

    sets.idle.PDT = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Incantor Stone",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Shamash Robe",
    hands="Inyan. Dastanas +2",
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Fucho-no-Obi",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Inyanga Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}

    sets.idle.Town = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Incantor Stone",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Shamash Robe",
    hands="Inyan. Dastanas +2",
    legs="Assid. Pants +1",
    feet="Herald's Gaiters",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Fucho-no-Obi",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Inyanga Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}
    
    sets.idle.Weak = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Incantor Stone",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Shamash Robe",
    hands="Inyan. Dastanas +2",
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Fucho-no-Obi",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Inyanga Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}
    
    -- Defense sets

    sets.defense.PDT = {
        main="Malignance Pole",
        sub="Vivid Strap",
        ammo="Incantor Stone",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Fucho-no-Obi",
        left_ear="Genmei Earring",
        right_ear="Etiolation Earring",
        left_ring="Defending Ring",
        right_ring="Inyanga Ring",
        back="Solemnity Cape",
}

    sets.defense.MDT = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Warder's Charm +1",
    waist="Fucho-no-Obi",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Archon Ring",
    back={ name="Alaunus's Cape", augments={'MP+54','Eva.+20 /Mag. Eva.+20','MP+6','"Cure" potency +10%',}},}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Lissome Necklace",
        waist="Grunfeld Rope",
        left_ear="Brutal Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Petrov Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.Club = {
        main="Maxentius",
        sub="Genmei Shield",
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Lissome Necklace",
        waist="Grunfeld Rope",
        left_ear="Brutal Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Petrov Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.Staff = {
        main="Malignance Pole",
        sub="Enki Strap",
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Lissome Necklace",
        waist="Windbuffet Belt +1",
        left_ear="Brutal Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Petrov Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.MaxAcc = {
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Subtlety Spec.",
        waist="Olseni Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.MaxAcc.Staff = {
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Subtlety Spec.",
        waist="Olseni Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.MaxAcc.Club = {
        ammo="Amar Cluster",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Subtlety Spec.",
        waist="Olseni Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.engaged.Shield = {
            main="Maxentius",
            sub="Genmei Shield",
            ammo="Amar Cluster",
            head="Aya. Zucchetto +2",
            body="Ayanmo Corazza +2",
            hands="Bunzi's Gloves",
            legs="Aya. Cosciales +2",
            feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck="Lissome Necklace",
            waist="Grunfeld Rope",
            left_ear="Brutal Earring",
            right_ear="Telos Earring",
            left_ring="Chirich Ring +1",
            right_ring="Defending Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {back="Mending Cape"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
    
    if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
       -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
       if state.CapacityMode.value then
        equip(sets.CapacityMantle)
    end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
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

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end
end


-- Function to display the current relevant user state when doing an update.
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

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
add_to_chat(159,'Author Aragan WHM.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(5, 33)
end

