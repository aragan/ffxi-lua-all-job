-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
-------------------------------- Initialization function that defines sets and variables to be used -----------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Make sure to also get the Mote-Include.lua file to go with this.
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-IncludePLD.lua')
    include('organizer-lib')
    organizer_items = {
        "Prime Sword",
        "Lentus Grip",
        "Foreshock Sword",
        "Mafic Cudgel",
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
function job_setup()
    state.WeaponLock = M(false, 'Weapon Lock')
    send_command('wait 6;input /lockstyleset 200')

end
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.ShieldMode = M{['description']='Shield Mode', 'Duban','Aegis', 'Ochain'} -- ,'Priwen' }
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Tp', 'Acc', 'Hybrid', 'STP', 'CRIT')
	--state.DefenseMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'PDL')
    state.CastingMode:options('Normal', 'DT', 'MB') 
    state.IdleMode:options('Normal', 'Refresh')
    --state.RestingModes:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'PD', 'PDH', 'Convert', 'Block', 'HPBOOST', 'Enmity' ,'Enmitymax')
    state.MagicalDefenseMode:options('MDT', 'Turtle', 'Evasion', 'ResistCharm', 'Dagger')
    state.HybridMode:options('Normal', 'PDT', 'MDT')
    --state.BreathDefenseModes:options('Turtle')
    --state.HybridDefenseMode:options('PDT', 'MDT', 'Reraise')
    --state.HybridDefenseMode=('none')
    --state.BreathDefenseModes:options'Turtle'
    --send_command('bind ^f11 gs c cycle MagicalDefenseModes')
 	--send_command('bind ^= gs c activate MDT')
    send_command('wait 2;input /lockstyleset 200')
    include('Mote-TreasureHunter')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('bind f12 gs c cycle MagicalDefenseMode')
    send_command('bind !w gs c toggle WeaponLock')
	send_command('bind f6 gs c cycle ShieldMode')

    include('caster_buffWatcher.lua')
    buffWatcher.watchList = 
    {
                           ["Protect"]="Protect V",
                           ["Enmity Boost"]="Crusade",
                           ["Cocoon"]="Cocoon",
                           ["Phalanx"]="Phalanx",
    }
    include('common_info.status.lua')	
end
function user_unload()
	send_command('unbind `')
    send_command('unbind @w')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind !-')	
	send_command('unbind ^=')
	send_command('unbind !=')		
	send_command('unbind delete')
	send_command('unbind end')
	send_command('unbind home')
    --send_command('unbind f12')


