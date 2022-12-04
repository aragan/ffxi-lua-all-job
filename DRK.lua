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
  
-- Setup vars that are user-independent.
function job_setup()
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    send_command('wait 2;input /lockstyleset 200')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
  
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
    scytheList = S{'Liberator', 'Apocalypse'}
    remaWeapons = S{'Apocalypse', 'Liberator', 'Caladbolg', 'Ragnarok','Nandaka'}
  
    shields = S{}
    -- Mote has capitalization errors in the default Absorb mappings, so we use our own
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    -- Offhand weapons used to activate DW mode
    swordList = S{}
  
    get_combat_form()
    get_combat_weapon()
    update_melee_groups()
end
  
-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------
  
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'STP', 'MidAcc', 'MaxAcc', 'SubtleBlow', 'crit', 'PD')
    state.HybridMode:options('Normal', 'Meva', 'PDT')
    state.WeaponskillMode:options('Normal', 'MaxAcc', 'Max')  ---Max for Scythe removes Ratri for safer WS---For Resolution removes Agrosy for Meva---
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'SE', 'SEboost')
    state.MagicalDefenseMode:options('MDT')
      
    war_sj = player.sub_job == 'WAR' or false
  
    -- Additional local binds
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c toggle SouleaterMode')
    select_default_macro_book()
end
  
function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end
  
  
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
      
    -- Precast sets to enhance JAs
    sets.precast.JA['Last Resort'] = {back="Ankou's mantle"}
    sets.precast.JA['Nether Void'] = {Legs="Heathen's Flanchard +1"}
    sets.precast.JA['Blood Weapon'] = {body="Fallen's Cuirass +3"}
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
  
         
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Ratri Sallet",
        body="Nyame Mail",
        hands="Ratri Gadlings",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}
  
  
    sets.precast.WS.MaxAcc = set_combine(sets.precast.WS, {
        
    })
  
   
    sets.precast.WS.Max = set_combine(sets.precast.WS, {
        
    })
  
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Catastrophe'] = {
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Ratri Sallet",
        body="Nyame Mail",
        hands="Ratri Gadlings",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}
  
    sets.precast.WS['Catastrophe'].MaxAcc = set_combine(sets.precast.WS['Catastrophe'], {})
    sets.precast.WS['Catastrophe'].Max = set_combine(sets.precast.WS['Catastrophe'], {})
  
  
