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
    -- Load and initialize the include file.
    include('Mote-IncludePLD.lua')
    require 'organizer-lib'
end

 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    options.OffenseModes = {'Normal', 'Acc', 'Tp'}
	options.DefenseModes = {'Normal', 'PDT'}
    options.WeaponskillModes = {'Normal', 'Acc'}
    options.CastingModes = {'Normal', 'DT'} 
    options.IdleModes = {'Normal',}
    options.RestingModes = {'Normal'}
    options.PhysicalDefenseModes = {'PD', 'HPBOOST', 'Enmity', 'HP', 'DEF', 'Convert', 'Block', 'Dagger'}
    options.MagicalDefenseModes = {'MDT' ,'Turtle','ResistCharm'}
    options.HybridDefenseModes = {'None', 'Reraise',}
    options.BreathDefenseModes = {'Turtle'}
	state.Defense.PhysicalMode = 'PD'
    state.HybridDefenseMode = 'None'
    state.BreathDefenseModes = 'Turtle'
    send_command('bind f12 gs c cycle MagicalDefense')
 	send_command('bind ^= gs c activate MDT')
    send_command('wait 2;input /lockstyleset 200')
    select_default_macro_book()
end

 function user_unload()
	send_command('unbind `')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind !-')	
	send_command('unbind ^=')
	send_command('unbind !=')		
	send_command('unbind delete')
	send_command('unbind end')
	send_command('unbind home')
end

-- Define sets and vars used by this job file.
function job_setup()
 	include('caster_buffWatcher.lua')
buffWatcher.watchList = 
{
                       ["Enlight"]="Enlight II",
					   ["Enmity Boost"]="Crusade",
                       ["Phalanx"]="Phalanx",
                       ["Protect"]="Protect V",
                       ["Shell"]="Shell IV",							   
}
include('common_info.status.lua')	
end

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------Precast sets-----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

