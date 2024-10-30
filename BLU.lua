---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------

--[[                                                                                                     
88888888ba   88                               88b           d88                                       
88      "8b  88                               888b         d888                                       
88      ,8P  88                               88`8b       d8'88                                       
88aaaaaa8P'  88  88       88   ,adPPYba,      88 `8b     d8' 88  ,adPPYYba,   ,adPPYb,d8   ,adPPYba,  
88""""""8b,  88  88       88  a8P_____88      88  `8b   d8'  88  ""     `Y8  a8"    `Y88  a8P_____88  
88      `8b  88  88       88  8PP"""""""      88   `8b d8'   88  ,adPPPPP88  8b       88  8PP"""""""  
88      a8P  88  "8a,   ,a88  "8b,   ,aa      88    `888'    88  88,    ,88  "8a,   ,d88  "8b,   ,aa  
88888888P"   88   `"YbbdP'Y8   `"Ybbd8"'      88     `8'     88  `"8bbdP"Y8   `"YbbdP"Y8   `"Ybbd8"'  
                                                                              aa,    ,88              
                                                                               "Y8bbdP"               
																			   
]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
-- Haste/DW Detection Requires Gearinfo Addon


-- Initialization function for this job file.
function get_sets()
    include('Display.lua') 
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end
--================================================--
--                                                --
--      |     |        ,---.     |                --
--      |,---.|---.    `---.,---.|--- .   .,---.  --
--      ||   ||   |        ||---'|    |   ||   |  --
--  `---'`---'`---'    `---'`---'`---'`---'|---'  --
--                                         |      --
--                                                --
--================================================--
-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    send_command('wait 2;input /lockstyleset 152')
    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.phalanxset = M(false,true)
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    blue_magic_maps = {}
    
    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.
    
    -- Physical Spells --
    
    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{
        'Bilgestorm'
    }

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{
        'Heavy Strike',
    }

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{
        'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Sinker Drill','Spinal Cleave',
        'Uppercut','Vertical Cleave'
    }
        
    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{
        'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
        'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
        'Vanity Dive'
    }
        
    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{
        'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'
    }
        
    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{
        'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'
    }

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{
        'Mandibular Bite','Queasyshroom'
    }

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{
        'Ram Charge','Screwdriver','Tourbillion'
    }

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{
        'Bludgeon'
    }

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{
        'Final Sting'
    }

    -- Magical Spells --

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{
        'Acrid Stream','Magic Hammer','Mind Blast'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{
        'Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{
        'Thermal Pulse'    
    }

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{
        'Charged Whisker','Gates of Hades'
    }
            
    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{
        '1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
        'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
        'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
        'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
        'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
        'Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast','Stinking Gas',
        'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'
    }
        
    -- Breath-based spells
    blue_magic_maps.Breath = S{
        'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
        'Hecatomb Wave','Magnetite Cloud','Poison Breath','Self-Destruct',
        'Thunder Breath','Vapor Spray','Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S{
        'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'
    }
        
    -- Healing spells
    blue_magic_maps.Healing = S{
        'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'Wild Carrot'
    }
    
    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{
        'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
        'Pyric Bulwark','Reactor Cool','Occultation'
    }

    -- Other general buffs
    blue_magic_maps.Buff = S{
        'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
        'Memento Mori','Nat. Meditation','Orcish Counterstance','Refueling',
        'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
        'Zephyr Mantle'
    }
    
    
    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{
        'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Polar Roar',
        'Pyric Bulwark','Thunderbolt','Tourbillion','Uproot','Cruel Joke',
    }
    -- Mote has capitalization errors in the default Absorb mappings, so we use our own
    absorbs = S{'Absorb-STR', 'Absorb-DEX', 'Absorb-VIT', 'Absorb-AGI', 'Absorb-INT', 'Absorb-MND', 'Absorb-CHR', 'Absorb-Attri', 'Absorb-MaxAcc', 'Absorb-TP'}
    state.Storms =  M{['description']='storms', 'Sandstorm', 'Aurorastorm', 'Voidstorm', 'Firestorm', 'Rainstorm', 'Windstorm', 'Hailstorm', 'Thunderstorm'}
    storms = S{"Aurorastorm", "Voidstorm", "Firestorm", "Sandstorm", "Rainstorm", "Windstorm", "Hailstorm", "Thunderstorm"}
    
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
    "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring", "Cumulus Masque +1",
    "Reraise Earring", "Reraise Gorget", "Airmid's Gorget","Wh. Rarab Cap +1",}
    elemental_ws = S{'Flash Nova', 'Sanguine Blade','Seraph Blade','Burning Blade','Red Lotus Blade',
     'Shining Strike', 'Shining Blade'}
    clubList = S{'Maxentius','Bunzi\'s Rod', 'Warp Cudgel'}
    swordList = S{'Naegling', 'Iris'}

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

--====================================================--
--	                                                  --
--	.   .                   ,---.     |               --
--	|   |,---.,---.,---.    `---.,---.|--- .   .,---. --
--	|   |`---.|---'|            ||---'|    |   ||   | --
--	`---'`---'`---'`        `---'`---'`---'`---'|---' --
--	                                            |     --
--                                                    --
--====================================================--

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'STP', 'SubtleBlow', 'CRIT', 'Refresh', 'Learning')
    state.HybridMode:options('Normal', 'DT', 'STR')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC')
    state.CastingMode:options('Normal', 'SIRD', 'ConserveMP', 'Duration', 'DT')
    state.IdleMode:options('Normal', 'PDT','MDT', 'Evasion','Regen', 'HP', 'EnemyCritRate', 'Enmity', 'Learning')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'Enmity')
    state.MagicalDefenseMode:options('MDT')
    state.HippoMode = M(false, "hippoMode")

    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'Naegling', 'Naegling2', 'Maxentius', 'Nuking', 'Learn'}

    send_command('lua l azureSets')
    -- Additional local binds
    send_command('bind f7 input //Sublimator')
    send_command('bind f3 gs c cycle Storms')
    send_command('bind f2 input //gs c Storms')
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind f6 gs c cycle WeaponSet')
    send_command('bind !f6 gs c cycleback WeaponSet')
    send_command('bind f1 gs c cycle HippoMode')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind f5 gs c cycle WeaponskillMode')
    send_command('alias lamp input /targetnpc;wait .1; input //tradenpc 1 "Smoldering Lamp";wait 1.4;setkey numpadenter down;wait 0.1;setkey numpadenter up;wait .1;setkey up down;wait .1;setkey up up;wait .1;setkey numpadenter down;wait 0.1;setkey numpadenter up;wait .1;setkey right down;wait .4;setkey right up;wait .1;setkey numpadenter down;wait .1;setkey numpadenter up;')  --//lamp
    send_command('alias glowing input /targetnpc;wait .1; input //tradenpc 1 "Glowing Lamp";wait 1.8;setkey up down;wait .1;setkey up up;wait .1;setkey numpadenter down;wait 0.1;setkey numpadenter up;') -- //glowing 
    send_command('wait 6;input /lockstyleset 152')
    send_command('bind f4 input //fillmode')
    send_command('bind ^/ gs disable all')
    send_command('bind !/ gs enable all')
    send_command('bind ^p gs c toggle phalanxset')

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
    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
    if init_job_states then init_job_states({"WeaponLock","MagicBurst","HippoMode"},{"IdleMode","OffenseMode","WeaponskillMode","CastingMode","WeaponSet","TreasureMode"}) 
    end
        
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
end

