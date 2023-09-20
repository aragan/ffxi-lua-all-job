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

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    send_command('wait 6;input /lockstyleset 152')
    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')
    sub_job_change()
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
    blue_magic_maps.Magical = S{
        'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray',
        'Diffusion Ray','Droning Whirlwind','Embalming Earth','Firespit','Foul Waters',
        'Ice Break','Leafstorm','Maelstrom','Rail Cannon','Regurgitation','Rending Deluge',
        'Retinal Glare','Subduction','Tem. Upheaval','Water Bomb'
    }

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{
        'Acrid Stream','Evryone. Grudge','Magic Hammer','Mind Blast'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{
        'Eyes On Me','Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{
        'Tenebral Crush'
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
        'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
        'Thunder Breath','Vapor Spray','Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S{
        'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'
    }
        
    -- Healing spells
    blue_magic_maps.Healing = S{
        'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral','White Wind',
        'Wild Carrot'
    }
    
    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{
        'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
        'Pyric Bulwark','Reactor Cool',
    }

    -- Other general buffs
    blue_magic_maps.Buff = S{
        'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
        'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
        'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
        'Zephyr Mantle'
    }
    
    
    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{
        'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Polar Roar',
        'Pyric Bulwark','Thunderbolt','Tourbillion','Uproot','Cruel Joke',
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'AccMAX', 'PD', 'CRIT', 'Refresh', 'Learning')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC')
    state.CastingMode:options('Normal', 'SIRD')
    state.IdleMode:options('Normal', 'PDT', 'Learning')
    state.PhysicalDefenseMode:options('PDT', 'enmity')
    state.MagicalDefenseMode:options('MDT')


    send_command('lua l azureSets')
    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')
    send_command('bind !w gs c toggle WeaponLock')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('alias lamp input /targetnpc;wait .1; input //tradenpc 1 "Smouldering Lamp";wait 1.4;setkey numpadenter down;wait 0.1;setkey numpadenter up;wait .1;setkey up down;wait .1;setkey up up;wait .1;setkey numpadenter down;wait 0.1;setkey numpadenter up;wait .1;setkey right down;wait .6;setkey right up;wait .1;setkey numpadenter down;wait .1;setkey numpadenter up;')
    send_command('alias glowing input /targetnpc;wait .1; input //tradenpc 1 "Glowing Lamp";wait 1.8;setkey up down;wait .1;setkey up up;wait .1;setkey numpadenter down;wait 0.1;setkey numpadenter up;')
    update_combat_form()
    select_default_macro_book()
    send_command('wait 2;input /lockstyleset 152')
    send_command('bind f4 input //fillmode')

end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
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
-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.buff['Burst Affinity'] = {feet="Mavi Basmak +2"}
    sets.buff['Chain Affinity'] = {head="Mavi Kavuk +2", feet="Assimilator's Charuqs"}
    sets.buff.Convergence = {head="Luhlaza Keffiyeh"}
    sets.buff.Diffusion = {feet="Luhlaza Charuqs"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah"}
    sets.buff.Efflux = {legs="Hashishin Tayt +1",}

    
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
        waist="Embla Sash",
    }
    sets.precast.JA['Provoke'] = sets.Enmity
    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = {hands="Mirage Bazubands +2"}
    sets.precast.RA = {
        range="Trollbane",
        head="Malignance Chapeau",
        body="Nisroch Jerkin",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        }

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {   body="Passion Jacket", 
    waist="Gishdubar Sash",
    right_ear="Mendi. Earring",
    right_ring="Stikini Ring +1",
    back="Solemnity Cape",}
          
    sets.precast.FC = {      
        ammo="Sapience Orb",
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        body="Pinga Tunic",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
        feet="Jhakri Pigaches +2",
        right_ear="Loquac. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
}
        
sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear1="Mendi. Earring"})

sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear1="Mendi. Earring"})


sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
    ammo="Impatiens",
    ring1="Lebeche Ring",
    waist="Rumination Sash",
    })

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.WS = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Ishvara Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Cornelia's Ring",
        right_ring="Ilabrat Ring",
        back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
        }
    
        sets.precast.WS.PDL = set_combine(sets.precast.WS, {
            ammo="Crepuscular Pebble",
            body="Gleti's Cuirass",
            hands="Gleti's Gauntlets",
            legs="Gleti's Breeches",
            left_ring="Sroda Ring", 
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
        left_ear="Brutal Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Rufescent Ring",
        back="Bleating Mantle",
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
            neck="Fotia Gorget",
            waist={ name="Sailfi Belt +1", augments={'Path: A',}},
            left_ear="Ishvara Earring",
            right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            left_ring="Cornelia's Ring",
            right_ring="Ilabrat Ring",
            back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
        })
        sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], {
            ammo="Crepuscular Pebble",
            body="Gleti's Cuirass",
            hands="Gleti's Gauntlets",
            left_ring="Sroda Ring", 
        })
    
        sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS, {
        
            ammo="Pemphredo Tathlum",
            head="Pixie Hairpin +1",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Sibyl Scarf",
            waist="Orpheus's Sash",
            left_ear="Friomisi Earring",
            right_ear="Hecate's Earring",
            left_ring="Cornelia's Ring",
            right_ring="Archon Ring",
            back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
                })
    
        sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Gleti's Cuirass",
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Mache Earring +1",
        right_ear="Odr Earring",
        left_ring="Ilabrat Ring",
        right_ring="Epona's Ring",
        back="Annealed Mantle",
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
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Hashi. Earring +1",
        left_ring="Epaminondas's Ring",
        right_ring="Cornelia's Ring",
        back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
    }
    sets.precast.WS['Expiacion'].PDL = set_combine(sets.precast.WS['Expiacion'], {
        ammo="Crepuscular Pebble",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        left_ring="Sroda Ring", 
        right_ear="Ishvara Earring",
    })

    sets.precast.WS['Aeolian Edge'] = {    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    ear1="Moonshade Earring",
    ear2="Friomisi Earring",
    ring1={ name="Metamor. Ring +1", augments={'Path: A',}},
    ring2="Cornelia's Ring",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
}
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Malignance Earring",
        left_ring="Freke Ring",
        right_ring="Cornelia's Ring",
        back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
        })

            sets.precast.WS['Myrkr'] = {
            ammo="Pemphredo Tathlum",
            head="Nyame Helm",
            body="Nyame Mail",
            hands="Nyame Gauntlets",
            legs="Nyame Flanchard",
            feet="Nyame Sollerets",
            neck="Baetyl Pendant",
            waist="Orpheus's Sash",
            left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
            right_ear="Friomisi Earring",
            left_ring="Cornelia's Ring",
            right_ring="Freke Ring",
            back={ name="Aurist's Cape +1", augments={'Path: A',}},
            }
        sets.precast.WS['Cataclysm'] = {
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
            }
        
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
        back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
        })
    sets.precast.WS['Black Halo'].PDL = set_combine(sets.precast.WS['Black Halo'], {
            ammo="Crepuscular Pebble",
            body="Gleti's Cuirass",
            hands="Gleti's Gauntlets",
            legs="Gleti's Breeches",
            left_ring="Sroda Ring", 
        })

    sets.precast.WS['Starburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Sunburst'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Earth Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Rock Crusher'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Seraph Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Shining Strike'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Seraph Blade'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Red Lotus Blade'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Burning Blade'] = sets.precast.WS['Myrkr']
    sets.precast.WS['Shining Blade'] = sets.precast.WS['Myrkr']
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
        back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
        }
    
    
    -- Midcast Sets
    sets.SIRD = {
        ammo="Staunch Tathlum +1",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        left_ear="Halasz Earring",
        right_ring="Evanescence Ring",
    }
    sets.midcast.FastRecast = sets.SIRD 

    sets.midcast.RA = {			range="Trollbane",
    head="Malignance Chapeau",
    body="Nisroch Jerkin",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    }
    sets.midcast['Blue Magic'] = {  
        ammo="Pemphredo Tathlum",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
        feet="Jhakri Pigaches +2",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Hecate's Earring",
        left_ring="Jhakri Ring",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
}
sets.midcast['Blue Magic'].SIRD = {  
    ammo="Pemphredo Tathlum",
    head="Jhakri Coronal +2",
    body="Jhakri Robe +2",
    hands="Jhakri Cuffs +2",
    legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
    feet="Jhakri Pigaches +2",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Jhakri Ring",
    right_ring="Stikini Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
}
    
    -- Physical Spells --
    
    sets.midcast['Blue Magic'].Physical = {
        ammo="Aurgelmir Orb +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Caro Necklace",
        waist="Prosilio Belt +1",
        left_ear="Ethereal Earring",
        right_ear="Balder Earring +1",
        left_ring="Shukuyu Ring",
        right_ring="Ilabrat Ring",
        back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+1','Weapon skill damage +10%',}},
        }
    sets.midcast['Blue Magic'].Physical.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Physical)

    sets.midcast['Blue Magic'].PhysicalAcc = {
        ammo="Inlamvuyeso",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Mirage Stole +2",
        waist="Olseni Belt",
        left_ear="Odr Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }
    sets.midcast['Blue Magic'].PhysicalAcc.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].PhysicalAcc)

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
        {})

    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)


    -- Magical Spells --
    
    sets.midcast['Blue Magic'].Magical = {
    ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
    head=empty,
    body={ name="Cohort Cloak +1", augments={'Path: A',}},
    hands="Jhakri Cuffs +2",
    legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
    feet="Hashi. Basmak +2",
    neck="Sibyl Scarf",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Jhakri Ring",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},
}

    sets.midcast['Blue Magic'].Magical.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Magical)
    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
        {})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Jhakri Cuffs +2",
        legs={ name="Luhlaza Shalwar +3", augments={'Enhances "Assimilation" effect',}},
        feet="Hashi. Basmak +2",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ear="Friomisi Earring",
        right_ear="Hecate's Earring",
        left_ring="Jhakri Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Evasion+10','"Mag.Atk.Bns."+10','Evasion+15',}},  
    })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicAccuracy = {
        main="Naegling",
        sub="Sakpata's Sword",
        ammo="Pemphredo Tathlum",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Mirage Stole +2",
        waist="Luminary Sash",
        left_ear="Crep. Earring",
        right_ear="Digni. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},    }

        sets.midcast['Blue Magic'].MagicAccuracy.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].MagicAccuracy)
    -- Breath Spells --
    
    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, { 
        ammo="Mavi Tathlum",
    })

    

    -- Other Types --
    
    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        { })
        
    sets.midcast['Blue Magic']['White Wind'] = {
        main={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        sub={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        neck="Mirage Stole +2",
        legs="Hashishin Tayt +1",
        waist="Gishdubar Sash",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    back="Solemnity Cape",
}

    sets.midcast['Blue Magic'].Healing = {
        main={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        sub={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        neck="Mirage Stole +2",
        legs="Hashishin Tayt +1",
            waist="Gishdubar Sash",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    back="Solemnity Cape",
}
sets.midcast['Blue Magic'].Healing.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Healing)

    sets.midcast['Blue Magic'].SkillBasedBuff = {
        ammo="Mavi Tathlum",
        ain={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        sub={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        neck="Mirage Stole +2",
        legs="Hashishin Tayt +1",
    waist="Cascade Belt",
    left_ear="Andoaa Earring",
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
}
sets.midcast['Blue Magic'].SkillBasedBuff.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].SkillBasedBuff) 


    sets.midcast['Blue Magic'].Buff = {
        ammo="Mavi Tathlum",
        ain={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        sub={ name="Iris", augments={'Blue Magic skill +15','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        neck="Mirage Stole +2",
        legs="Hashishin Tayt +1",
    waist="Cascade Belt",
    left_ear="Andoaa Earring",
    right_ear="Hashi. Earring +1", 
    left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    }
    sets.midcast['Blue Magic'].Buff.SIRD = set_combine(sets.SIRD, sets.midcast['Blue Magic'].Buff) 

  
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Protectra = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    sets.midcast.Shellra = {ring1="Sheltered Ring"}
    
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
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},}

        sets.midcast['Enhancing Magic'].SIRD = {
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
    

    sets.midcast.phalanx = {
        sub="Sakpata's Sword",
        ammo="Sapience Orb",
        head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
        body="Pinga Tunic",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        feet="Jhakri Pigaches +2",
        neck="Incanter's Torque",
        waist="Olympus Sash",
        left_ear="Andoaa Earring",
        right_ear="Loquac. Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}

sets.midcast.phalanx.SIRD = {
    sub="Sakpata's Sword",
    ammo="Sapience Orb",
    head={ name="Carmine Mask", augments={'Accuracy+15','Mag. Acc.+10','"Fast Cast"+3',}},
    body="Pinga Tunic",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet="Jhakri Pigaches +2",
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Loquac. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Fi Follet Cape +1", augments={'Path: A',}},
}
    
    
    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = {ammo="Mavi Tathlum",hands="Assim. Bazu. +1", neck="Mirage Stole +2",
    legs="Hashishin Tayt +1", left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
        --head="Luhlaza Keffiyeh",  
        --body="Assimilator's Jubbah",hands="Assimilator's Bazubands +1",
        --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}


    sets.latent_refresh = {}

    -- Resting sets
    sets.resting = {
        body="Shamash Robe",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        left_ear="Infused Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
    }
    
    -- Idle sets
    sets.idle = {     ammo="Homiliary",
    head="Gleti's Mask",
    body="Shamash Robe",
    hands="Gleti's Gauntlets",
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet="Gleti's Boots",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    waist="Fucho-no-Obi",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Infused Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Moonlight Cape",
    }

    sets.idle.PDT = set_combine(sets.idle, sets.defense.PDT) 

    sets.idle.Town = sets.idle 

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    
    -- Defense sets
    sets.defense.PDT = {
        main="Naegling",
        sub="Sakpata's Sword",
        ammo="Amar Cluster",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Defending Ring",
        right_ring="Vengeful Ring",
        back="Moonlight Cape",
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
		left2="Eihwaz Ring",
        right2="Vengeful Ring",
        back="Reiki Cloak",
        }

    
    sets.defense.MDT = { 
        main="Naegling",
        sub="Sakpata's Sword",
        ammo="Amar Cluster",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
        feet="Malignance Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear="Infused Earring",
        right_ear="Eabani Earring",
        left_ring="Defending Ring",
        right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.Kiting = {
        ammo="Staunch Tathlum +1",
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    
}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
 sets.engaged = {
       
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet="Malignance Boots",
        neck="Ainia Collar",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Epona's Ring",
        back="Annealed Mantle",
    
    }
    
sets.engaged.Acc = {
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Malignance Boots",
    neck="Lissome Necklace",
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
}
sets.engaged.AccMAX = set_combine(sets.engaged, {
    ammo="Aurgelmir Orb +1",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Malignance Tights",
    feet="Gleti's Boots",
    neck="Lissome Necklace",
    waist="Olseni Belt",
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},})


sets.engaged.CRIT = {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Thereoid Greaves",
    neck="Nefarious Collar +1",
    waist="Gerdr Belt",
    left_ear="Odr Earring",
    right_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Hetairoi Ring",
    back="Annealed Mantle",}
    

    sets.engaged.Refresh = set_combine(sets.engaged, { 
        ammo="Homiliary",
        body="Shamash Robe",
        waist="Fucho-no-Obi",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
    })

sets.engaged.DW = {
        ammo="Aurgelmir Orb +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
    neck="Ainia Collar",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Suppanomimi",
    right_ear="Telos Earring",
    left_ring="Petrov Ring",
    right_ring="Epona's Ring",
    back="Annealed Mantle",
    }
sets.engaged.DW.PD = set_combine(sets.engaged, {
    head="Malignance Chapeau",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Ainia Collar",
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear="Mache Earring +1",
    right_ear="Dedition Earring",
    left_ring="Defending Ring",
    right_ring="Epona's Ring",
    } )

sets.engaged.DW.Acc = set_combine(sets.engaged, {
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Lissome Necklace",
    left_ear="Suppanomimi",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    } )
    sets.engaged.DW.AccMAX = set_combine(sets.engaged, {
        ammo="Aurgelmir Orb +1",
        head="Malignance Chapeau",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Lissome Necklace",
        waist="Olseni Belt",
        left_ear="Suppanomimi",
        right_ear="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},})
    
sets.engaged.DW.CRIT = {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Thereoid Greaves",
        neck="Nefarious Collar +1",
        waist="Gerdr Belt",
        left_ear="Suppanomimi",
        right_ear="Odr Earring",
        left_ring="Epona's Ring",
        right_ring="Hetairoi Ring",
        back="Annealed Mantle",}

sets.engaged.PD = {
          
            ammo="Coiste Bodhar",
            head="Malignance Chapeau",
            body="Gleti's Cuirass",
            hands="Gleti's Gauntlets",
            legs="Malignance Tights",
            feet="Malignance Boots",
            neck="Ainia Collar",
            waist={ name="Sailfi Belt +1", augments={'Path: A',}},
            left_ear="Mache Earring +1",
            right_ear="Dedition Earring",
            left_ring="Defending Ring",
            right_ring="Epona's Ring",
            back="Moonlight Cape",
        }
sets.engaged.PDT = {
            ammo="Coiste Bodhar",
            head="Malignance Chapeau",
            body="Gleti's Cuirass",
            hands="Gleti's Gauntlets",
            legs="Malignance Tights",
            feet="Malignance Boots",
            neck="Ainia Collar",
            waist={ name="Sailfi Belt +1", augments={'Path: A',}},
            left_ear="Mache Earring +1",
            right_ear="Dedition Earring",
            left_ring="Defending Ring",
            right_ring="Epona's Ring",
            back="Moonlight Cape",
        }

sets.engaged.DW.Refresh =  set_combine(sets.engaged.DW, { 
    ammo="Homiliary",
    body="Shamash Robe",
    waist="Fucho-no-Obi",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
})
    
    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
    sets.engaged.DW.Learning = set_combine(sets.engaged.DW, sets.Learning)

    sets.TreasureHunter = {ammo="Per. Lucky Egg",
    head="White rarab cap +1", 
    waist="Chaac Belt"}

    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",        --(6)
        legs="Nyame Flanchard", --10
        feet="Jhakri Pigaches +2", --7
        neck="Warder's Charm +1", --10
        --ear1="Static Earring",--5
        ring1="Mujin Band", --(5)
        ring2="Jhakri Ring", --5
        --back="Seshaw Cape", --5
        })

    sets.self_healing = sets.midcast['Blue Magic'].Healing
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
end
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type:endswith('Magic') and buffactive.silence then
        eventArgs.cancel = true
        send_command('input /item "Remedy" <me>')
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
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
        if spellMap == 'Magical' then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end

    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
    end
    if state.Buff['Burst Affinity'] or (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
        equip(sets.magic_burst)
        end
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
    if buff == "doom" then
        if gain then
            equip(sets.Doom)
            send_command('input /p Doomed, please Cursna.')
            send_command('input /item "Holy Water" <me>')	
             disable('ring1','ring2','waist','neck')
        else
            enable('ring1','ring2','waist','neck')
            send_command('input /p Doom removed.')
            handle_equipping_gear(player.status)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

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
end
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.IdleMode.current == 'PDT' then
        idleSet = set_combine(idleSet, sets.idle.PDT)
    end
    if state.IdleMode.current == 'Learning' then
        idleSet = set_combine(idleSet, sets.idle.Learning)
    end
    --if player.mpp < 51 then
        --set_combine(idleSet, sets.latent_refresh)
    --end
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
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
function customize_melee_set(meleeSet)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == "Genmei Shield" or player.equipment.sub == "Sors Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
end
function sub_job_change(new,old)
    if user_setup then
        user_setup()
        send_command('wait 6;input /lockstyleset 152')
    end
end

add_to_chat(159,'Author Aragan BLU.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(6, 40)
    else
        set_macro_page(6, 40)
    end
end