function init_gear_sets()

	 -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.precast.JA['Provoke'], {legs="Cab. Breeches +3"})
   
    sets.precast.JA['Holy Circle'] = set_combine(sets.precast.JA['Provoke'], {feet="Rev. Leggings"})
         
    sets.precast.JA['Shield Bash'] = set_combine(sets.precast.JA['Provoke'], {sub="Aegis", hands="Cab. Gauntlets +2", left_ear="Knightly Earring", left_ring="Guardian's Ring",right_ring="Fenian Ring"})
     
    sets.precast.JA['Intervene'] = sets.precast.JA['Shield Bash']
    
    sets.precast.JA['Sentinel'] = set_combine(sets.precast.JA['Provoke'], {feet="Cab. Leggings +3"})   
     
    --The amount of damage absorbed is variable, determined by VIT*2
    sets.precast.JA['Rampart'] =     
{

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
     
    sets.precast.JA['Divine Emblem'] = set_combine(sets.precast.JA['Provoke'], {feet="Chev. Sabatons +1"})
     
    --15 + min(max(floor((user VIT + user MND - target VIT*2)/4),0),15)
    sets.precast.JA['Cover'] = set_combine(sets.precast.JA['Rampart'], {head="Rev. Coronet +2", body="Cab. Surcoat +1"})
    
    sets.buff['Cover'] = sets.precast.JA['Cover']
     
    -- add MND for Chivalry
    sets.precast.JA['Chivalry'] = 
{   hands={ name="Cab. Gauntlets +1", augments={'Enhances "Chivalry" effect',}},
}
     
    ------------------------ Sub WAR ------------------------ 
	sets.precast.JA['Provoke'] =    --enmity +152
{

}
 
    sets.precast.JA['Warcry'] = sets.precast.JA['Provoke'] 
     
    sets.precast.JA['Defender'] = sets.precast.JA['Provoke']
 
    ------------------------ Sub DNC ------------------------ 
     
    -- Waltz set (chr and vit)
    sets.precast.Waltz = 
{

}
         
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
	sets.precast.FC = 
{   
    ammo="Sapience Orb",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body="Rev. Surcoat +3",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Kishar Ring",
    back="Moonlight Cape",
}
     
	sets.precast.FC.DT = 
{ 
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
	 
    sets.precast.FC.Phalanx = set_combine(sets.precast.FC , {})
	sets.precast.FC.Enlight = sets.precast.FC.Phalanx
	sets.precast.FC['Enlight II'] = sets.precast.FC.Phalanx
	sets.precast.FC.Protect = sets.precast.FC.Phalanx
	sets.precast.FC.Shell = sets.precast.FC.Phalanx
	sets.precast.FC.Crusade = sets.precast.FC.Phalanx
         
    sets.precast.FC.Cure = 
{
    right_ear="Mendi. Earring",
    left_ring="Moonbeam Ring",
}
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = 
{   ammo="Ginsen",
head="Sakpata's Helm",
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs="Sakpata's Cuisses",
feet="Sulev. Leggings +2",
neck="Fotia Gorget",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Thrud Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
left_ring="Beithir Ring",
    right_ring="Epaminondas's Ring",
    back="Atheling Mantle",

}
 
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
 
    --Stat Modifier:     73~85% MND  fTP:    1.0
 sets.precast.WS['Requiescat'] = 
{ammo="Ginsen",
    head="Flam. Zucchetto +2",
    body="Sulevia's Plate. +2",
    hands="Flam. Manopolas +2",
    legs="Sulev. Cuisses +2",
    feet="Sulev. Leggings +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Thrud Earring",
    right_ear="Telos Earring",
    left_ring="Moonbeam Ring",
    right_ring="Petrov Ring",
    back="Atheling Mantle",


}
    
   --Stat Modifier:  50%MND / 30%STR MAB+    fTP:2.75
    sets.precast.WS['Sanguine Blade'] = 
{
    ammo="Pemphredo Tathlum",
    head={ name="Valorous Mask", augments={'Weapon skill damage +4%',}},
    body={ name="Valorous Mail", augments={'Accuracy+13 Attack+13','Weapon skill damage +4%','STR+2','Attack+8',}},
    hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
    legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
    feet="Sulev. Leggings +2",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Beithir Ring",
    right_ring="Epaminondas's Ring",
    back="Argocham. Mantle",
}	
	
     
    sets.precast.WS['Aeolian Edge'] = 
{   
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
    legs="Nyame Flanchard",
    feet="Sulev. Leggings +2",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Epaminondas's Ring",
    back="Argocham. Mantle",
}	

sets.precast.WS['Cataclysm'] = 
{   
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body={ name="Valorous Mail", augments={'Accuracy+13 Attack+13','Weapon skill damage +4%','STR+2','Attack+8',}},
    hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
    legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
    feet="Sulev. Leggings +2",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Archon Ring",
    right_ring="Epaminondas's Ring",
    back="Argocham. Mantle",
}	

 
    --Stat Modifier: 50%MND / 50%STR fTP: 1000:4.0 2000:10.25 3000:13.75
    sets.precast.WS['Savage Blade'] = 
{       ammo="Coiste Bodhar",
head="Sakpata's Helm",
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs="Sakpata's Cuisses",
feet="Sulev. Leggings +2",
neck="Fotia Gorget",
waist={ name="Sailfi Belt +1", augments={'Path: A',}},
left_ear="Thrud Earring",
right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
left_ring="Beithir Ring",
right_ring="Epaminondas's Ring",
back="Atheling Mantle",

}

   --Stat Modifier:  80%DEX  fTP:2.25
   sets.precast.WS['Chant du Cygne'] = 
{	
    ammo="Ginsen",
    head="Sakpata's Helm",
    body="Hjarrandi Breast.",
    hands="Flam. Manopolas +2",
    legs="Sakpata's Cuisses",
    feet="Sulev. Leggings +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear="Telos Earring",
    left_ring="Petrov Ring",
    right_ring="Epaminondas's Ring",
    back="Atheling Mantle",
}
	
    --Stat Modifier: WS damage + 30/31%   2211DMG maxaggro
    sets.precast.WS['Atonement'] = 
{
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
           
    ------------------------------------------------------------------------------------------------
    -----------------------------------------Midcast sets-------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.midcast.FastRecast = 
{
    
}
	
    -- Divine Skill 590/594 142 Acc
    sets.midcast.Divine = 
{

}

    sets.midcast.Divine.DT = 
{


    ammo="Sapience Orb",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body={ name="Odyss. Chestplate", augments={'Attack+23','"Fast Cast"+5','STR+8','Accuracy+15',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Odyssean Cuisses", augments={'Attack+29','"Fast Cast"+5','CHR+10',}},
    feet={ name="Odyssean Greaves", augments={'Accuracy+9','"Fast Cast"+2','Mag. Acc.+2','"Mag.Atk.Bns."+1',}},
    neck="Diemer Gorget",
    waist="Cascade Belt",
    left_ear="Nourish. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back={ name="Weard Mantle", augments={'VIT+1','Enmity+3','Phalanx +5',}},
}
	
	--skill 401/402
	sets.midcast['Enhancing Magic'] =
{    
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

	sets.midcast.MAB = 
{
}

     
    sets.midcast.Flash = 
{

}

    sets.midcast.Flash.DT = 
{
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Founder's Hose", augments={'MND+5','Mag. Acc.+5','Attack+3','Breath dmg. taken -2%',}},
    feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Audumbla Sash",
    left_ear="Knightly Earring",
    right_ear="Ethereal Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
    back="Moonlight Cape",
}
         
    sets.midcast.Enlight = sets.midcast.Divine --+95 accu
    sets.midcast['Enlight II'] = sets.midcast.Enlight--+142 accu (+2 acc each 20 divine skill)
     
    --Max HP+ set for reprisal 3951HP / war so 7902+ damage reflect before it off (8k+ with food)
    sets.midcast.Reprisal =	
{
    sub="Ochain",
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Rev. Surcoat +3",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonbeam Ring",
    back="Moonlight Cape",
}
     
    --Phalanx skill 386/386 = 31/31  + phalanx + 30/31 total 61/62
    sets.midcast.Phalanx = 
    {
        ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        body="Shab. Cuirass +1",
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
        legs="Sakpata's Cuisses",
        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+23','Magic dmg. taken -5%','INT+9',}},
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Knightly Earring",
        right_ear="Andoaa Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Weard Mantle", augments={'VIT+1','Enmity+3','Phalanx +5',}},
    } 

    sets.midcast.Phalanx.DT = 
{
    sub="Ochain",
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
     
    sets.midcast.Banish = 
{

}
	
	
    sets.midcast['Banish II'] = set_combine(sets.midcast.MAB, {right_ring="Fenian Ring"})
     
    sets.midcast.Holy = sets.midcast.MAB
    sets.midcast['Holy II'] = sets.midcast.Holy
     
    sets.midcast.Crusade = 
{
    
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

sets.midcast.Cocoon =
{    
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

sets.midcast.Cocoon.DT =
{    
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
    sets.midcast.Cure = 
{    

}

    sets.midcast.Cure.DT = 
{
    
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

-- 630 HP (curecheat)
	sets.self_healing =
{      

}
	
	sets.self_healing.DT =
{
    
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


    sets.midcast.Protect = set_combine(sets.self_healing.DT, {
     head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Sheltered Ring",
    right_ring="Stikini Ring +1",

})
    sets.midcast.Shell = set_combine(sets.self_healing.DT, {
     head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    neck="Enhancing Torque",
    waist="Olympus Sash",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Sheltered Ring",
    right_ring="Stikini Ring +1",
})
	sets.midcast.Raise = 
{       
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
	sets.SID =
{   
    
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

---------- NIN Spell	--------------
	sets.midcast.Utsusemi = 
{      
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
    sets.midcast['Geist Wall'] =
{    
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
	

    sets.midcast['Sheep Song'] = 
{   
    ammo="Pemphredo Tathlum",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck="Sanctity Necklace",
    waist="Luminary Sash",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",

}

	
	sets.midcast.Soporific = 
{   
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

	
	sets.midcast['Stinking Gas'] = 
{   
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

    
	sets.midcast['Bomb Toss'] = 
{   
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

	
	
	
	
	
	
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
	sets.Cover = set_combine(sets.precast.JA['Rampart'], {head="Rev. Coronet +2", body="Cab. Surcoat +1"})
    sets.Doom = {neck="Nicander's Necklace",left_ring="Eshmun's Ring",right_ring="Blenmot's Ring +1", waist="Gishdubar Sash"} -- +65%
    sets.Petri = {back="Sand Mantle"} 
	sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
	sets.Sleep = {neck="Vim Torque +1",left_ear="Infused Earring",}
	sets.Breath =
{

}
   
    sets.resting = 
{

}
     
    -- Idle sets
    sets.idle = 
{ 

}
 
    sets.idle.Town =
{	 
    legs="Carmine Cuisses +1"
}
     
    sets.idle.Weak = 
{
    head="Twilight Helm", body="Twilight Mail"
}
     
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
	
	sets.HQ =
{

}
	

     
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
    sets.defense.PDT = 
{
    sub="Ochain",
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
    sets.defense.MDT =
{
    sub="Aegis",
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

	sets.defense.Turtle =
{   

    sub="Aegis",
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Hjarrandi Breast.",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Nierenschutz",
    left_ear="Odnowa Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Patricius Ring",
    right_ring="Moonbeam Ring",
    back="Moonlight Cape",
}

	sets.defense.ResistCharm =
{
    sub="Ochain",
    ammo="Staunch Tathlum +1",
    head="Loess Barbuta +1",
    body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Nierenschutz",
    left_ear="Thureous Earring",
    right_ear="Volunt. Earring",
    left_ring="Unyielding Ring",
    right_ring="Wuji Ring",
    back="Solemnity Cape",
}	
	
    sets.defense.Enmity = 
{ 
    sub="Ochain",
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
    
    sets.defense.PD = 
{    
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
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Fortified Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}
 
    sets.defense.HPBOOST = 
{
    sub="Ochain",
    ammo="Staunch Tathlum +1",
    head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    body="Rev. Surcoat +3",
    hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Creed Baudrier",
    left_ear="Tuisto Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Moonbeam Ring",
    back="Moonlight Cape",
 
}

sets.defense.HP = set_combine(sets.defense.HPBOOST, {
    ammo="Iron Gobbet",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Sakpata's Gauntlets",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
})

sets.defense.DEF = {
    sub="Ochain",
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
    sub="Ochain",
    ammo="Staunch Tathlum +1",
    head="Chev. Armet +1",
    body="Sakpata's Plate",
    hands="Rev. Gauntlets +3",
    legs="Sakpata's Cuisses",
    feet="Rev. Leggings +3",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Ethereal Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

sets.defense.Block = {
    sub="Ochain",
    ammo="Staunch Tathlum +1",
    head="Sakpata's Helm",
    body="Sakpata's Plate",
    hands="Rev. Gauntlets +3",
    legs="Sakpata's Cuisses",
    feet="Sakpata's Leggings",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Ethereal Earring",
    right_ear="Thureous Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Fortified Ring",
    back={ name="Rudianos's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','VIT+10','Enmity+10','Chance of successful block +5',}},
}

sets.defense.Dagger = 
{    
    main={ name="Malevolence", augments={'INT+10','"Mag.Atk.Bns."+6',}},
    sub="Ochain",
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

--Doom/RR",
     
    sets.defense.PDT.Reraise = set_combine(sets.defense.PDT, sets.Reraise)
    sets.defense.PD.Reraise = set_combine(sets.defense.PD, sets.Reraise)
    sets.defense.MDT.Reraise = set_combine(sets.defense.MDT, sets.Reraise)
    sets.defense.PD.Reraise = set_combine(sets.defense.PD, sets.Reraise)
     
    sets.defense.PDT.Doom = set_combine(sets.defense.PDT, sets.Doom)
    sets.defense.PD.Doom = set_combine(sets.defense.PD, sets.Doom)
    sets.defense.MDT.Doom = set_combine(sets.defense.PDT, sets.Doom)
    sets.defense.PD.Doom = set_combine(sets.defense.PD, sets.Doom)
     
    sets.Kiting = {
        
        legs="Carmine Cuisses +1",right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        back="Moonlight Cape",

}

 
 
    --------------------------------------
    -- Engaged sets
    --------------------------------------
     
    sets.engaged = --1124 / 1264 avec enlight up
{       main={ name="Malevolence", augments={'INT+10','"Mag.Atk.Bns."+6',}},
sub="Ochain",
hands="Rev. Gauntlets +3",

}
 
    sets.engaged.Acc = --1179 / 1315 avec enlight up
{

ammo="Coiste Bodhar",
head="Flam. Zucchetto +2",
body="Sakpata's Plate",
hands="Sakpata's Gauntlets",
legs="Sakpata's Cuisses",
feet="Sakpata's Leggings",
neck={ name="Vim Torque +1", augments={'Path: A',}},
waist={ name="Sailfi Belt +1", augments={'Path: A',}},
left_ear="Brutal Earring",
right_ear="Telos Earring",
left_ring="Patricius Ring",
right_ring="Petrov Ring",
back="Atheling Mantle",
}

sets.engaged.Tp = --1179 / 1315 avec enlight up
{

ammo="Coiste Bodhar",
head="Flam. Zucchetto +2",
body="Sakpata's Plate",
hands="Rev. Gauntlets +3",
legs="Sakpata's Cuisses",
feet="Sakpata's Leggings",
neck={ name="Vim Torque +1", augments={'Path: A',}},
waist={ name="Sailfi Belt +1", augments={'Path: A',}},
left_ear="Brutal Earring",
right_ear="Telos Earring",
left_ring="Patricius Ring",
right_ring="Petrov Ring",
back="Atheling Mantle",
}

end
------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------Job-specific hooks that are called to process player actions at specific points in time-----------
------------------------------------------------------------------------------------------------------------------------------------------
 

 
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
     
    return idleSet
end
 
 
 
function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
     
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
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
function job_post_precast(spell, action, spellMap, eventArgs)
 refine_various_spells(spell, action, spellMap, eventArgs)
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
 
end
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
 
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
        player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
        state.CombatForm = 'DW'
        else
        state.CombatForm = nil
        end
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
                        send_command('@input /p Doomed, please Cursna.')
                        send_command('@input /item "Holy Water" <me>')					
                        disable('legs','ring1','ring2','waist')
                elseif not gain and not player.status == "Dead" and not player.status == "Engaged Dead" then
                        enable('legs','ring1','ring2','waist')
                        send_command('input /p Doom removed, Thank you.')
                        handle_equipping_gear(player.status)
                else
                        enable('legs','ring1','ring2','waist')
                        send_command('input /p '..player.name..' is no longer Doom Thank you !')
                end
				 elseif buff == "petrification" then
                if gain then    
						equip(sets.Petri)
                        disable('back')				
                        send_command('@input /p Petrification, please Stona.')		
				else
                        enable('back')
                        send_command('input /p '..player.name..' is no longer Petrify Thank you !')
					end
				 elseif buff == "Charm" then
				 if gain then  			
                        send_command('@input /p Charmd, please Sleep me.')		
				else	
                        send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
					end
				elseif buff == "paralysis" then
                 if gain then
                        
                        send_command('@input /p '..player.name..' Paralysed, please Paralyna.')
						send_command('@input /item "Remedy" <me>')	
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
        set_macro_page(2, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'RDM' then
        set_macro_page(2, 8)
    elseif player.sub_job == 'RUN' then
        set_macro_page(2, 1)
	elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)	
	elseif player.sub_job == 'BLU' then
        set_macro_page(2, 3)	
    else
        set_macro_page(2, 1)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
  if spellMap == 'Cure' and spell.target.type == 'SELF' then
    if options.CastingModes.value == 'DT' then
      equip(sets.self_healing.DT)
    else
      equip(sets.self_healing)
  end
end
  end


function job_self_command(cmdParams, eventArgs)
if cmdParams[1] == 'buffWatcher' then
      buffWatch(cmdParams[2],cmdParams[3])
  end
  if cmdParams[1] == 'stopBuffWatcher' then
      stopBuffWatcher()
  end
end
add_to_chat(159,'Author Aragan PLD.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')

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
            send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
            return
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
        -- send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
        -- eventArgs.cancel = true
        -- return
    -- end
-- end