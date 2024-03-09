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

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
    organizer_items  = {
        "Molybdosis",
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
        "Prime Sword",
        "Earp",
        "Mafic Cudgel",
        "Living Bullet",
        "Decimating Bullet",
        "Chrono Bullet",
        "Trump Card Case",
        "Trump Card",
        "Chr. Bul. Pouch", 
        "Liv. Bul. Pouch", 
        "Dec. Bul. Pouch",
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
        "Reraise Earring",
    }
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    state.WeaponLock = M(false, 'Weapon Lock')
    state.Moving  = M(false, "moving")
    state.RP = M(false, "Reinforcement Points Mode")  
    state.CapacityMode = M(false, 'Capacity Point Mantle')  
    -- Whether a warning has been given for low ammo
    state.warned = M(false)
    include('Mote-TreasureHunter')
    send_command('wait 6;input /lockstyleset 151')
    define_roll_values()
    send_command('lua l AutoCOR')
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Wh. Rarab Cap +1",
    "Dev. Bul. Pouch", "Chr. Bul. Pouch", "Liv. Bul. Pouch", "Cumulus Masque +1", "Airmid's Gorget",}
    elemental_ws = S{"Aeolian Edge", "Leaden Salute", "Wildfire"}
    no_shoot_ammo = S{"Animikii Bullet", "Hauksbok Bullet"}
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    state.QDMode = M{['description']='Quick Draw Mode', 'STP', 'Enhance', 'Potency', 'TH'}

end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.GunMode = M{['description']='Gun Mode', 'normal','DeathPenalty', 'Anarchy', 'Fomalhaut', 'Earp'} -- , 'Priwen', 'Anarchy_+2' }

    state.OffenseMode:options('Normal', 'Acc', 'STP', 'Ranged', 'CRIT')
    state.RangedMode:options('Normal', 'Molybdosis', 'Acc', 'MaxAcc', 'STP', 'NOENMITY', 'Critical')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Evasion', 'Refresh')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')
    state.MagicalDefenseMode:options('MDT')
    swordList = S{"Naegling", "Demers. Degen +1"}
    daggerList = S{"Tauret", "Demers. Degen +1"}
    sub_weapons = S{"Sangarius +1", "Usonmunku", "Perun 1+", "Tanmogayi +1", "Reikiko", "Digirbalag", "Twilight Knife",
    "Kustawi +1", "Zantetsuken", "Excalipoor II", "Warp Cudgel", "Qutrub Knife", "Wind Knife +1", "Firetongue", "Nihility",
        "Extinction", "Heartstopper +1", "Twashtar", "Aeneas", "Gleti's Knife", "Naegling", "Tauret", "Caduceus", "Loxotic Mace +1",
        "Debahocho +1", "Dolichenus", "Arendsi Fleuret", "Demers. Degen +1", "Ternion Dagger +1", "Blurred Knife +1",}
    state.WeaponSet = M{['description']='Weapon Set', 'normal', 'SWORDS', 'DAGGERS',}
    state.Weapongun = M{['description']='Weapon Set', 'normal', 'DeathPenalty', 'Anarchy', 'Fomalhaut', 'Earp'}

    gear.RAbullet = "Decimating Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Living Bullet"
    gear.QDbullet = "Living Bullet"
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind @q gs c cycle QDMode')
    send_command('bind ^numlock input /ja "Triple Shot" <me>')
    send_command('wait 2;input /lockstyleset 151')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('bind f7 gs c cycle Weapongun')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind !- gs c toggle RP')  

    state.Auto_Kite = M(false, 'Auto_Kite')

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false

    determine_haste_group()
    update_combat_form()
    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^numlock')
    send_command('unbind !w')