organizer_items = {
    "Airmid's Gorget",
    "Prime Sword",
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
    "Emporox's Ring",
    "Red Curry Bun",
    "Instant Reraise",
    "Black Curry Bun",
    "Rolan. Daifuku",}
    
-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +2", feet="Hashi. Basmak +2"}
    sets.buff['Chain Affinity'] = {head="Mavi Kavuk +2", feet="Assimilator's Charuqs"}
    sets.buff.Convergence = {head="Luh. Keffiyeh +3"}
    sets.buff.Diffusion = {feet="Luhlaza Charuqs +3"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah"}
    sets.buff.Efflux = {legs="Hashishin Tayt +3",}

    ---- WeaponSet ----

    sets.Normal = {}
    sets.Naegling = {main="Naegling", sub="Thibron"}
    sets.Naegling2 = {main="Naegling", sub="Zantetsuken"}
    sets.Maxentius = {main="Maxentius", sub="Thibron"}
    sets.Nuking = {main="Maxentius", sub="Bunzi's Rod"}
    sets.Learn = {main="Iris", sub="Iris",}


--==================================================--
--  ____                                       _    --
-- |  _ \   _ __    ___    ___    __ _   ___  | |_  --
-- | |_) | | '__|  / _ \  / __|  / _` | / __| | __| --
-- |  __/  | |    |  __/ | (__  | (_| | \__ \ | |_  --
-- |_|     |_|     \___|  \___|  \__,_| |___/  \__| --
--                                                  --
--==================================================--
    -- Precast Sets
    sets.Enmity = {
        ammo="Sapience Orb", --2
        head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Kurys Gloves", --9
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet="Ahosi Leggings", --7
        neck="Unmoving Collar +1", --10
        ear1="Cryptic Earring", --4
        ear2="Trux Earring", --5
		left2="Eihwaz Ring",
        right2="Vengeful Ring",
        back="Reiki Cloak",
        }
    sets.precast.JA['Sublimation'] = {
    }
    sets.precast.JA['Provoke'] = sets.Enmity
    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = {hands="Mirage Bazubands +2"}
    
    sets.precast.RA = {ammo=empty,
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    }

    -- Waltz set (chr and vit)
sets.precast.Waltz = {   body="Passion Jacket", 
    waist="Gishdubar Sash",
    right_ear="Mendi. Earring",
    legs="Dashing Subligar",
}
          
sets.precast.FC = {      
        ammo="Sapience Orb",
        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
        body="Pinga Tunic +1",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs="Pinga Pants +1",
        feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
        neck="Orunmila's Torque",
        waist="Witful Belt",
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}
        
sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {
    body="Hashishin Mintan +2",
    hands="Hashi. Bazu. +2",
})
sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
sets.precast.FC.Cure = set_combine(sets.precast.FC, { ear1="Mendi. Earring"})


sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
    waist="Rumination Sash",
})

    -- Don't need any special gear for Healing Waltz.
sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells


    --===============================================================================--		
