-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
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
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
  
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end
organizer_items = {
    "Pixquizpan",
    "Maliya Sickle +1",
    "Foreshock Sword",
    "Hepatizon Axe +1",
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
-- Setup vars that are user-independent.
function job_setup()
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    send_command('wait 6;input /lockstyleset 166')
    send_command('bind !` gs c toggle MagicBurst')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    state.MagicBurst = M(false, 'Magic Burst')
    state.Buff.Souleater = buffactive.souleater or false
    state.Buff['Last Resort'] = buffactive['Last Resort'] or false
    -- Set the default to false if you'd rather SE always stay acitve
    state.SouleaterMode = M(true, 'Soul Eater Mode')
    -- state.LastResortMode = M(false, 'Last Resort Mode')
    -- Use Gavialis helm?
    use_gavialis = true
  
    -- Weaponskills you want Gavialis helm used with (only considered if use_gavialis = true)
    wsList = S{}
    -- Greatswords you use. 
    gsList = S{'Ragnarok','Caladbolg','Nandaka'}
    scytheList = S{'Apocalypse'}
    remaWeapons = S{'Apocalypse','Ragnarok','Nandaka'}
  
    shields = S{'Blurred Shield +1'}
    -- Mote has capitalization errors in the default Absorb mappings, so we use our own
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    -- Offhand weapons used to activate DW mode
    swordList = S{"Naegling", "Sangarius +1", "Usonmunku", "Perun +1", "Tanmogayi", "Loxotic Mace +1"}
    sets.weaponList = {"Apocalypse", "Nandaka", "Blurred Shield +1", "Naegling", "Sangarius +1", "Usonmunku", "Perun +1", "Tanmogayi", "Loxotic Mace +1"}

    get_combat_form()
    update_melee_groups()
end
  
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
  
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'PD', 'Mid', 'STP', 'DA', 'MaxAcc', 'SubtleBlow', 'crit')
    state.HybridMode:options('Normal', 'DreadSP', 'PDT')
    state.WeaponskillMode:options('Normal', 'Mid', 'PDL', 'SC', 'Dread')  ---Mid for Scythe removes Ratri for safer WS---For Resolution removes Agrosy for Meva---
    state.CastingMode:options('Normal', 'MB', 'ConserveMP', 'sird')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Enmity', 'Dread Spikes', 'SEboost', 'Reraise')
    state.MagicalDefenseMode:options('MDT')
    state.IdleMode:options('Normal', 'Refresh')

      
    war_sj = player.sub_job == 'WAR' or false
  
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c toggle SouleaterMode')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind ^/ gs disable all')
    send_command('bind ^- gs enable all')
    send_command('wait 2;input /lockstyleset 166')

    select_default_macro_book()
end
  
function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
    send_command('unbind f5')