end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------


    sets.normal = {}
    sets.SWORDS = {main="Naegling", sub="Demers. Degen +1"}
    sets.DAGGERS = {main="Tauret", sub="Gleti's Knife"}

    sets.normal = {}
    sets.DeathPenalty = {range="Death Penalty"}
    sets.Anarchy = {range="Anarchy +2"}
    sets.Fomalhaut = {range="Fomalhaut"}
    sets.Earp = {range="Earp"}

    sets.DefaultShield = {sub="Nusku Shield"}
    sets.FullTP = {ear1="Crematio Earring"}

    -- Precast Sets

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Snake Eye'] = {}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +3"}

    
    sets.precast.CorsairRoll = {
    main={ name="Rostam", augments={'Path: C',}},
    range={ name="Compensator", augments={'DMG:+9','Rng.Acc.+9','Rng.Atk.+9',}},
    head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
    hands="Chasseur's Gants +3",
    neck="Regal Necklace",
    right_ring="Luzaf's Ring",
    back="Camulus's Mantle",}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +3",})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +2"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +2",})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +2",})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +3",})
    
    sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},}
    
    --sets.precast.CorsairShot = {}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Mummu Bonnet +2",    
        body="Passion Jacket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
    }
    sets.TreasureHunter = { 
        --ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {
    head="Mummu Bonnet +2",    
    body="Passion Jacket",
    }

    -- Fast cast sets for spells
    
    sets.precast.FC = {    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    left_ear="Etiolation Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
}
sets.precast.JA.Jump = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Olseni Belt",
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}
sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Olseni Belt",
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",}) 
sets.precast.JA['Super Jump'] = sets.precast.JA.Jump

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket",})


    sets.precast.RA = {
        hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
        head="Chass. Tricorne +2",
        body="Oshosi Vest",
        legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
    feet="Meg. Jam. +2",
    waist="Yemaya Belt",
    back="Tactical Mantle",
}

sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
    body="Laksa. Frac +3", --0/20
    }) --47/52

sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    head="Chass. Tricorne +2",
    body="Laksa. Frac +3",
 legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}},
 feet="Meg. Jam. +2",
 waist="Yemaya Belt",
 back="Tactical Mantle",
    }) --32/73


       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Nyame Helm",
        body="Laksa. Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Camulus's Mantle",
    }
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        body="Ikenga's Vest",
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
    sets.precast.WS['Evisceration'] = sets.precast.WS, {
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mummu Jacket +2",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Mummu Gamash. +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    right_ear="Odr Earring",
    left_ring="Ilabrat Ring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
    }
    sets.precast.WS['Evisceration'].PDL = sets.precast.WS['Evisceration'], {
        body="Ikenga's Vest",
        right_ear="Mache Earring +1",
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        head="Nyame Helm",
		body="Nyame Mail",
        hands="Chasseur's Gants +3",
        legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Rep. Plat. Medal",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back="Camulus's Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
        body="Ikenga's Vest",
		left_ring="Sroda Ring", 
        waist="Kentarch Belt +1",
	})

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
		head="Nyame Helm",
        body="Lanun Frac +3",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back="Camulus's Mantle",
    })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Telos Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Rufescent Ring",
        back="Bleating Mantle",
})

    sets.precast.WS['Last Stand'] = {
    ammo=gear.WSbullet,
    head={ name="Lanun Tricorne +3", augments={'Enhances "Winning Streak" effect',}},
    body="Ikenga's Vest",
    hands="Chasseur's Gants +3",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck="Rep. Plat. Medal",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Regal Ring",
    back="Camulus's Mantle",
    }

    sets.precast.WS['Last Stand'].PDL = set_combine(sets.precast.WS['Last Stand'], {
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Ikenga's Vest",
    legs="Ikenga's Trousers",
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Sroda Ring", 
    right_ring="Cornelia's Ring",
    back="Camulus's Mantle",
    })


    sets.precast.WS['Wildfire'] = {
        ammo=gear.MAbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Hecate's Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back="Camulus's Mantle",
}
    sets.precast.WS['Hot Shot'] = set_combine(sets.precast.WS['Wildfire'],  {  
    hands="Chasseur's Gants +3",})

    sets.precast.WS['Leaden Salute'] = {     
    ammo=gear.MAbullet,
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck="Baetyl Pendant",
    waist="Svelt. Gouriz +1",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back="Camulus's Mantle",
}
    
    sets.precast.WS['Leaden Salute'].Acc = {   
    ammo=gear.RAbullet,
    head="Pixie Hairpin +1",
    body="Lanun Frac +3",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
    neck="Baetyl Pendant",
    waist="Svelt. Gouriz +1",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Cornelia's Ring",
    back="Camulus's Mantle",
    }

    -- Midcast Sets
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        hands="Rawhide Gloves", --15
        legs="Carmine Cuisses +1", --20
        neck="Loricate Torque +1", --5
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
    sets.midcast.CorsairShot = {
        ammo=gear.QDbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet={ name="Lanun Bottes +3", augments={'Enhances "Wild Card" effect',}},
        neck="Baetyl Pendant",
        waist="Skrymir Cord",
        left_ear="Friomisi Earring",
        right_ear="Crematio Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back="Camulus's Mantle",
}

    sets.midcast.CorsairShot.Acc = {
        ammo=gear.QDbullet,
        head="Nyame Helm",
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Chass. Bottes +2",
        neck="Baetyl Pendant",
        waist="Skrymir Cord",
        left_ear="Friomisi Earring",
        right_ear="Crematio Earring",
        left_ring="Dingir Ring",
        right_ring="Cornelia's Ring",
        back="Camulus's Mantle",
}
    sets.midcast.CorsairShot.STP = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        waist="Kentarch Belt +1",
        back="Tactical Mantle",

        }
    sets.midcast.CorsairShot['Light Shot'] = {
        ammo=gear.QDbullet,
        head="Malignance Chapeau",
        body="Laksa. Frac +3",
        hands="Malignance Gloves",
        legs="Chas. Culottes +3",
        feet="Chass. Bottes +2",
        neck="Sanctity Necklace",
        waist="Eschan Stone",
        left_ear="Crep. Earring",
        right_ear="Chas. Earring +1",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Camulus's Mantle",
}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']
    sets.midcast.CorsairShot.Enhance = {feet="Chass. Bottes +2"}


    -- Ranged gear