-- __        __                                               _      _   _   _   --
-- \ \      / /   ___    __ _   _ __     ___    _ __    ___  | | __ (_) | | | |  --
--  \ \ /\ / /   / _ \  / _` | | '_ \   / _ \  | '_ \  / __| | |/ / | | | | | |  --
--   \ V  V /   |  __/ | (_| | | |_) | | (_) | | | | | \__ \ |   <  | | | | | |  --
--    \_/\_/     \___|  \__,_| | .__/   \___/  |_| |_| |___/ |_|\_\ |_| |_| |_|  --
--                             |_|                                               --
--                                                                               --
--===============================================================================--

sets.precast.WS = {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Cornelia's Ring",
    right_ring="Ilabrat Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
    
sets.precast.WS.PDL = set_combine(sets.precast.WS, {
    ammo="Crepuscular Pebble",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
})
    
-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
    ammo="Coiste Bodhar",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
neck="Fotia Gorget",
waist="Fotia Belt",
right_ear="Brutal Earring",
left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
right_ring="Rufescent Ring",
back="Annealed Mantle",
})
sets.precast.WS['Requiescat'].PDL = set_combine(sets.precast.WS, {
    ammo="Crepuscular Pebble",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
})

sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Ishvara Earring",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Cornelia's Ring",
    right_ring="Ilabrat Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
    ammo="Crepuscular Pebble",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    left_ring="Sroda Ring", 
})
    
sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Gleti's Cuirass",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Fotia Belt",
    left_ear="Mache Earring +1",
    right_ear="Odr Earring",
    left_ring="Ilabrat Ring",
    right_ring="Epona's Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
})
    --sets.precast.WS['Chant du Cygn'].PDL = set_combine(sets.precast.WS['Chant du Cygn'], {
    --ammo="Crepuscular Pebble",
    --body="Gleti's Cuirass",
    --hands="Gleti's Gauntlets",
    --legs="Gleti's Breeches",
    --feet="Gleti's Boots",
    --left_ring="Sroda Ring", 
--})
sets.precast.WS['Chant du Cygne'].SC = set_combine(sets.precast.WS['Chant du Cygne'], {
    ammo="Crepuscular Pebble",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    left_ring="Sroda Ring", 
})
    
sets.precast.WS['Expiacion'] = {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Hashi. Earring +1",
    left_ring="Epaminondas's Ring",
    right_ring="Cornelia's Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.precast.WS['Expiacion'].PDL = set_combine(sets.precast.WS['Expiacion'], {
    ammo="Crepuscular Pebble",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    left_ring="Sroda Ring", 
    right_ear="Ishvara Earring",
})


--[[Club Weaponskill]]


sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
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
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Cornelia's Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})
sets.precast.WS['Black Halo'].PDL = set_combine(sets.precast.WS['Black Halo'], {
        ammo="Crepuscular Pebble",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
})

sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
sets.precast.WS['Vorpal Blade'].PDL = sets.precast.WS['Chant du Cygne'].PDL
sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
sets.precast.WS['Realmrazer'].PDL = sets.precast.WS['Requiescat'].PDL

sets.precast.WS['Shattersoul'] = {
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear="Ishvara Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    left_ring="Rufescent Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}

-- Elemental Weapon Skill --elemental_ws--

-- SANGUINE BLADE
-- 50% MND / 50% STR Darkness Elemental
sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
    ammo="Pemphredo Tathlum",
    head="Pixie Hairpin +1",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring",
    right_ring="Archon Ring",
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
})

sets.precast.WS["Dark Harvest"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Shadow of Death"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Infernal Scythe"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Steal"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS["Energy Drain"] = set_combine(sets.precast.WS["Sanguine Blade"], {})
sets.precast.WS.Cataclysm = sets.precast.WS["Sanguine Blade"]

sets.precast.WS["Burning Blade"] = set_combine(sets.precast.WS, {
    ammo="Pemphredo Tathlum",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Cornelia's Ring",
    right_ring="Freke Ring",
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
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


-- Midcast Sets
	
--==================================================--
--   __  __   _       _                        _    --
--  |  \/  | (_)     | |                      | |   --
--  | \  / |  _    __| |   ___    __ _   ___  | |_  --
--  | |\/| | | |  / _` |  / __|  / _` | / __| | __| --
--  | |  | | | | | (_| | | (__  | (_| | \__ \ | |_  --
--  |_|  |_| |_|  \__,_|  \___|  \__,_| |___/  \__| --
--                                                  --
--==================================================--


sets.midcast.FastRecast = sets.SIRD 
sets.midcast.Utsusemi = sets.SIRD

sets.midcast.RA = {			range="Trollbane",
head="Malignance Chapeau",
body="Nisroch Jerkin",
hands="Malignance Gloves",
legs="Malignance Tights",
feet="Malignance Boots",
}
sets.midcast['Blue Magic'] = {  
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Cornflower Cape",
}
sets.midcast['Blue Magic'].SIRD = set_combine(sets.midcast['Blue Magic'], {  
    ammo="Staunch Tathlum +1",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Assim. Shalwar +2",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Halasz Earring",
    right_ring="Evanescence Ring",
    waist="Rumination Sash",
})
    
    -- Physical Spells --
    --[[PHYSICAL SPELLS]]

sets.midcast['Blue Magic'].Physical = {
    ammo="Aurgelmir Orb +1",
    head="Gleti's Mask",
    body="Hashishin Mintan +2",
    hands="Hashi. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck="Rep. Plat. Medal",
    waist="Prosilio Belt +1",
    left_ear="Ethereal Earring",
    right_ear="Balder Earring +1",
    left_ring="Shukuyu Ring",
    right_ring="Ilabrat Ring",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
}
sets.midcast['Blue Magic'].Physical.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Physical)

sets.midcast['Blue Magic'].PhysicalAcc = {
    head="Gleti's Mask",
    body="Hashishin Mintan +2",
    hands="Hashi. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Olseni Belt",
    right_ear="Hashi. Earring +1",
    left_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
}
sets.midcast['Blue Magic'].PhysicalAcc.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].PhysicalAcc)

sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
    {})

sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
    ear2="Mache Earring +1",
    ear1="Mache Earring +1",
    ring2="Ilabrat Ring",})

sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
    {})

sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
 ring2="Ilabrat Ring",
})

sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
    ammo="Ghastly Tathlum +1",
    ear2="Regal Earring",
    ring2="Metamor. Ring +1",
    back="Aurist's Cape +1",
    waist="Acuity Belt +1",
})

sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
   left_ring="Stikini Ring +1",
   right_ring="Stikini Ring +1",
})

sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
{    ear1="Regal Earring",
})

sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical, {
})


    -- Magical Spells --
    --[[MAGICAL SPELLS]]

sets.midcast['Blue Magic'].Magical = {
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head="Hashishin Kavuk +2",
    body="Hashishin Mintan +2",
    hands="Hashi. Bazu. +2",
    legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
    feet="Hashi. Basmak +2",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear="Regal Earring",
    left_ring="Jhakri Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
}

sets.midcast['Blue Magic'].Magical.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Magical)

sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
    head="Pixie Hairpin +1",
    ring2="Archon Ring",
})

sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
    --ring2="Weather. Ring +1"
})

sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,{
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",})

sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, { 
ear1="Regal Earring",
})

sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {
    ammo="Aurgelmir Orb +1",
})

sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, { 
ammo="Aurgelmir Orb +1",
ear2="Mache Earring +1",
ring2="Ilabrat Ring",})

sets.midcast['Blue Magic'].MagicAccuracy = {
    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},   
}

sets.midcast['Blue Magic']['Cruel Joke'] = {
    main="Naegling",
    sub="Sakpata's Sword",
    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},   
}
sets.midcast['Blue Magic'].MagicAccuracy.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].MagicAccuracy)
    -- Breath Spells --
    
sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, { 
    ammo="Mavi Tathlum",
    head="Luh. Keffiyeh +3",
})

    -- Other Types --

sets.ConserveMP = {    
    ammo="Pemphredo Tathlum",
    body="Vedic Coat",
    waist="Austerity Belt +1",
}
sets.SIRD = {
    ammo="Staunch Tathlum +1",
    sub="Culminus",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Assim. Shalwar +2",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    left_ear="Halasz Earring",
    right_ring="Evanescence Ring",
    waist="Rumination Sash",
}
sets.DT={
    ammo="Staunch Tathlum +1",
    body="Hashishin Mintan +2",
    hands="Hashi. Bazu. +2",
    legs="Hashishin Tayt +3",
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ring="Defending Ring",
}

sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {})
        
sets.midcast['Blue Magic']['White Wind'] = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Pinga Tunic +1",
    hands="Telchine Gloves",
    legs="Pinga Pants +1",
    feet="Medium's Sabots",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Eihwaz Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Moonlight Cape",
}
sets.midcast['Blue Magic']['White Wind'].SIRD = set_combine(sets.SIRD ,sets.midcast['Blue Magic'].MagicAccuracy, {})

sets.midcast['Blue Magic'].Healing = {
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body="Pinga Tunic +1",
    hands="Telchine Gloves",
    legs="Pinga Pants +1",
    feet="Medium's Sabots",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Solemnity Cape",
}
sets.midcast['Blue Magic'].Healing.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Healing)
sets.self_healing = set_combine(sets.midcast['Blue Magic'].Healing, {
    waist="Gishdubar Sash", -- (10)
})

sets.midcast['Blue Magic'].SkillBasedBuff = {
    ammo="Mavi Tathlum",
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Cornflower Cape",
}
sets.midcast['Blue Magic'].SkillBasedBuff.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].SkillBasedBuff) 


sets.midcast['Blue Magic'].Buff = {
    ammo="Mavi Tathlum",
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Cornflower Cape",
}
sets.midcast['Blue Magic'].Buff.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Buff) 
sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'].Buff, {
    hands="Hashi. Bazu. +2",
}) -- 1 shadow per 50 skill
sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'].Buff, {waist="Gishdubar Sash"})

sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
    head=empty;
    body="Cohort Cloak +1",
})
sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Regal Cuffs",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Mendi. Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
})

sets.midcast['Enhancing Magic'] = {
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Telchine Gloves",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Mendi. Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}

sets.midcast.Duration = {
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Telchine Gloves",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Mendi. Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}

sets.midcast['Enhancing Magic'].SIRD = set_combine(sets.SIRD, sets.midcast['Enhancing Magic']) 

    
sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash"})
sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {left_ear="Brachyura Earring",})
sets.midcast.Protectra = sets.midcast.Protect
sets.midcast.Shell = sets.midcast.Protect
sets.midcast.Shellra = sets.midcast.Protect

sets.midcast['Dark Magic'] = {
    neck="Erra Pendant",
    left_ear="Regal Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {
    main="Sakpata's Sword",
    ammo="Staunch Tathlum +1",
    head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
    body={ name="Herculean Vest", augments={'Phys. dmg. taken -1%','Accuracy+11 Attack+11','Phalanx +2','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+11','Pet: Phys. dmg. taken -5%','Phalanx +4',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet={ name="Herculean Boots", augments={'Accuracy+8','Pet: Attack+28 Pet: Rng.Atk.+28','Phalanx +4','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Loquac. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
})
sets.midcast.Phalanx.Duration = set_combine(sets.midcast.Duration, {})

sets.midcast.Phalanx.SIRD = set_combine(sets.SIRD, sets.midcast.Phalanx) 
    
sets.midcast.Haste = {
    ammo="Pemphredo Tathlum",
    head="Telchine Cap",
    body="Telchine Chas.",
    hands="Telchine Gloves",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Mendi. Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
sets.Learning = {
    ammo="Mavi Tathlum",
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands="Assim. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Cornflower Cape",
}
        --head="Luhlaza Keffiyeh",  
        --body="Assimilator's Jubbah",hands="Assimilator's Bazubands +1",
        --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs +3"}


sets.latent_refresh = {waist="Fucho-no-Obi",}

    -- Resting sets
sets.resting = {
        body="Shamash Robe",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
}

    
    -- Defense sets
sets.defense.PDT = {
    ammo="Staunch Tathlum +1",
    head={ name="Gleti's Mask", augments={'Path: A',}},
    body="Adamantite Armor",
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs={ name="Gleti's Breeches", augments={'Path: A',}},
    feet="Gleti's Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear="Genmei Earring",
    right_ear="Ethereal Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back="Shadow Mantle",}

sets.defense.Evasion = {
    main="Naegling",
    sub="Sakpata's Sword",
    ammo="Amar Cluster",
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
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
}

sets.defense.Enmity = {
    ammo="Iron Gobbet",        --2
    head="Halitus Helm", --8
    body="Emet Harness +1", --10
    hands="Kurys Gloves", --9
    legs={ name="Zoar Subligar +1", augments={'Path: A',}},
    feet="Ahosi Leggings", --7
    neck="Unmoving Collar +1", --10
    ear1="Cryptic Earring", --4
    ear2="Trux Earring", --5
    left_ring="Eihwaz Ring",
    right_ring="Vengeful Ring",
    back="Reiki Cloak",
}

sets.defense.MDT = { 
    ammo="Staunch Tathlum +1",
    head={ name="Gleti's Mask", augments={'Path: A',}},
    body={ name="Gleti's Cuirass", augments={'Path: A',}},
    hands={ name="Gleti's Gauntlets", augments={'Path: A',}},
    legs={ name="Gleti's Breeches", augments={'Path: A',}},
    feet={ name="Gleti's Boots", augments={'Path: A',}},
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Sanare Earring",
    left_ring="Defending Ring",
    left_ring="Shadow Ring",
    back="Moonlight Cape",
}
    
--=================================--
--      ___       _   _            --
--     |_ _|   __| | | |   ___     --
--      | |   / _` | | |  / _ \    --
--      | |  | (_| | | | |  __/    --
--     |___|  \__,_| |_|  \___|    --
--                                 --
--=================================--

-- Idle sets
sets.idle = {     
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Shamash Robe",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Moonlight Cape",
}

sets.idle.Evasion = {
    main="Naegling",
    sub="Sakpata's Sword",
    ammo="Amar Cluster",
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
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
}
sets.idle.PDT = {    
ammo="Staunch Tathlum +1",
head="Nyame Helm",
body="Adamantite Armor",
hands="Nyame Gauntlets",
legs="Nyame Flanchard",
feet="Nyame Sollerets",
neck={ name="Loricate Torque +1", augments={'Path: A',}},
waist="Flume Belt +1",
left_ear="Ethereal Earring",
right_ear="Genmei Earring",
right_ring="Defending Ring",
left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
back="Shadow Mantle",}

sets.idle.HP = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Adamantite Armor",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Plat. Mog. Belt",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Eihwaz Ring",
    back="Moonlight Cape",
}

