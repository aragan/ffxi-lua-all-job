-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')

    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "Caudata Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}

    sets.precast.JA['Trance'] = {head="Horos Tiara"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Horos Tiara",ear1="Roundel Earring",
        body="Maxixi Casaque",hands="Buremte Gloves",ring1="Asklepian Ring",
        back="Toetapper Mantle",waist="Caudata Belt",legs="Nahtirah Trousers",feet="Maxixi Toe Shoes"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {ammo="Yamarang",
    legs="Dashing Subligar",}
    
    sets.precast.Samba = {head="Maxixi Tiara"}

    sets.precast.Jig = {legs="Horos Tights", feet="Maxixi Toe Shoes"}

    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Step['Feather Step'] = {feet="Charis Shoes +2"}

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Horos Casaque",hands="Buremte Gloves",ring2="Sangoma Ring",
        waist="Chaac Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"} -- magic accuracy
    sets.precast.Flourish1['Desperate Flourish'] = {ammo="Charis Feather",
        head="Whirlpool Mask",neck="Ej Necklace",
        body="Horos Casaque",hands="Buremte Gloves",ring1="Beeline Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"} -- acc gear

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Charis Bangles +2"}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Charis Casaque +2"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Charis Tiara +2"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves",ring1="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {    ammo="Aurgelmir Orb +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Meg. Gloves +2",
    legs={ name="Herculean Trousers", augments={'Weapon skill damage +3%',}},
    feet={ name="Herculean Boots", augments={'Accuracy+6','Weapon skill damage +3%','AGI+10',}},
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Odr Earring",
    left_ring="Regal Ring",
    right_ring="Epaminondas's Ring",
    back="Mecistopins Mantle" }
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
    ammo="C. Palug Stone",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Meg. Chausses +2",
    feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Sherida Earring",
    right_ear="Ishvara Earring",
    left_ring="Ilabrat Ring",
    right_ring="Regal Ring",})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {ammo="Honed Tathlum", back="Toetapper Mantle"})
    sets.precast.WS['Exenterator'].Fodder = set_combine(sets.precast.WS['Exenterator'], {waist=gear.ElementalBelt})

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Meg. Chausses +2",
        feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear="Brutal Earring",
        left_ring="Gere Ring",
        right_ring="Regal Ring",
        back={ name="Mecisto. Mantle", augments={'Cap. Point+46%','HP+10','DEF+9',}},
    })
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS.Acc, {})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Sherida Earring",
        right_ear="Odr Earring",
        left_ring="Ilabrat Ring",
        right_ring="Regal Ring",
    })
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
        ammo="Aurgelmir Orb +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Meg. Gloves +2",
        legs={ name="Herculean Trousers", augments={'Weapon skill damage +3%',}},
        feet={ name="Herculean Boots", augments={'Accuracy+6','Weapon skill damage +3%','AGI+10',}},
        neck="Caro Necklace",
        waist="Grunfeld Rope",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Odr Earring",
        left_ring="Regal Ring",
        right_ring="Epaminondas's Ring",
        back="Mecistopins Mantle" 
    })
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})

    sets.precast.WS['Aeolian Edge'] = {        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring",
    right_ring="Epaminondas's Ring",}
    
    sets.precast.Skillchain = {hands="Charis Bangles +2"}
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Felistris Mask",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Felistris Mask",neck="Ej Necklace",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",
        back="Toetapper Mantle",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}
    

    -- Idle sets

    sets.idle = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",}

    sets.idle.Town = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",}
    
    sets.idle.Weak = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",}
    
    -- Defense sets

    sets.defense.Evasion = {
        ammo="Staunch Tathlum +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Infused Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Sheltered Ring",
        right_ring="Paguroidea Ring",}

    sets.defense.PDT = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",}

    sets.defense.MDT = {    ammo="Staunch Tathlum +1",
    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",}

    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Meg. Chausses +2",
    feet="Malignance Boots",
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Brutal Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Mecistopins Mantle"}

    sets.engaged.Fodder = {ammo="Charis Feather",
        head="Felistris Mask",neck="Charis Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Charis Casaque +2",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs=gear.AugQuiahuiz,feet="Horos Toe Shoes"}
    sets.engaged.Fodder.Evasion = {ammo="Charis Feather",
        head="Felistris Mask",neck="Charis Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs=gear.AugQuiahuiz,feet="Horos Toe Shoes"}

    sets.engaged.Acc = {    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Mecistopins Mantle" }
    sets.engaged.Evasion = {ammo="Charis Feather",
        head="Felistris Mask",neck="Ej Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
    sets.engaged.PDT = {ammo="Charis Feather",
        head="Felistris Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Shadow Mantle",waist="Patentia Sash",legs="Qaaxo Tights",feet="Iuitl Gaiters +1"}
    sets.engaged.Acc.Evasion = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Qaaxo Tights",feet="Qaaxo Leggings"}
    sets.engaged.Acc.PDT = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Qaaxo Tights",feet="Qaaxo Leggings"}

    -- Custom melee group: High Haste (2x March or Haste)
    sets.engaged.HighHaste = {ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Brutal Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Mecistopins Mantle" }

    sets.engaged.Fodder.HighHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Charis Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Charis Casaque +2",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs=gear.AugQuiahuiz,feet="Horos Toe Shoes"}
    sets.engaged.Fodder.Evasion.HighHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Charis Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    sets.engaged.Acc.HighHaste = {ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Mecistopins Mantle" }
    sets.engaged.Evasion.HighHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Ej Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
    sets.engaged.Acc.Evasion.HighHaste = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Qaaxo Tights",feet="Qaaxo Leggings"}
    sets.engaged.PDT.HighHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Shadow Mantle",waist="Patentia Sash",legs="Qaaxo Tights",feet="Iuitl Gaiters +1"}
    sets.engaged.Acc.PDT.HighHaste = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Qaaxo Tights",feet="Qaaxo Leggings"}


    -- Custom melee group: Max Haste (2x March + Haste)
    sets.engaged.MaxHaste = {    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Sherida Earring",
    right_ear="Brutal Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Mecistopins Mantle" }

    -- Getting Marches+Haste from Trust NPCs, doesn't cap delay.
    sets.engaged.Fodder.MaxHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Thaumas Coat",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs=gear.AugQuiahuiz,feet="Horos Toe Shoes"}
    sets.engaged.Fodder.Evasion.MaxHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Qaaxo Harness",hands="Maxixi Bangles",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Mecistopins Mantle", waist="Patentia Sash",legs="Kaabnax Trousers",feet="Manibozho Boots"}

    sets.engaged.Acc.MaxHaste = {    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back="Mecistopins Mantle" }
    sets.engaged.Evasion.MaxHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
    sets.engaged.Acc.Evasion.MaxHaste = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Beeline Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Qaaxo Leggings"}
    sets.engaged.PDT.MaxHaste = {ammo="Charis Feather",
        head="Felistris Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Shadow Mantle",waist="Windbuffet Belt",legs="Qaaxo Tights",feet="Iuitl Gaiters +1"}
    sets.engaged.Acc.PDT.MaxHaste = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Qaaxo Tights",feet="Qaaxo Leggings"}



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {legs="Horos Tights"}
    sets.buff['Climactic Flourish'] = {head="Charis Tiara +2"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
    
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(3, 20)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 20)
    elseif player.sub_job == 'SAM' then
        set_macro_page(2, 20)
    else
        set_macro_page(5, 20)
    end
end

