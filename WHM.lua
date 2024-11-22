-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
-- IMPORTANT: This include requires supporting include files:
-- from my web :
-- Mote-include
-- Mote-Mappings
-- Mote-Globals

-- use addon curepleas or healbot or addon trust for help  u 
--use f2 f3 f3 for switch barstatus barelement boostspell
--this makw whm  easy and help u 
--add macro 
-- /console gs c barelement
-- /console gs c barstatus
-- /console gs c boostspell

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    include('Display.lua')
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
    state.RP = M(false, "Reinforcement Points Mode")
    state.CP = M(false, "Capacity Points Mode")
    barStatus = S{'Barpoison','Barparalyze','Barvirus','Barsilence','Barpetrify','Barblind','Baramnesia','Barsleep','Barpoisonra','Barparalyzra','Barvira','Barsilencera','Barpetra','Barblindra','Baramnesra','Barsleepra'}
    elemental_ws = S{"Flash Nova", "Sanguine Blade","Seraph Blade","Burning Blade","Red Lotus Blade"
    , "Shining Strike", "Aeolian Edge", "Gust Slash", "Cyclone","Energy Steal","Energy Drain"
    , "Leaden Salute", "Wildfire", "Hot Shot", "Flaming Arrow", "Trueflight", "Blade: Teki", "Blade: To"
    , "Blade: Chi", "Blade: Ei", "Blade: Yu", "Frostbite", "Freezebite", "Herculean Slash", "Cloudsplitter"
    , "Primal Rend", "Dark Harvest", "Shadow of Death", "Infernal Scythe", "Thunder Thrust", "Raiden Thrust"
    , "Tachi: Goten", "Tachi: Kagero", "Tachi: Jinpu", "Tachi: Koki", "Rock Crusher", "Earth Crusher", "Starburst"
    , "Sunburst", "Omniscience", "Garland of Bliss"}
    send_command('wait 2;input /lockstyleset 178')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'MaxAcc', 'Shield')
    state.HybridMode:options('Normal', 'SubtleBlow' , 'PDT')
    state.CastingMode:options( 'Duration', 'Normal', 'ConserveMP', 'SIRD', 'Enmity')
    state.WeaponskillMode:options('Normal', 'PDL')
    state.IdleMode:options('Normal', 'PDT', 'PDT', 'MDT', 'DT', 'HP', 'Evasion', 'MP', 'Refresh', 'Sphere')
    state.PhysicalDefenseMode:options('PDT','DT','HP', 'Evasion', 'MP')
    state.HippoMode = M(false, "hippoMode")
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.SrodaNecklace = M(false, 'SrodaNecklace')

    state.AutoEquipBurst = M(true)
    
    state.BarElement = M{['description']='BarElement', 'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesra', 'Barvira', 'Barparalyzra', 'Barsilencera', 'Barpetra', 'Barpoisonra', 'Barblindra', 'Barsleepra'}
    state.BoostSpell = M{['description']='BoostSpell', 'Boost-STR', 'Boost-INT', 'Boost-AGI', 'Boost-VIT', 'Boost-DEX', 'Boost-MND', 'Boost-CHR'}

    --use //listbinds    .. to show command keys
    -- Additional local binds
    --send_command('bind f3 @input /ja "Sublimation" <me>')
    send_command('bind ^f11 gs c set DefenseMode Magical')
	send_command('bind f11 gs c cycle CastingMode')
    send_command('bind f7 input //Sublimator')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind !s gs c toggle SrodaNecklace')
    send_command('bind @q gs c toggle AutoEquipBurst')
    send_command('bind @c gs c toggle CP')
    send_command('bind @x gs c toggle RP')  
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('wait 6;input /lockstyleset 178')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind f2 gs c cycle BoostSpell')
    send_command('bind !f2 gs c BoostSpell')
    send_command('bind f3 gs c cycle BarElement')
    send_command('bind !f3 gs c BarElement')
    send_command('bind f4 gs c cycle BarStatus')
    send_command('bind !f4 gs c BarStatus')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
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
    select_default_macro_book()
    if init_job_states then init_job_states({"WeaponLock","MagicBurst","HippoMode","SrodaNecklace"},{"IdleMode","OffenseMode","CastingMode","BarElement","BarStatus","BoostSpell"}) 
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- neck JSE Necks Reinforcement Points Mode add u neck here 
    sets.RP = {}
    -- Capacity Points Mode back
    sets.CP = {}
    -- Precast Sets

    -- Fast cast sets for spells


    sets.precast.FC = {
    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Sapience Orb",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Inyanga Jubbah +2",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Aya. Cosciales +2",
    feet={ name="Regal Pumps +1", augments={'Path: A',}},
    neck={ name="Clr. Torque +2", augments={'Path: A',}},
    waist="Witful Belt",
    left_ear="Loquac. Earring",
    right_ear="Malignance Earring",
    left_ring="Kishar Ring",
    right_ring="Prolix Ring",
    back="Alaunus's Cape",}
    
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak", waist="Shinjutsu-no-Obi +1"})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {
        head="Umuthi Hat",
        neck="Nodens Gorget",
        waist="Siegel Sash",})

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {legs="Ebers Pant. +2",})

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
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
    
    sets.precast.RA = {ammo=empty,
	head={ name="Nyame Helm", augments={'Path: B',}},
	body={ name="Nyame Mail", augments={'Path: B',}},
	hands={ name="Nyame Gauntlets", augments={'Path: B',}},
	legs={ name="Nyame Flanchard", augments={'Path: B',}},
	feet={ name="Nyame Sollerets", augments={'Path: B',}},
	left_ear="Crep. Earring",
	right_ear="Telos Earring",
	}

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
    
	sets.precast.WS.PDL = set_combine(sets.precast.WS,{
		ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
	})
    sets.precast.WS['Flash Nova'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Clr. Torque +2", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ear="Regal Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Cornelia's Ring",
        back="Argocham. Mantle",
    }
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Starburst'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Flash Nova']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Flash Nova']

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
            right_ear="Regal Earring",
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
        neck={ name="Clr. Torque +2", augments={'Path: A',}},
        waist="Prosilio Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Regal Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Black Halo'].PDL = set_combine(sets.precast.WS['Black Halo'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
    })
    sets.precast.WS['Mystic Boon'] = set_combine(sets.precast.WS['Black Halo'],{
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })
    sets.precast.WS['Mystic Boon'].PDL = set_combine(sets.precast.WS['Mystic Boon'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
    })
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
        right_ear="Regal Earring",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Cornelia's Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Judgment'].PDL = set_combine(sets.precast.WS['Judgment'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
    })
    sets.precast.WS['Realmrazer'] = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Regal Earring",
        right_ear="Telos Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Realmrazer'].PDL = set_combine(sets.precast.WS['Realmrazer'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
    })

    sets.precast.WS['Shattersoul'] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Regal Earring",
        right_ear="Brutal Earring",
        left_ring="Rufescent Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Shattersoul'].PDL = set_combine(sets.precast.WS['Realmrazer'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
    })
    sets.precast.WS['Hexa Strike'] = {
        ammo="Crepuscular Pebble",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Mache Earring +1",
        right_ear="Mache Earring +1",
        left_ring="Rufescent Ring",
        right_ring="Begrudging Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.precast.WS['Hexa Strike'].PDL = set_combine(sets.precast.WS['Hexa Strik'],{
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
        right_ear="Brutal Earring",
        left_ear="Regal Earring",
    })
    sets.precast.WS['True Strike'] = set_combine(sets.precast.WS['Hexa Strik'],{})
    sets.precast.WS['True Strike'].PDL = set_combine(sets.precast.WS['True Strike'], {
        ammo="Crepuscular Pebble",
        body={ name="Bunzi's Robe", augments={'Path: A',}},
        right_ear="Brutal Earring",
        left_ear="Regal Earring",
    })
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
        hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
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
        hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
    }
    sets.SIRDT = {
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
        legs={ name="Nyame Flanchard", augments={'Path: B',}},
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Halasz Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MP+20','"Cure" potency +10%','Phys. dmg. taken-10%',}},
    }

    sets.ConserveMP = {     main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
    left_ring="Naji's Loop",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",}
    
    -- Cure sets
    sets.Obi = {waist="Hachirin-no-Obi", back="Twilight Cape"}
    sets.Srodanecklace = {neck="Sroda necklace"}

    sets.midcast.CureSolace = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Ebers Bliaut +2",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck={ name="Clr. Torque +2", augments={'Path: A',}},
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear="Glorious Earring",
    left_ring="Naji's Loop",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Alaunus's Cape",}

    sets.midcast.CureSolace.SIRD = set_combine(sets.midcast.CureSolace, {
        main="Daybreak",
        sub="Culminus",
        ammo="Staunch Tathlum +1",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Ros. Jaseran +1", augments={'Path: A',}},
        hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
        legs="Ebers Pant. +2",
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Mendi. Earring",
        right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring="Defending Ring",
        back="Alaunus's Cape",
    })

    sets.midcast.CureSolace.ConserveMP = set_combine(sets.midcast.CureSolace, {    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
    left_ring="Naji's Loop",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.CureSolace.Enmity = set_combine(sets.midcast.CureSolace, {  
    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Pinga Tunic +1",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Pinga Pants +1",
    feet="Bunzi's Sabots",
    neck={ name="Clr. Torque +2", augments={'Path: A',}},
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Glorious Earring",
    right_ear="Ebers Earring",
    left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Cure = {main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck={ name="Clr. Torque +2", augments={'Path: A',}},
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
        hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
        legs="Ebers Pant. +2",
        feet="Theo. Duckbills +3",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear="Mendi. Earring",
        right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Defending Ring",
        back="Alaunus's Cape",
    })

    sets.midcast.Cure.ConserveMP = set_combine(sets.midcast.Cure, {    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
    left_ring="Naji's Loop",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Cure.Enmity = set_combine(sets.midcast.Cure, {  
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
        sub="Sors Shield",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Pinga Tunic +1",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Pinga Pants +1",
        feet="Bunzi's Sabots",
        neck={ name="Clr. Torque +2", augments={'Path: A',}},
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Glorious Earring",
        right_ear="Ebers Earring",
        left_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        right_ring={ name="Cacoethic Ring +1", augments={'Path: A',}},
        back="Solemnity Cape",})

    sets.midcast.Curaga = { main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Ebers Bliaut +2",
    hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck={ name="Clr. Torque +2", augments={'Path: A',}},
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
    hands={ name="Chironic Gloves", augments={'Mag. Acc.+11','Spell interruption rate down -10%','MND+8',}},
    legs="Ebers Pant. +2",
    feet="Theo. Duckbills +3",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear="Mendi. Earring",
    right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
    left_ring="Mephitas's Ring +1",
    right_ring="Defending Ring",
    back="Alaunus's Cape",
    })

    sets.midcast.Curaga.ConserveMP = set_combine(sets.midcast.Curaga, {   
    main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
    sub="Sors Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body="Vedic Coat",
    hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
    legs="Ebers Pant. +2",
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    neck="Reti Pendant",
    waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
    left_ear="Mendi. Earring",
    right_ear={ name="Nourish. Earring +1", augments={'Path: A',}},
    left_ring="Naji's Loop",
    right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
    back="Solemnity Cape",})

    sets.midcast.Curaga.Enmity = set_combine(sets.midcast.Curaga, {  
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
        sub="Sors Shield",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Pinga Tunic +1",
        hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
        legs="Pinga Pants +1",
        feet="Bunzi's Sabots",
        neck={ name="Clr. Torque +2", augments={'Path: A',}},
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
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Ebers Bliaut +2",
        hands={ name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Debilis Medallion",
        waist="Gishdubar Sash",
        right_ear="Ebers Earring",
        left_ring="Haoma's Ring",
        right_ring="Menelaus's Ring",
        back="Alaunus's Cape",
    }

    sets.midcast.StatusRemoval = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
        body="Ebers Bliaut +2",
        hands="Ebers Mitts +2",
        legs="Ebers Pant. +2",
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck={ name="Clr. Torque +2", augments={'Path: A',}},
        left_ring="Haoma's Ring",
        right_ring="Menelaus's Ring",
        back="Alaunus's Cape",    }
        sets.midcast.StatusRemoval.SIRD = set_combine(sets.midcast.StatusRemoval,sets.SIRD) 

    sets.Duration = {
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Theo. Duckbills +3",
        waist="Embla Sash",
    }

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
    main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head="Befouled Crown",
    body="Telchine Chas.",
    hands="Inyan. Dastanas +2",
    legs="Telchine Braconi",
    feet="Theo. Duckbills +3",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ring="Stikini Ring",
    left_ring="Stikini Ring",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}
    sets.midcast['Enhancing Magic'].SIRD = set_combine(sets.midcast['Enhancing Magic'],sets.SIRD) 
    sets.midcast['Enhancing Magic'].Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash",})
    sets.midcast.Refresh.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration, {waist="Gishdubar Sash",})

    sets.midcast.Stoneskin = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Theo. Duckbills +3",
        neck="Nodens Gorget",
		legs="Haven Hose",
        waist="Siegel Sash",
		right_ear="Earthcry Earring",
        left_ear="Andoaa Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}
        sets.midcast.Stoneskin.SIRD = set_combine(sets.midcast.Stoneskin,sets.SIRD) 
        sets.midcast.Stoneskin.Duration = set_combine(sets.midcast.Stoneskin,sets.Duration) 

    sets.midcast.Blink = {
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Theo. Duckbills +3",
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
        main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Regal Cuffs",
        legs="Telchine Braconi",
        feet="Theo. Duckbills +3",
        neck="Incanter's Torque",
        waist="Embla Sash",
        left_ear="Andoaa Earring",
        left_ring="Mephitas's Ring",
        right_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    sets.midcast.Aquaveil.SIRD = set_combine(sets.midcast.Aquaveil,sets.SIRD)
    sets.midcast.Aquaveil.Duration = set_combine(sets.midcast.Aquaveil,sets.Duration) 

    sets.midcast.Haste = set_combine(sets.midcast['Enhancing Magic'])
    sets.midcast.Haste.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {feet="Ebers Duckbills +1"})
    sets.midcast.Auspice.Duration = set_combine(sets.midcast['Enhancing Magic'].Duration, {
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Ebers Duckbills +2",
        neck="Incanter's Torque",
        left_ear="Andoaa Earring",
        right_ring="Stikini Ring",
        left_ring="Stikini Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}) 

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
    main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    ammo="Pemphredo Tathlum",
    head="Ebers Cap +2",
    body="Ebers Bliaut +2",
    hands="Telchine Gloves",
    legs="Ebers Pant. +2",
    feet="Ebers Duckbills +2",
    neck="Incanter's Torque",
    waist="Embla Sash",
    left_ear="Andoaa Earring",
    right_ring="Stikini Ring",
    left_ring="Stikini Ring",
    back="Alaunus's Cape",
    })
    sets.midcast.BarElement.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration) 

    sets.midcast.Regen =set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        ammo="Sapience Orb",
        head="Inyanga Tiara +2",
        body="Telchine Chas.",
        hands="Ebers Mitts +2",
        legs="Telchine Braconi",
        feet="Theo. Duckbills +3",
        waist="Embla Sash",})
    sets.midcast.Regen.Duration = set_combine(sets.midcast['Enhancing Magic'],sets.Duration, { 
        hands="Ebers Mitts +2",}) 

    sets.midcast.Protectra = sets.midcast['Enhancing Magic']
    sets.midcast.Shellra = sets.midcast['Enhancing Magic']

    sets.midcast['Divine Magic'] = {
    main="Daybreak",
    sub="Ammurapi Shield",
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
    main="Daybreak",
    sub="Ammurapi Shield",
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
        main="Daybreak",
        sub="Ammurapi Shield",
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

    sets.magic_burst = set_combine(sets.midcast['Divine Magic'],{
        head={ name="Nyame Helm", augments={'Path: B',}},
        body={ name="Bunzi's Robe", augments={'Path: A',}},
        hands={ name="Bunzi's Gloves", augments={'Path: A',}},
        legs={ name="Bunzi's Pants", augments={'Path: A',}},
        feet={ name="Bunzi's Sabots", augments={'Path: A',}},
        neck="Mizu. Kubikazari",
        left_ring="Locus Ring",
        right_ring="Mujin Band",
    })

    sets.midcast['Dark Magic'] = {
    main={ name="Gada", augments={'Indi. eff. dur. +1','VIT+1','"Mag.Atk.Bns."+19',}},
    sub="Ammurapi Shield",
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
    sets.midcast.Impact = set_combine(sets.midcast['Dark Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        waist="Shinjutsu-no-Obi +1",
        })
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
    sets.defense.MDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Bunzi's Hat", augments={'Path: A',}},
    body="Shamash Robe",
    hands={ name="Bunzi's Gloves", augments={'Path: A',}},
    legs={ name="Bunzi's Pants", augments={'Path: A',}},
    feet={ name="Bunzi's Sabots", augments={'Path: A',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Inyanga Ring",
    right_ring="Shadow Ring",
    back="Alaunus's Cape",}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        ammo="Homiliary",
        head="Befouled Crown",
        body="Shamash Robe",
        hands={ name="Chironic Gloves", augments={'VIT+4','"Waltz" potency +2%','"Refresh"+2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
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
        ammo="Homiliary",
        head={ name="Nyame Helm", augments={'Path: B',}},
        body="Shamash Robe",
        hands={ name="Nyame Gauntlets", augments={'Path: B',}},
        legs={ name="Assid. Pants +1", augments={'Path: A',}},
        feet={ name="Nyame Sollerets", augments={'Path: B',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Plat. Mog. Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Etiolation Earring",
        left_ring="Stikini Ring +1",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Alaunus's Cape",}
    
    sets.idle.Refresh = {
    ammo="Homiliary",
    head="Befouled Crown",
    body="Shamash Robe",
    hands={ name="Chironic Gloves", augments={'VIT+4','"Waltz" potency +2%','"Refresh"+2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Alaunus's Cape",}


    sets.idle.Sphere = set_combine(sets.idle.PDT , {
    body="Annoint. Kalasiris"})

    sets.idle.MDT = set_combine(sets.defense.MDT , {})    
    sets.idle.DT = set_combine(sets.defense.DT , {})
    sets.idle.HP = set_combine(sets.defense.HP , {})
    sets.idle.Evasion = set_combine(sets.defense.Evasion , {})
    sets.idle.MP = set_combine(sets.defense.MP , {})
    sets.idle.Town = {
    feet="Herald's Gaiters",
    left_ear="Infused Earring",}
    
    sets.idle.Weak = {
    ammo="Homiliary",
    head="Befouled Crown",
    body="Shamash Robe",
    hands={ name="Chironic Gloves", augments={'VIT+4','"Waltz" potency +2%','"Refresh"+2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    legs="Assid. Pants +1",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear="Andoaa Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Inyanga Ring",
    back="Alaunus's Cape",}


    sets.Kiting = {feet="Herald's Gaiters"}
    sets.MoveSpeed = {feet="Herald's Gaiters"}
    sets.Adoulin = {body="Councilor's Garb",}
    sets.raise = sets.SIRDT

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
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
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
        neck="Combatant's Torque",
        waist="Plat. Mog. Belt",
        back="Moonlight Cape",
    })

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts +2", back="Mending Cape"}
    sets.buff.Sublimation = {waist="Embla Sash"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
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

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        elseif spell.skill == 'Enhancing Magic' then
            equip(sets.SIRD)
        end
    end
    if spell.name == 'Impact' then
		equip(sets.precast.FC.Impact)
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
end
function job_post_midcast(spell, action, spellMap, eventArgs)
    RaiseSpells = S{'Raise','Raise II','Raise III','Arise','Reraise','Reraise II','Reraise III','Reraise IV'}
	if RaiseSpells:contains(spell.english) then
		equip(sets.raise)
	end
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if (spell.skill == 'Elemental Magic' or spell.skill == 'Divine Magic') and (state.MagicBurst.value or AEBurst) then
        equip(sets.magic_burst)
        if spell.english == "Impact" then
            equip(sets.midcast.Impact)
        end
    end
    if spell.action_type == 'Magic' then
        if state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        end
    end
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.Duration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh.Duration)
            end
        end
        if spellMap == "Regen" and state.CastingMode.value == 'Duration' then
            equip(sets.midcast.Regen.Duration)
        end
    end
	if (spell.skill == 'Elemental Magic' or spell.skill == 'Healing Magic' or spell.skill == 'Divine Magic') and (spell.element == world.weather_element or spell.element == world.day_element) then
        equip(sets.Obi)
    elseif state.MagicBurst.value then
            equip(sets.magic_burst)
    end
    if barStatus:contains(spell.name) then
        if state.SrodaNecklace.value then
            equip({neck="Sroda necklace"})
        end
    end
end
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Repose" then
            send_command('@timers c "Repose ['..spell.target.name..']" 90 down spells/00098.png')
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

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
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
    if buff == "curse" then
        if gain then  
        send_command('input /item "Holy Water" <me>')
        end
    end
    if not midaction() then
        job_update()
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if update_job_states then update_job_states() 
    end
    handle_equipping_gear(player.status)
end

windower.register_event('zone change',
    function()
        --add that at the end of zone change
        if update_job_states then update_job_states() end
    end
)

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
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
         enable('back')
    end
    if state.RP.current == 'on' then
        equip(sets.RP)
        disable('neck')
    else
        enable('neck')
    end
    if state.HippoMode.value == true then 
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)

end
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'barelement' then
        send_command('@input /ma '..state.BarElement.value..' <me>')
    elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    elseif cmdParams[1]:lower() == 'boostspell' then
        send_command('@input /ma '..state.BoostSpell.value..' <me>')
    end

    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(cmdParams[4]) == 'string' then

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
    if state.AutoEquipBurst.value then
        msg = msg ..'Auto Equip Magic Burst Set: On'
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
    if state.HippoMode.value == true then 
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
-- Auto toggle Magic burst set.
MB_Window = 0
time_start = 0
AEBurst = false

if player and player.index and windower.ffxi.get_mob_by_index(player.index) then

    windower.raw_register_event('action', function(act)
        for _, target in pairs(act.targets) do
            local battle_target = windower.ffxi.get_mob_by_target("t")
            if battle_target ~= nil and target.id == battle_target.id then
                for _, action in pairs(target.actions) do
                    if action.add_effect_message > 287 and action.add_effect_message < 302 then
                        --last_skillchain = skillchains[action.add_effect_message]
                        MB_Window = 11
                        MB_Time = os.time()
                    end
                end
            end
        end
    end)

    windower.raw_register_event('prerender', function()
        --Items we want to check every second
        if os.time() > time_start then
            time_start = os.time()
            if MB_Window > 0 then
                MB_Window = 11 - (os.time() - MB_Time)
                if state.AutoEquipBurst.value then
                    AEBurst = true
                end
            else
                AEBurst = false
            end
        end
    end)
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 13)
end