sets.midcast.RA = {
    ammo=gear.RAbullet,
    head="Ikenga's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Dingir Ring",
    right_ring="Ilabrat Ring",
    back="Tactical Mantle",
}

    sets.midcast.RA.Molybdosis = {
    ammo=gear.RAbullet,
    head="Ikenga's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Enervating Earring",
    right_ear="Telos Earring",
    left_ring="Dingir Ring",
    right_ring="Ilabrat Ring",
    back="Tactical Mantle",
}
sets.midcast.RA.Acc = {
    ammo=gear.RAbullet,
    head="Malignance Chapeau",
    body="Laksa. Frac +3",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    right_ring="Regal Ring",
    back="Tactical Mantle",
}
sets.midcast.RA.MaxAcc = {
    ammo=gear.WSbullet,
    head="Malignance Chapeau",
    body="Laksa. Frac +3",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Yemaya Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Regal Ring",
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back="Tactical Mantle",
}
sets.midcast.RA.STP = {
    ammo=gear.RAbullet,
    head="Ikenga's Hat",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Gerdr Belt",
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}
sets.midcast.RA.NOENMITY = set_combine(sets.midcast.RA, {

    head="Ikenga's Hat",
    body="Ikenga's Vest",
    hands="Ikenga's Gloves",
    legs="Ikenga's Trousers",
    feet="Osh. Leggings +1",
    neck="Iskur Gorget",
    right_ear="Enervating Earring",
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back="Tactical Mantle",
})
sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
    ammo=gear.WSbullet,
    head="Meghanada Visor +2",
    body="Nisroch Jerkin",
    hands="Chasseur's Gants +3",
    legs="Mummu Kecks +2",
    feet="Osh. Leggings +1",
    neck="Iskur Gorget",
    waist="Gerdr Belt",
    left_ear="Odr Earring",
    right_ear="Chas. Earring +1",
    left_ring="Mummu Ring",
    right_ring="Dingir Ring",
    back="Camulus's Mantle",

})

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        head="Meghanada Visor +2",
        body="Meg. Cuirie +2",
        hands="Meg. Gloves +2",
        legs="Meg. Chausses +2",
        feet="Meg. Jam. +2",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets
    sets.idle = {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Odnowa Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
        }

        sets.idle.Evasion = set_combine(sets.idle, {
            head="Malignance Chapeau",
            body="Malignance Tabard",
            hands="Malignance Gloves",
            legs="Malignance Tights",
            feet="Malignance Boots",
            neck={ name="Bathy Choker +1", augments={'Path: A',}},
            waist="Svelt. Gouriz +1",
            left_ear="Infused Earring",
            right_ear="Eabani Earring",
            left_ring="Defending Ring",
            right_ring="Vengeful Ring",
            back="Camulus's Mantle",
        })
        sets.idle.Town ={legs="Carmine Cuisses +1",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",}
    
    -- Defense sets
sets.defense.PDT = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Paguroidea Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}

