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

end
organizer_items = {
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
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
    state.Moving  = M(false, "moving")
    send_command('wait 6;input /lockstyleset 178')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'MaxAcc', 'Shield')
    state.HybridMode:options('Normal', 'SubtleBlow' , 'PDT')
    state.CastingMode:options('Normal', 'ConserveMP', 'SIRD', 'Duration', 'Enmity')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')
    state.PhysicalDefenseMode:options('PDT','DT','HP', 'Evasion', 'MP')
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    send_command('bind f3 @input /ja "Sublimation" <me>')
    send_command('bind f4 input //Sublimator')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('wait 2;input /lockstyleset 178')
    send_command('bind f1 gs c cycle HippoMode')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells
    sets.CapacityMantle  = { }

    sets.precast.FC = {

    ammo="Sapience Orb",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Inyanga Jubbah +2",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Aya. Cosciales +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Baetyl Pendant",
    left_ear="Loquac. Earring",
    right_ear="Malignance Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    back="Alaunus's Cape",}
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        head="Umuthi Hat",
        neck="Nodens Gorget",
        waist="Siegel Sash",})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pant. +2",})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {

    legs="Ebers Pant. +2",
    left_ear="Mendi. Earring",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    })
    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    -- CureMelee spell map should default back to Healing Magic.
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {}
    sets.precast.JA['Afflatus Solace'] = {back="Alaunus's Cape",}
    sets.precast.JA['Sublimation'] = {
        waist="Embla Sash",
    }
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    gear.default.weaponskill_neck = ""
    gear.default.weaponskill_waist = ""
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
        right_ear="Brutal Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    
    sets.precast.WS['Flash Nova'] = {
        ammo="Oshasha's Treatise",
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
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        neck="Sanctity Necklace",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Evans Earring",
        left_ring="Mephitas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
        }

        sets.precast.WS['Cataclysm'] = {
            ammo="Oshasha's Treatise",
            head="Pixie Hairpin +1",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Sibyl Scarf",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Friomisi Earring",
            right_ring="Cornelia's Ring",
            left_ring="Archon Ring",
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
        left_ear="Malignance Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Judgment'] = {
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

    sets.precast.WS['Realmrazer'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Malignance Earring",
        right_ear="Telos Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
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
        left_ear="Malignance Earring",
        right_ear="Brutal Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['True Strike'] = {
        ammo="Crepuscular Pebble",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Nyame Flanchard",
        feet="Aya. Gambieras +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Mache Earring +1",
        right_ear="Mache Earring +1",
        left_ring="Rufescent Ring",
        right_ring="Hetairoi Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Hexa Strike'] = {
        ammo="Crepuscular Pebble",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Nyame Flanchard",
        feet="Aya. Gambieras +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Mache Earring +1",
        right_ear="Mache Earring +1",
        left_ring="Rufescent Ring",
        right_ring="Hetairoi Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS.Dagan = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Ebers Bliaut +2",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Inyanga Shalwar +2",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Nodens Gorget",
        waist="Luminary Sash",
        left_ear="Andoaa Earring",
        right_ear="Halasz Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Mephitas's Ring",
        back="Alaunus's Cape",
    }
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        ammo="Staunch Tathlum +1",
        hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
        legs="Bunzi's Pants",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Rumination Sash",
        right_ear="Halasz Earring",
        left_ring="Freke Ring",
        right_ring="Evanescence Ring",
    }
    sets.midcast.SIRD = {
        ammo="Staunch Tathlum +1",
        sub="Culminus",
        hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
    }
    sets.ConserveMP = {    
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist="Austerity Belt +1",
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Haoma's Ring",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",}
    
    sets.Duration = {
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        waist="Embla Sash",

    }
    -- Cure sets
    sets.Obi = {waist="Hachirin-no-Obi", back="Twilight Cape"}
    

    sets.midcast.CureSolace = {
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Ebers Bliaut +2",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Cleric's Torque",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Glorious Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back="Alaunus's Cape",}

    sets.midcast.CureSolace.SIRD = set_combine(sets.midcast.CureSolace, {
        ammo="Staunch Tathlum +1",
        sub="Culminus",
        hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
})

    sets.midcast.CureSolace.ConserveMP = set_combine(sets.midcast.CureSolace, {   
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Haoma's Ring",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.CureSolace.Enmity = set_combine(sets.midcast.CureSolace, {  

    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Pinga Tunic",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Pinga Pants",
    feet="Bunzi's Sabots",
    neck="Clotharius Torque",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Glorious Earring",
    right_ear="Ebers Earring",
    left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Cure = {

    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Cleric's Torque",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Glorious Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back="Alaunus's Cape",}

    sets.midcast.Cure.SIRD = set_combine(sets.midcast.Cure, {
        main="Daybreak",
        sub="Culminus",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
        legs="Ebers Pant. +2",
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Mendi. Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Defending Ring",
        back="Alaunus's Cape",
})

    sets.midcast.Cure.ConserveMP = set_combine(sets.midcast.Cure, { 
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Haoma's Ring",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Cure.Enmity = set_combine(sets.midcast.Cure, {  

        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Pinga Tunic",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Pinga Pants",
        feet="Bunzi's Sabots",
        neck="Clotharius Torque",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Glorious Earring",
        right_ear="Ebers Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
        back="Solemnity Cape",})

    sets.midcast.Curaga = {
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Ebers Bliaut +2",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Cleric's Torque",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Glorious Earring",
    left_ring="Naji's Loop",
    right_ring="Mephitas's Ring",
    back="Alaunus's Cape",
}

    sets.midcast.Curaga.SIRD = set_combine(sets.midcast.Curaga, {
    main="Daybreak",
    sub="Culminus",
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Ros. Jaseran +1", augments={'Path: A',}},
    hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
    legs="Ebers Pant. +2",
    feet="Theo. Duckbills +3",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Mendi. Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Mephitas's Ring +1",
    right_ring="Defending Ring",
    back="Alaunus's Cape",

    })

    sets.midcast.Curaga.ConserveMP = set_combine(sets.midcast.Curaga, {   

    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Gifted Earring",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Curaga.Enmity = set_combine(sets.midcast.Curaga, {  

        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Pinga Tunic",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Pinga Pants",
        feet="Bunzi's Sabots",
        neck="Clotharius Torque",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Glorious Earring",
        right_ear="Ebers Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
        back="Alaunus's Cape",
    })

    sets.midcast.CureMelee = {}

    --cure weather day

    sets.midcast.CureSolaceWeather = set_combine(sets.midcast.CureSolace, {
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
    })

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
    })

    sets.midcast.CuragaWeather = set_combine(sets.midcast.Curaga, {
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
    })
    sets.midcast.CuragaWeather.SIRD = set_combine(sets.midcast.CuragaWeather,sets.SIRD) 


    sets.midcast.Cursna = {
        ammo="Pemphredo Tathlum",
        body="Ebers Bliaut +2",
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        neck="Debilis Medallion",
        waist="Gishdubar Sash",
        left_ring="Haoma's Ring",
        right_ring="Haoma's Ring",
        back="Alaunus's Cape",
    }
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash",})
    sets.midcast.Refresh.Duration = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash",})

    sets.midcast.StatusRemoval = {

        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Ebers Bliaut +2",
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        legs="Ebers Pant. +2",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Cleric's Torque",
        left_ring="Haoma's Ring",
        right_ring="Haoma's Ring",
        back="Alaunus's Cape",    }
        sets.midcast.StatusRemoval.SIRD = set_combine(sets.midcast.StatusRemoval,sets.SIRD) 

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {

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
    sets.midcast['Enhancing Magic'].SIRD = set_combine(sets.midcast['Enhancing Magic'],sets.SIRD) 
    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Stoneskin = {

        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Nodens Gorget",
        waist="Siegel Sash",
        left_ear="Andoaa Earring",
        right_ear="Gifted Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
        sets.midcast.Stoneskin.SIRD = set_combine(sets.midcast.Stoneskin,sets.SIRD) 
        sets.midcast.Stoneskin.Duration = set_combine(sets.midcast.Stoneskin,sets.Duration) 

    sets.midcast.Blink = {

        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Andoaa Earring",
        right_ear="Gifted Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
        sets.midcast.Blink.SIRD = set_combine(sets.midcast.Blink,sets.SIRD) 
        sets.midcast.Blink.Duration = set_combine(sets.midcast.Blink,sets.Duration) 


    sets.midcast.Aquaveil = {

        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Regal Cuffs",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Gifted Earring",
        left_ear="Andoaa Earring",
        left_ring="Mephitas's Ring",
        right_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Aquaveil.SIRD = set_combine(sets.midcast.Aquaveil,sets.SIRD)
    sets.midcast.Aquaveil.Duration = set_combine(sets.midcast.Aquaveil,sets.Duration) 

    sets.midcast.Haste = set_combine(sets.midcast['Enhancing Magic'])
    sets.midcast.Haste.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Auspice = sets.midcast['Enhancing Magic']
    sets.midcast.Auspice.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Telchine Gloves",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    neck="Incanter's Torque",
    waist="Embla Sash",
    left_ear="Andoaa Earring",
    right_ring="Stikini Ring",
    back="Alaunus's Cape",
    })
    sets.midcast.BarElement.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Regen =set_combine(sets.midcast['Enhancing Magic'], {

        ammo="Sapience Orb",
        head="Inyanga Tiara +2",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        waist="Embla Sash",})
    sets.midcast.Regen.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Protectra = sets.midcast['Enhancing Magic']
    sets.midcast.Shellra = sets.midcast['Enhancing Magic']

    sets.midcast['Divine Magic'] = {

    ammo="Pemphredo Tathlum",
    head="Inyanga Tiara +2",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Inyan. Dastanas +2",
    legs="Ebers Pant. +2",
    feet="Bunzi's Sabots",
    neck="Erra Pendant",
    waist="Luminary Sash",
    right_ear="Malignance Earring",
    left_ear="Regal Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.midcast.Repose = set_combine(sets.midcast['Divine Magic'], {
        hands="Regal Cuffs",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
        waist="Obstin. Sash",
        left_ear="Regal Earring",
        right_ear={ name="Ebers Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+10','Mag. Acc.+10',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    })

    sets.midcast['Divine Magic'].Holy = set_combine(sets.midcast['Divine Magic'], {

    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    body={ name="Cohort Cloak +1", augments={'Path: A',}},
    hands="Bunzi's Gloves",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet="Bunzi's Sabots",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Regal Earring",
    right_ear="Malignance Earring",
    left_ring="Stikini Ring +1",
    right_ring="Freke Ring",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }) 
    sets.midcast['Holy II'] = set_combine(sets.midcast['Divine Magic'].Holy, {})

    sets.midcast['Divine Magic'].Banish = set_combine(sets.midcast['Divine Magic'], {

        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet="Bunzi's Sabots",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Luminary Sash",
		left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Stikini Ring +1",
        right_ring="Freke Ring",
        back="Disperser's Cape",
    }) 
    sets.midcast['Banish II'] = set_combine(sets.midcast['Divine Magic'].Banish, {})
    sets.midcast['Banish III'] = set_combine(sets.midcast['Divine Magic'].Banish, {})

    sets.midcast['Banishga'] = set_combine(sets.midcast['Divine Magic'].Banish, {})
    sets.midcast['Banishga II'] = set_combine(sets.midcast['Divine Magic'].Banish, {})



    sets.midcast['Dark Magic'] = {

    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Vanya Robe", augments={'HP+50','MP+50','"Refresh"+2',}},
    hands="Inyan. Dastanas +2",
    legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
    feet={ name="Medium's Sabots", augments={'MP+25','MND+2','"Conserve MP"+3',}},
    neck="Erra Pendant",
    waist="Fucho-no-Obi",
    right_ear="Malignance Earring",
    left_ear="Regal Earring",
    ring1="Evanescence Ring",
    ring2="Archon Ring",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    -- Custom spell classes
    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Divine Magic'], {
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Regal Cuffs",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
        waist="Obstin. Sash",
        left_ear="Regal Earring",
        right_ear={ name="Ebers Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+10','Mag. Acc.+10',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    })
    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Dark Magic'], {
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Regal Cuffs",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','MND+7','"Mag.Atk.Bns."+10',}},
        waist="Obstin. Sash",
        left_ear="Regal Earring",
        right_ear={ name="Ebers Earring", augments={'System: 1 ID: 1676 Val: 0','Accuracy+10','Mag. Acc.+10',}},
        left_ring="Stikini Ring +1",
        right_ring="Kishar Ring",
    })
    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {        ammo="Homiliary",
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
        ammo="Homiliary",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Inyan. Dastanas +2",
        legs="Assid. Pants +1",
        feet="Inyan. Crackows +2",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Genmei Earring",
        right_ear="Etiolation Earring",
        left_ring="Stikini Ring +1",
        right_ring="Inyanga Ring",
        back="Alaunus's Cape",
    }
    
    sets.idle.PDT = {
        main="Malignance Pole",
        sub="Enki Strap",
        ammo="Homiliary",
        head="Befouled Crown",
        body="Shamash Robe",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Assid. Pants +1",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Etiolation Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Alaunus's Cape",}
    
    sets.idle.Refresh = {
    ammo="Homiliary",
    head="Befouled Crown",
    body="Shamash Robe",
    hands="Inyan. Dastanas +2",
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Alaunus's Cape",}

    sets.defense.MP = {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Ebers Bliaut +2",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Inyanga Shalwar +2",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Nodens Gorget",
        waist="Luminary Sash",
        left_ear="Andoaa Earring",
        right_ear="Halasz Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Mephitas's Ring",
        back="Alaunus's Cape",
    }
    
    sets.idle.Town = {
    feet="Herald's Gaiters",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    }
    
    sets.idle.Weak = {
    ammo="Homiliary",
    head="Befouled Crown",
    body="Shamash Robe",
    hands="Inyan. Dastanas +2",
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Inyanga Ring",
    back="Alaunus's Cape",}
    
    -- Defense sets

    sets.defense.PDT = {
        main="Daybreak",
        sub="Culminus",
        ammo="Staunch Tathlum +1",
        head="Befouled Crown",
        body="Shamash Robe",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs="Assid. Pants +1",
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Genmei Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Alaunus's Cape",}
    sets.defense.Evasion = {
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
        left_ring="Defending Ring",
        right_ring="Vengeful Ring",
        back="Alaunus's Cape",
    }
    sets.defense.DT = {
        ammo="Eluder's Sachet",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Fortified Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Alaunus's Cape",
    }
    sets.defense.HP = {
        ammo="Eluder's Sachet",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Ilabrat Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.defense.MDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Shamash Robe",
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Shadow Ring",
    back="Alaunus's Cape",}

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.MoveSpeed = {feet="Herald's Gaiters"}
    sets.Adoulin = {body="Councilor's Garb",}

    sets.latent_refresh = {waist="Fucho-no-obi",}

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
        feet="Battlecast Gaiters",
        neck="Lissome Necklace",
        waist="Cornelia's Belt",
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
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
        waist="Cornelia's Belt",
        left_ear="Brutal Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Defending Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
}
    sets.engaged.SubtleBlow = set_combine(sets.engaged, {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Digni. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.engaged.SubtleBlow.Shield = set_combine(sets.engaged.Shield, {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Bunzi's Gloves",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Digni. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",
    })
    sets.engaged.SubtleBlow.MaxAcc = set_combine(sets.engaged.MaxAcc, {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Digni. Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.engaged.PDT = set_combine(sets.engaged, {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Bunzi's Gloves",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        back="Moonlight Cape",
    })
    sets.engaged.PDT.MaxAcc = set_combine(sets.engaged.MaxAcc, {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Bunzi's Gloves",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        back="Moonlight Cape",
    })
    sets.engaged.PDT.Shield = set_combine(sets.engaged.Shield, {
        sub="Ammurapi Shield",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Bunzi's Gloves",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        back="Moonlight Cape",
    })

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {back="Mending Cape"}
    sets.buff.Sublimation = {waist="Embla Sash"}

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
    
    --[[if spell.skill == 'Healing Magic' then
        gear.default.obi_back = "Mending Cape"
    else
        gear.default.obi_back = "Toro Cape"
    end
       -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
       if state.CapacityMode.value then
        equip(sets.CapacityMantle)
    end]]
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        elseif spell.skill == 'Enhancing Magic' then
            equip(sets.SIRD)
        end
    end
end
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spell.action_type == 'Magic' then
        if state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        end
    end
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
    if spellMap == 'Banish' or spellMap == "Holy" then
        if (world.weather_element == 'Light' or world.day_element == 'Light') then
            equip(sets.Obi)
    elseif state.MagicBurst.value then
            equip(sets.magic_burst)
        end
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 178')
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
    handle_equipping_gear(player.status)
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if player.status == 'Engaged' then
            disable('main','sub')
        else
            enable('main','sub')
        end        
        --[[if default_spell_map == 'Cure' then
            if buffactive['Afflatus Solace'] then
                if (world.weather_element == 'Light' or world.day_element == 'Light') then
                    return "CureSolaceWeather"
                else
                    return "CureSolace"
              end
            else
                if (world.weather_element == 'Light' or world.day_element == 'Light') then
                    return "CureWeather"
                else
                    return "Cure"
              end
            end
        elseif default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return "CuragaWeather"
            else
                return "Curaga"
            end
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end]]
    end
end


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
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
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
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
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 13)
end