end
-- Define sets and vars used by this job file.

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------Precast sets-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
function init_gear_sets()
	 -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.precast.JA['Provoke'], {legs="Cab. Breeches +3"})
    sets.precast.JA['Holy Circle'] = set_combine(sets.precast.JA['Provoke'], {feet="Rev. Leggings +3"})
    sets.precast.JA['Shield Bash'] = set_combine(sets.precast.JA['Provoke'], {sub="Aegis", hands="Cab. Gauntlets +2", left_ear="Knightly Earring"})
    sets.precast.JA['Intervene'] = sets.precast.JA['Shield Bash']
    sets.precast.JA['Sentinel'] = set_combine(sets.precast.JA['Provoke'], {feet="Cab. Leggings +3"})   
    --The amount of damage absorbed is variable, determined by VIT*2
    sets.precast.JA['Rampart'] = {
    ammo="Brigantia Pebble",
    head={ name="Cab. Coronet +3", augments={'Enhances "Iron Will" effect',}},
    body="Shab. Cuirass +1",
    hands="Sulev. Gauntlets +1",
    legs="Sulev. Cuisses +2",
    feet={ name="Founder's Greaves", augments={'VIT+8','Accuracy+13','"Mag.Atk.Bns."+14','Mag. Evasion+14',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    left_ear="Thrud Earring",
    right_ear="Tuisto Earring",
    left_ring="Titan Ring +1",
    right_ring="Petrov Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
    sets.buff['Rampart'] = sets.precast.JA['Rampart']
    sets.precast.JA['Fealty'] = set_combine(sets.precast.JA['Provoke'], {body="Cab. Surcoat +1",})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.precast.JA['Provoke'], {feet="Chev. Sabatons +2"})
    --15 + min(max(floor((user VIT + user MND - target VIT*2)/4),0),15)
    sets.precast.JA['Cover'] = set_combine(sets.precast.JA['Rampart'], {head="Rev. Coronet +2", body="Cab. Surcoat +1"})
    sets.buff['Cover'] = sets.precast.JA['Cover']
    -- add MND for Chivalry
    sets.precast.JA['Chivalry'] = set_combine(sets.defense.HPBOOST, {
        ammo="Staunch Tathlum +1",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands={ name="Cab. Gauntlets +1", augments={'Enhances "Chivalry" effect',}},
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Luminary Sash",
        left_ear="Tuisto Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Moonbeam Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    })
    ------------------------ Sub WAR ------------------------ 
	sets.precast.JA['Provoke'] =    --enmity +152
    {   
    head={ name="Loess Barbuta +1", augments={'Path: A',}},
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet="Eschite Greaves",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Trux Earring",
    right_ear="Cryptic Earring",
    left_ring={ name="Apeile Ring +1", augments={'Path: A',}},
    right_ring="Apeile Ring",   
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
sets.Enmity =    --enmity +152
{    main="Burtgang",
head={ name="Loess Barbuta +1", augments={'Path: A',}},
body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
feet="Eschite Greaves",
neck={ name="Unmoving Collar +1", augments={'Path: A',}},
waist="Creed Baudrier",
left_ear="Trux Earring",
right_ear="Cryptic Earring",
left_ring={ name="Apeile Ring +1", augments={'Path: A',}},
right_ring="Apeile Ring",   
back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

    sets.precast.JA['Warcry'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Defender'] = sets.precast.JA['Provoke']
    ------------------------ Sub DNC ------------------------ 
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    -- Special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = sets.precast.Waltz
    sets.precast.Step = sets.precast.JA['Provoke']
    sets.precast.Flourish1 = sets.precast.Step
    ------------------------ Sub RUN ------------------------ 
    sets.precast.JA['Ignis'] = sets.precast.JA['Provoke']   
    sets.precast.JA['Gelus'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Flabra'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Tellus'] = sets.precast.JA['Provoke']  
    sets.precast.JA['Sulpor'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Unda'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Lux'] = sets.precast.JA['Provoke']     
    sets.precast.JA['Tenebrae'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Vallation'] = sets.precast.JA['Provoke'] 
    sets.precast.JA['Pflug'] = sets.precast.JA['Provoke'] 
    -- Fast cast sets for spells   2844HP FC+80/80
	sets.precast.FC = {   
    ammo="Sapience Orb",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body="Rev. Surcoat +3",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}
	sets.precast.FC.DT = set_combine(sets.precast.FC, {})
    sets.precast.FC.Phalanx = set_combine(sets.precast.FC, {waist="Siegel Sash",})
	sets.precast.FC.Enlight = sets.precast.FC
	sets.precast.FC['Enlight II'] = sets.precast.FC
	sets.precast.FC.Protect = sets.precast.FC
	sets.precast.FC.Shell = sets.precast.FC
	sets.precast.FC.Crusade = sets.precast.FC
    sets.precast.FC.Cure = set_combine(sets.precast.FC,{
    right_ear="Mendi. Earring",
    left_ring="Moonlight Ring",
    waist="Acerbic Sash +1",
})
sets.precast.FC.Cure.DT = set_combine(sets.precast.FC,{
    right_ear="Mendi. Earring",
    left_ring="Moonlight Ring",
    waist="Acerbic Sash +1",
})
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
sets.precast.WS = {   
ammo="Aurgelmir Orb +1",
head="Nyame Helm",
body="Nyame Mail",
body="Nyame Mail",
legs="Nyame Flanchard",
feet="Nyame Sollerets",
neck="Fotia Gorget",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Thrud Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Cornelia's Ring",
    back="Atheling Mantle",
}
sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    ammo="Crepuscular Pebble",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    left_ring="Sroda Ring", 
})
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
 
    --Stat Modifier:     73~85% MND  fTP:    1.0
sets.precast.WS['Requiescat'] = {
ammo="Aurgelmir Orb +1",
head="Hjarrandi Helm",
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs="Sakpata's Cuisses",
feet="Sakpata's Leggings",
neck="Fotia Gorget",
waist="Fotia Belt",
left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
right_ear="Cessance Earring",
left_ring="Petrov Ring",
right_ring="Regal Ring",
back="Bleating Mantle",
}
sets.precast.WS['Requiescat'].PDL = set_combine(sets.precast.WS['Requiescat'], {
    hands="Sakpata's Gauntlets",
})
   --Stat Modifier:  50%MND / 30%STR MAB+    fTP:2.75
    sets.precast.WS['Sanguine Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Nyame Mail",
        legs="Nyame Flanchard",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Archon Ring",
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
}	     
    sets.precast.WS['Aeolian Edge'] = {   
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back="Argocham. Mantle",
}	
sets.precast.WS['Cataclysm'] = {   
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body="Nyame Mail",
    legs="Nyame Flanchard",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Archon Ring",
    right_ring="Cornelia's Ring",
    back="Argocham. Mantle",
}	 
    --Stat Modifier: 50%MND / 50%STR fTP: 1000:4.0 2000:10.25 3000:13.75
sets.precast.WS['Savage Blade'] = {
ammo="Aurgelmir Orb +1",
head="Nyame Helm",
body="Nyame Mail",
hands="Nyame Gauntlets",
legs="Nyame Flanchard",
feet="Nyame Sollerets",
neck="Rep. Plat. Medal",
waist={ name="Sailfi Belt +1", augments={'Path: A',}},
left_ear="Thrud Earring",
right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
left_ring="Regal Ring",
right_ring="Cornelia's Ring",
back="Bleating Mantle",
}
sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
    ammo="Crepuscular Pebble",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    left_ring="Sroda Ring", 
})
   --Stat Modifier:  80%DEX  fTP:2.25
   sets.precast.WS['Chant du Cygne'] = {	
    ammo={ name="Coiste Bodhar", augments={'Path: A',}},
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    neck="Fotia Gorget",
    waist="Flume Belt +1",
    left_ear="Mache Earring +1",
    right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    left_ring="Regal Ring",
    right_ring="Hetairoi Ring",
    back="Bleating Mantle",
}
sets.precast.WS['Chant du Cygne'].PDL = set_combine(sets.precast.WS['Chant du Cygne'], {
    ammo="Crepuscular Pebble",
    hands="Sakpata's Gauntlets",
})
    --Stat Modifier: WS damage + 30/31%   2211DMG maxaggro
    sets.precast.WS['Atonement'] = {
    ammo="Paeapua",
    head={ name="Loess Barbuta +1", augments={'Path: A',}},
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck="Moonlight Necklace",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Cryptic Earring",
    left_ring={ name="Apeile Ring +1", augments={'Path: A',}},
    right_ring="Apeile Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS, {})
sets.precast.WS['Impulse Drive'].PDL = set_combine(sets.precast.WS['Impulse Drive'], {    
    ammo="Crepuscular Pebble",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    left_ring="Sroda Ring", 
})
sets.precast.WS["Realmrazer"] = set_combine(sets.precast.WS["Requiescat"], {})
sets.precast.WS["Realmrazer"].PDL = set_combine(sets.precast.WS["Requiescat"].PDL, {})
sets.precast.WS["Flash Nova"] = set_combine(sets.precast.WS["Aeolian Edge"], {})
sets.precast.WS["True Strike"] = set_combine(sets.precast.WS["Chant du Cygne"], {})
sets.precast.WS["True Strike"].PDL = set_combine(sets.precast.WS["Chant du Cygne"], {})
sets.precast.WS['Shattersoul'] = set_combine(sets.precast.WS["Requiescat"], {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Brutal Earring",
    left_ring="Rufescent Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Annealed Mantle",
})
sets.precast.WS['Shattersoul'].PDL = set_combine(sets.precast.WS["Requiescat"].PDL, {
    ammo="Crepuscular Pebble",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    left_ring="Sroda Ring", 
})
sets.precast.WS['Resolution'] = set_combine(sets.precast.WS['Requiescat'], {})
sets.precast.WS['Resolution'].PDL = set_combine(sets.precast.WS['Requiescat'].PDL, {})

    ------------------------------------------------------------------------------------------------
    -----------------------------------------Midcast sets-------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.midcast.FastRecast = sets.SID
    -- Divine Skill 590/594 142 Acc
    sets.midcast.Divine = {
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Rev. Surcoat +3",
        hands="Eschite Gauntlets",
        neck="Incanter's Torque",
        waist="Asklepian Belt",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
}
    sets.midcast.Divine.DT = set_combine(sets.SID, {
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Rev. Surcoat +3",
        hands="Eschite Gauntlets",
        neck="Incanter's Torque",
        waist="Asklepian Belt",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    })
	--skill 401/402
	sets.midcast['Enhancing Magic'] ={    
    ammo="Staunch Tathlum +1",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body="Shab. Cuirass +1",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    right_ear="Andoaa Earring",
    right_ring="Stikini Ring +1",
    back={ name="Weard Mantle", augments={'VIT+1','Enmity+3','Phalanx +5',}},
}
sets.midcast['Enhancing Magic'].DT = set_combine(sets.SID, {    
    left_ear="Andoaa Earring",
    right_ring="Stikini Ring +1",
})
	sets.midcast.MAB = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Skrymir Cord",
        left_ear="Hecate's Earring",
        right_ear="Friomisi Earring",
        left_ring="Mephitas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        back="Argocham. Mantle",
    }
    sets.midcast.MAB.MB = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Skrymir Cord",
        left_ear="Hecate's Earring",
        right_ear="Friomisi Earring",
        left_ring="Locus Ring",
        right_ring="Mujin Band",
        back="Argocham. Mantle",
    }
    sets.magic_burst = {
        ammo="Pemphredo Tathlum",
        head={ name="Jumalik Helm", augments={'MND+1','Magic burst dmg.+8%',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Skrymir Cord",
        left_ear="Hecate's Earring",
        right_ear="Friomisi Earring",
        left_ring="Locus Ring",
        right_ring="Mujin Band",
        back="Argocham. Mantle",
    }

    sets.midcast['Elemental Magic'] = {
        ammo="Pemphredo Tathlum",
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Eschan Stone",
        left_ear="Hecate's Earring",
        right_ear="Friomisi Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Stikini Ring +1",
        back="Argocham. Mantle",}

        sets.midcast['Elemental Magic'].MB = {
            ammo="Pemphredo Tathlum",
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck={ name="Warder's Charm +1", augments={'Path: A',}},
            waist="Eschan Stone",
            left_ear="Hecate's Earring",
            right_ear="Friomisi Earring",
            left_ring="Locus Ring",
            right_ring="Mujin Band",
            back="Argocham. Mantle",
        }
    sets.midcast.Flash = sets.Enmity
    sets.midcast.Flash.DT = sets.Enmity
    sets.midcast.Enlight = sets.midcast.Divine --+95 accu
    sets.midcast['Enlight II'] = sets.midcast.Divine --+142 accu (+2 acc each 20 divine skill)
    --Max HP+ set for reprisal 3951HP / war so 7902+ damage reflect before it off (8k+ with food)
    sets.midcast.Reprisal =	{
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Rev. Surcoat +3",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}
    --Phalanx skill 386/386 = 31/31  + phalanx + 30/31 total 61/62
    sets.midcast.Phalanx = {
        main="Sakpata's Sword",
        sub="Priwen",
        ammo="Staunch Tathlum +1",
        head="Yorium Barbuta",
        body="Yorium Cuirass",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs="Sakpata's Cuisses",
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Knightly Earring",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Defending Ring",
        back={ name="Weard Mantle", augments={'VIT+1','Enmity+3','Phalanx +5',}},
    } 
    sets.midcast.Phalanx.DT = {
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Audumbla Sash",
    left_ear="Knightly Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back={ name="Weard Mantle", augments={'VIT+1','Enmity+3','Phalanx +5',}},
}
    sets.midcast.Banish = sets.midcast.MAB
    sets.midcast['Banish II'] = set_combine(sets.midcast.MAB, {})
    sets.midcast.Holy = sets.midcast.MAB
    sets.midcast['Holy II'] = sets.midcast.MAB
    sets.midcast.Crusade = {
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        body="Shab. Cuirass +1",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Enhancing Torque",
        waist="Olympus Sash",
        right_ear="Andoaa Earring",
        right_ring="Stikini Ring +1",
}
sets.midcast.Cocoon = {    
    ammo="Staunch Tathlum +1",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body="Shab. Cuirass +1",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    right_ear="Andoaa Earring",
    right_ring="Stikini Ring +1",
}
sets.midcast.Cocoon.DT = {    
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
-- Cure1=120; Cure2=266; Cure3=600; Cure4=1123; cure potency caps at 50/50% received caps at 32/30%. sans signet 
    sets.midcast.Cure = {
        ammo="Staunch Tathlum +1",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
        right_ear="Chev. Earring +1",
        left_ring="Moonlight Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Solemnity Cape",
}
    sets.midcast.Cure.DT = set_combine(sets.SID, {
        hands="Macabre Gaunt. +1",
        left_ear="Mendi. Earring",
        right_ear="Chev. Earring +1",
    })
    sets.midcast.Cure.MB = set_combine(sets.midcast.Cure, {
        ammo="Pemphredo Tathlum",
        hands="Macabre Gaunt. +1",
        neck="Reti Pendant",
        waist="Austerity Belt +1",
        left_ear="Mendi. Earring",
        right_ear="Chev. Earring +1",
        back="Solemnity Cape",
    })
-- 630 HP (curecheat)
	sets.self_healing = {      
        ammo="Staunch Tathlum +1",
        head={ name="Loess Barbuta +1", augments={'Path: A',}},
        body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        hands="Macabre Gaunt. +1",
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
        right_ear="Chev. Earring +1",
        left_ring="Moonlight Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Solemnity Cape",
}
	sets.self_healing.DT = set_combine(sets.SID, {
        hands="Macabre Gaunt. +1",
        right_ear="Chev. Earring +1",
    })
    sets.self_healing.MB = set_combine(sets.midcast.Cure, {
        ammo="Pemphredo Tathlum",
        hands="Macabre Gaunt. +1",
        neck="Reti Pendant",
        waist="Austerity Belt +1",
        left_ear="Mendi. Earring",
        right_ear="Chev. Earring +1",
        back="Solemnity Cape",
    })
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
     head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Sheltered Ring",
    right_ring="Stikini Ring +1",
})
    sets.midcast.Shell = set_combine(sets.midcast['Enhancing Magic'] , {
     head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Sheltered Ring",
    right_ring="Stikini Ring +1",
})
	sets.midcast.Raise = {       
ammo="Staunch Tathlum +1",
head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
neck="Moonlight Necklace",
waist="Audumbla Sash",
left_ear="Tuisto Earring",
right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
right_ring="Defending Ring",
back="Moonlight Cape",
}	
sets.midcast.Raise.DT = {       
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
    }	
    sets.midcast.Stun = sets.midcast.Flash
	
	--Spell interupt down (pro shell raise)104/102
	sets.SID = {   ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
---------- NIN Spell	--------------
	sets.midcast.Utsusemi = {      
ammo="Staunch Tathlum +1",
head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
neck="Moonlight Necklace",
waist="Audumbla Sash",
left_ear="Tuisto Earring",
right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
right_ring="Defending Ring",
back="Moonlight Cape",

}
---------- BLU Spell	--------------
    sets.midcast['Geist Wall'] ={    
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
sets.midcast['Geist Wall'].DT ={    
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
    sets.midcast['Sheep Song'] = {   
    ammo="Pemphredo Tathlum",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Erra Pendant",
    waist="Luminary Sash",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}

sets.midcast['Sheep Song'].DT = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
	sets.midcast.Soporific = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
sets.midcast.Soporific.DT = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
	sets.midcast['Stinking Gas'] = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}    
sets.midcast['Stinking Gas'].DT = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}    
	sets.midcast['Bomb Toss'] = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
sets.midcast['Bomb Toss'].DT = {   
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}

sets.midcast['Frightful Roar'] = 
{   main="Naegling",
    range="Ullr",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Erra Pendant",
    waist="Luminary Sash",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
sets.midcast['Frightful Roar'].DT = {  
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}	
sets.TreasureHunter = { 
    ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt",
 }
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
	sets.Cover = set_combine(sets.precast.JA['Rampart'], {main="Kheshig Blade", head="Rev. Coronet +2", body="Cab. Surcoat +1"})
    sets.Doom = {neck="Nicander's Necklace",left_ring="Eshmun's Ring",right_ring="Blenmot's Ring +1", waist="Gishdubar Sash"} -- +65%
    sets.Petri = {back="Sand Mantle"} 
	sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
	sets.Sleep = {neck="Vim Torque +1",left_ear="Infused Earring",}
	sets.Breath = sets.defense.MDT
   
    sets.resting = {
        ammo="Homiliary",
        head="Chev. Armet +3",
        body="Rev. Surcoat +3",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        neck="Sanctity Necklace",
        waist="Fucho-no-Obi",
        left_ear="Infused Earring",
        right_ear="Cryptic Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back="Moonlight Cape",
    }
     
    -- Idle sets
    sets.idle =  { ammo="Iron Gobbet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Carmine Cuisses +1",
    feet="Sakpata's Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Thureous Earring",
    right_ear="Ethereal Earring",
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
    }
    sets.idle.Field = sets.idle

    sets.idle.Refresh ={
        ammo="Homiliary",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
}
    sets.idle.Town ={legs="Carmine Cuisses +1"}
     
    sets.idle.Weak = {head="Twilight Helm", body="Twilight Mail"}
     
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
	
	sets.HQ = {}

    --   Physical
    --     PDT
    --     Aegis
    -- Defense sets
    --   Magical
    --     MDT
    --   Hybrid (on top of either physical or magical)
    --     Repulse  
    --     Reraise
    --     RepulseReraise
    --   Custom
     
    -- sets.Repulse = {back="Repulse Mantle"}
  --3367 HP   
    sets.defense.PDT = {
    main="Burtgang",
    ammo="Iron Gobbet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Thureous Earring",
    right_ear="Ethereal Earring",
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear. Current gear set is 248/256.
    -- Shellra V can provide 75/256.
    sets.defense.MDT ={
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head={ name="Founder's Corona", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Magic dmg. taken -5%',}},
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Warder's Charm +1",
    waist="Creed Baudrier",
    left_ear="Genmei Earring",
    right_ear="Sanare Earring",
    left_ring="Shadow Ring",
    right_ring="Defending Ring",
    back="Engulfer Cape +1",
}

	sets.defense.Turtle ={   
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Asklepian Belt",
    left_ear="Odnowa Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Shadow Ring",
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}

	sets.defense.ResistCharm ={
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head="Loess Barbuta +1",
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Thureous Earring",
    right_ear="Volunt. Earring",
    left_ring="Unyielding Ring",
    right_ring="Wuji Ring",
    back="Solemnity Cape",
}	


sets.defense.Dagger = {    
    main="Ternion Dagger +1",
    ammo="Eluder's Sachet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Rev. Gauntlets +3",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Fortified Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
sets.defense.Evasion = {    
    ammo="Amar Cluster",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Eabani Earring",
    right_ear="Infused Earring",
    left_ring="Vengeful Ring",
    right_ring="Defending Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
	
    sets.defense.Enmity = { 
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head={ name="Loess Barbuta +1", augments={'Path: A',}},
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Tuisto Earring",
    right_ear="Cryptic Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
sets.defense.Enmitymax = { 
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head={ name="Loess Barbuta +1", augments={'Path: A',}},
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Trux Earring",
    right_ear="Cryptic Earring",
    left_ring={ name="Apeile Ring +1", augments={'Path: A',}},
    right_ring="Apeile Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
    
    sets.defense.PD = {    
    main="Burtgang",
    ammo="Eluder's Sachet",
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
    right_ring="Fortified Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

sets.defense.PDT = {
    main="Burtgang",
    ammo="Iron Gobbet",
    head="Chev. Armet +3",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Chev. Cuisses +3",
    feet="Sakpata's Leggings",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Moonlight Ring",
    right_ring="Fortified Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

sets.defense.PDH = {
    main="Burtgang",
    ammo="Iron Gobbet",
    head="Chev. Armet +3",
    body="Chev. Cuirass +2",
    hands="Chev. Gauntlets +2",
    legs="Chev. Cuisses +3",
    feet="Chev. Sabatons +2",
    neck="Elite Royal Collar",
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear="Chev. Earring +1",
    left_ring="Moonlight Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
 
    sets.defense.HPBOOST = {
    main="Burtgang",
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Rev. Surcoat +3",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonlight Ring",
    back="Moonlight Cape",
}

sets.defense.HP = set_combine(sets.defense.HPBOOST, {
    ammo="Iron Gobbet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    waist="Plat. Mog. Belt",
})

sets.defense.DEF = {
    main="Burtgang",
    ammo="Iron Gobbet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Paguroidea Ring",
    right_ring="Provocare Ring",
    back="Moonlight Cape",
}

sets.defense.Convert = {
    ammo="Iron Gobbet",
    head="Chev. Armet +3",
    body="Rev. Surcoat +3",
    hands="Chev. Gauntlets +2",
    legs="Chev. Cuisses +3",
    feet="Rev. Leggings +3",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Tuisto Earring",
    right_ear="Ethereal Earring",
    left_ring="Moonlight Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

sets.defense.Block = {
    main="Burtgang",
    ammo="Iron Gobbet",
    head="Chev. Armet +3",
    body="Sakpata's Plate",
    hands="Chev. Gauntlets +2",
    legs="Chev. Cuisses +3",
    feet="Rev. Leggings +3",
    neck="Elite Royal Collar",
    waist="Carrier's Sash",
    left_ear="Thureous Earring",
    right_ear="Chev. Earring +1",
    left_ring="Moonbeam Ring",
    right_ring="Moonlight Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

--Doom/RR",
     
    sets.defense.PDT.Reraise = set_combine(sets.defense.PDT, sets.Reraise)
    sets.defense.PD.Reraise = set_combine(sets.defense.PD, sets.Reraise)
    sets.defense.MDT.Reraise = set_combine(sets.defense.MDT, sets.Reraise)
    sets.defense.Turtle.Reraise = set_combine(sets.defense.Turtle, sets.Reraise)
    sets.defense.Enmity.Reraise = set_combine(sets.defense.Enmity, sets.Reraise)
    sets.defense.HPBOOST.Reraise = set_combine(sets.defense.HPBOOST, sets.Reraise)
    sets.defense.DEF.Reraise = set_combine(sets.defense.DEF, sets.Reraise)
    sets.defense.Convert.Reraise = set_combine(sets.defense.Convert, sets.Reraise)
    sets.defense.Block.Reraise = set_combine(sets.defense.Block, sets.Reraise)
    sets.defense.Dagger.Reraise = set_combine(sets.defense.Dagger, sets.Reraise)
    sets.defense.ResistCharm.Reraise = set_combine(sets.defense.ResistCharm, sets.Reraise)
    sets.defense.PDH.Reraise = set_combine(sets.defense.PDH, sets.Reraise)


    sets.defense.PDT.Doom = set_combine(sets.defense.PDT, sets.Doom)
    sets.defense.PD.Doom = set_combine(sets.defense.PD, sets.Doom)
    sets.defense.MDT.Doom = set_combine(sets.defense.MDT, sets.Doom)
    sets.defense.Turtle.Doom = set_combine(sets.defense.Turtle, sets.Doom)
    sets.defense.Enmity.Doom = set_combine(sets.defense.Enmity, sets.Doom)
    sets.defense.HPBOOST.Doom = set_combine(sets.defense.HPBOOST, sets.Doom)
    sets.defense.DEF.Doom = set_combine(sets.defense.DEF, sets.Doom)
    sets.defense.Convert.Doom = set_combine(sets.defense.Convert, sets.Doom)
    sets.defense.Block.Doom = set_combine(sets.defense.Block, sets.Doom)
    sets.defense.Dagger.Doom = set_combine(sets.defense.Dagger, sets.Doom)
    sets.defense.ResistCharm.Doom = set_combine(sets.defense.ResistCharm, sets.Doom)
    sets.defense.PDH.Doom = set_combine(sets.defense.PDH, sets.Doom)

    sets.Obi = {waist="Hachirin-no-Obi"}

    sets.Kiting = {legs="Carmine Cuisses +1",back="Moonlight Cape",}
    --------------------------------------
    -- Engaged sets
    --------------------------------------
     
    sets.engaged = --1124 / 1264 avec enlight up 
    {}
 
    sets.engaged.Acc = --1179 / 1315 avec enlight up
    {main="Naegling",
    sub="Blurred Shield +1",
    ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",
}

sets.engaged.Tp = --1179 / 1315 avec enlight up
{   main="Naegling",
    sub="Blurred Shield +1",
    ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",}

    sets.engaged.STP = --1179 / 1315 avec enlight up
{   main="Naegling",
    sub="Blurred Shield +1",
    ammo="Aurgelmir Orb +1",
    head="Flam. Zucchetto +2",
    body="Flamma Korazin +2",
    hands="Flam. Manopolas +2",
    legs="Flamma Dirs +2",
    feet="Flam. Gambieras +2",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Dedition Earring",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Annealed Mantle",}


sets.engaged.Hybrid = --1179 / 1315 avec enlight up
{   ammo="Aurgelmir Orb +1",
    head="Hjarrandi Helm",
    body="Hjarrandi Breast.",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Vim Torque +1", augments={'Path: A',}},
    waist="Tempus Fugit +1",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Petrov Ring",
    right_ring="Moonlight Ring",
    back="Annealed Mantle",
}

sets.engaged.CRIT = --1179 / 1315 avec enlight up
{
    ammo="Coiste Bodhar",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Cessance Earring",
    right_ear="Brutal Earring",
    left_ring="Defending Ring",
    right_ring="Hetairoi Ring",
    back="Annealed Mantle",}
    sets.engaged.PDT = --1179 / 1315 avec enlight up
    {
        ammo="Staunch Tathlum +1",
        head="Chev. Armet +3",
        body="Chev. Cuirass +2",
        hands="Chev. Gauntlets +2",
        legs="Chev. Cuisses +3",
        feet="Chev. Sabatons +2",
        neck={ name="Vim Torque +1", augments={'Path: A',}},
        waist="Tempus Fugit +1",
        left_ear="Mache Earring +1",
        right_ear="Telos Earring",
        left_ring="Defending Ring",
        right_ring="Moonlight Ring",
        back="Shadow Mantle",
    }
    sets.engaged.MDT = --1179 / 1315 avec enlight up
    {
        ammo="Staunch Tathlum +1",
        head="Chev. Armet +3",
        body="Tartarus Platemail",
        hands="Chev. Gauntlets +2",
        legs="Chev. Cuisses +3",
        feet="Chev. Sabatons +2",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Tempus Fugit +1",
        left_ear="Mache Earring +1",
        right_ear="Telos Earring",
        left_ring="Shadow Ring",
        right_ring="Moonlight Ring",
        back="Engulfer Cape +1",
    }
    

end
------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------Job-specific hooks that are called to process player actions at specific points in time-----------
------------------------------------------------------------------------------------------------------------------------------------------
 

 
function job_update(cmdParams, eventArgs)
    job_self_command()
    update_defense_mode()
    customize_defense_set(defenseSet)
    customize_idle_set(idleSet)
    customize_melee_set(meleeSet)
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        idleSet = set_combine(idleSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    return idleSet
end
function customize_melee_set(meleeSet)
    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        meleeSet = set_combine(meleeSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    return meleeSet
end
function customize_defense_set(defenseSet)

    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        defenseSet = set_combine(defenseSet, sets.Reraise)
        send_command('input //gs equip sets.Reraise')
    end
    return defenseSet
end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- General hooks for change events.
-------------------------------------------------------------------------------------------------------------------
 
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
function job_precast(spell, action, spellMap, eventArgs)

end
function job_post_precast(spell, action, spellMap, eventArgs)
 --refine_various_spells(spell, action, spellMap, eventArgs)
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
 
end
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
    end
    if spell.skill == 'Divine Magic' and (spell.english == "Holy" or spell.english == "Holy II" or spell.english == "Banish" or spell.english == "Banish II" ) and state.MagicBurst.value then
        equip(sets.magic_burst)
    end

    if spell.skill == 'Divine Magic' and (spell.english == "Holy" or spell.english == "Holy II" or spell.english == "Banish" or spell.english == "Banish II" ) then     
           if (spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element])) then
            equip(sets.Obi)
        -- Target distance under 1.7 yalms.
        elseif spell.target.distance < (1.7 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
       elseif (spell.element == world.day_element and spell.element == world.weather_element) then
            equip(sets.Obi)
        -- Target distance under 8 yalms.
        elseif spell.target.distance < (8 + spell.target.model_size) then
            equip({waist="Orpheus's Sash"})
        -- Match day or weather.
       elseif (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
 
    return idleSet
end
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    return meleeSet
end
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
 
        --print( buff )
        --print( state.Buff[buff] )
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end
-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    if field == 'HybridDefenseMode' then
        classes.CustomDefenseGroups:clear()
        classes.CustomDefenseGroups:append(new_value)
    end
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end
function update_defense_mode()
    if player.equipment.main == 'Burtgang' and not classes.CustomDefenseGroups:contains('Burtgang') then
        classes.CustomDefenseGroups:append('Burtgang')
    end
     
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:endswith('Shield') and
        player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' and player.equipment.sub ~= 'Duban' and player.equipment.sub ~= 'Priwen' and player.equipment.sub ~= 'Blurred Shield +1' and player.equipment.sub ~= 'Beatific Shield +1' then
        state.CombatForm = 'DW'
        else
        state.CombatForm = nil
        end
    end
end
function job_handle_equipping_gear(playerStatus, eventArgs)    	
    if state.ShieldMode.value == "Duban" then
	   equip({sub="Duban"})
    elseif state.ShieldMode.value == "Ochain" then
	   equip({sub="Ochain"})
	elseif state.ShieldMode.value == "Aegis" then
	   equip({sub="Aegis"})
	--elseif state.ShieldMode.value == "Srivatsa" then
	   --equip({sub="Srivatsa"})
	end	
end

function job_buff_change(buff, gain)
        if buff == "Cover" then
                if gain then
                        equip (sets.Cover)
                        disable('Body','Head')
                else
                        enable('Body','Head')
                        handle_equipping_gear(player.status)
                end
        elseif buff == "doom" then
                if gain then           
                        equip(sets.Doom)
                        send_command('input /p Doomed, please Cursna.')
                        send_command('input /item "Holy Water" <me>')					
                        disable('legs','ring1','ring2','waist','neck')
                elseif not gain and not player.status == "Dead" and not player.status == "Engaged Dead" then
                        enable('legs','ring1','ring2','waist','neck')
                        send_command('input /p Doom removed, Thank you.')
                        handle_equipping_gear(player.status)
                else
                        enable('legs','ring1','ring2','waist','neck')
                        send_command('input /p '..player.name..' is no longer Doom Thank you !')
                end
				 elseif buff == "petrification" then
                if gain then    
						equip(sets.Petri)
                        disable('back')				
                        send_command('input /p Petrification, please Stona.')		
				else
                        enable('back')
                        send_command('input /p '..player.name..' is no longer Petrify Thank you !')
					end
				 elseif buff == "Charm" then
				 if gain then  			
                        send_command('input /p Charmd, please Sleep me.')		
				else	
                        send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
					end
				elseif buff == "paralysis" then
                 if gain then
                        
                        send_command('input /p '..player.name..' Paralysed, please Paralyna.')
						send_command('input /item "Remedy" <me>')	
                else                        
                        send_command('input /p '..player.name..' is no longer Paralysed Thank you !')
                    end	

        end
	for index,value in pairs(buffWatcher.watchList) do
    if index==buff then
      buffWatch()
      break
    end
  end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 37)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 37)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 37)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 37)
	elseif player.sub_job == 'WAR' then
        set_macro_page(1, 37)
	elseif player.sub_job == 'BLU' then
        set_macro_page(1, 37)
    else
        set_macro_page(1, 37)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
  if spellMap == 'Cure' and spell.target.type == 'SELF' then
    if state.CastingMode.value == 'DT' then
      equip(sets.self_healing.DT)
    else
    if state.CastingMode.value == 'MB' then
      equip(sets.self_healing.MB)
    else
      equip(sets.self_healing)
    end
  end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 200')
    end
end


function job_self_command(cmdParams, eventArgs)
if cmdParams[1] == 'buffWatcher' then
      buffWatch(cmdParams[2],cmdParams[3])
  end
  if cmdParams[1] == 'stopBuffWatcher' then
      stopBuffWatcher()
  end
    if player.hpp < 8 then --if u hp 10% or down click f12 to change to sets.Reraise this code add from Aragan Asura
        equip(sets.Reraise)
        send_command('input //gs equip sets.Reraise')
        eventArgs.handled = true
    end
    return
end

-- Curing rules
function refine_various_spells(spell,action,spell_map,event_args)
 
  cures = S{'Cure','Cure II','Cure III','Cure IV'}
  banish = S{'Banish','Banish II'}
      if not cures:contains(spell.english) and not banish:contains(spell.english) then
        return
    end 

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'

    if spell_recasts[spell.recast_id] > 0 then
        if cures:contains(spell.english) then
            if spell.english == 'Cure' then
                eventArgs.cancel = true
            return
            elseif spell.english == 'Cure IV' then
                newSpell = 'Cure III'
            elseif spell.english == 'Cure III' then
                newSpell = 'Cure II'
            elseif spell.english == 'Cure II' then
                newSpell = 'Cure'
            end 
        elseif banish:contains(spell.english) then
            if spell.english == 'Banish' then
                add_to_chat(122,cancelling)
                eventArgs.cancel = true
            return
            elseif spell.english == 'Banish II' then
                newSpell = 'Banish'
            end
        end
    end
        if newSpell ~= spell.english then
            send_command('input /ma "'..newSpell..'" '..tostring(spell.target.raw))
            return
        end
    end
end

-- -------------------------------------Aspir,Sleep/ga Nuke's refine rules (thanks Asura.Vafruvant for this code)-----------------------------------
-- function refine_various_spells(spell, action, spellMap, eventArgs)

	-- Enmity = S{'Geist Wall', 'Sheep Song', 'Soporific'}
 
    -- if not Enmitys:contains(spell.english) then
        -- return
    -- end
 
    -- local newSpell = spell.english
    -- local spell_recasts = windower.ffxi.get_spell_recasts()
    -- local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
  
    -- if spell_recasts[spell.recast_id] > 0 then
        -- if aspirs:contains(spell.english) then
            -- if spell.english == 'Geist Wall' then
                -- add_to_chat(122,cancelling)
                -- eventArgs.cancel = true
                -- return
				-- elseif spell.english == 'Geist Wall' then
                -- newSpell = 'Sheep Song'
				-- elseif spell.english == 'Sheep Song' then
                -- newSpell = 'Soporific'

            -- end         
 
        -- end
    -- end
  
    -- if newSpell ~= spell.english then
        -- send_command('input /ma "'..newSpell..'" '..tostring(spell.target.raw))
        -- eventArgs.cancel = true
        -- return
    -- end
-- end