sets.defense.MDT = {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Shadow Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.defense.Evasion =  {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Svelt. Gouriz +1",
    left_ear="Infused Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring="Vengeful Ring",
    back="Camulus's Mantle",
}
    
    sets.Adoulin = {body="Councilor's Garb",
       legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
    sets.MoveSpeed = {legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
    sets.Kiting = {legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group


sets.engaged = {
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Iskur Gorget",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Petrov Ring",
    back="Tactical Mantle",
    }
sets.engaged.Acc = {
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Iskur Gorget",
    waist="Kentarch Belt +1",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    ring1="Chirich Ring +1",
    ring2="Chirich Ring +1",
    back="Tactical Mantle",
    }
sets.engaged.CRIT = {
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Mummu Jacket +2",
    hands="Mummu Wrists +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Mummu Gamash. +2",
    neck="Nefarious Collar +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Brutal Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back="Annealed Mantle",
    }
        sets.engaged.Ranged = {    
        head="Malignance Chapeau",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Chas. Culottes +3",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        waist="Windbuffet Belt +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back="Camulus's Mantle",
        }
 
        sets.engaged.STP = set_combine(sets.engaged, {
            left_ear="Dedition Earring",
            ring1="Chirich Ring +1",
            ring2="Chirich Ring +1",
            waist="Kentarch Belt +1",
            })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    --DW cap all set haste capped

        sets.engaged.DW = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        waist="Windbuffet Belt +1",
        left_ear="Suppanomimi",
        right_ear="Telos Earring",
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back="Tactical Mantle",
    }
        sets.engaged.DW.Acc = set_combine(sets.engaged.Acc,{
            waist="Reiki Yotai",
            left_ear="Suppanomimi",
        })
        sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT,{
            waist="Reiki Yotai",
            left_ear="Suppanomimi",
            })
            sets.engaged.DW.Ranged = {    
                head="Malignance Chapeau",
                body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
                hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
                legs="Chas. Culottes +3",
                feet="Malignance Boots",
                neck="Iskur Gorget",
                waist="Windbuffet Belt +1",
                left_ear="Cessance Earring",
                right_ear="Telos Earring",
                left_ring="Epona's Ring",
                right_ring="Petrov Ring",
                back="Camulus's Mantle",
                }
    sets.engaged.DW.STP = set_combine(sets.engaged, {
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        })

    -- No Magic Haste (74% DW to cap)

    ------------------------------------------------------------------------------------------------
      ---------------------------------------- DW-HASTE ------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.engaged.DW.LowHaste = { 
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back="Tactical Mantle",
        } -- 33%
        sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
            body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
            hands="Floral Gauntlets", --5
            legs="Carmine Cuisses +1", --6
            left_ear="Suppanomimi",  --5
            right_ear="Eabani Earring", --4
            waist="Reiki Yotai", --7
            }) -- 33%

        sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
            body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
            hands="Floral Gauntlets", --5
            legs="Carmine Cuisses +1", --6
            left_ear="Suppanomimi",  --5
            right_ear="Eabani Earring", --4
            waist="Reiki Yotai", --7
            }) -- 33%
        sets.engaged.DW.Ranged.LowHaste = set_combine(sets.engaged.DW.Ranged, {
            body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
            hands="Floral Gauntlets", --5
            legs="Carmine Cuisses +1", --6
            left_ear="Suppanomimi",  --5
            right_ear="Eabani Earring", --4
            waist="Reiki Yotai", --7
            }) -- 33%

        sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
            body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
            hands="Floral Gauntlets", --5
            legs="Carmine Cuisses +1", --6
            left_ear="Suppanomimi",  --5
            right_ear="Eabani Earring", --4
            waist="Reiki Yotai", --7
            }) -- 33%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = { 
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Iskur Gorget",
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        left_ring="Epona's Ring",
        right_ring="Petrov Ring",
        back="Tactical Mantle",
        } -- 22%
    sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW.Acc,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%
    sets.engaged.DW.CRIT.MidHaste = set_combine(sets.engaged.DW.CRIT,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%

    sets.engaged.DW.Ranged.MidHaste = set_combine(sets.engaged.DW.Ranged,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%
   sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.STP,{ 
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
        waist="Reiki Yotai", --7
        }) -- 22%

        sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW)
        sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc)
        sets.engaged.DW.CRIT.MaxHaste = set_combine(sets.engaged.DW.CRIT)
        sets.engaged.DW.Ranged.MaxHaste = set_combine(sets.engaged.DW.Ranged)
        sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.STP)
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------
sets.engaged.Hybrid = {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
}
   