sets.idle.EnemyCritRate = set_combine(sets.idle.PDT, { 
    ammo="Eluder's Sachet",
    left_ring="Warden's Ring",
    right_ring="Fortified Ring",
    back="Reiki Cloak",
})
sets.idle.Regen = set_combine(sets.idle, {
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.idle.MDT = set_combine(sets.defense.MDT, {})
sets.idle.Enmity = set_combine(sets.defense.Enmity, {})
sets.idle.Town = {legs="Carmine Cuisses +1",
left_ear="Infused Earring",}

sets.idle.Learning = set_combine(sets.idle, sets.Learning, { 
    main="Iris", 
    sub="Iris",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
})
    
sets.Kiting = {ammo="Staunch Tathlum +1",
legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},}
sets.Adoulin = {body="Councilor's Garb",}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    

--====================================================--
--     _____   ____      ____           _             --
--    |_   _| |  _ \    / ___|    ___  | |_   ___     --
--      | |   | |_) |   \___ \   / _ \ | __| / __|    --
--      | |   |  __/     ___) | |  __/ | |_  \__ \    --
--      |_|   |_|       |____/   \___|  \__| |___/    --
--                                                    --
--====================================================--

    -- Normal melee group
sets.engaged = {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    right_ear="Dedition Earring",
    left_ear="Telos Earring",
    left_ring="Petrov Ring",
    right_ring="Epona's Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}, 
}
sets.engaged.DPL = set_combine(sets.engaged, {
    neck="Clotharius Torque",
    right_ear="Mache Earring +1",
    waist="Windbuffet Belt +1",
})
    
