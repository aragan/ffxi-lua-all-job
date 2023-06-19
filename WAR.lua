-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

--[[     
 === Notes ===
 this is incomplete. my war just hit 99
 Using warcry = Upheaval
 Using bloodrage = Ukko's
--]]
--
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')

        organizer_items = {"Prime Sword",
            "Drepanum",
            "Lentus Grip",
            "Maliya Sickle +1",
            "Thr. Tomahawk",
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
    send_command('wait 6;input /lockstyleset 179')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    state.WeaponLock = M(false, 'Weapon Lock')
	send_command('bind @w gs c toggle WeaponLock')
    state.CapacityMode = M(false, 'Capacity Point Mantle')

    --state.Buff.Souleater = buffactive.souleater or false
    state.Buff.Berserk = buffactive.berserk or false
    state.Buff.Retaliation = buffactive.retaliation or false
    
    wsList = S{ 'Savage Blade', 'Impulse Drive', 'Torcleaver', 'Ukko\'s Fury', 'Upheaval'}
    gsList = S{'Macbain', 'Nandaka', 'Nativus Halberd'}
    war_sub_weapons = S{"Sangarius +1", "Usonmunku", "Perun 1+", "Tanmogayi +1", "Reikiko", "Digirbalag", "Twilight Knife",
    "Kustawi +1", "Zantetsuken", "Excalipoor II", "Warp Cudgel", "Qutrub Knife", "Wind Knife +1", "Firetongue", "Nihility",
        "Extinction", "Heartstopper +1", "Twashtar", "Aeneas", "Gleti's Knife", "Naegling", "Tauret", "Caduceus", "Loxotic Mace +1",
        "Debahocho +1", "Dolichenus", "Arendsi Fleuret", "Demers. Degen +1", "Ternion Dagger +1",
    }
    get_combat_form()
    get_combat_weapon()
    update_combat_form()

end
 
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Mid', 'Acc', 'STP', 'PD', 'CRIT')
    state.HybridMode:options('Normal', 'PDT', 'H2H', 'SubtleBlow', 'SubtleBlow75', 'Counter')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
    state.CastingMode:options('Normal', 'sird', 'ConserveMP')
    state.IdleMode:options('Normal', 'Refresh', 'Regen')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'HP','Evasion', 'Enmity', 'MP', 'Reraise')
    state.MagicalDefenseMode:options('MDT')
    state.drain = M(false)
    
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
    send_command('bind ^/ gs disable all')
    send_command('bind ^- gs enable all')
    send_command('wait 2;input /lockstyleset 179')
    select_default_macro_book()
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^`')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
end
 
       
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }
     sets.Enmity = {
        ammo="Iron Gobbet",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Moonlight Necklace",
        waist="Plat. Mog. Belt",
        left_ear="Cryptic Earring",
        right_ear="Trux Earring",
        left_ring="Apeile Ring",
        right_ring={ name="Apeile Ring +1", augments={'Path: A',}},
        back="Reiki Cloak",
    }

    sets.MadrigalBonus = {
        hands="Composer's Mitts"
    }
     -- Precast Sets
     -- Precast sets to enhance JAs
     --sets.precast.JA['Mighty Strikes'] = {hands="Fallen's Finger Gauntlets +1"}
     sets.precast.JA['Blood Rage'] = {}
     sets.precast.JA['Provoke'] = set_combine(sets.Enmity, { })
     sets.precast.JA['Berserk'] = { body="Pummeler's Lorica +3"}
     sets.precast.JA['Warcry'] = { head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
     sets.precast.JA['Mighty Strikes'] = { head="Agoge Mufflers"}
     sets.precast.JA['Retaliation'] = { hands="Pummeler's Mufflers +1", feet="Ravager's Calligae +2"}
     sets.precast.JA['Aggressor'] = {}
     sets.precast.JA['Restraint'] = { hands="Boii Mufflers +2"}
     sets.precast.JA['Warrior\'s Charge'] = {}

     --sets.CapacityMantle  = { back="Mecistopins Mantle" }
     --sets.Berserker       = { neck="Berserker's Torque" }
     sets.WSDayBonus      = { head="Gavialis Helm" }
     -- TP ears for night and day, AM3 up and down. 
     sets.BrutalLugra     = { ear1="Brutal Earring", ear2="Lugra Earring +1" }
     sets.Lugra           = { ear1="Lugra Earring +1" }
     sets.Brutal          = { ear1="Brutal Earring" }
 
     sets.reive = {}
     -- Waltz set (chr and vit)
     sets.precast.Waltz = {
        body="Passion Jacket",     }
            
     -- Fast cast sets for spells
     sets.precast.FC = {
        ammo="Sapience Orb",
        head="Sakpata's Helm",
        body={ name="Odyss. Chestplate", augments={'Attack+23','"Fast Cast"+5','STR+8','Accuracy+15',}},
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Baetyl Pendant",
        waist="Plat. Mog. Belt",
        left_ear="Loquac. Earring",
        right_ear="Mendi. Earring",
        left_ring="Prolix Ring",
        right_ring="Rahab Ring",
        back="Moonlight Cape",
     }
     sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        waist="Acerbic Sash +1",
        right_ear="Mendi. Earring",
     })
     sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })

     -- Midcast Sets
     sets.midcast.FastRecast = sets.midcast.sird

    sets.midcast.sird = {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear="Genmei Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Solemnity Cape",
    }
    sets.sird = {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear="Genmei Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Solemnity Cape",
    }
    sets.ConserveMP = {    
    ammo="Pemphredo Tathlum",
    legs={ name="Augury Cuisses +1", augments={'Path: A',}},
    neck="Reti Pendant",
    right_ear="Mendi. Earring",
    left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    right_ring="Mephitas's Ring",
    back="Solemnity Cape",
    }
    sets.midcast.ConserveMP = {    
        ammo="Pemphredo Tathlum",
        legs={ name="Augury Cuisses +1", augments={'Path: A',}},
        neck="Reti Pendant",
        right_ear="Mendi. Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Mephitas's Ring",
        back="Solemnity Cape",
        }
     -- Specific spells
     sets.midcast.Utsusemi = {
     }
     sets.midcast.Cure = {
        ammo="Pemphredo Tathlum",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Incanter's Torque",
        waist="Plat. Mog. Belt",
        left_ear="Ethereal Earring",
        right_ear="Mendi. Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Solemnity Cape",
	}
    sets.midcast.Cure.sird = set_combine(sets.midcast.Cure, {})
    sets.midcast.Cure.ConserveMP = set_combine(sets.midcast.Cure, {})

     sets.midcast['Enhancing Magic'] = {
        body="Shab. Cuirass +1",
        neck="Incanter's Torque",
        waist="Olympus Sash",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
	}

     sets.midcast['Enfeebling Magic'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Hjarrandi Helm",
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Incanter's Torque",
        waist="Eschan Stone",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    }

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        feet="Shabti Sabatons",
        waist="Gishdubar sash"
    })
	sets.midcast.Refresh.sird = set_combine(sets.midcast.Refresh, {
    })

 
     -- Ranged for xbow
     sets.precast.RA = {
        ammo=empty,
        range="Trollbane",  
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        right_ear="Telos Earring",
         ring2="Crepuscular Ring",
     }
     sets.midcast.RA = {
         ammo=empty,
         range="Trollbane",  
         body="Nyame Mail",
         hands="Nyame Gauntlets",
         legs="Nyame Flanchard",
         feet="Nyame Sollerets",
         right_ear="Telos Earring",
         ear2="Crepuscular Earring",
          ring2="Crepuscular Ring",
     }

     -- WEAPONSKILL SETS
     -- General sets
     sets.precast.WS = {
        ammo="Knobkierrie",
        head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
        body="Nyame Mail",
        hands="Boii Mufflers +2",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
     }

     sets.precast.WS.Mid = set_combine(sets.precast.WS, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
     })
     sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
     })
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body="Nyame Mail",
    hands="Boii Mufflers +2",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Thrud Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Regal Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Upheaval'].Mid = set_combine(sets.precast.WS['Upheaval'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS['Upheaval'], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS["King's Justice"] = set_combine(sets.precast.WS["Upheaval"], {})
    sets.precast.WS["King's Justice"].Acc = set_combine(sets.precast.WS["Upheaval"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Boii Mufflers +2",
        legs="Nyame Flanchard",
        feet="Thereoid Greaves",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Regal Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Ukko's Fury"].Mid = set_combine(sets.precast.WS, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Ukko's Fury"].Acc = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
        })
    sets.precast.WS["Stardiver"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        hands="Flam. Manopolas +2",
    })
    sets.precast.WS["Stardiver"].Mid = set_combine(sets.precast.WS["Stardiver"], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Stardiver"].Acc = set_combine(sets.precast.WS["Stardiver"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })

    sets.precast.WS["Keen Edge"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Raging Rush"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        hands="Flam. Manopolas +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })
    sets.precast.WS["Raging Rush"].Acc = set_combine(sets.precast.WS["Raging Rush"], {
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS["Sturmwind"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Vorpal Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Fast Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Swift Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
    sets.precast.WS["Rampage"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Vorpal Scythe"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Vorpal Thrust"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Evisceration"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        ammo="Aurgelmir Orb +1",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Evisceration"].Mid = set_combine(sets.precast.WS["Evisceration"], {
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Evisceration"].Acc = set_combine(sets.precast.WS["Evisceration"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })

    sets.precast.WS["True Strike"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["True Strike"].Acc = set_combine(sets.precast.WS["True Strike"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body="Nyame Mail",
    hands="Boii Mufflers +2",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Thrud Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Fell Cleave"].Mid = set_combine(sets.precast.WS["Fell Cleave"], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Fell Cleave"].Acc = set_combine(sets.precast.WS["Fell Cleave"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Moonlight Necklace",
        waist="Eschan Stone",
        left_ear="Crep. Earring",
        right_ear="Digni. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Shield Break"] = set_combine(sets.precast.WS["Armor Break"], {})
    sets.precast.WS["Weapon Break"] = set_combine(sets.precast.WS["Armor Break"], {})



     -- RESOLUTION
     -- 86-100% STR
    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
         left_ring="Niqmaddu Ring",
         right_ring="Sroda Ring", 
         left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
         left_ear="Schere Earring",
         back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
    sets.precast.WS['Resolution'].Mid = set_combine(sets.precast.WS['Resolution'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        feet="Sakpata's Leggings",
        ammo="Crepuscular Pebble",
        right_ring="Sroda Ring", 
    })
     
     sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS) 
     sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['One Inch Punch'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS) 
     sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS) 
     sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS) 
     sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['Tornado Kick'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Resolution'], sets.precast.WS)
     sets.precast.WS["Raging Axe"] = set_combine(sets.precast.WS["Resolution"], {})
     sets.precast.WS["Ruinator"] = set_combine(sets.precast.WS["Resolution"], {})
     sets.precast.WS["Exenterator"] = set_combine(sets.precast.WS["Resolution"], {})
     sets.precast.WS["Viper Bite"] = set_combine(sets.precast.WS["Resolution"], {ammo="Aurgelmir Orb +1",})
     sets.precast.WS["Realmrazer"] = set_combine(sets.precast.WS["Resolution"], {left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
     sets.precast.WS["Penta Thrust"] = set_combine(sets.precast.WS["Resolution"], {})
     sets.precast.WS["Double Thrust"] = set_combine(sets.precast.WS["Resolution"], {})
     sets.precast.WS["Bora Axe"] = set_combine(sets.precast.WS, {
        ammo="Aurgelmir Orb +1",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})

        sets.precast.WS["Decimation"] = set_combine(sets.precast.WS["Resolution"], {
            ammo="Coiste Bodhar",
            head="Hjarrandi Helm",
            body="Nyame Mail",
            hands="Boii Mufflers +2",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Fotia Gorget",
            waist="Fotia Belt",
            left_ear="Schere Earring",
            right_ear="Boii Earring +1",           
            left_ring="Regal Ring",
            right_ring="Niqmaddu Ring",
            back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        })
        sets.precast.WS["Decimation"].Mid = set_combine(sets.precast.WS["Decimation"], {
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Decimation"].Acc = set_combine(sets.precast.WS["Decimation"], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",
        })

        sets.precast.WS["Cross Reaper"] = set_combine(sets.precast.WS, {
            right_ring="Niqmaddu Ring",
        })
        sets.precast.WS["Cross Reaper"].Mid = set_combine(sets.precast.WS["Cross Reaper"], {
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Cross Reaper"].Acc = set_combine(sets.precast.WS["Cross Reaper"], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Entropy"] = set_combine(sets.precast.WS, {
            right_ring="Niqmaddu Ring",
            right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        })
        sets.precast.WS["Entropy"].Mid = set_combine(sets.precast.WS["Entropy"], {
            right_ring="Niqmaddu Ring",
            right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        })
        sets.precast.WS["Entropy"].Acc = set_combine(sets.precast.WS["Entropy"], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",
        })

          -- REQUISCAT
     -- 73% MND - breath damage
     sets.precast.WS.Requiescat = set_combine(sets.precast.WS, {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Brutal Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
     sets.precast.WS.Requiescat.Mid = set_combine(sets.precast.WS.Requiescat, {
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
     })
     sets.precast.WS.Requiescat.Acc = set_combine(sets.precast.WS.Requiescat, {
        ammo="Crepuscular Pebble",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
     })
     sets.precast.WS['Spirits Within'] = {
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Kyrene's Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Moonlight Ring",
        back="Moonlight Cape",
     }

     -- TORCLEAVER 
     -- VIT 80%
     sets.precast.WS.Torcleaver = set_combine(sets.precast.WS, {
         head="Sakpata's Helm",
         ammo="Knobkierrie",
         neck="Fotia Gorget",
     })
     sets.precast.WS.Torcleaver.Mid = set_combine(sets.precast.WS.Mid, {
        neck="Fotia Gorget",
     })
     sets.precast.WS.Torcleaver.Acc = set_combine(sets.precast.WS.Torcleaver.Mid, sets.precast.WS.Acc)


    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Nyame Flanchard",
        feet="Thereoid Greaves",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Regal Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Impulse Drive'].Mid = set_combine(sets.precast.WS['Impulse Drive'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
    sets.precast.WS['Impulse Drive'].Acc = set_combine(sets.precast.WS['Impulse Drive'], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
        })
    sets.precast.WS["Sonic Thrust"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        right_ear="Lugra Earring +1",
    })
    sets.precast.WS["Sonic Thrust"].Mid = set_combine(sets.precast.WS["Sonic Thrust"], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Sonic Thrust"].Acc = set_combine(sets.precast.WS["Sonic Thrust"], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Impulse Drive'], {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body="Nyame Mail",
    hands="Boii Mufflers +2",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Savage Blade'].Mid = set_combine(sets.precast.WS['Savage Blade'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Crepuscular Pebble",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +2",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Mistral Axe'].Mid = set_combine(sets.precast.WS['Savage Blade'].Mid, {})
    sets.precast.WS['Mistral Axe'].Acc = set_combine(sets.precast.WS['Savage Blade'].Acc, {})
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Judgment'].Mid = set_combine(sets.precast.WS['Judgment'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
        sets.precast.WS['Judgment'].Acc = set_combine(sets.precast.WS['Judgment'], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Black Halo"] = set_combine(sets.precast.WS["Savage Blade"], {left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
        sets.precast.WS["Black Halo"].Mid = set_combine(sets.precast.WS["Black Halo"], {
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Black Halo"].Acc = set_combine(sets.precast.WS["Black Halo"], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Ground Strike"] = set_combine(sets.precast.WS['Savage Blade'], {
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Lugra Earring +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",    })
        sets.precast.WS["Ground Strike"].Mid = set_combine(sets.precast.WS['Ground Strike'], {
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Ground Strike"].Acc = set_combine(sets.precast.WS['Ground Strike'], {
            ammo="Crepuscular Pebble",
            hands="Sakpata's Gauntlets",
            legs="Boii Cuisses +2",
            left_ring="Sroda Ring",   })

    sets.precast.WS["Shockwave"] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS["Power Slash"] = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",})



     -- Sword WS's
     -- SANGUINE BLADE
     -- 50% MND / 50% STR Darkness Elemental
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
    head="Pixie Hairpin +1",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Hachirin-no-Obi",
    left_ear="Friomisi Earring",
    right_ear="Thrud Earring",
    right_ring="Archon Ring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},   
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})

    sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Red Lotus Blade"] = set_combine(sets.precast.WS["Sanguine Blade"],{
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Shining Blade"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Seraph Blade"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Gale Axe"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Cloudsplitter"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        head="Nyame Helm",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Aeolian Edge"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Cyclone"] = set_combine(sets.precast.WS["Sanguine Blade"], {
            ammo="Aurgelmir Orb +1",
            head="Nyame Helm",
            right_ring="Cornelia's Ring",
            right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Gust Slash"] = set_combine(sets.precast.WS["Sanguine Blade"], {
                ammo="Aurgelmir Orb +1",
                head="Nyame Helm",
                right_ring="Cornelia's Ring",
                right_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Shining Strike"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Thunder Thrust"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Raiden Thrust"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Frostbite"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})
    sets.precast.WS["Freezebite"] = set_combine(sets.precast.WS["Sanguine Blade"], {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm",
        right_ring="Cornelia's Ring",})

     sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

     -- Resting sets
     sets.resting = {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
     }
     -- Idle sets
     sets.idle = {
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        ear1="Tuisto Earring",
        ear2={ name="Odnowa Earring +1", augments={'Path: A',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        right_ring="Paguroidea Ring",
        left_ring="Defending Ring",
        feet="Hermes' Sandals +1",
        back="Moonlight Cape",
        }
     sets.idle.Town = {
         feet="Hermes' Sandals +1",
     }
     sets.idle.Field = set_combine(sets.idle.Town, {
         head="Sakpata's Helm",
         body="Sakpata's Plate",
         hands="Sakpata's Gauntlets",
         legs="Sakpata's Cuisses",
         ear1="Tuisto Earring",
         ear2={ name="Odnowa Earring +1", augments={'Path: A',}},
         neck={ name="Loricate Torque +1", augments={'Path: A',}},
         waist="Carrier's Sash",
         right_ring="Paguroidea Ring",
         left_ring="Defending Ring",
         feet="Hermes' Sandals +1",
         back="Moonlight Cape",
     })
     sets.idle.Regen = set_combine(sets.idle.Field, {
        body="Obviation Cuirass",
        neck="Sanctity Necklace",
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
     })
     sets.idle.Refresh = set_combine(sets.idle.Field, {
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
     })
 
     sets.idle.Weak = set_combine(sets.idle.Field, {
        head="Twilight Helm",
        body="Twilight Mail",
        back="Moonlight Cape",
     })

     -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Paguroidea Ring",
        back="Moonlight Cape",
     }

    sets.defense.HP = {
        sub="Blurred Shield +1",
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Kyrene's Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Moonlight Cape",
     }
     sets.defense.Evasion = {
        ammo="Amar Cluster",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Vengeful Ring",
        back="Moonlight Cape",
     }
     sets.defense.Enmity = {
        ammo="Iron Gobbet",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Moonlight Necklace",
        waist="Plat. Mog. Belt",
        left_ear="Cryptic Earring",
        right_ear="Trux Earring",
        left_ring="Apeile Ring",
        right_ring={ name="Apeile Ring +1", augments={'Path: A',}},
        back="Reiki Cloak",
    }

     sets.defense.Reraise = sets.idle.Weak
 
     sets.defense.MDT = set_combine(sets.defense.PDT, {
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        left_ear="Eabani Earring",
        left_ring="Moonlight Ring",
     })
     sets.defense.MP = set_combine(sets.defense.PDT, {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Sanctity Necklace",
        waist="Flume Belt +1",
        left_ear="Ethereal Earring",
        right_ear="Mendi. Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Mephitas's Ring",
        back="Moonlight Cape",
     })
 
     sets.Kiting = {feet="Hermes' Sandals +1"}
 
     sets.Terror = {feet="Founder's Greaves"}

     sets.Reraise = {
        head="Twilight Helm",
        body="Twilight Mail",}

     -- Defensive sets to combine with various weapon-specific sets below
     -- These allow hybrid acc/pdt sets for difficult content
     sets.Defensive = {
         head="Sakpata's Helm", -- no haste
         body="Sakpata's Plate", -- 3% haste
         hands="Sakpata's Gauntlets",
         legs="Sakpata's Cuisses", -- 5% haste
         feet="Sakpata's Leggings", -- 3% haste
         neck={ name="War. Beads +2", augments={'Path: A',}},
         ring2="Defending Ring",
         waist="Sailfi Belt +1",
     }
     sets.Defensive_Acc = set_combine(sets.Defensive, {
         neck="Warrior's Bead Necklace +2",
         left_ear="Digni. Earring",
         right_ear="Mache Earring +1",
         left_ring="Chirich Ring +1",
         right_ring="Chirich Ring +1",
     })
 
     -- Engaged set, assumes Liberator
     sets.engaged = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Moonlight Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
    sets.engaged.Mid = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Cessance Earring",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Petrov Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
    sets.engaged.Acc = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Telos Earring",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })

    sets.engaged.PD = {
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Schere Earring",
        right_ear="Telos Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Petrov Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }

    sets.engaged.CRIT = set_combine(sets.engaged, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Schere Earring",
    right_ear="Boii Earring +1",
    left_ring="Niqmaddu Ring",
    right_ring="Hetairoi Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })
    sets.engaged.SubtleBlow = set_combine(sets.engaged, {        
        body="Flamma Korazin +2",
        hands="Sakpata's Gauntlets",
        left_ear={ name="Schere Earring", augments={'Path: A',}},
        right_ear="Boii Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.engaged.Mid.SubtleBlow = set_combine(sets.defense.PDT, {        
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Flamma Korazin +2",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear={ name="Schere Earring", augments={'Path: A',}},
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Moonlight Cape",
    })
    sets.engaged.SubtleBlow75 = set_combine(sets.engaged, {        
        body="Flamma Korazin +2",
        hands="Kobo Kote",
        legs="Sakpata's Cuisses",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Sarissapho. Belt",
        left_ear={ name="Schere Earring", augments={'Path: A',}},
        right_ear="Boii Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
        back="Sokolski Mantle",
    })
    sets.engaged.Mid.SubtleBlow75 = set_combine(sets.defense.PDT, {        
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Flamma Korazin +2",
        hands="Kobo Kote",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Sarissapho. Belt",
        left_ear={ name="Schere Earring", augments={'Path: A',}},
        right_ear="Boii Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Sokolski Mantle",
    })
    sets.engaged.H2H = {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Mache Earring +1",
        right_ear="Mache Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Petrov Ring",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }

    sets.engaged.DW = set_combine(sets.engaged, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Suppanomimi",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Moonlight Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })

    sets.engaged.DW.Mid = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Suppanomimi",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
    sets.engaged.DW.Acc = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Suppanomimi",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Chirich Ring +1",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
    sets.engaged.PD.DW = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet="Pumm. Calligae +3",
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Suppanomimi",
    right_ear="Schere Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Petrov Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })

     sets.engaged.STP = set_combine(sets.engaged, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet="Pumm. Calligae +3",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

    sets.engaged.Club = set_combine(sets.engaged, {
        main={ name="Loxotic Mace +1", augments={'Path: A',}},
        sub="Blurred Shield +1",
    })

    sets.engaged.Polearm = set_combine(sets.engaged, {
        main="Shining One",
        sub="Utu Grip",
    })

    sets.engaged.Counter = set_combine(sets.engaged, {
        ammo="Amar Cluster",
        body="Obviation Cuirass",
        hands={ name="Founder's Gauntlets", augments={'STR+7','Attack+10','"Mag.Atk.Bns."+8','Phys. dmg. taken -2%',}},
        feet="Sakpata's Leggings",
    left_ear="Genmei Earring",
    right_ear="Cryptic Earring",
    })

    

     sets.engaged.PDT = set_combine(sets.engaged, sets.Defensive)
     sets.engaged.Mid.PDT = set_combine(sets.engaged.Mid, sets.Defensive)
     sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.Defensive_Acc)




     sets.engaged.Reraise = set_combine(sets.engaged, {
     	head="Twilight Helm",
     	body="Twilight Mail"
     })
     sets.buff.Berserk = { 
         --feet="Warrior's Calligae +2" 
     }
     sets.buff.Retaliation = { 
         hands="Pummeler's Mufflers +1"
     }
     sets.Doom = {    neck="Nicander's Necklace",
     waist="Gishdubar Sash",
     left_ring="Purity Ring",
     right_ring="Blenmot's Ring +1",}
 
    
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Echo Drops" <me>')
    --elseif spell.target.distance > 8 and player.status == 'Engaged' then
    --    eventArgs.cancel = true
    --    add_to_chat(122,"Outside WS Range! /Canceling")
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
end
 
function job_post_precast(spell, action, spellMap, eventArgs)

    -- Make sure abilities using head gear don't swap 
	if spell.type:lower() == '' then
        
        if is_sc_element_today(spell) then
            if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
                -- do nothing
            else
                equip(sets.WSDayBonus)
            end
        end
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        
        -- if player.tp > 2999 then
        --     equip(sets.BrutalLugra)
        -- else -- use Lugra + moonshade
        --     if world.time >= (17*60) or world.time <= (7*60) then
        --         equip(sets.Lugra)
        --     else
        --         equip(sets.Brutal)
        --     end
        -- end
        -- Use SOA neck piece for WS in rieves
        if buffactive['Reive Mark'] then
            equip(sets.reive)
        end
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if (state.HybridMode.current == 'PDT' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
    end
    if state.Buff.Berserk and not state.Buff.Retaliation then
        equip(sets.buff.Berserk)
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(player,status, eventArgs)
    customize_idle_set(idleSet)
    customize_melee_set(meleeSet)
    job_state_change(stateField, newValue, oldValue)

end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    --if player.hpp < 90 then
        --idleSet = set_combine(idleSet, sets.idle.Regen)
    --end
    if state.HybridMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.defense.PDT)
    end
    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
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
    if state.Buff.Berserk and not state.Buff.Retaliation then
    	meleeSet = set_combine(meleeSet, sets.buff.Berserk)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        meleeSet = set_combine(meleeSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    return meleeSet
end
 
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
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
 
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == "Engaged" then
        if buffactive.Berserk and not state.Buff.Retaliation then
            equip(sets.buff.Berserk)
        end
        get_combat_weapon()
    --elseif newStatus == 'Idle' then
    --    determine_idle_group()
    end
end
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)

    
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
    
    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'Acc' then
            equip(sets.MadrigalBonus)
        end
    end
    -- Warp ring rule, for any buff being lost
    if S{'Warp', 'Vocation', 'Capacity'}:contains(player.equipment.ring2) then
        if not buffactive['Dedication'] then
            disable('ring2')
        end
    else
        enable('ring2')
    end
    
    if buff == "Berserk" then
        if gain and not buffactive['Retaliation'] then
            equip(sets.buff.Berserk)
        else
            if not midaction() then
                handle_equipping_gear(player.status)
            end
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
    if buff == "weakness" then
        if gain then
            equip(sets.Reraise)
             disable('body','head')
            else
             enable('body','head')
        end
        return meleeSet
    end

end
 
 
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_self_command(cmdParams, eventArgs)
    if player.hpp < 8 then --if have lag click f12 to change to sets.Reraise this code add from Aragan Asura
        equip(sets.Reraise)
        send_command('input //gs equip sets.Reraise')
        eventArgs.handled = false
    end
    return 
end
function job_update(player,cmdParams, eventArgs)
    job_self_command()
    get_combat_form()
    get_combat_weapon()
    update_combat_form()

end

function get_custom_wsmode(spell, spellMap, default_wsmode)
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function get_combat_form()
    --if war_sj then
        --state.CombatForm:set("War")
    --else
        --state.CombatForm:reset()
    --end
    if S{'NIN', 'DNC'}:contains(player.sub_job) and war_sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    elseif S{'SAM', 'DRK', 'PLD', 'DRG', 'RUN'}:contains(player.sub_job) and player.equipment.sub == 'Blurred Shield +1' then
        state.CombatForm:set("OneHand")
    else
        state.CombatForm:reset()
    end

end

function get_combat_weapon()
    if gsList:contains(player.equipment.main) then
        state.CombatWeapon:set("GreatSword")
    else -- use regular set
        state.CombatWeapon:reset()
    end
end
function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == "Blurred Shield +1" or player.equipment.sub == "Beatific Shield +1" or player.equipment.sub == "Utu Grip" or 
    player.equipment.sub == "Alber Strap" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    --if stateField == 'Look Cool' then
    --    if newValue == 'On' then
    --        send_command('gs equip sets.cool;wait 1.2;input /lockstyle on;wait 1.2;gs c update user')
    --        --send_command('wait 1.2;gs c update user')
    --    else
    --        send_command('@input /lockstyle yes')
    --    end
    --end

end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 179')
    end
end
add_to_chat(159,'Author Aragan WAR.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
function select_default_macro_book()
    -- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(6, 24)
	elseif player.sub_job == 'SAM' then
		set_macro_page(6, 24)
	else
		set_macro_page(6, 24)
	end
end