sets.engaged.PDT = set_combine(sets.engaged,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})
sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})
sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})
sets.engaged.Ranged.PDT = set_combine(sets.Ranged,{    
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})
sets.engaged.STP.PDT = set_combine(sets.engaged.STP,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})
sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ring="Defending Ring",
})
sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Suppanomimi",
    waist="Reiki Yotai",
    left_ring="Defending Ring",
})
sets.engaged.DW.CRIT.PDT = set_combine(sets.engaged.DW.CRIT,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Suppanomimi",
    waist="Reiki Yotai",
    left_ring="Defending Ring",
})
sets.engaged.DW.Ranged.PDT = set_combine(sets.engaged.DW.Ranged,{    
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Chas. Culottes +3",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ring="Defending Ring",
})

sets.engaged.DW.STP.PDT = set_combine(sets.engaged.DW.STP,{
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Suppanomimi",
    waist="Reiki Yotai",
    left_ring="Defending Ring",
})

        sets.engaged.DW.PDT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Acc.PDT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
        sets.engaged.DW.CRIT.PDT.LowHaste = set_combine(sets.engaged.DW.CRIT.LowHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Ranged.PDT.LowHaste = set_combine(sets.engaged.DW.Ranged.LowHaste, sets.engaged.Hybrid)
        sets.engaged.DW.STP.PDT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

        sets.engaged.DW.PDT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Acc.PDT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)
        sets.engaged.DW.CRIT.PDT.MidHaste = set_combine(sets.engaged.DW.CRIT.MidHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Ranged.PDT.MidHaste = set_combine(sets.engaged.DW.Ranged.MidHaste, sets.engaged.Hybrid)
        sets.engaged.DW.STP.PDT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

        sets.engaged.DW.PDT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Acc.PDT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
        sets.engaged.DW.CRIT.PDT.MaxHaste = set_combine(sets.engaged.DW.CRIT.MaxHaste, sets.engaged.Hybrid)
        sets.engaged.DW.Ranged.PDT.MaxHaste = set_combine(sets.engaged.DW.Ranged.MaxHaste, sets.engaged.Hybrid)
        sets.engaged.DW.STP.PDT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)
-------------