sets.precast.WS['Insurgency'] = {
    sub="Utu Grip",
    ammo="Knobkierrie",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Balder Earring +1",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}
  
    sets.precast.WS['Insurgency'].MaxAcc = set_combine(sets.precast.WS['Insurgency'], {})
    sets.precast.WS['Insurgency'].Max = set_combine(sets.precast.WS['Insurgency'], {head="Sakpata's Helm",})
  
    sets.precast.WS['Cross Reaper'] = {
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Sakpata's Helm",
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
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}
  
    sets.precast.WS['Cross Reaper'].MaxAcc = set_combine(sets.precast.WS['Catastrophe'], {})
    sets.precast.WS['Cross Reaper'].Max = set_combine(sets.precast.WS['Catastrophe'], {})
  
sets.precast.WS['Quietus'] = {
    sub="Utu Grip",
    ammo="Knobkierrie",
    head="Ratri Sallet",
    body="Nyame Mail",
    hands="Ratri Gadlings",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Sulev. Leggings +2",
    neck="Fotia Gorget",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
} 

sets.precast.WS['Entropy '] = {
    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Flam. Gambieras +2",
    neck="Fotia Gorget",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Balder Earring +1",
    left_ring="Regal Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
} 

sets.precast.WS['Infernal Scythe'] = {    ammo="Knobkierrie",
head="Pixie Hairpin +1",
body="Nyame Mail",
hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
feet="Sulev. Leggings +2",
neck="Baetyl Pendant",
waist="Orpheus's Sash",
left_ear="Friomisi Earring",
right_ear="Malignance Earring",
left_ring="Archon Ring",
right_ring="Epaminondas's Ring",
back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}
sets.precast.WS['Infernal Scythe'].MaxAcc = set_combine(sets.precast.WS['Torcleaver'], {})
sets.precast.WS['Infernal Scythe'].Max = set_combine(sets.precast.WS['Torcleaver'], {
    
})
          
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
    right_ring="Beithir Ring",
    back={ name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
}
  
    sets.precast.WS['Resolution'].MaxAcc = set_combine(sets.precast.WS['Resolution'], {})
    sets.precast.WS['Resolution'].Max = set_combine(sets.precast.WS['Resolution'], {})
      
    sets.precast.WS['Ground Strike'] = {
        sub="Utu Grip",
        ammo="Knobkierrie",
        head="Ratri Sallet",
        body="Nyame Mail",
        hands="Ratri Gadlings",
        legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
        feet="Sulev. Leggings +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ear="Thrud Earring",
        left_ring="Beithir Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
    } 
  
    sets.precast.WS['Scourge'] = set_combine(sets.precast.WS['Torcleaver'], {})
    sets.precast.WS['Scourge'].MaxAcc = set_combine(sets.precast.WS['Torcleaver'], {})
    sets.precast.WS['Scourge'].Max = set_combine(sets.precast.WS['Torcleaver'], {})
      
    sets.precast.WS['Torcleaver'] = {ammo="Knobkierrie",
    head="Sakpata's Helm",
    body="Nyame Mail",
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Sulev. Leggings +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
    right_ear="Thrud Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Damage taken-5%',}},
}
    sets.precast.WS['Torcleaver'].MaxAcc = set_combine(sets.precast.WS['Torcleaver'], {})
    sets.precast.WS['Torcleaver'].Max = set_combine(sets.precast.WS['Torcleaver'], {
        
    })
      
      
   
    --------------------------------------
    -- Midcast sets
    --------------------------------------
  
    sets.midcast.FastRecast = {}
          
    sets.midcast.Enmity = {}
  
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})
      
    sets.midcast.Cure = {}
      
      
    sets.midcast['Dread Spikes'] = {
        ammo="Staunch Tathlum +1",
        head="Ratri Sallet",
        body="Heath. Cuirass +1",
        hands="Ratri Gadlings",
        legs="Ratri Cuisses",
        feet="Nyame Sollerets",
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
        head="Sakpata's Helm",
        body={ name="Fall. Cuirass +3", augments={'Enhances "Blood Weapon" effect',}},
    hands="Sakpata's Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Sakpata's Leggings",
    neck="Erra Pendant",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Dignitary's Earring",
    left_ring="Evanescence Ring",
    right_ring="Archon Ring",
    back={ name="Ankou's Mantle", augments={'INT+20','Mag. MaxAcc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
}
      
      
      sets.midcast.Absorb = set_combine(sets.midcast['Dark Magic'], {
        -- neck="Sanctity Necklace",
        -- back="Niht Mantle",
        -- hands="Flamma Manopolas +2",

        ring1="Evanescence Ring", -- 10
        ring2="Kishar Ring",
    })
      
      
     -- Drain spells 
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
   
    })
    sets.midcast.Aspir = sets.midcast.Drain
  
    sets.midcast.Drain.Acc = set_combine(sets.midcast.Drain, {
        hands="Leyline Gloves",
        waist="Eschan Stone", -- macc/matk 7
    })
    sets.midcast.Aspir.Acc = sets.midcast.Drain.Acc
      
      
      
      
    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Stikini Ring +1",
        right_ring="Locus Ring",
        back="Argocham. Mantle",
    }
  
  
   sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Dark Magic'], {
    ammo="Pemphredo Tathlum",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs={ name="Fall. Flanchard +3", augments={'Enhances "Muted Soul" effect',}},
    feet="Nyame Sollerets",
    neck="Incanter's Torque",
    waist="Eschan Stone",
    left_ear="Malignance Earring",
    right_ear="Crep. Earring",
    left_ring="Kishar Ring",
    right_ring="Stikini Ring +1",
    back="Solemnity Cape",
    })
      
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
  
         -- Resting sets
    sets.resting = {
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Stikini Ring +1",
        right_ring="Chirich Ring +1",
    }
      
  
    -- Idle sets
    sets.idle = {
        
    ammo="Staunch Tathlum +1",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Carmine Cuisses +1",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Stikini Ring +1",
    right_ring="Defending Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},

}
  
    sets.idle.Town = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Sakpata's Leggings",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Infused Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},

}
  
    sets.idle.Field = set_combine(sets.idle, {
        
        
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Sakpata's Leggings",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Infused Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back="Moonbeam cape",
    })
    sets.idle.Regen = set_combine(sets.idle.Field, {})
      
    sets.idle.Weak = {head="Twilight Helm",body="Twilight Mail"}
      
    sets.idle.Refresh = set_combine(sets.idle, {
    left_ring="Stikini Ring +1",
    })
  
    sets.idle.Sphere = set_combine(sets.idle, {   })
  
    --------------------------------------
    -- Defense sets
    --------------------------------------
  
  
    -- Basic defense sets.
          
    sets.defense.PDT = {
        
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
    sets.defense.HP = {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Moonlight Ring",
        back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}

sets.defense.SE = {

    ammo="Eluder's Sachet",
    head="Ratri Sallet",
    body="Ratri Plate",
    hands="Ratri Gadlings",
    legs="Ratri Cuisses",
    feet="Flam. Gambieras +2",
    neck="Nicander's Necklace",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Dedition Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
    back="Atheling Mantle",
}

sets.defense.SEboost = {

    ammo="Staunch Tathlum +1",
    head="Ratri Sallet",
    body="Hjarrandi Breast.",
    hands="Ratri Gadlings",
    legs="Ratri Cuisses",
    feet="Nyame Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Moonlight Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
  
      
    sets.defense.MDT = {
        head="Sulevia's mask +1",neck="Warder's Charm +1",ear1="Odnowa Earring",ear2="Odnowa Earring +1",
        body="Souveran cuirass",hands="Souveran handschuhs +1",ring1="Moonlight Ring",ring2="Moonlight Ring",
        back="Moonbeam cape",waist="Gold Moogle Belt",legs="Souveran diechlings +1",feet="Souveran Schuhs +1"
    }
  
        sets.Kiting = {legs="Carmine Cuisses +1",
    }
    --------------------------------------
    -- Engaged sets
    --------------------------------------
      
    sets.engaged ={
        ammo="Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Hjarrandi Breast.",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Cessance Earring",
        right_ear="Schere Earring",
        left_ring="Hetairoi Ring",
        right_ring="Niqmaddu Ring",
        back="Atheling Mantle",
    }
  
    sets.engaged.STP = {
     ammo="Coiste Bodhar",
    head="Flam. Zucchetto +2",
    body="Flamma Korazin +2",
    hands="Flam. Manopolas +2",
    legs="Sulev. Cuisses +2",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Dedition Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Chirich Ring +1",
    back="Atheling Mantle",
}
  
    sets.engaged.MidAcc = {     ammo="Coiste Bodhar",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Kentarch Belt +1",
    left_ear="Telos Earring",
    right_ear="Digni. Earring",
    right_ring="Moonlight Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}

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
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
})

sets.engaged.PD = set_combine(sets.engaged, {

    ammo="Coiste Bodhar",
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Sulev. Cuisses +2",
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
    body="Sulevia's Plate. +2",
    hands="Sulev. Gauntlets +2",
    legs="Sulev. Cuisses +2",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Ioskeha Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+1','Weapon skill damage +10%',}},
}

sets.engaged.SubtleBlow = set_combine(sets.engaged, {

    hands="Sakpata's Gauntlets",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Sarissapho. Belt",
    left_ear="Digni. Earring",
    right_ear="Schere Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Atheling Mantle",
})
      
      
    -- These only apply when delay is capped.
    sets.engaged.Haste = set_combine(sets.engaged, {
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.STP = set_combine(sets.engaged.STP, {
        waist="Ioskeha Belt +1",
    })
    sets.engaged.Haste.crit = set_combine(sets.engaged.crit, {
        waist="Ioskeha Belt +1",
    })
  
    sets.engaged.Haste.SubtleBlow = set_combine(sets.engaged.SubtleBlow, {
        waist="Ioskeha Belt +1",
    })
      
  
    sets.engaged.Meva = {ammo="Coiste Bodhar",
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
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
    sets.engaged.PDT = {ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
      
    sets.engaged.MidAcc.Meva = set_combine(sets.engaged.Meva, {})
    sets.engaged.MidAcc.PDT = {ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
      
    sets.engaged.MaxAcc.Meva = set_combine(sets.engaged.Meva, {})
    sets.engaged.MaxAcc.PDT = {ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Ig. Flanchard +3",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Moonlight Ring",
    back={ name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
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
        send_command('input /item "Echo Drops" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    aw_custom_aftermath_timers_precast(spell)
end
  
  
  
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
end
  
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Drain') then
        if player.status == 'Engaged' and state.CastingMode.current == 'Normal' and player.hpp < 70 then
            classes.CustomClass = 'OhShit'
        end
    end
  
    if (state.HybridMode.current == 'PDT' and state.PhysicalDefenseMode.current == 'Reraise') then
        equip(sets.Reraise)
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
    if spell.type == 'WeaponSkill' then
        if state.Buff.Souleater and state.SouleaterMode.value then
            send_command('@wait 1.0;cancel souleater')
            --enable("head")
        end
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.hpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    elseif player.mpp < 50 then
        idleSet = set_combine(idleSet, sets.idle.Refresh)
    end
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
    if newStatus == "Engaged" then
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
    get_combat_weapon()
    update_melee_groups()
    select_default_macro_book()
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
  
function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current
  
    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.CombatForm.current ~= '' then 
        msg = msg .. ', Form: ' .. state.CombatForm.current 
    end
    if state.CombatWeapon.current ~= '' then 
        msg = msg .. ', Weapon: ' .. state.CombatWeapon.current 
    end
    if state.CapacityMode.value then
        msg = msg .. ', Capacity: ON, '
    end
    if state.SouleaterMode.value then
        msg = msg .. ', SE Cancel, '
    end
    -- if state.LastResortMode.value then
    --     msg = msg .. ', LR Defense, '
    -- end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end
  
    add_to_chat(123, msg)
    eventArgs.handled = true
end
  
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
end
  
-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Dark Magic' and absorbs:contains(spell.english) then
        return 'Absorb'
    end
    -- if spell.type == 'Trust' then
    --     return 'Trust'
    -- end
end
  
  
function update_melee_groups()
  
    classes.CustomMeleeGroups:clear()
    -- mythic AM    
    if player.equipment.main == 'Liberator' then
        if buffactive['Aftermath: Lv.3'] then
            classes.CustomMeleeGroups:append('AM3')
        end
    else
        -- relic AM
        if buffactive['Aftermath'] then
            classes.CustomMeleeGroups:append('AM')
        end
        -- if buffactive['Samurai Roll'] then
        --     classes.CustomRangedGroups:append('SamRoll')
        -- end
    end
end
  
function select_default_macro_book()
      
    if scytheList:contains(player.equipment.main) then
        set_macro_page(7, 2)
    elseif gsList:contains(player.equipment.main) then
        set_macro_page(7, 2)
    elseif player.sub_job == 'SAM' then
        set_macro_page(7, 2)
    else
        set_macro_page(7, 2)
    end
end
add_to_chat(159,'Author Aragan DRK.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
function update_combat_form()
  
end