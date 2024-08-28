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
    include('Display.lua')
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')

        organizer_items = {
            "Airmid's Gorget",
            "Agwu's Claymore",
            "Reikiko",
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
            "Drepanum",
            "Sword Strap",
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
    send_command('wait 2;input /lockstyleset 152')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.Moving  = M(false, "moving")
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')

    --state.Buff.Souleater = buffactive.souleater or false
    state.Buff.Berserk = buffactive.berserk or false
    state.Buff.Retaliation = buffactive.retaliation or false
    
    wsList = S{ 'Savage Blade', 'Impulse Drive', 'Torcleaver', 'Ukko\'s Fury', 'Upheaval'}
    swordList = S{"Naegling", "Sangarius +1", "Perun +1", "Tanmogayi +1", "Loxotic Mace +1", "Reikiko", "Firetongue", "Demers. Degen +1", "Zantetsuken", "Excalipoor II"}
    gsList = S{'Macbain', 'Nandaka', 'Agwu\'s Claymore'}
    Hand_weapon = S{'Naegling', 'Ikenga\'s Axe', 'Ternion Dagger +1' ,'Loxotic Mace +1','Dolichenus','Zantetsuken',
    'Reikiko','Perun +1','Demers. Degen +1','Sangarius +1'}
    war_sub_weapons = S{"Sangarius +1", "Perun +1", "Tanmogayi +1", "Reikiko", "Digirbalag", "Twilight Knife",
    "Kustawi +1", "Zantetsuken", "Excalipoor II", "Warp Cudgel", "Qutrub Knife", "Wind Knife +1", "Firetongue", "Nihility",
        "Extinction", "Heartstopper +1", "Twashtar", "Aeneas", "Gleti's Knife", "Naegling", "Tauret", "Caduceus", "Loxotic Mace +1",
        "Debahocho +1", "Dolichenus", "Arendsi Fleuret", "Demers. Degen +1", "Ternion Dagger +1",}
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1", "Thr. Tomahawk",}
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Naegling', 'Loxotic', 'Shining','Chango', 'AgwuClaymore', 'Drepanum', 'TernionDagger','IkengaAxe'}
    state.shield = M{['description']='Weapon Set', 'Normal', 'shield'}
    get_combat_form()
    get_combat_weapon()
    update_combat_form()

end
 
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'CRIT', 'SubtleBlow', 'Counter', 'H2H')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'SC', 'PDL')
    state.CastingMode:options('Normal', 'sird', 'ConserveMP')
    state.IdleMode:options('Normal', 'PDT', 'MDT', 'HP', 'Regen', 'Evasion', 'EnemyCritRate', 'Refresh')
    --state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'HP','Evasion', 'Enmity', 'MP', 'Reraise')
    state.MagicalDefenseMode:options('MDT')
    --state.drain = M(false)

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
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind !f7 gs c cycle shield')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind !f6 gs c cycleback WeaponSet')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('wait 6;input /lockstyleset 152')
    select_default_macro_book()
    state.Auto_Kite = M(false, 'Auto_Kite')

    if init_job_states then init_job_states({"WeaponLock"},{"IdleMode","OffenseMode","WeaponskillMode","WeaponSet","shield","TreasureMode"}) 
    end
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^`')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
    send_command('lua u AutoCOR')

end
 
       
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
--Weaponsets
sets.Normal = {}
sets.Chango = {main="Chango", sub="Utu Grip"}
sets.AgwuClaymore = {main="Agwu's Claymore", sub="Utu Grip"}
sets.Shining = {main="Shining One", sub="Utu Grip"}
sets.Naegling = {main="Naegling", sub="Demers. Degen +1",}
sets.Loxotic = {main="Loxotic Mace +1", sub="Demers. Degen +1",}
sets.TernionDagger = {main="Ternion Dagger +1", sub="Demers. Degen +1",}
sets.Drepanum = {main="Drepanum", sub="Utu Grip",}
sets.IkengaAxe = {main="Ikenga's Axe", sub="Demers. Degen +1",}

sets.Normal = {}
sets.shield = {sub="Blurred Shield +1"}
sets.DefaultShield = {sub="Blurred Shield +1"}


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


     -- Precast Sets
     -- Precast sets to enhance JAs
     --sets.precast.JA['Mighty Strikes'] = {hands="Fallen's Finger Gauntlets +1"}
     sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3",}
     sets.precast.JA['Provoke'] = set_combine(sets.Enmity, { })
     sets.precast.JA['Berserk'] = { body="Pummeler's Lorica +3",feet="Agoge Calligae +3",
     back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
     sets.precast.JA['Warcry'] = { head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},}
     sets.precast.JA['Mighty Strikes'] = {hands="Boii Mufflers +3"}
     sets.precast.JA['Retaliation'] = {}
     sets.precast.JA['Aggressor'] = {}
     sets.precast.JA['Restraint'] = {hands="Boii Mufflers +3"}
     sets.precast.JA['Warrior\'s Charge'] = {}
     sets.precast.JA.Tomahawk = set_combine(sets.precast.JA, {ammo="Thr. Tomahawk",feet="Agoge Calligae +3"})

     --sets.CapacityMantle  = { back="Mecistopins Mantle" }
     --sets.Berserker       = { neck="Berserker's Torque" }
     sets.WSDayBonus      = { head="Gavialis Helm" }
     -- TP ears for night and day, AM3 up and down. 
     sets.BrutalLugra     = { ear2="Brutal Earring", ear1="Lugra Earring +1" }
     sets.Lugra           = { ear1="Lugra Earring +1" }
     sets.Brutal          = { ear1="Brutal Earring" }
 
     sets.reive = {}
     -- Waltz set (chr and vit)
     sets.precast.Waltz = {
        body="Passion Jacket",     }
            
     -- Fast cast sets for spells
     sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body="Sacro Breastplate",
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
        left_ear="Brachyura Earring",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
	}
    sets.midcast.Phalanx = {
        ammo="Staunch Tathlum +1",
        head={ name="Odyssean Helm", augments={'INT+5','"Cure" potency +8%','Phalanx +4','Accuracy+15 Attack+15','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
        body="Shab. Cuirass +1",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
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
        waist="Gishdubar sash"})
	sets.midcast.Refresh.sird = set_combine(sets.midcast.Refresh, {})
    sets.midcast.Absorb = {
        ammo="Pemphredo Tathlum",
        neck="Erra Pendant",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Kishar Ring",
    }
 
     -- Ranged for xbow
     sets.precast.RA = {
        ammo=empty,
        range="Trollbane",  
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        right_ear="Telos Earring",
         ring2="Crepuscular Ring",
     }
     sets.midcast.RA = {
         ammo=empty,
         range="Trollbane",  
         body={ name="Nyame Mail", augments={'Path: B',}},
         hands={ name="Nyame Gauntlets", augments={'Path: B',}},
         legs={ name="Nyame Flanchard", augments={'Path: B',}},
         feet={ name="Nyame Sollerets", augments={'Path: B',}},
         right_ear="Telos Earring",
         ear2="Crepuscular Earring",
          ring2="Crepuscular Ring",
     }

     -- WEAPONSKILL SETS
     -- General sets
     sets.precast.WS = {
        ammo="Knobkierrie",
        head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands="Boii Mufflers +3",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Thrud Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
     }

     sets.precast.WS.SC= set_combine(sets.precast.WS, {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
     })
     sets.precast.WS.PDL= set_combine(sets.precast.WS, {
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
     })
    sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Boii Mufflers +3",
    legs="Boii Cuisses +3",
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Thrud Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ring="Niqmaddu Ring",
    left_ring="Regal Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Upheaval'].SC= set_combine(sets.precast.WS['Upheaval'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Upheaval'].PDL= set_combine(sets.precast.WS['Upheaval'], {
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        left_ring="Sroda Ring",
    })
    sets.precast.WS["King's Justice"] = set_combine(sets.precast.WS["Upheaval"], {})
    sets.precast.WS["King's Justice"].PDL= set_combine(sets.precast.WS["Upheaval"], {
        ammo="Crepuscular Pebble",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })
    sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Thereoid Greaves",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Boii Earring +1",
        right_ring="Niqmaddu Ring",
        left_ring="Begrudging Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Ukko's Fury"].SC= set_combine(sets.precast.WS, {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Ukko's Fury"].PDL= set_combine(sets.precast.WS, {
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
        })
    sets.precast.WS["Stardiver"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        body="Hjarrandi Breast.",
        hands="Flam. Manopolas +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })
    sets.precast.WS["Stardiver"].SC= set_combine(sets.precast.WS["Stardiver"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Stardiver"].PDL= set_combine(sets.precast.WS["Stardiver"], {
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })

    sets.precast.WS["Keen Edge"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Raging Rush"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        hands="Flam. Manopolas +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })
    sets.precast.WS["Raging Rush"].PDL= set_combine(sets.precast.WS["Raging Rush"], {
        neck="Fotia Gorget",
        waist="Fotia Belt",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })
    sets.precast.WS["Sturmwind"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Vorpal Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Fast Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {left_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Swift Blade"] = set_combine(sets.precast.WS["Ukko's Fury"], {left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
    sets.precast.WS["Rampage"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Rampage"].PDL = set_combine(sets.precast.WS["Ukko's Fury"].PDL, {})
    sets.precast.WS["Hexa Strike"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Hexa Strike"].PDL = set_combine(sets.precast.WS["Ukko's Fury"].PDL, {})
    sets.precast.WS["Vorpal Scythe"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Vorpal Thrust"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["Evisceration"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        ammo="Aurgelmir Orb +1",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},})
    sets.precast.WS["Evisceration"].SC= set_combine(sets.precast.WS["Evisceration"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Evisceration"].PDL= set_combine(sets.precast.WS["Evisceration"], {
        ammo="Crepuscular Pebble",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })

    sets.precast.WS["True Strike"] = set_combine(sets.precast.WS["Ukko's Fury"], {})
    sets.precast.WS["True Strike"].PDL= set_combine(sets.precast.WS["True Strike"], {
        ammo="Crepuscular Pebble",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Boii Mufflers +3",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Thrud Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Fell Cleave"].SC= set_combine(sets.precast.WS["Fell Cleave"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Fell Cleave"].PDL= set_combine(sets.precast.WS["Fell Cleave"], {
        ammo="Crepuscular Pebble",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
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
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
         left_ring="Niqmaddu Ring",
         right_ring="Sroda Ring", 
         left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
         right_ear="Schere Earring",
         back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })
    sets.precast.WS['Resolution'].SC= set_combine(sets.precast.WS['Resolution'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Resolution'].PDL= set_combine(sets.precast.WS['Resolution'], {
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
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
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},})

        sets.precast.WS["Decimation"] = set_combine(sets.precast.WS["Resolution"], {
            ammo="Coiste Bodhar",
            head="Hjarrandi Helm",
            body={ name="Nyame Mail", augments={'Path: B',}},
            hands="Boii Mufflers +3",
            legs={ name="Nyame Flanchard", augments={'Path: B',}},
            feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck="Fotia Gorget",
            waist="Fotia Belt",
            left_ear="Schere Earring",
            right_ear="Boii Earring +1",           
            left_ring="Regal Ring",
            right_ring="Niqmaddu Ring",
            back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        })
        sets.precast.WS["Decimation"].SC= set_combine(sets.precast.WS["Decimation"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Decimation"].PDL= set_combine(sets.precast.WS["Decimation"], {
            ammo="Crepuscular Pebble",
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",
            left_ring="Sroda Ring",
        })

        sets.precast.WS["Cross Reaper"] = set_combine(sets.precast.WS, {
            right_ring="Niqmaddu Ring",
        })
        sets.precast.WS["Cross Reaper"].SC= set_combine(sets.precast.WS["Cross Reaper"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Cross Reaper"].PDL= set_combine(sets.precast.WS["Cross Reaper"], {
            ammo="Crepuscular Pebble",
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Entropy"] = set_combine(sets.precast.WS, {
            right_ring="Niqmaddu Ring",
            right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        })
        sets.precast.WS["Entropy"].SC= set_combine(sets.precast.WS["Entropy"], {
            right_ring="Niqmaddu Ring",
            right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        })
        sets.precast.WS["Entropy"].PDL= set_combine(sets.precast.WS["Entropy"], {
            ammo="Crepuscular Pebble",
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",
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
     sets.precast.WS.Requiescat.SC= set_combine(sets.precast.WS.Requiescat, {
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
     })
     sets.precast.WS.Requiescat.PDL= set_combine(sets.precast.WS.Requiescat, {
        ammo="Crepuscular Pebble",
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
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
        right_ear="Tuisto Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Moonlight Ring",
        back="Moonlight Cape",
     }

     -- TORCLEAVER 
     -- VIT 80%
     sets.precast.WS.Torcleaver = set_combine(sets.precast.WS, {
         head={ name="Sakpata's Helm", augments={'Path: A',}},
         ammo="Knobkierrie",
         neck="Fotia Gorget",
     })
     sets.precast.WS.Torcleaver.SC= set_combine(sets.precast.WS.Mid, {
        neck="Fotia Gorget",
     })
     sets.precast.WS.Torcleaver.PDL= set_combine(sets.precast.WS.Torcleaver.Mid, sets.precast.WS.PDL)


    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Boii Mufflers +3",
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet="Thereoid Greaves",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Boii Earring +1",
        right_ring="Niqmaddu Ring",
        left_ring="Begrudging Ring",
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Impulse Drive'].SC= set_combine(sets.precast.WS['Impulse Drive'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
    sets.precast.WS['Impulse Drive'].PDL= set_combine(sets.precast.WS['Impulse Drive'], {
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
        })
    sets.precast.WS["Sonic Thrust"] = set_combine(sets.precast.WS["Ukko's Fury"], {
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        left_ear="Lugra Earring +1",
    })
    sets.precast.WS["Sonic Thrust"].SC= set_combine(sets.precast.WS["Sonic Thrust"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS["Sonic Thrust"].PDL= set_combine(sets.precast.WS["Sonic Thrust"], {
        ammo="Crepuscular Pebble",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Impulse Drive'], {
    ammo="Knobkierrie",
    head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands="Boii Mufflers +3",
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck={ name="War. Beads +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS['Savage Blade'].SC= set_combine(sets.precast.WS['Savage Blade'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'].PDL= set_combine(sets.precast.WS['Savage Blade'], {
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        legs="Boii Cuisses +3",
        left_ring="Sroda Ring",
    })
    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS['Savage Blade'], {
        left_ring="Sroda Ring",})
    sets.precast.WS['Mistral Axe'].SC= set_combine(sets.precast.WS['Savage Blade'].Mid, {})
    sets.precast.WS['Mistral Axe'].PDL= set_combine(sets.precast.WS['Savage Blade'].PDL, {})
    sets.precast.WS['Calamity'] = set_combine(sets.precast.WS['Savage Blade'], {
        left_ring="Sroda Ring",})
    sets.precast.WS['Calamity'].SC= set_combine(sets.precast.WS['Savage Blade'].Mid, {})
    sets.precast.WS['Calamity'].PDL= set_combine(sets.precast.WS['Savage Blade'].PDL, {})
    sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Judgment'].SC= set_combine(sets.precast.WS['Judgment'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
        sets.precast.WS['Judgment'].PDL= set_combine(sets.precast.WS['Judgment'], {
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Black Halo"] = set_combine(sets.precast.WS["Savage Blade"], {left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
        sets.precast.WS["Black Halo"].SC= set_combine(sets.precast.WS["Black Halo"], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Black Halo"].PDL= set_combine(sets.precast.WS["Black Halo"], {
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",
            left_ring="Sroda Ring",
        })
        sets.precast.WS["Ground Strike"] = set_combine(sets.precast.WS['Savage Blade'], {
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Lugra Earring +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",    })
        sets.precast.WS["Ground Strike"].SC= set_combine(sets.precast.WS['Ground Strike'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
        })
        sets.precast.WS["Ground Strike"].PDL= set_combine(sets.precast.WS['Ground Strike'], {
            ammo="Knobkierrie",
            body={ name="Sakpata's Plate", augments={'Path: A',}},
            hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
            legs="Boii Cuisses +3",   })

    sets.precast.WS["Shockwave"] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS["Power Slash"] = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",})



-- Elemental Weapon Skill --elemental_ws--

-- SANGUINE BLADE
-- 50% MND / 50% STR Darkness Elemental
    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head="Pixie Hairpin +1",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Baetyl Pendant",
    waist="Hachirin-no-Obi",
    right_ear="Friomisi Earring",
    left_ear="Thrud Earring",
    right_ring="Archon Ring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},   
    back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })

    sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Energy Steal"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS["Energy Drain"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
    sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

    sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck="Baetyl Pendant",
        waist="Hachirin-no-Obi",
        right_ear="Friomisi Earring",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},   
        back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
    })
    sets.precast.WS["Red Lotus Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Shining Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Seraph Blade"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Cloudsplitter"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Primal Rend"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Aeolian Edge"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Cyclone"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Gust Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Shining Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Seraph Strike"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Thunder Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Raiden Thrust"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Frostbite"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Freezebite"] = set_combine(sets.precast.WS["Burning Blade"],{})

    sets.precast.WS["Herculean Slash"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Earth Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Rock Crusher"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Starburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Sunburst"] = set_combine(sets.precast.WS["Burning Blade"],{})
    sets.precast.WS["Flaming Arrow"] = set_combine(sets.precast.WS["Burning Blade"],{})

     -- Resting sets
    sets.resting = {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    }

     -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body="Adamantite Armor",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Paguroidea Ring",
        back="Moonlight Cape",
    }

    sets.defense.HP = {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body="Hjarrandi Breast.",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Kyrene's Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Moonlight Ring",
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
        waist="Engraved Belt",
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
        ammo="Staunch Tathlum +1",
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        left_ear="Eabani Earring",
        left_ring="Shadow Ring",
    })
    sets.defense.MP = set_combine(sets.defense.PDT, {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body="Adamantite Armor",
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
 
     -- Idle sets
     sets.idle = {
        head={ name="Sakpata's Helm", augments={'Path: A',}},
        body="Adamantite Armor",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
        ear1="Tuisto Earring",
        ear2={ name="Odnowa Earring +1", augments={'Path: A',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Engraved Belt",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        back="Moonlight Cape",
    }
        sets.idle.Town ={
        feet="Hermes' Sandals +1",
        left_ear="Infused Earring",}      

     --[[sets.idle.Field = {
         head={ name="Sakpata's Helm", augments={'Path: A',}},
         body={ name="Sakpata's Plate", augments={'Path: A',}},
         hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
         legs={ name="Sakpata's Cuisses", augments={'Path: A',}},
         feet={ name="Sakpata's Leggings", augments={'Path: A',}},
         ear1="Tuisto Earring",
         ear2={ name="Odnowa Earring +1", augments={'Path: A',}},
         neck={ name="Loricate Torque +1", augments={'Path: A',}},
         waist="Engraved Belt",
         right_ring="Paguroidea Ring",
         left_ring="Defending Ring",
         back="Moonlight Cape",
     }]]

     sets.idle.PDT = sets.defense.PDT
     sets.idle.MDT = sets.defense.MDT
     sets.idle.Evasion = sets.defense.Evasion
     sets.idle.HP = sets.defense.HP

     sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
        ammo="Eluder's Sachet",
        left_ring="Warden's Ring",
        right_ring="Fortified Ring",
        back="Reiki Cloak",
    })
    sets.idle.Regen = set_combine(sets.idle, {
        body="Sacro Breastplate",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    })
    sets.idle.Refresh = set_combine(sets.idle, {
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    })
 
     sets.idle.Weak = set_combine(sets.idle, {
        head="Crepuscular Helm",
        body="Crepuscular Mail",
        back="Moonlight Cape",
    })

    sets.Kiting = {feet="Hermes' Sandals +1"}
    sets.Adoulin = {body="Councilor's Garb"}
    sets.MoveSpeed = {feet="Hermes' Sandals +1"}
    sets.Terror = {feet="Founder's Greaves"}

    sets.Reraise = {
        head="Crepuscular Helm",
        body="Crepuscular Mail",}

 
     -- Engaged set, assumes Liberator
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Boii Lorica +3",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Niqmaddu Ring",
        right_ring="Petrov Ring",
    back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }
    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Boii Lorica +3",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs="Pumm. Cuisses +3",
        feet="Pumm. Calligae +3",
        neck={ name="War. Beads +2", augments={'Path: A',}},
        waist="Ioskeha Belt +1",
        left_ear="Telos Earring",
        right_ear="Boii Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     })

    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Boii Lorica +3",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet="Pumm. Calligae +3",
        neck="Ainia Collar",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    })

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

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

     -- Defensive sets to combine with various weapon-specific sets below
     -- These allow hybrid acc/pdt sets for difficult content
     sets.Defensive = {
        head={ name="Sakpata's Helm", augments={'Path: A',}}, -- 4% haste
        body={ name="Sakpata's Plate", augments={'Path: A',}}, -- 2% haste
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}}, -- 4% haste
        legs={ name="Sakpata's Cuisses", augments={'Path: A',}}, -- 4% haste
        feet={ name="Sakpata's Leggings", augments={'Path: A',}}, -- 2% haste
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},-- 9% haste
    }

    sets.engaged.SubtleBlow = set_combine(sets.engaged, {        
        body="Dagon Breast.",
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Schere Earring", augments={'Path: A',}},
        right_ear="Boii Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Niqmaddu Ring",
    })

    sets.engaged.H2H = {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body={ name="Sakpata's Plate", augments={'Path: A',}},
        hands={ name="Sakpata's Gauntlets", augments={'Path: A',}},
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

    sets.engaged.Counter = set_combine(sets.engaged, {
        ammo="Amar Cluster",
        body="Obviation Cuirass",
        hands={ name="Founder's Gauntlets", augments={'STR+7','Attack+10','"Mag.Atk.Bns."+8','Phys. dmg. taken -2%',}},
        feet={ name="Sakpata's Leggings", augments={'Path: A',}},
    left_ear="Genmei Earring",
    right_ear="Cryptic Earring",
    })
    sets.engaged.ressistwater = {
        head="Genmei Kabuto",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
    }


    sets.engaged.PDT = set_combine(sets.engaged, sets.Defensive)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.Defensive)
    sets.engaged.STP.PDT = set_combine(sets.engaged.STP, sets.Defensive)
    sets.engaged.CRIT.PDT = set_combine(sets.engaged.CRIT, sets.Defensive)
    sets.engaged.SubtleBlow.PDT = set_combine(sets.engaged.SubtleBlow, sets.Defensive,{  
        body="Dagon Breast.",
        left_ring="Defending Ring",
    })

    ------------------------------------------------------------------------------------------------
      ---------------------------------------- DW-HASTE ------------------------------------------
    ------------------------------------------------------------------------------------------------
    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    sets.engaged.DW = set_combine(sets.engaged, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
     })

    sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
     })
    sets.engaged.DW.STP = set_combine(sets.engaged.STP, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
     })
     sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
     })
     sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {
        left_ear="Suppanomimi",  --5
        right_ear="Eabani Earring", --4
     })

     sets.engaged.DW.PDT = set_combine(sets.engaged.DW, sets.Defensive)
     sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, sets.Defensive)
     sets.engaged.DW.STP.PDT = set_combine(sets.engaged.DW.STP, sets.Defensive)
     sets.engaged.DW.CRIT.PDT = set_combine(sets.engaged.DW.CRIT, sets.Defensive)
     sets.engaged.DW.SubtleBlow.PDT = set_combine(sets.engaged.DW.SubtleBlow, sets.Defensive,{  
        body="Dagon Breast.",
        left_ring="Defending Ring",
    })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


     sets.engaged.Reraise = set_combine(sets.engaged, {
     	head="Crepuscular Helm",
        body="Crepuscular Mail",     })
     sets.buff.Berserk = { 
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
     }
     sets.buff.Retaliation = { 
         hands="Pummeler's Mufflers +1"
     }
     sets.buff.Doom = {    neck="Nicander's Necklace",
     waist="Gishdubar Sash",
     left_ring="Purity Ring",
     right_ring="Blenmot's Ring +1",
     legs="Shabti Cuisses +1",
    }
     sets.buff.sleep = {neck="Vim Torque +1"}

    
end

function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    --elseif spell.target.distance > 8 and player.status == 'Engaged' then
    --    eventArgs.cancel = true
    --    add_to_chat(122,"Outside WS Range! /Canceling")
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
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
end
 
function job_post_precast(spell, action, spellMap, eventArgs)

	if spell.type:lower() == 'weaponskill' then
        
        if is_sc_element_today(spell) then
            if state.OffenseMode.current == 'Normal' and wsList:contains(spell.english) then
                equip(sets.WSDayBonus)
            end
        end
        -- Replace Moonshade Earring if we're at cap TP
        if player.tp == 3000 and spell.name ~= 'Decimation' then
            equip({left_ear="Lugra Earring +1"})
        end
        -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        if spell.type == 'WeaponSkill' then
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
    check_weaponset()

end

function job_post_aftercast(spell, action, spellMap, eventArgs)
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_moving()
    get_combat_form()
    get_combat_weapon()
    update_combat_form()
    check_weaponset()
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
    --if player.hpp < 90 then
        --idleSet = set_combine(idleSet, sets.idle.Regen)
    --end
    --[[if state.HybridMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.defense.PDT)
    end]]
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
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.Buff.Berserk and not state.Buff.Retaliation then
    	meleeSet = set_combine(meleeSet, sets.buff.Berserk)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.HybridMode.current == 'ressistwater' then
        meleeSet = set_combine(meleeSet, sets.engaged.ressistwater)
    end

    --[[if state.buff.sleep and player.hp > 120 and player.status == "Engaged" then -- Equip Vim Torque When You Are Asleep
        meleeSet = set_combine(meleeSet, sets.buff.Sleep)
    end]]
    check_weaponset()

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
    handle_equipping_gear(player.status)
    if newStatus == "Engaged" then
        if buffactive.Berserk and not state.Buff.Retaliation then
            equip(sets.buff.Berserk)
        end
        if not buffactive['Restraint'] then
            send_command('@input /ja "Restraint" <me>')
        end
        if not buffactive['Berserk'] then
            send_command('@wait 1.5;input /ja "Berserk" <me>')
        end
        get_combat_weapon()

    end

end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
    equip(sets[state.shield.current])
    if (player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC' and Hand_weapon:contains(player.equipment.main) ) then
        equip(sets.DefaultShield)
    elseif (player.sub_job == 'NIN' and player.sub_job_level < 10 or player.sub_job == 'DNC' and player.sub_job_level < 20 and Hand_weapon:contains(player.equipment.main) ) then
        equip(sets.DefaultShield)
    end

end
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    job_handle_equipping_gear(player.status)
    buff = string.lower(buff)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
    if buff == "Mighty Strikes" then
        if gain then  			
            send_command('input /p "Mighty Strikes" [ON]')		
        else	
            send_command('input /p "Mighty Strikes" [OFF]')
        end
    end
    if buff == "Warcry" and buffactive['Warcry'] then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [active]')
        
    end
	if buff == "Warcry" then
        if gain then  			
            send_command('input /p "Warcry" [ON]')		
        else	
            send_command('input /p "Warcry" [OFF]')
        end
    end

    if buff == "Blood Rage" then
        if gain then  			
            send_command('input /p "Blood Rage" [ON]')		
        else	
            send_command('input /p "Blood Rage" [OFF]')
        end
    end    
    if buff == "sleep" and gain and player.hp > 200 and player.status == "Engaged" then
        equip({neck="Vim Torque +1"})
        disable('neck')
    elseif not gain then 
        enable('neck')
        handle_equipping_gear(player.status)
    end
    if buff == "Restraint" and not gain then
        if player.status == 'Engaged' then
            send_command('@input /ja "Restraint" <me>')		
        else
            if not midaction() then
                status_change(player.status)
            end
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
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
        end
    end
    if buff == "Berserk" then
        if gain and not buffactive['Retaliation'] then
            equip(sets.buff.Berserk)
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
    --[[if buff == "weakness" then
        if gain then
            equip(sets.Reraise)
            disable('body','head')
            else
            enable('body','head')
        end
        return meleeSet
    end]]
    if S{'terror','petrification','sleep','stun'}:contains(name) then
        if gain then
            equip(sets.defense.PDT)
        elseif not gain then 
            handle_equipping_gear(player.status)
        end
    end
    if name == 'sleep' then
        if gain and player.hp > 120 and player.status == 'Engaged' then -- Equip Vim Torque When You Are Asleep
            equip(sets.buff.Sleep)
			disable('neck')
        elseif not gain then 
			enable('neck')
            handle_equipping_gear(player.status)
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
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
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
    if buffactive["sleep"] then
        if player.hp > 200 and player.status == "Engaged" then -- Equip Vim's Torque When You Are Asleep & Have 200+ HP --
            equip({ neck="Vim Torque +1"})
        end
        
    end

    if buff == "poison" then
        if gain then  
        send_command('input /item "remedy" <me>')
        end
    end
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end
 
function check_buffs(check)
     
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end
function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
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
function job_update(cmdParams, eventArgs)
    check_moving()
    check_weaponset()

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
end
)

function get_custom_wsmode(spell, spellMap, default_wsmode)
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

windower.register_event('hpp change',-- code add from Aragan Asura
function(new_hpp,old_hpp)
    if new_hpp < 5 then
        equip(sets.Reraise)
    end
end
)

function get_combat_form()
    --if war_sj then
        --state.CombatForm:set("War")
    --else
        --state.CombatForm:reset()
    --end
    --[[if swordList:contains(player.equipment.main) then
        send_command('input /lockstyleset 152')
    end
    if gsList:contains(player.equipment.main) then
        send_command('input /lockstyleset 165')
    end]]
    if S{'NIN', 'DNC'}:contains(player.sub_job) and war_sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    elseif S{'SAM', 'DRK', 'PLD', 'DRG', 'RUN'}:contains(player.sub_job) and player.equipment.sub ~= 'Blurred Shield +1' then
        state.CombatForm:set("OneHand")
    else
        state.CombatForm:reset()
    end
    check_weaponset()
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
    check_weaponset()

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
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if update_job_states then update_job_states() 
    end

    check_weaponset()
    job_handle_equipping_gear(player.status)

end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 152')
    end
end

windower.register_event('zone change',
    function()
        --add that at the end of zone change
        if update_job_states then update_job_states() end
    end
)

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