sets.engaged.Acc = {
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Malignance Boots",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Olseni Belt",
    left_ear="Crep. Earring",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
}
sets.engaged.STP = set_combine(sets.engaged, {
    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    waist="Gerdr Belt",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    })

sets.engaged.CRIT = {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Thereoid Greaves",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Gerdr Belt",
    right_ear="Odr Earring",
    left_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
    
sets.engaged.SubtleBlow = set_combine(sets.engaged ,{
    right_ear="Cessance Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})

sets.engaged.Refresh = set_combine(sets.engaged, { 
        body="Shamash Robe",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
})
sets.engaged.Learning = { 
    ammo="Mavi Tathlum",
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands="Assim. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}

------------------------------------------------------------------------------------------------
    ---------------------------------------- DW ------------------------------------------
------------------------------------------------------------------------------------------------
    -- Base Dual-Wield Values:
    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%
    -- No Magic Haste (74% DW to cap)

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

sets.engaged.DW = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Suppanomimi",
    right_ear="Dedition Earring",
    left_ring="Petrov Ring",
    right_ring="Epona's Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
    }

sets.engaged.DW.Acc = set_combine(sets.engaged.Acc, {
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    left_ear="Suppanomimi",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
    
sets.engaged.DW.STP = set_combine(sets.engaged.STP, {
    left_ear="Suppanomimi",
    waist="Gerdr Belt",
})
sets.engaged.DW.DPL = set_combine(sets.engaged.DPL, {
    left_ear="Suppanomimi",
})

sets.engaged.DW.CRIT = set_combine(sets.engaged.CRIT, {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Thereoid Greaves",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Gerdr Belt",
    left_ear="Suppanomimi",
    right_ear="Odr Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back={ name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
})
sets.engaged.DW.SubtleBlow = set_combine(sets.engaged.SubtleBlow,{
    right_ear="Cessance Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})

sets.engaged.DW.Refresh =  set_combine(sets.engaged.Refresh, { 
    body="Shamash Robe",
    left_ear="Suppanomimi",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
})
    
sets.engaged.DW.Learning =  set_combine(sets.engaged.DW, sets.Learning, {
    head="Luh. Keffiyeh +3",
    body="Assim. Jubbah +3",
    hands="Assim. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet="Luhlaza Charuqs +3",
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
})
------------------------------------------------------------------------------------------------
    ---------------------------------------- DW-HASTE ------------------------------------------
------------------------------------------------------------------------------------------------

    -- 15% Magic Haste (67% DW to cap)

sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    legs="Carmine Cuisses +1", --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 28%

sets.engaged.DW.Acc.LowHaste = set_combine(sets.engaged.DW.Acc, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    legs="Carmine Cuisses +1", --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 28%

sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.STP, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    legs="Carmine Cuisses +1", --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 28%
sets.engaged.DW.CRIT.LowHaste = set_combine(sets.engaged.DW.CRIT, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    legs="Carmine Cuisses +1", --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 28%
sets.engaged.DW.Refresh.LowHaste = set_combine(sets.engaged.DW.Refresh, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    legs="Carmine Cuisses +1", --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 28%


--MID-HASTE
sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 22%

sets.engaged.DW.Acc.MidHaste = set_combine(sets.engaged.DW.Acc, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 22%

sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.STP, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 22%
sets.engaged.DW.CRIT.MidHaste = set_combine(sets.engaged.DW.CRIT, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 22%
sets.engaged.DW.Refresh.MidHaste = set_combine(sets.engaged.DW.Refresh, {
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
}) -- 22%
sets.engaged.DW.SubtleBlow.MidHaste = set_combine(sets.engaged.DW.SubtleBlow,{
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}, --6
    ear2="Eabani Earring", --5
    ear1="Suppanomimi", --4
    waist="Reiki Yotai", --7
})

--MAX-HASTE

sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW)
sets.engaged.DW.Acc.MaxHaste = set_combine(sets.engaged.DW.Acc)
sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.STP)
sets.engaged.DW.CRIT.MaxHaste = set_combine(sets.engaged.DW.CRIT)
sets.engaged.DW.Refresh.MaxHaste = set_combine(sets.engaged.DW.Refresh)
sets.engaged.DW.Learning.MaxHaste = set_combine(sets.engaged.DW.Learning)
sets.engaged.DW.SubtleBlow.MaxHaste = set_combine(sets.engaged.DW.SubtleBlow, {})


------------------------------------------------------------------------------------------------
---------------------------------------- Hybrid Sets -------------------------------------------
------------------------------------------------------------------------------------------------

sets.engaged.Hybrid = {
    head="Malignance Chapeau", --6/6
    body="Malignance Tabard", --9/9
    hands="Malignance Gloves", --5/5
    legs="Malignance Tights", --7/7
    feet="Malignance Boots", --4/4
    left_ring="Defending Ring", --10/10
    waist="Reiki Yotai",
}

sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
sets.engaged.Acc.DT = set_combine(sets.engaged.Acc, sets.engaged.Hybrid)
sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)
sets.engaged.CRIT.DT = set_combine(sets.engaged.CRIT, sets.engaged.Hybrid)
sets.engaged.Refresh.DT = set_combine(sets.engaged.Refresh, sets.engaged.Hybrid)
sets.engaged.SubtleBlow.DT = set_combine(sets.engaged.SubtleBlow ,sets.engaged.Hybrid,{
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.engaged.Learning.DT = set_combine(sets.engaged.Learning, sets.engaged.Hybrid, {
    ammo="Staunch Tathlum +1",
    head={ name="Luh. Keffiyeh +3", augments={'Enhances "Convergence" effect',}},
    body="Assim. Jubbah +3",
    hands="Assim. Bazu. +2",
    legs="Hashishin Tayt +3",
    feet={ name="Luhlaza Charuqs +3", augments={'Enhances "Diffusion" effect',}},
    neck={ name="Mirage Stole +2", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Genmei Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
})

sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT = set_combine(sets.engaged.DW.Acc, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT = set_combine(sets.engaged.DW.CRIT, sets.engaged.Hybrid)
sets.engaged.DW.Refresh.DT = set_combine(sets.engaged.DW.Refresh, sets.engaged.Hybrid)
sets.engaged.DW.Learning.DT = set_combine(sets.engaged.DW.Learning, sets.engaged.Learning.DT, {})
sets.engaged.DW.SubtleBlow.DT = set_combine(sets.engaged.DW.SubtleBlow ,sets.engaged.Hybrid,{
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.LowHaste = set_combine(sets.engaged.DW.Acc.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.LowHaste = set_combine(sets.engaged.DW.CRIT.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Refresh.DT.LowHaste = set_combine(sets.engaged.DW.Refresh.LowHaste, sets.engaged.Hybrid)
sets.engaged.DW.Learning.DT.LowHaste = set_combine(sets.engaged.DW.Learning.LowHaste, sets.engaged.Learning.DT, {})
sets.engaged.DW.SubtleBlow.DT.LowHaste = set_combine(sets.engaged.DW.SubtleBlow.LowHaste ,sets.engaged.Hybrid,{
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.MidHaste = set_combine(sets.engaged.DW.Acc.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.MidHaste = set_combine(sets.engaged.DW.CRIT.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Refresh.DT.MidHaste = set_combine(sets.engaged.DW.Refresh.MidHaste, sets.engaged.Hybrid)
sets.engaged.DW.Learning.DT.MidHaste = set_combine(sets.engaged.DW.Learning.MidHaste, sets.engaged.Learning.DT, {})
sets.engaged.DW.SubtleBlow.DT.MidHaste = set_combine(sets.engaged.DW.SubtleBlow.MidHaste ,sets.engaged.Hybrid,{
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Acc.DT.MaxHaste = set_combine(sets.engaged.DW.Acc.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.CRIT.DT.MaxHaste = set_combine(sets.engaged.DW.CRIT.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Refresh.DT.MaxHaste = set_combine(sets.engaged.DW.Refresh.MaxHaste, sets.engaged.Hybrid)
sets.engaged.DW.Learning.DT.MaxHaste = set_combine(sets.engaged.DW.Learning.MaxHaste, sets.engaged.Hybrid, {})
sets.engaged.DW.SubtleBlow.DT.MaxHaste = set_combine(sets.engaged.DW.SubtleBlow.MaxHaste ,sets.engaged.Hybrid,{
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
})
------------------------------------------------------------------------------------------------
---------------------------------------- Special Sets ------------------------------------------
------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------	
---- _____    ____    _   _   _____    _____   _______   _____    ____    _   _              _      ----
--  / ____|  / __ \  | \ | | |  __ \  |_   _| |__   __| |_   _|  / __ \  | \ | |     /\     | |       --
-- | |      | |  | | |  \| | | |  | |   | |      | |      | |   | |  | | |  \| |    /  \    | |       --
-- | |      | |  | | | . ` | | |  | |   | |      | |      | |   | |  | | | . ` |   / /\ \   | |       --
-- | |____  | |__| | | |\  | | |__| |  _| |_     | |     _| |_  | |__| | | |\  |  / ____ \  | |____   --
--  \_____|  \____/  |_| \_| |_____/  |_____|    |_|    |_____|  \____/  |_| \_| /_/    \_\ |______|  --
----																								----
--------------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt"}

    sets.buff.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",        --(6)
    legs="Nyame Flanchard", --10
    feet="Hashi. Basmak +2",--15
    neck="Warder's Charm +1", --10
    --ear1="Static Earring",--5
    ring1="Mujin Band", --(5)
    ring2="Jhakri Ring", --5
    --back="Seshaw Cape", --5
})


end

--======================================================================--
--    __  __                                                     _      --
--   |  \/  |   ___   __   __   ___   _ __ ___     ___   _ __   | |_    --
--   | |\/| |  / _ \  \ \ / /  / _ \ | '_ ` _ \   / _ \ | '_ \  | __|   --
--   | |  | | | (_) |  \ V /  |  __/ | | | | | | |  __/ | | | | | |_    --
--   |_|  |_|  \___/    \_/    \___| |_| |_| |_|  \___| |_| |_|  \__|   --
--                                                                      --
--======================================================================--


--=================================================================--
--  _____                          _     _                         --
-- |  ___|  _   _   _ __     ___  | |_  (_)   ___    _ __    ___   --
-- | |_    | | | | | '_ \   / __| | __| | |  / _ \  | '_ \  / __|  --
-- |  _|   | |_| | | | | | | (__  | |_  | | | (_) | | | | | \__ \  --
-- |_|      \__,_| |_| |_|  \___|  \__| |_|  \___/  |_| |_| |___/  --
--                                                                 --
--=================================================================--



-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
    end
    if spell.english == 'Searing Tempest' or spell.english == 'Spectral Floe' 
	or spell.english == 'Anvil Lightning' or spell.english == 'Scouring Spate' 
    or spell.english == 'Nectarous Deluge' or spell.english == 'Rending Deluge' 
	or spell.english == 'Droning Whirlwind' or spell.english == 'Gates of Hades' 
	or spell.english == 'Thunderbolt' or spell.english == 'Rail Cannon' or spell.english == 'Atra. Libations' 
	or spell.english == 'Entomb' or spell.english == 'Tenebral Crush' 
	or spell.english == 'Palling Salvo' or spell.english == 'Blinding Fulgor' then

        local allRecasts = windower.ffxi.get_ability_recasts()
        local Burst_AffinityCooldown = allRecasts[182]
        
        
        if player.main_job_level >= 25 and Burst_AffinityCooldown < 3 then
            cast_delay(1.1)
            send_command('@input /ja "Burst Affinity" <me>')
        end
        if not midaction() then
            job_update()
        end
    end
end
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if (spell.target.model_size + spell.range * range_mult[spell.range]) < spell.target.distance then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
            return
        end
    end
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
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
    if spell.english == 'Warcry' then
        if buffactive['Warcry'] then
            cancel_spell()
            add_to_chat(123, spell.name..' Canceled: Warcry its up [active]')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
		if player.tp == 3000 then  -- Replace Moonshade Earring if we're at cap TP
            equip({left_ear="Ishvara Earring"})
		end
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
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.self_healing)
        elseif state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        elseif state.CastingMode.value == 'ConserveMP' then
            equip(sets.ConserveMP)
        elseif state.CastingMode.value == 'DT' then
            equip(sets.DT)
        end
        if spellMap == 'Magical' then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
    if state.CastingMode.value == 'SIRD' then
        equip(sets.SIRD)
    elseif state.CastingMode.value == 'ConserveMP' then
        equip(sets.ConserveMP)
    elseif state.CastingMode.value == 'DT' then
        equip(sets.DT)
    end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        if state.CastingMode.value == 'Duration' then
            equip(sets.midcast.Duration)
        elseif state.CastingMode.value == 'SIRD' then
            equip(sets.SIRD)
        elseif state.CastingMode.value == 'ConserveMP' then
            equip(sets.ConserveMP)
        elseif state.CastingMode.value == 'DT' then
            equip(sets.DT)
        else
        equip(sets.midcast['Enhancing Magic'])
        end
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        elseif spellMap == 'Aquaveil' then
            equip(sets.midcast.Aquaveil)
        elseif spellMap == 'Phalanx' then
            equip(sets.midcast.Phalanx)
        elseif spellMap == 'Haste' then
            equip(sets.midcast.Haste)
        end
    end


    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    --[[if state.CastingMode.value == 'Learning' then
        equip(sets.Learning)
    end]]
    if state.Buff['Burst Affinity'] or (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
        equip(sets.magic_burst)
        end
    end
end
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
        end
    end
    if player.status ~= 'Engaged' and state.WeaponLock.value == false then
        check_weaponset()
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end
    if buff == "phalanx" or "Phalanx II" then
        if gain then
            state.phalanxset:set(false)
        end
    end
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('input /p Doomed, please Cursna.')
            send_command('input /item "Holy Water" <me>')	
             disable('ring1','ring2','waist','neck')
        else
            enable('ring1','ring2','waist','neck')
            send_command('input /p Doom removed.')
            handle_equipping_gear(player.status)
        end
    end
    if buff == "petrification" then
        if gain then    
            equip(sets.defense.PDT)
            send_command('input /p Petrification, please Stona.')		
        else
            send_command('input /p '..player.name..' is no longer Petrify !')
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
    if buff == "Charm" then
        if gain then  			
           send_command('input /p Charmd, please Sleep me.')		
        else	
           send_command('input /p '..player.name..' is no longer Charmed, please wake me up!')
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
    if buff == "poison" then
        if gain then  
        send_command('input /item "remedy" <me>')
        end
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

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    check_moving()
    determine_haste_group()
    if state.HippoMode.value == true then 
        equip({feet="Hippo. Socks +1"})
    end
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
    if swordList:contains(player.equipment.main) then
        send_command('input /lockstyleset 152')
    elseif clubList:contains(player.equipment.main) then
        send_command('input /lockstyleset 149')
    end
    if state.phalanxset .value == true then
        --equip(sets.midcast.Phalanx)
        send_command('gs equip sets.midcast.Phalanx')
        send_command('input /p Phalanx set equiped [ON] PLZ GIVE ME PHALANX')		
    else 
        state.phalanxset:reset()
    end
    if update_job_states then update_job_states() 
    end

    check_weaponset()
end
function check_weaponset()
    equip(sets[state.WeaponSet.current])
    if player.sub_job ~= 'NIN' and player.sub_job ~= 'DNC' then
       equip(sets.DefaultShield)
    end
end
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    check_weaponset()

    return meleeSet
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.HippoMode.value == true then 
        idleSet = set_combine(idleSet, {feet="Hippo. Socks +1"})
    end
    --[[if state.IdleMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.idle.PDT)
    end
    if state.IdleMode.current == 'Learning' then
        idleSet = set_combine(idleSet, sets.idle.Learning)
    end]]
    if world.area:contains("Adoulin") then
        idleSet = set_combine(idleSet, {body="Councilor's Garb"})
    end
    --if player.mpp < 51 then
        --set_combine(idleSet, sets.latent_refresh)
    --end
    if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    check_moving()

end

function display_current_job_state(eventArgs)
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

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'storms' then
        send_command('@input /ma "'..state.Storms.value..'" <stpc>')
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

function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 152')
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

windower.register_event('zone change',
    function()
        --add that at the end of zone change
        if update_job_states then update_job_states() end
    end
)

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

--=-----------------------------=--
--          __   __   __   __    --
--    /|/| /  | /    /  | /  |   --
--   ( / |(___|(    (___|(   |   --
--   |   )|   )|   )|\   |   )   --
--   |  / |  / |__/ | \  |__/    --
--=-----------------------------=--


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(6, 40)
    if player.sub_job == 'DNC' then
        set_macro_page(6, 40)
    elseif player.sub_job == "SCH" then
        set_macro_page(8, 40)
    else
        set_macro_page(6, 40)
    end
end