sets.TripleShot = {
    head="Oshosi Mask +1",
    body="Chasseur's Frac +2",
    hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}},
    legs="Osh. Trousers +1",
    feet="Osh. Leggings +1",
    }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

 sets.Doom = {    neck="Nicander's Necklace",
   waist="Gishdubar Sash",
   left_ring="Purity Ring",
   right_ring="Blenmot's Ring +1",}
   sets.RP = {neck="Comm. Charm +2"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs) 
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end
    -- Replace Moonshade Earring if we're at cap TP
    if spell.type == 'Weaponskill' and player.tp == 3000 then
        equip({right_ear="Ishvara Earring"})
    end
    if elemental_ws:contains(spell.name) then
        -- Matching double weather (w/o day conflict).
        if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
        elseif spell.element == world.day_element and spell.element == world.weather_element then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
        elseif spell.element == world.day_element or spell.element == world.weather_element then
            equip({waist="Hachirin-no-Obi"})
        end
    end
    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
    if spell.action_type == 'Ranged Attack' then
        special_ammo_check()
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
    elseif spell.type == 'WeaponSkill' then
        if spell.skill == 'Marksmanship' then
            special_ammo_check()
        end
        -- Replace TP-bonus gear if not needed.
        if spell.english == 'Leaden Salute' or spell.english == 'Aeolian Edge' and player.tp > 2900 then
            equip(sets.FullTP)
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel 445; cancel ; Copy Image; cancel Copy Image (2); cancel Copy Image (3)')
        end
    end
end
function job_buff_change(buff,gain)
    -- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            --add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
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
    if buff == "Sleep" then
        if gain then    
            send_command('input /p ZZZzzz, please cure.')		
        else
            send_command('input /p '..player.name..' is no longer Sleep!')
            handle_equipping_gear(player.status)    
        end
        if not midaction() then
            handle_equipping_gear(player.status)
            job_update()
        end
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end
--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
              end
            end
        end
    end)
function job_handle_equipping_gear(playerStatus, eventArgs)
    determine_haste_group()
    update_combat_form()
    check_moving()

end
--[[function get_combat_form()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    else
        state.CombatForm:reset()
    end
end]]
function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
    if player.equipment.sub:endswith('Shield') then
        state.CombatForm:reset()
    end
end
--[[function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end]]
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairShot' then
        if (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
            if state.QDMode.value == 'Enhance' then
                equip(sets.midcast.CorsairShot.Enhance)
            elseif state.QDMode.value == 'TH' then
                equip(sets.midcast.CorsairShot)
                equip(sets.TreasureHunter)
            elseif state.QDMode.value == 'STP' then
                equip(sets.midcast.CorsairShot.STP)
            end
        end
    elseif spell.action_type == 'Ranged Attack' then
        if buffactive['Triple Shot'] then
            equip(sets.TripleShot)
        end
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and not spell.interrupted then
        display_roll_info(spell)
    end
    if spell.english == "Light Shot" then
        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    check_weaponset()
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
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

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    --if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        --state.OffenseMode:set('Ranged')
    --end
    --handle_equipping_gear(player.status)
    check_moving()
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 38 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 38 and DW_needed <= 40 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 40 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
            send_command('gs c update')

        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
            send_command('gs c update')

        end
    end
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    -- if state.CP.current == 'on' then
    --     equip(sets.CP)
    --     disable('back')
    -- else
    --     enable('back')
    -- end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
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
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    --[[if state.WeaponSet.value == "SWORDS" then
        send_command('input /lockstyleset 151')
    elseif state.WeaponSet.value == "DAGGERS" then
        send_command('input /lockstyleset 163')
    end]]
    --meleeSet = set_combine(meleeSet, select_earring())

    check_weaponset()

    return meleeSet
end
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function check_weaponset()
    equip(sets[state.WeaponSet.current])
    equip(sets[state.Weapongun.current])
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC') then
        equip(sets.DefaultShield)
    elseif player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 then
        equip(sets.DefaultShield)
    end
end
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
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
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

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end
function special_ammo_check()
    -- Stop if Animikii/Hauksbok equipped
    if no_shoot_ammo:contains(player.equipment.ammo) then
        cancel_spell()
        add_to_chat(123, '** Action Canceled: [ '.. player.equipment.ammo .. ' equipped!! ] **')
        return
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 151')
    end
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(4, 26)
end
