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
    "Airmid's Gorget",
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
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.FootworkWS = M(false, 'Footwork on WS')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.Moving  = M(false, "moving")

    include('Mote-TreasureHunter')
    send_command('wait 6;input /lockstyleset 179')
    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.WeaponskillMode:options('Normal', 'PDL', 'Fodder')
    state.HybridMode:options('Normal', 'PDT', 'SubtleBlow', 'Counter')
    state.PhysicalDefenseMode:options('PDT', 'HP')
    state.HippoMode = M{['description']='Hippo Mode', 'normal','Hippo'}

    update_combat_form()
    update_melee_groups()
    --send_command('bind != gs c toggle CapacityMode')
    send_command('wait 2;input /lockstyleset 179')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind f4 input //fillmode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    select_default_macro_book()

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
end
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('lua u AutoCOR')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Hesychast's Hose +1"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1"}
    sets.precast.JA['Dodge'] = {feet="Anch. Gaiters +3"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown +1"}
    sets.precast.JA['Counterstance'] = {feet="Hesychast's Gaiters +1"}
    sets.precast.JA['Footwork'] = {feet="Anch. Gaiters +3"}
    sets.precast.JA['Formless Strikes'] = {body="Hesychast's Cyclas"}
    sets.precast.JA['Mantra'] = {feet="Hesychast's Gaiters +1"}

    sets.precast.JA['Chi Blast'] = {head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
}

    sets.precast.JA['Chakra'] = {
        ammo="Iron Gobbet",
        head="Genmei Kabuto",
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        left_ear={ name="Handler's Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring="Niqmaddu Ring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        body="Passion Jacket",
        legs="Dashing Subligar",
    }
    sets.TreasureHunter = {ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt"}
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}
    sets.CapacityMantle  = { }


    -- Fast cast sets for spells
    
    sets.precast.FC = {    ammo="Sapience Orb",
    neck="Baetyl Pendant",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Rahab Ring",
    right_ring="Prolix Ring",
}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",
    body="Passion Jacket",

   })   sets.precast.RA = { ammo=empty,
   range="Trollbane",  


   }
       sets.midcast.RA = { ammo=empty,
        range="Trollbane",  

     }


       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Ishvara Earring",
        right_ear="Telos Earring",
        left_ring="Ilabrat Ring",
        right_ring="Cornelia's Ring",
        back="Segomo's Mantle",
    }
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS.Mod = set_combine(sets.precast.WS, {
       
    })


    -- Specific weaponskill sets.
    
    -- legs={name="Quiahuiz Trousers", augments={'Phys. dmg. taken -2%','Magic dmg. taken -2%','STR+8'}}}

    sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Nyame Flanchard",
        feet="Mpaca's Boots",
        neck="Rep. Plat. Medal",
        waist="Moonbow Belt +1",
        right_ear="Schere Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",
    })
    sets.precast.WS["Raging Fists"].PDL = set_combine(sets.precast.WS["Raging Fists"], {
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS['Howling Fist'] = set_combine(sets.precast.WS, {
    ammo="Coiste Bodhar",
    head={ name="Mpaca's Cap", augments={'Path: A',}},
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Moonbow Belt +1",
    right_ear="Schere Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back="Segomo's Mantle",
    })
    sets.precast.WS["Howling Fist"].PDL = set_combine(sets.precast.WS["Howling Fist"], {
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    
    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Moonbow Belt +1",
        right_ear="Schere Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",
    })
    sets.precast.WS["Asuran Fists"].PDL = set_combine(sets.precast.WS["Asuran Fists"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS["Ascetic's Fury"] = set_combine(sets.precast.WS, {
       
    })
    sets.precast.WS["Ascetic's Fury"].PDL = set_combine(sets.precast.WS["Ascetic's Fury"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Mpaca's Doublet",
      hands="Mpaca's Gloves",
    legs={ name="Mpaca's Hose", augments={'Path: A',}},
    feet="Mpaca's Boots",
    neck="Fotia Gorget",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Schere Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back="Segomo's Mantle",
    })
    sets.precast.WS["Victory Smite"].PDL = set_combine(sets.precast.WS["Victory Smite"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mpaca's Doublet",
          hands="Mpaca's Gloves",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Moonbow Belt +1",
        left_ear="Sherida Earring",
        right_ear="Schere Earring",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",
    })
    sets.precast.WS["Shijin Spiral"].PDL = set_combine(sets.precast.WS["Shijin Spiral"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
    })

    sets.precast.WS['Dragon Kick'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Moonbow Belt +1",
        right_ear="Schere Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",
    })
    sets.precast.WS["Dragon Kick"].PDL = set_combine(sets.precast.WS["Dragon Kick"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS['Tornado Kick'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
    head={ name="Mpaca's Cap", augments={'Path: A',}},
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Moonbow Belt +1",
    right_ear="Schere Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back="Segomo's Mantle",
    })
    sets.precast.WS["Tornado Kick"].PDL = set_combine(sets.precast.WS["Tornado Kick"],{
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS["Black Halo"] = set_combine(sets.precast.WS, {
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
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Segomo's Mantle",  
    })
    sets.precast.WS["Black Halo"].PDL = set_combine(sets.precast.WS["Black Halo"], {
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })
    sets.precast.WS["Retribution"] = set_combine(sets.precast.WS, {
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
        left_ring="Regal Ring",
        right_ring="Cornelia's Ring",
        back="Segomo's Mantle",   
    })
    sets.precast.WS["Retribution"].PDL = set_combine(sets.precast.WS["Retribution"], {
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
    })

    sets.precast.WS["Shell Crusher"] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Moonlight Necklace",
        waist="Acuity Belt +1",
        left_ear="Digni. Earring",
        right_ear="Crep. Earring",
        left_ring="Stikini Ring +1",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Sacro Mantle",
    })

    sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS, { 
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mpaca's Doublet",
          hands="Mpaca's Gloves",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Moonbow Belt +1",
        left_ear="Sherida Earring",
        right_ear="Schere Earring",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",  
    })
    sets.precast.WS['Spinning Attack'].PDL = set_combine(sets.precast.WS, {   
        ammo="Crepuscular Pebble",
        hands="Bhikku Gloves +2",
        legs="Malignance Tights",
        left_ring="Sroda Ring", 
})

    sets.precast.WS["Raging Fists"].Mod = set_combine(sets.precast.WS["Raging Fists"], sets.precast.WS.Mod)
    sets.precast.WS["Howling Fist"].Mod = set_combine(sets.precast.WS["Howling Fist"], sets.precast.WS.Mod)
    sets.precast.WS["Asuran Fists"].Mod = set_combine(sets.precast.WS["Asuran Fists"], sets.precast.WS.Mod)
    sets.precast.WS["Ascetic's Fury"].Mod = set_combine(sets.precast.WS["Ascetic's Fury"], sets.precast.WS.Mod)
    sets.precast.WS["Victory Smite"].Mod = set_combine(sets.precast.WS["Victory Smite"], sets.precast.WS.Mod)
    sets.precast.WS["Shijin Spiral"].Mod = set_combine(sets.precast.WS["Shijin Spiral"], sets.precast.WS.Mod)
    sets.precast.WS["Dragon Kick"].Mod = set_combine(sets.precast.WS["Dragon Kick"], sets.precast.WS.Mod)
    sets.precast.WS["Tornado Kick"].Mod = set_combine(sets.precast.WS["Tornado Kick"], sets.precast.WS.Mod)


    sets.precast.WS['Cataclysm'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Archon Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Sacro Mantle",
    }
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
    }
        
    -- Specific spells
    sets.midcast.Utsusemi = {
    }

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body="Hiza. Haramaki +2",
        hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Moonbow Belt +1",
        left_ear="Infused Earring",
        right_ear="Odr Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    }
    

    -- Idle sets
    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Moonbow Belt +1",
        left_ear="Odnowa Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Chirich Ring +1",
        right_ring="Defending Ring",
        back="Moonlight Cape",

    }

    sets.idle.Town = {feet="Hermes' Sandals +1"}
    
    sets.idle.Weak = sets.idle
    
    -- Defense sets
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Moonbow Belt +1",
        left_ear="Odnowa Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

    sets.defense.HP = {
        ammo="Staunch Tathlum +1",
        head="Genmei Kabuto",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ear="Tuisto Earring",
        right_ring="Defending Ring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.defense.MDT = {	      
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Engraved Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Archon Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
}
    sets.MoveSpeed = {feet="Hermes' Sandals +1",}
    sets.Kiting = {feet="Hermes' Sandals +1",}
    sets.Adoulin = {body="Councilor's Garb",}

    sets.ExtraRegen = {    head={ name="Rao Kabuto", augments={'VIT+10','Attack+20','"Counter"+3',}},
    body="Hiza. Haramaki +2",
    hands={ name="Rao Kote", augments={'Accuracy+10','Attack+10','Evasion+15',}},
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee sets
    sets.engaged = {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mpaca's Doublet",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Bhikku Hose +2",
        feet="Malignance Boots",
        neck="Moonbeam Nodowa",
        waist="Moonbow Belt +1",
        left_ear="Sherida Earring",
        right_ear="Mache Earring +1",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",
    }

    sets.engaged.Acc = {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head="Malignance Chapeau",
        body="Mpaca's Doublet",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Bhikku Hose +2",
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Moonbeam Nodowa",
        waist="Moonbow Belt +1",
        left_ear="Mache Earring +1",
        right_ear="Mache Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Segomo's Mantle",
    }

    sets.engaged.Fodder = {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Hiza. Somen +2",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Bhikku Hose +2",
        feet="Mpaca's Boots",
        neck="Moonbeam Nodowa",
        waist="Moonbow Belt +1",
        left_ear="Sherida Earring",
        right_ear="Mache Earring +1",
        left_ring="Gere Ring",
        right_ring="Niqmaddu Ring",
        back="Segomo's Mantle",

    }

    -- Defensive melee hybrid sets
    sets.engaged.PDT = {       
    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
	right_ring="Defending Ring",
    back="Segomo's Mantle",
}

    sets.engaged.Acc.PDT = {	
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
    body="Mpaca's Doublet",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Malignance Tights",
    feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
    neck="Moonbeam Nodowa",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Niqmaddu Ring",
	right_ring="Defending Ring",
    back="Segomo's Mantle",
		
	}
    sets.engaged.Counter = {
		ammo="Amar Cluster",
		head="Hiza. Somen +2",
		body="Mpaca's Doublet",
		hands={ name="Rao Kote", augments={'Accuracy+10','Attack+10','Evasion+15',}},
        legs="Bhikku Hose +2",
		feet="Hiza. Sune-Ate +2",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Moonbow Belt +1",
        right_ear="Mache Earring +1",
		left_ear="Cryptic Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Defending Ring",
		back="Segomo's Mantle",
		
	}
    sets.engaged.Acc.Counter = {ammo="Amar Cluster",
	head="Hiza. Somen +2",
	body="Mpaca's Doublet",
	hands={ name="Rao Kote", augments={'Accuracy+10','Attack+10','Evasion+15',}},
    legs="Bhikku Hose +2",
	feet="Hiza. Sune-Ate +2",
    neck="Anu Torque",
	waist="Moonbow Belt +1",
    right_ear="Mache Earring +1",
    left_ear="Cryptic Earring",
	left_ring="Niqmaddu Ring",
	right_ring="Defending Ring",
    back="Segomo's Mantle",
}
sets.engaged.SubtleBlow = set_combine(sets.engaged, {
    ammo="Staunch Tathlum +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs={ name="Mpaca's Hose", augments={'Path: A',}},
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Defending Ring",
    back="Segomo's Mantle",
})
sets.engaged.Acc.SubtleBlow = set_combine(sets.engaged.Acc, {
    ammo="Staunch Tathlum +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs={ name="Mpaca's Hose", augments={'Path: A',}},
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Chirich Ring +1",
    right_ring="Defending Ring",
    back="Segomo's Mantle",
})




    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged)
    sets.engaged.HF.Impetus = set_combine(sets.engaged, {body="Bhikku Cyclas +2"})
    sets.engaged.Impetus = set_combine(sets.engaged, {body="Bhikku Cyclas +2"})
    sets.engaged.Acc.Impetus = set_combine(sets.engaged.Acc, {body="Bhikku Cyclas +2"})
    sets.engaged.Acc.HF = set_combine(sets.engaged.Acc)
    sets.engaged.Acc.HF.Impetus = set_combine(sets.engaged.Acc, {body="Bhikku Cyclas +2"})
    sets.engaged.Counter.HF = set_combine(sets.engaged.Counter)
    sets.engaged.Counter.HF.Impetus = set_combine(sets.engaged.Counter, {body="Bhikku Cyclas +2"})
    sets.engaged.Acc.Counter.HF = set_combine(sets.engaged.Acc.Counter)
    sets.engaged.Acc.Counter.HF.Impetus = set_combine(sets.engaged.Acc.Counter, {body="Bhikku Cyclas +2"})
    sets.engaged.Acc.Impetus = set_combine(sets.engaged.Acc, {body="Bhikku Cyclas +2"})

    --sets.engaged.SubtleBlow.HF = set_combine(sets.SubtleBlow, {body="Bhikku Cyclas +2"})
    --sets.engaged.SubtleBlow.HF.Impetus = set_combine(sets.SubtleBlow, {body="Bhikku Cyclas +2"})
    --sets.engaged.SubtleBlow.Impetus = set_combine(sets.SubtleBlow, {body="Bhikku Cyclas +2"})
    --sets.engaged.SomeAcc.SubtleBlow.Impetus = set_combine(sets.engaged.SomeAcc.SubtleBlow, {body="Bhikku Cyclas +2"})


    -- Footwork combat form
    --sets.engaged.Footwork = {}
    --sets.engaged.Footwork.Acc = {} 
        
    -- Quick sets for post-precast adjustments, listed here so that the gear can be Validated.
    sets.impetus_body = {body="Bhikku Cyclas +2"}
    sets.footwork_kick_feet = {feet="Anch. Gaiters +3"}
    sets.buff.Doom = {neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Lugra Earring +1"})
		end
	end
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Tantra to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
        
         -- CP mantle must be worn when a mob dies, so make sure it's equipped for WS.
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        -- Replace Moonshade Earring if we're at cap TP
    end
    
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
        send_command('cancel Footwork')
    end
    if (buff == "Impetus" and gain) or buffactive.impetus then
        equip({body="Bhikku Cyclas +2"})
    end
    if state.Buff["Impetus"] then
        equip({body="Bhikku Cyclas +2"})
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end

    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    return meleeSet

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
    if buff == "terror" then
        if gain then
            send_command('input /p i am TERROR cant move.')		
            equip(sets.defense.PDT)
        end
        handle_equipping_gear(player.status)
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

    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
        if (buff == "Impetus" and gain) or buffactive.impetus then
            equip({body="Bhikku Cyclas +2"})
        end
        if state.Buff["Impetus"] then
            equip({body="Bhikku Cyclas +2"})
        end
    
    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
    if not midaction() then
        job_update()
    end
end
function check_buffs(check)
     
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if state.HippoMode.value == "Hippo" then
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    elseif state.HippoMode.value == "normal" then
       equip({})
    end
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    return idleSet
end
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if (buff == "Impetus" and gain) or buffactive.impetus then
        equip({body="Bhikku Cyclas +2"})
    end
    if state.Buff["Impetus"] then
        equip({body="Bhikku Cyclas +2"})
    end
    return meleeSet
end
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    update_melee_groups()
end
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if (buff == "Impetus" and gain) or buffactive.impetus then
        equip({body="Bhikku Cyclas +2"})
    end
    if state.Buff["Impetus"] then
        equip({body="Bhikku Cyclas +2"})
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    if (buff == "Impetus" and gain) or buffactive.impetus then
        equip(sets.impetus_body)
    end
    if state.Buff["Impetus"] then
        equip({body="Bhikku Cyclas +2"})
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end
    
    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
    if (buff == "Impetus" and gain) or buffactive.impetus then
        equip(sets.impetus_body)
    end
    if state.Buff["Impetus"] then
        equip({body="Bhikku Cyclas +2"})
    end
end

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 179')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

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

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _,target in pairs(action.targets) do
                if target.id == player.id then
                    for _,action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end
        
        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
    
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'THF' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'RUN' then
        set_macro_page(2, 12)
    else
        set_macro_page(2, 12)
    end
end