end
  
  
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
      
    -- Precast sets to enhance JAs
    sets.precast.JA['Last Resort'] = {back="Ankou's mantle", feet={ name="Fallen's Sollerets", augments={'Enhances "Desperate Blows" effect',}},}
    sets.precast.JA['Nether Void'] = {Legs="Heathen's Flanchard +1"}
    sets.precast.JA['Blood Weapon'] = {body="Fall. Cuirass +2"}
    sets.precast.JA['Arcane Circle'] = {feet="Ignominy Sollerets +3"}
    sets.precast.JA['Weapon Bash'] = {hands="Ignominy Gauntlets +3"}
    sets.precast.JA['Souleater'] = {head="Ignominy Burgonet +3"}
    sets.precast.JA['Dark Seal'] = {head="Fallen's Burgeonet +3"}
    sets.precast.JA['Diabolic Eye'] = {hands="Fall. Fin. Gaunt. +3"}
      
    
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
          
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
      
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}
  
    -- Fast cast sets for spells
    sets.TreasureHunter = { 
        ammo="Per. Lucky Egg",
        head="White rarab cap +1", 
        waist="Chaac Belt",
     }

    sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        body={ name="Odyss. Chestplate", augments={'Attack+23','"Fast Cast"+5','STR+8','Accuracy+15',}},
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Austerity Belt +1",
        left_ear="Loquac. Earring",
        right_ear="Malignance Earring",
        left_ring="Kishar Ring",
        right_ring="Rahab Ring",
        back="Solemnity Cape",
}
  
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
  
    
    sets.precast.RA = { ammo=empty,
        range="Trollbane",  
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        waist="Yemaya Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Purity Ring",
        right_ring="Ilabrat Ring",

    }
    sets.midcast.RA = { ammo=empty,
        range="Trollbane",  
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        waist="Yemaya Belt",
        left_ear="Crep. Earring",
        right_ear="Telos Earring",
        left_ring="Purity Ring",
        right_ring="Ilabrat Ring",
    }	
         
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Cornelia's Ring",
        right_ring="Niqmaddu Ring",
        back="Ankou's Mantle",
}
    sets.precast.WS.Dread  = sets.defense['Dread Spikes']
    sets.precast.WS.Mid = set_combine(sets.precast.WS, {       
        head={ name="Nyame Helm", augments={'Path: B',}},
       body={ name="Nyame Mail", augments={'Path: B',}},
       hands={ name="Nyame Gauntlets", augments={'Path: B',}},
       legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
       feet="Heath. Sollerets +2",
        })

    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    ammo="Crepuscular Pebble",
    head="Heath. Burgeon. +2",
    body="Nyame Mail",
    hands="Sakpata's Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    right_ear={ name="Heathen's Earring", augments={'Accuracy+7','Mag. Acc.+7',}},
    right_ring="Sroda Ring",
    })
    sets.precast.WS.SC = set_combine(sets.precast.WS, {       
       head="Nyame Helm",
       body="Nyame Mail",
       hands="Nyame Gauntlets",
       legs="Nyame Flanchard",
       feet="Nyame Sollerets",
       neck={ name="Warder's Charm +1", augments={'Path: A',}},
       })
    sets.precast.WS.Judgment = set_combine(sets.precast.WS, {
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    })
    sets.precast.WS.Judgment.PDL = set_combine(sets.precast.WS.Judgment, {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS.Judgment.SC = set_combine(sets.precast.WS.Judgment, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Vorpal Scythe'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Hjarrandi Breast.",
        hands="Flam. Manopolas +2",
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet="Thereoid Greaves",
        neck="Nefarious Collar +1",
        waist="Gerdr Belt",
        left_ear="Schere Earring",
        right_ear="Brutal Earring",
        left_ring="Hetairoi Ring",
        right_ring="Niqmaddu Ring",
        back="Ankou's Mantle",
    })
    sets.precast.WS['Power Slash'] = set_combine(sets.precast.WS['Vorpal Scythe'], {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Catastrophe'] = {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Thrud Earring",
        left_ring="Cornelia's Ring",
        right_ring="Niqmaddu Ring",
        back="Ankou's Mantle",
}
  
    sets.precast.WS['Catastrophe'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Catastrophe'].Mid = set_combine(sets.precast.WS['Catastrophe'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
    })
    sets.precast.WS['Catastrophe'].PDL = set_combine(sets.precast.WS['Catastrophe'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        body="Nyame Mail",
        hands="Sakpata's Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear={ name="Heathen's Earring", augments={'Accuracy+7','Mag. Acc.+7',}},
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Catastrophe'].SC = set_combine(sets.precast.WS['Catastrophe'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Catastrophe'], {})
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Catastrophe'], {})
    sets.precast.WS['Savage Blade'].SC = set_combine(sets.precast.WS['Catastrophe'], {})


    sets.precast.WS['Spiral Hell'] = set_combine(sets.precast.WS, {
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    })
    sets.precast.WS['Spiral Hell'].Mid = set_combine(sets.precast.WS.Mid, {
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    })
    sets.precast.WS['Spiral Hell'].PDL = set_combine(sets.precast.WS['Spiral Hell'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Spiral Hell'].SC = set_combine(sets.precast.WS['Spiral Hell'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

sets.precast.WS['Insurgency'] = {
    ammo="Knobkierrie",
    head="Hjarrandi Helm",
    body="Nyame Mail",
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Sakpata's Leggings",
    neck="Fotia Gorget",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Balder Earring +1",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back="Ankou's Mantle",
}
  
    sets.precast.WS['Insurgency'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Insurgency'].Mid = set_combine(sets.precast.WS['Insurgency'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Sakpata's Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",    })
    sets.precast.WS['Insurgency'].PDL = set_combine(sets.precast.WS['Insurgency'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        legs="Sakpata's Cuisses",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",    })

    sets.precast.WS['Insurgency'].SC = set_combine(sets.precast.WS['Insurgency'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},  })
  
    sets.precast.WS['Cross Reaper'] = {
        ammo="Knobkierrie",
        head="Hjarrandi Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sakpata's Leggings",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back="Ankou's Mantle",
}
  
    sets.precast.WS['Cross Reaper'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Cross Reaper'].Mid = set_combine(sets.precast.WS['Cross Reaper'], {
    })
    sets.precast.WS['Cross Reaper'].PDL = set_combine(sets.precast.WS['Cross Reaper'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Cross Reaper'].SC = set_combine(sets.precast.WS['Cross Reaper'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
  
sets.precast.WS['Quietus'] = {
    ammo="Knobkierrie",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Heath. Sollerets +2",
    neck="Fotia Gorget",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back="Ankou's Mantle",
} 
sets.precast.WS['Quietus'].Mid = set_combine(sets.precast.WS['Quietus'], {
    head="Nyame Helm",
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Heath. Sollerets +2",
})
sets.precast.WS['Quietus'].PDL = set_combine(sets.precast.WS['Quietus'], {
    ammo="Crepuscular Pebble",
    head="Heath. Burgeon. +2",
    hands="Sakpata's Gauntlets",
    right_ear="Heathen's Earring",
    right_ring="Sroda Ring",
})
sets.precast.WS['Quietus'].SC = set_combine(sets.precast.WS['Quietus'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
})

sets.precast.WS['Entropy'] = {
    ammo="Knobkierrie",
    head="Hjarrandi Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Fotia Gorget",
    head="Hjarrandi Helm",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Balder Earring +1",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back="Bleating Mantle",
} 
sets.precast.WS['Entropy'].Mid = set_combine(sets.precast.WS['Entropy'], {})

sets.precast.WS['Entropy'].PDL = set_combine(sets.precast.WS['Entropy'], {
    ammo="Crepuscular Pebble",
    head="Heath. Burgeon. +2",
    hands="Sakpata's Gauntlets",
    right_ear="Heathen's Earring",
    right_ring="Sroda Ring",
})
sets.precast.WS['Entropy'].SC = set_combine(sets.precast.WS['Entropy'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
})

sets.precast.WS['Infernal Scythe'] = {   
ammo="Pemphredo Tathlum",
head="Pixie Hairpin +1",
body="Nyame Mail",
hands="Nyame Gauntlets",
legs="Nyame Flanchard",
feet="Nyame Sollerets",
neck="Sibyl Scarf",
waist="Orpheus's Sash",
left_ear="Friomisi Earring",
right_ear="Malignance Earring",
left_ring="Archon Ring",
right_ring="Cornelia's Ring",
back="Ankou's Mantle",
}
sets.precast.WS['Infernal Scythe'].Dread  = sets.defense['Dread Spikes']
sets.precast.WS['Infernal Scythe'].Mid = set_combine(sets.precast.WS['Infernal Scythe'], {})

sets.precast.WS['Infernal Scythe'].PDL = set_combine(sets.precast.WS['Infernal Scythe'], {
    ammo="Crepuscular Pebble",
    head="Heath. Burgeon. +2",
    hands="Sakpata's Gauntlets",
    right_ear="Heathen's Earring",
    right_ring="Sroda Ring",
})
sets.precast.WS['Infernal Scythe'].SC = set_combine(sets.precast.WS['Infernal Scythe'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
})
sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS['Infernal Scythe'], {neck="Sibyl Scarf",})
sets.precast.WS['Shadow of Death'].Mid = set_combine(sets.precast.WS['Infernal Scythe'], {neck="Sibyl Scarf",})
sets.precast.WS['Shadow of Death'].PDL = set_combine(sets.precast.WS['Infernal Scythe'].PDL, {neck="Sibyl Scarf",})
sets.precast.WS['Shadow of Death'].SC = set_combine(sets.precast.WS['Infernal Scythe'].SC, {neck="Sibyl Scarf",})
sets.precast.WS['Dark Harvest'] = set_combine(sets.precast.WS['Infernal Scythe'], {})
sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Infernal Scythe'], {})
sets.precast.WS['Freezebite'] = set_combine(sets.precast.WS['Infernal Scythe'], {
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})
sets.precast.WS['Frostbite'] = set_combine(sets.precast.WS['Infernal Scythe'], {
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},})

sets.precast.WS['Nightmare Scythe'] = {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck="Subtlety Spec.",
    waist="Olseni Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Rufescent Ring",
    right_ring="Chirich Ring +1",
    back="Ankou's Mantle",}


    sets.precast.WS['Resolution'] = {
    ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Flam. Gambieras +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Schere Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Regal Ring",
    back="Bleating Mantle",
}
  
    sets.precast.WS['Resolution'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Resolution'].PDL = set_combine(sets.precast.WS['Resolution'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Sickle Moon'] = set_combine(sets.precast.WS['Resolution'], {})

    sets.precast.WS['Ground Strike'] = {
        ammo="Knobkierrie",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Lugra Earring +1",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back="Ankou's Mantle",
    } 
    sets.precast.WS['Ground Strike'].Mid = set_combine(sets.precast.WS['Ground Strike'], {
        head="Nyame Helm",
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
    })
    sets.precast.WS['Ground Strike'].PDL = set_combine(sets.precast.WS['Ground Strike'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Ground Strike'].SC = set_combine(sets.precast.WS['Ground Strike'], {
        head="Nyame Helm",
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
    })
    sets.precast.WS['Scourge'] = set_combine(sets.precast.WS['Torcleaver'], {})
    sets.precast.WS['Scourge'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Scourge'].PDL = set_combine(sets.precast.WS['Torcleaver'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
      
    sets.precast.WS['Torcleaver'] = {
    ammo="Knobkierrie",
    head="Sakpata's Helm",
    body="Nyame Mail",
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Heath. Sollerets +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back="Ankou's Mantle",
    }       
    sets.precast.WS['Torcleaver'].Dread  = sets.defense['Dread Spikes']
    sets.precast.WS['Torcleaver'].Mid = set_combine(sets.precast.WS['Torcleaver'], {})
    sets.precast.WS['Torcleaver'].PDL = set_combine(sets.precast.WS['Torcleaver'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
    })
    sets.precast.WS['Torcleaver'].SC = set_combine(sets.precast.WS['Torcleaver'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Spinning Scythe'] = {
        ammo="Knobkierrie",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Nyame Mail", augments={'Path: B',}},
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back="Ankou's Mantle",
}
    sets.precast.WS['Spinning Scythe'].PDL = set_combine(sets.precast.WS['Spinning Scythe'], {
        ammo="Crepuscular Pebble",
        head="Heath. Burgeon. +2",
        hands="Sakpata's Gauntlets",
        right_ear="Heathen's Earring",
        right_ring="Sroda Ring",
})
sets.precast.WS['Spinning Slash'] = set_combine(sets.precast.WS['Spinning Scythe'], {
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Lugra Earring +1",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",})

sets.precast.WS['Spinning Slash'].SC = set_combine(sets.precast.WS['Spinning Scythe'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
})
sets.precast.WS['Spinning Slash'].PDL = set_combine(sets.precast.WS['Spinning Scythe'], {
    ammo="Crepuscular Pebble",
    head="Heath. Burgeon. +2",
    hands="Sakpata's Gauntlets",
    right_ear="Heathen's Earring",
    right_ring="Sroda Ring",
})
      
    --------------------------------------
    -- Midcast sets
    --------------------------------------
  
    sets.midcast.FastRecast = {   
         ammo="Staunch Tathlum +1",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Halasz Earring",
    right_ear="Mendi. Earring",
    right_ring="Evanescence Ring",
}
          
    sets.midcast.Enmity = {
        ammo="Iron Gobbet",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body={ name="Emet Harness +1", augments={'Path: A',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
        feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Cryptic Earring",
        right_ear="Trux Earring",
        left_ring="Vengeful Ring",
        right_ring="Petrov Ring",
        back="Reiki Cloak",
    }
  
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {

    })
      
    sets.midcast.Cure = {    ammo="Staunch Tathlum +1",
    head={ name="Loess Barbuta +1", augments={'Path: A',}},
    body={ name="Jumalik Mail", augments={'HP+40','Enmity+2',}},
    hands="Macabre Gaunt. +1",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Austerity Belt +1",
    left_ear="Halasz Earring",
    right_ear="Mendi. Earring",
    left_ring="Defending Ring",
    right_ring="Naji's Loop",
    back="Solemnity Cape",}

    sets.midcast.Cure.ConserveMP = set_combine(sets.midcast.Cure,{
    ammo="Pemphredo Tathlum",
    legs="Augury Cuisses",
    neck="Reti Pendant",
    waist="Austerity Belt +1",
    right_ear="Mendi. Earring",
    left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",} )
    
    sets.midcast.Cure.sird = set_combine(sets.midcast.Cure,{
        ammo="Staunch Tathlum +1",
        legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ear="Halasz Earring",
        left_ring="Evanescence Ring",
    })
    sets.midcast['Dread Spikes'] = {
        ammo="Staunch Tathlum +1",
        head="Ratri Sallet",
        body="Heath. Cuirass +2",
        hands="Ratri Gadlings",
        legs="Ratri Cuisses",
        feet="Ratri Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Moonlight Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
}
    sets.midcast['Dark Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body={ name="Fall. Cuirass +3", augments={'Enhances "Blood Weapon" effect',}},
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Heath. Sollerets +2",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Dignitary's Earring",
    left_ring="Evanescence Ring",
    right_ring="Archon Ring",
    back="Argocham. Mantle",
}
      sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'], {
        -- neck="Sanctity Necklace",
        -- back="Niht Mantle",
        -- hands="Flamma Manopolas +2",
        neck="Erra Pendant",
        ring1="Evanescence Ring", -- 10
        ring2="Kishar Ring",
    })
     -- Drain spells 
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        neck="Erra Pendant",
        waist="Austerity Belt +1",
        right_ring="Evanescence Ring",
    })
    sets.midcast.Aspir = set_combine(sets.midcast['Dark Magic'], {
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        neck="Erra Pendant",
        waist="Austerity Belt +1",
        right_ring="Evanescence Ring",
    })
  
    sets.midcast.Drain.Acc = set_combine(sets.midcast['Dark Magic'], {
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        neck="Erra Pendant",
        waist="Austerity Belt +1",
        right_ring="Evanescence Ring",
    })
    sets.midcast.Aspir.Acc = sets.midcast.Drain.Acc
      
    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Fall. Cuirass +2",
        hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
        legs="Nyame Flanchard",
        feet="Heath. Sollerets +2",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Locus Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Argocham. Mantle",
    }
    sets.midcast['Elemental Magic'].MB = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Locus Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Argocham. Mantle",
    }
    sets.magic_burst = set_combine(sets.midcast['Elemental Magic'], {
        head="Nyame Helm",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        left_ring="Locus Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    })
  
   sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Dark Magic'], {
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body="Nyame Mail",
    hands={ name="Fall. Fin. Gaunt. +3", augments={'Enhances "Diabolic Eye" effect',}},
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Nyame Sollerets",
    neck="Incanter's Torque",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Crep. Earring",
    left_ring="Kishar Ring",
    right_ring="Stikini Ring +1",
    })
      
    sets.midcast['Enhancing Magic'] = {
    head="Befouled Crown",
    body="Shab. Cuirass +1",
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
  
         -- Resting sets
    sets.resting = {
        head=empty,
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    }
    -- Idle sets
    sets.idle = {
    ammo="Staunch Tathlum +1",
    head=empty,
    body={ name="Lugra Cloak +1", augments={'Path: A',}},
    hands="Sakpata's Gauntlets",
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Moonlight Cape",
}
  
    sets.idle.Town = {
        ammo="Staunch Tathlum +1",
        head=empty,
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        hands="Sakpata's Gauntlets",
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        feet="Sakpata's Leggings",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Infused Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
}
    sets.idle.Field = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1",
        head=empty,
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        hands="Sakpata's Gauntlets",
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        feet="Sakpata's Leggings",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Infused Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    })

    sets.idle.Weak = {head="Twilight Helm",body="Twilight Mail"}
    sets.idle.Field.Weak = {head="Twilight Helm",body="Twilight Mail"}

      
    sets.idle.Refresh = set_combine(sets.idle, {        head=empty,
        body={ name="Lugra Cloak +1", augments={'Path: A',}},
        neck={ name="Vim Torque +1", augments={'Path: A',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    })
  
    sets.idle.Sphere = set_combine(sets.idle, {   })
  
    --------------------------------------
    -- Defense sets
    --------------------------------------
  
  
    -- Basic defense sets.
          
    sets.defense.PDT = {
        ammo="Staunch Tathlum +1",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Eabani Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}
    sets.defense.HP = {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Moonlight Ring",
        back="Moonlight Cape",
    }

sets.defense['Dread Spikes'] = {

    ammo="Coiste Bodhar",
    head="Ratri Sallet",
    body="Heath. Cuirass +2",
    hands="Ratri Gadlings",
    legs="Ratri Cuisses",
    feet="Ratri Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}

sets.defense.SEboost = {

    ammo="Eluder's Sachet",
    head="Ratri Sallet",
    body="Ratri Plate",
    hands="Ratri Gadlings",
    legs="Ratri Cuisses",
    feet="Ratri Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}
    sets.defense.MDT = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Tartarus Platemail",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Warder's Charm +1",
        waist="Asklepian Belt",
        left_ear="Eabani Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Shadow Ring",
        right_ring="Moonlight Ring",
        back="Engulfer Cape +1",
    }
    sets.defense.Enmity = {
        sub="Alber Strap",
        ammo="Iron Gobbet",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body="Obviation Cuirass",
        hands="Macabre Gaunt. +1",
        legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
        feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Cryptic Earring",
        right_ear="Trux Earring",
        left_ring="Vengeful Ring",
        right_ring="Petrov Ring",
        back="Reiki Cloak",
    }
    sets.defense.Reraise = set_combine(sets.defense.PDT, {
        ammo="Staunch Tathlum +1",
    head="Sakpata's Helm",
    head="Twilight Helm",
    body="Twilight Mail",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Etiolation Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
})
  
        sets.Kiting = {legs="Carmine Cuisses +1",
    }
    --------------------------------------
    -- Engaged sets
    --------------------------------------
      
    sets.engaged ={
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Flam. Zucchetto +2",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Moonlight Ring",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",
    }
    sets.engaged.Mid = {          
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Flam. Zucchetto +2",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Moonlight Ring",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",}
  
    sets.engaged.STP = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sulevia's Mask +2",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Moonlight Ring",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}
sets.engaged.DA = set_combine(sets.engaged, {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck="Asperity Necklace",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Brutal Earring",
    right_ear="Schere Earring",
    left_ring="Hetairoi Ring",
    right_ring="Niqmaddu Ring",
    back="Annealed Mantle",
})
sets.engaged.crit = set_combine(sets.engaged, {

    ammo="Yetshila +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Ioskeha Belt +1",
    left_ear="Schere Earring",
    right_ear="Brutal Earring",
    left_ring="Hetairoi Ring",
    right_ring="Niqmaddu Ring",
    back="Annealed Mantle",})

sets.engaged.PD = set_combine(sets.engaged, {

    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Dedition Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
})
      
    sets.engaged.MaxAcc = {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sulevia's Mask +2",
    body="Flamma Korazin +2",
    hands="Sulev. Gauntlets +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Sokolski Mantle",
}

sets.engaged.SubtleBlow = set_combine(sets.engaged, {        
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sakpata's Helm",
    body="Flamma Korazin +2",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Sakpata's Leggings",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Digni. Earring",
    right_ear="Telos Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",
})
      
      
    -- These only apply when delay is capped.
    sets.engaged.Haste = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.Mid = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.STP = set_combine(sets.engaged.STP, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.DA = set_combine(sets.engaged.SubtleBlow, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.crit = set_combine(sets.engaged.crit, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.PD = set_combine(sets.engaged.PD, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.MaxAcc = set_combine(sets.engaged.MaxAcc, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
  
    sets.engaged.Haste.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",
    })
      
  
    sets.engaged.Meva = {      
      ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Brutal Earring",
    right_ear="Dedition Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Petrov Ring",
    back="Annealed Mantle",
}
    sets.engaged.PDT = set_combine(sets.engaged, {
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    left_ring="Niqmaddu Ring",
    right_ring="Defending Ring",
})
      
    sets.engaged.Mid.Meva = set_combine(sets.engaged.Meva, {})
    sets.engaged.Mid.PDT = {ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back="Annealed Mantle",
}
      
    sets.engaged.MaxAcc.Meva = set_combine(sets.engaged.Meva, {})
    sets.engaged.MaxAcc.PDT = {ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back="Annealed Mantle",
}       
    -- Apocalypse
    sets.engaged.Apocalypse = set_combine(sets.engaged, {
        ammo={ name="Coiste Bodhar", augments={'Path: A',}},
        head="Flam. Zucchetto +2",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Cessance Earring",
        right_ear="Dedition Earring",
        left_ring="Moonlight Ring",
        right_ring="Niqmaddu Ring",
        back="Tactical Mantle",
    })
    sets.engaged.Apocalypse.STP = {
        ammo="Coiste Bodhar",
        head="Sulevia's Mask +2",
        body="Hjarrandi Breast.",
        hands="Flam. Manopolas +2",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        left_ring="Moonlight Ring",
        right_ring="Chirich Ring +1",
        back="Tactical Mantle",
    }
   sets.engaged.Apocalypse.DA = set_combine(sets.engaged, {
    ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck="Asperity Necklace",
    waist="Ioskeha Belt +1", 
    left_ear="Brutal Earring",
    right_ear="Schere Earring",
    left_ring="Hetairoi Ring",
    right_ring="Niqmaddu Ring",
    back="Annealed Mantle",
})
   sets.engaged.Apocalypse.Mid = {    
    ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Telos Earring",
    right_ear="Cessance Earring",
    left_ring="Moonlight Ring",
    right_ring="Chirich Ring +1",
    back="Tactical Mantle",
}   
    sets.engaged.Apocalypse.crit = set_combine(sets.engaged, {
    ammo="Yetshila +1",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Ioskeha Belt +1",
    left_ear="Schere Earring",
    right_ear="Brutal Earring",
    left_ring="Hetairoi Ring",
    right_ring="Niqmaddu Ring",
    back="Ankou's Mantle",
    })
    sets.engaged.Apocalypse.PD = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Ig. Flanchard +3",
        feet="Flam. Gambieras +2",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Cessance Earring",
        right_ear="Dedition Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    })
    sets.engaged.Apocalypse.PDT = set_combine(sets.engaged.Apocalypse, {
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        left_ring="Niqmaddu Ring",
        right_ring="Defending Ring",
    })
    sets.engaged.Apocalypse.MaxAcc = {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Sulevia's Mask +2",
    body="Sulevia's Plate. +2",
    hands="Sulev. Gauntlets +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Sokolski Mantle",
    }
    sets.engaged.Apocalypse.SubtleBlow = set_combine(sets.engaged, {
        body="Flamma Korazin +2",
        hands="Sulev. Gauntlets +2",
        legs="Ig. Flanchard +3",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Sarissapho. Belt",
        left_ear="Digni. Earring",
        right_ear="Schere Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back="Annealed Mantle",
    })

    sets.engaged.Apocalypse.DreadSP = set_combine(sets.engaged.Apocalypse, {
        body="Heath. Cuirass +2",
    })
    sets.engaged.Apocalypse.MaxAcc.DreadSP = set_combine(sets.engaged.MaxAcc.Apocalypse, {
        body="Heath. Cuirass +2",
    })
    sets.engaged.Apocalypse.DreadSP.PDT = set_combine(sets.engaged.Apocalypse, {
        body="Heath. Cuirass +2",
    })



    sets.engaged.Haste.Apocalypse = set_combine(sets.engaged.Apocalypse, {        ammo="Coiste Bodhar",
    waist="Ioskeha Belt +1",  })
    sets.engaged.Haste.Apocalypse.Mid = set_combine(sets.engaged.Apocalypse.Mid, {        ammo="Coiste Bodhar",
    waist="Ioskeha Belt +1",  })

    sets.engaged.Haste.Apocalypse.DA = set_combine(sets.engaged.Apocalypse.DA, {        ammo="Coiste Bodhar",
    waist="Ioskeha Belt +1",  })
    sets.engaged.Haste.Apocalypse.PD = set_combine(sets.engaged.Apocalypse.PD, {        ammo="Coiste Bodhar",
    waist="Ioskeha Belt +1",  })   

    sets.engaged.Haste.Apocalypse.STP = set_combine(sets.engaged.STP, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",    })
    sets.engaged.Haste.Apocalypse.Crit = set_combine(sets.engaged.crit, {
        ammo="Coiste Bodhar",
        waist="Ioskeha Belt +1",    })
    sets.engaged.Haste.Apocalypse.MaxAcc = set_combine(sets.engaged.MaxAcc, {})
  
    sets.engaged.Haste.Apocalypse.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {})

    sets.engaged.Reraise = set_combine(sets.engaged, {	
	head="Twilight Helm",
    body="Twilight Mail",})

    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}
    sets.Reraise = {head="Twilight Helm",body="Twilight Mail"}

  
end
  
  
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
  
  
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if world.time >= 17*60 or world.time < 7*60 and player.tp > 2600 then -- Dusk to Dawn time.
            equip({ear1="Lugra Earring +1", ear2="Thrud Earring"})
        end
        if world.time >= 17*60 or world.time < 7*60 then
            equip({ear2="Thrud Earring"})
        end
            if player.tp > 2700 then
            equip({ear1="Lugra Earring +1"})
        end 
    end
end
  
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
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
  
  
  
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
end
  
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    --if spell.english:startswith('Drain') then
        --if player.status == 'Engaged' and state.CastingMode.current == 'Normal' and player.hpp < 70 then
            --classes.CustomClass = 'OhShit'
        --end
    --end
    if (state.HybridMode.current == 'PDT' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
    end
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        end
    end
    if spell.skill == 'Elemental Magic' then
        if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) and spellMap ~= 'Helix' then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) and spellMap ~= 'Helix' then
            equip({waist="Hachirin-no-Obi"})
        end
    end
end
  
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_aftercast(spell)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end
  
function job_post_aftercast(spell, action, spellMap, eventArgs)
    --if spell.type == 'WeaponSkill' then
        --if state.Buff.Souleater and state.SouleaterMode.value then
            --send_command('@wait 1.0;cancel souleater')
            --enable("head")
        --end
    --end
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
end
function job_self_command(cmdParams, eventArgs)
    if player.hpp < 10 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        equip(sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    return
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.IdleMode.current == 'Sphere' then
        idleSet = set_combine(idleSet, sets.idle.Sphere)
    end
    if state.HybridMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.defense.PDT)
    end
    return idleSet
end
  
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    if state.Buff['Souleater'] then
        meleeSet = set_combine(meleeSet, sets.buff.Souleater)
    end
    --meleeSet = set_combine(meleeSet, select_earring())
    return meleeSet
end
  
-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
  
-- Called when the player's status changes.
function job_status_change(newStatus, oldStatus, eventArgs)
    --if newStatus == "Engaged" then
        --if state.Buff['Last Resort'] then
        --    send_command('@wait 1.0;cancel hasso')
        --end
        -- handle weapon sets
    if remaWeapons:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
    end
        -- if gsList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("GreatSword")
        -- elseif scytheList:contains(player.equipment.main) then
        --     state.CombatWeapon:set("Scythe")
        -- elseif remaWeapons:contains(player.equipment.main) then
        --     state.CombatWeapon:set(player.equipment.main)
        -- else -- use regular set, which caters to Liberator
        --     state.CombatWeapon:reset()
        -- end
        --elseif newStatus == 'Idle' then
        --    determine_idle_group()
    --end
end
  
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
  
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
  
    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'MaxAcc' then
            equip(sets.MadrigalBonus)
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
             disable('body', 'head')
            else
             enable('body', 'head')
        end
        return meleeSet
    end
    if S{'haste', 'march', 'embrava', 'geo-haste', 'indi-haste', 'last resort'}:contains(buff:lower()) then
        if (buffactive['Last Resort']) then
            if (buffactive.embrava or buffactive.haste) and buffactive.march then
                state.CombatForm:set("Haste")
                if not midaction() then
                    handle_equipping_gear(player.status)
                end
            end
        else
            if state.CombatForm.current ~= 'DW' and state.CombatForm.current ~= 'SW' then
                state.CombatForm:reset()
            end
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
    -- Drain II/III HP Boost. Set SE to stay on.
    -- if buff == "Max HP Boost" and state.SouleaterMode.value then
    --     if gain or buffactive['Max HP Boost'] then
    --         state.SouleaterMode:set(false)
    --     else
    --         state.SouleaterMode:set(true)
    --     end
    -- end
    -- Make sure SE stays on for BW
    if buff == 'Blood Weapon' and state.SouleaterMode.value then
        if gain or buffactive['Blood Weapon'] then
            state.SouleaterMode:set(false)
        else
            state.SouleaterMode:set(true)
        end
    end
    -- AM custom groups
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Liberator' then
            classes.CustomMeleeGroups:clear()
  
            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                classes.CustomMeleeGroups:append('AM3')
                add_to_chat(8, '-------------Mythic AM3 UP-------------')
            -- elseif (buff == "Aftermath: Lv.3" and not gain) then
            --     add_to_chat(8, '-------------Mythic AM3 DOWN-------------')
            end
  
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        else
            classes.CustomMeleeGroups:clear()
  
            if buff == "Aftermath" and gain or buffactive.Aftermath then
                classes.CustomMeleeGroups:append('AM')
            end
  
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        end
    end
      
    -- if  buff == "Samurai Roll" then
    --     classes.CustomRangedGroups:clear()
    --     if (buff == "Samurai Roll" and gain) or buffactive['Samurai Roll'] then
    --         classes.CustomRangedGroups:append('SamRoll')
    --     end
         
    -- end
  
    --if buff == "Last Resort" then
    --    if gain then
    --        send_command('@wait 1.0;cancel hasso')
    --    else
    --        if not midaction() then
    --            send_command('@wait 1.0;input /ja "Hasso" <me>')
    --        end
    --    end
    --end
end
  
  
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
  
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
  
    war_sj = player.sub_job == 'WAR' or false
    get_combat_form()
    update_melee_groups()
    job_self_command()
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
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
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
--function th_action_check(category, param)
--    if category == 2 or -- any ranged attack
--        --category == 4 or -- any magic action
--        (category == 3 and param == 30) or -- Aeolian Edge
--        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
--        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
--        then 
--            return true
--    end
--end
-- function get_custom_wsmode(spell, spellMap, default_wsmode)
--     if state.OffenseMode.current == 'Mid' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3Mid'
--         end
--     elseif state.OffenseMode.current == 'MaxAcc' then
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3MaxAcc'
--         end
--     else
--         if buffactive['Aftermath: Lv.3'] then
--             return 'AM3'
--         end
--     end
-- end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
function get_combat_form()
  
    if S{'NIN', 'DNC'}:contains(player.sub_job) and swordList:contains(player.equipment.main) then
        state.CombatForm:set("DW")
    --elseif player.equipment.sub == '' or shields:contains(player.equipment.sub) then
    elseif swordList:contains(player.equipment.main) then
        state.CombatForm:set("SW")
    elseif buffactive['Last Resort'] then
        if (buffactive.embrava or buffactive.haste) and buffactive.march then
            add_to_chat(8, '-------------Delay Capped-------------')
            state.CombatForm:set("Haste")
        else
            state.CombatForm:reset()
        end
    else
        state.CombatForm:reset()
    end
end
  
function get_combat_weapon()
    state.CombatWeapon:reset()
    if remaWeapons:contains(player.equipment.main) then
        state.CombatWeapon:set(player.equipment.main)
    end
    -- if remaWeapons:contains(player.equipment.main) then
    --     state.CombatWeapon:set(player.equipment.main)
    -- elseif gsList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("GreatSword")
    -- elseif scytheList:contains(player.equipment.main) then
    --     state.CombatWeapon:set("Scythe")
    -- end
end
  
function aw_custom_aftermath_timers_precast(spell)
    if spell.type == 'WeaponSkill' then
        info.aftermath = {}
  
        local mythic_ws = "Insurgency"
  
        info.aftermath.weaponskill = mythic_ws
        info.aftermath.duration = 0
  
        info.aftermath.level = math.floor(player.tp / 1000)
        if info.aftermath.level == 0 then
            info.aftermath.level = 1
        end
  
        if spell.english == mythic_ws and player.equipment.main == 'Liberator' then
            -- nothing can overwrite lvl 3
            if buffactive['Aftermath: Lv.3'] then
                return
            end
            -- only lvl 3 can overwrite lvl 2
            if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
                return
            end
  
            if info.aftermath.level == 1 then
                info.aftermath.duration = 90
            elseif info.aftermath.level == 2 then
                info.aftermath.duration = 120
            else
                info.aftermath.duration = 180
            end
        end
    end
end
  
-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
    if not spell.interrupted and spell.type == 'WeaponSkill' and
        info.aftermath and info.aftermath.weaponskill == spell.english and info.aftermath.duration > 0 then
  
        local aftermath_name = 'Aftermath: Lv.'..tostring(info.aftermath.level)
        send_command('timers d "Aftermath: Lv.1"')
        send_command('timers d "Aftermath: Lv.2"')
        send_command('timers d "Aftermath: Lv.3"')
        send_command('timers c "'..aftermath_name..'" '..tostring(info.aftermath.duration)..' down abilities/aftermath'..tostring(info.aftermath.level)..'.png')
  
        info.aftermath = {}
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 166')
    end
end
function select_default_macro_book()
      
    if scytheList:contains(player.equipment.main) then
        set_macro_page(7, 21)
    elseif gsList:contains(player.equipment.main) then
        set_macro_page(7, 21)
    elseif player.sub_job == 'SAM' then
        set_macro_page(7, 21)
    else
        set_macro_page(7, 21)
    end
end
add_to_chat(159,'Author Aragan DRK.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
function update_combat_form()
  
end