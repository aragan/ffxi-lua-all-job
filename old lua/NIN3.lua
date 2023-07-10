

------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
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
-- Haste II has the same buff ID [33], so we have to use a toggle. 
-- gs c toggle hastemode -- Toggles whether or not you're getting Haste II
-- for Rune Fencer sub, you need to create two macros. One cycles runes, and gives you descrptive text in the log.
-- The other macro will use the actual rune you cycled to. 
-- Macro #1 //console gs c cycle Runes
-- Macro #2 //console gs c toggle UseRune
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
    include('organizer-lib')
    include('Mote-TreasureHunter')
    state.TreasureMode:set('None')
    organizer_items = {
        "Toolbag (Shihe)",
        "Chonofuda",
        "Shikanofuda",
        "Inoshishinofuda",
        "Sanjaku-Tenugui",
        "Toolbag (Cho)",   
        "Toolbag (Shika)",
        "Toolbag (Ino)",
        "Shihei",
        "Toolbag (Shihe)",
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
    state.Buff.Migawari = buffactive.migawari or false
    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.Buff.Innin = buffactive.innin or false



    state.HasteMode = M{['description']='Haste Mode', 'Hi', 'Normal'}
    state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
    state.UseRune = M(false, 'Use Rune')
    state.UseWarp = M(false, 'Use Warp')
    state.Adoulin = M(false, 'Adoulin')
    state.Moving  = M(false, "moving")
    send_command('wait 2;input /lockstyleset 144')
    run_sj = player.sub_job == 'RUN' or false

    select_ammo()
    LugraWSList = S{'Blade: Ku', 'Blade: Jin'}
    state.CapacityMode = M(false, 'Capacity Point Mantle')
    state.Proc = M(false, 'Proc')
    state.unProc = M(false, 'unProc')



    wsList = S{'Blade: Hi', 'Blade: Kamu', 'Blade: Ten'}
    nukeList = S{'Katon: San', 'Doton: San', 'Suiton: San', 'Raiton: San', 'Hyoton: San', 'Huton: San'}

    update_combat_form()

    state.warned = M(false)
    options.ammo_warning_limit = 25
    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

end


-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Mid', 'Acc', 'Sword', 'GK', 'Club', 'Staff', 'Dagger', 'Katana', 'Scythe', 'GS', 'Polearm')
    state.HybridMode:options('Normal', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'SIRD')
    state.WeaponskillMode:options('Normal', 'Mid', 'Acc', 'SC')
    state.PhysicalDefenseMode:options('PDT', 'Enmity', 'TreasureHunter', 'Evasion')
    state.MagicalDefenseMode:options('MDT')

    select_default_macro_book()
    
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^[ gs c toggle UseWarp')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c cycle HasteMode')
    send_command('bind @[ gs c cycle Runes')
    send_command('bind ^] gs c toggle UseRune')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind f5 gs c cycle WeaponskillMode')
    -- send_command('bind !- gs equip sets.crafting')

end


function file_unload()
    send_command('unbind ^[')
    send_command('unbind @f9')
    send_command('unbind @[')
    send_command('unbind ^=')

end


-- Define sets and vars used by this job file.
-- visualized at http://www.ffxiah.com/node/194 (not currently up to date 10/29/2015)
-- Happo
-- Hachiya
-- sets.engaged[state.CombatForm][state.CombatWeapon][state.OffenseMode][state.HybridMode][classes.CustomMeleeGroups (any number)

-- Ninjutsu tips
-- To stick Slow (Hojo) lower earth resist with Raiton: Ni
-- To stick poison (Dokumori) or Attack down (Aisha) lower resist with Katon: Ni
-- To stick paralyze (Jubaku) lower resistence with Huton: Ni

function init_gear_sets()
    --------------------------------------
    -- Augments
    --------------------------------------

    --------------------------------------
    -- Job Abilties
    --------------------------------------
    sets.precast.JA['Mijin Gakure'] = { legs="Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { hands="Hattori Tekko +2" }
    sets.precast.JA['Provoke'] = set_combine(sets.midcast.enmity , {
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    })
    sets.precast.JA.Sange = { }

    -- Waltz (chr and vit)
    sets.precast.Waltz = {}
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {   
    ammo="Yamarang",   
    head="Mummu Bonnet +2",
    body="Passion Jacket",
    legs="Dashing Subligar",
}
    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {
        body="Hattori Ningi +1",
        waist="Olseni Belt",
    }
    sets.MadrigalBonus = {
    }
    -- sets.midcast.Trust =  {
    --     head="Hattori Zukin +1",
    --     hands="Ryuo Tekko",
    --     feet="Hachiya Kyahan +1"
    -- }
    sets.midcast["Apururu (UC)"] = set_combine(sets.midcast.Trust, {
        body="Apururu Unity shirt",
    })
    sets.Warp = { ring1="Warp Ring" }

    --------------------------------------
    -- Utility Sets for rules below
    --------------------------------------
    sets.TreasureHunter = {ammo="Per. Lucky Egg", head="Wh. Rarab Cap +1",
    waist="Chaac Belt"}
    sets.CapacityMantle = {}
    sets.WSDayBonus     = {}
    -- sets.WSBack         = { back="Trepidity Mantle" }
    sets.OdrLugra    = { ear1="Odr Earring", ear2="Lugra Earring +1" }
    sets.OdrIshvara  = { ear1="Odr Earring", ear2="Ishvara Earring" }
    sets.OdrBrutal  = { ear1="Odr Earring", ear2="Brutal Earring" }
    sets.OdrMoon     = { ear1="Odr Earring", ear2="Moonshade Earring" }



    -- sets.NightAccAmmo   = { ammo="Ginsen" }
    -- sets.DayAccAmmo     = { ammo="Seething Bomblet +1" }

    --------------------------------------
    -- Ranged
    --------------------------------------

    sets.precast.RA = {        range="Trollbane",  
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    }
    sets.midcast.RA = {   range="Trollbane",  
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    }
    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
    })
    sets.midcast.RA.TH = set_combine(sets.midcast.RA, set.TreasureHunter)

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Herculean Helm", augments={'"Triple Atk."+4','STR+7','Accuracy+5','Attack+8',}},
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Rahab Ring",
        right_ring="Kishar Ring",
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {    neck="Magoraga Beads",
        body="Passion Jacket",
        feet="Hattori Kyahan +1",
     })

    -- Midcast Sets
    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.enmity = {
        ammo="Iron Gobbet",
        hands="Kurys Gloves",
        body={ name="Emet Harness +1", augments={'Path: A',}},
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
		neck="Moonlight Necklace",
        waist="Flume Belt +1",
        left_ear="Trux Earring",
        right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
        right_ring="Vengeful Ring",
        back="Reiki Cloak",
         }
    -- skill ++ 
    sets.midcast.Ninjutsu = {
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
        neck="Incanter's Torque",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        waist="Cimmerian Sash",
    }

    sets.midcast.EnfeeblingNinjutsu = {
    
        ammo="Yamarang",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    }

    -- any ninjutsu cast on self
    sets.midcast.SelfNinjutsu = {    neck="Incanter's Torque",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
sets.midcast.SelfNinjutsu.SIRD = {       sub="Tancho",
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonlight Necklace",
    waist="Audumbla Sash",
    left_ear="Halasz Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Defending Ring",
    right_ring="Evanescence Ring",
    back="Moonlight Cape",
}
    sets.midcast.Utsusemi = set_combine(sets.midcast.Ninjutsu, {    
        feet="Hattori Kyahan +1",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.midcast.Utsusemi.SIRD = set_combine(sets.midcast.Ninjutsu, {        sub="Tancho",
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        legs="Malignance Tights",
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Evanescence Ring",
        feet="Hattori Kyahan +1",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.midcast.Migawari = set_combine(sets.midcast.Ninjutsu, {    neck="Incanter's Torque",
    ammo="Staunch Tathlum +1",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.midcast.Migawari.SIRD = set_combine(sets.midcast.Ninjutsu, {     sub="Tancho",
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands={ name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Moonlight Necklace",
        waist="Audumbla Sash",
        left_ear="Halasz Earring",
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        left_ring="Defending Ring",
        right_ring="Evanescence Ring",
        back="Moonlight Cape",
    })

    -- Nuking Ninjutsu (skill & magic attack)
    sets.midcast.ElementalNinjutsu = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body="Nyame Mail",
        hands="Hattori Tekko +2",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
     left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
     right_ring="Dingir Ring",
     left_ear="Hecate's Earring",
     right_ear="Friomisi Earring",
     back="Argocham. Mantle",
    }
    sets.magic_burst = set_combine(sets.midcast.ElementalNinjutsu, { 
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body="Nyame Mail",
        hands="Hattori Tekko +2",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Orpheus's Sash",
        left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ring="Mujin Band",
        back="Argocham. Mantle",

})

    -- Effusions
    sets.precast.Effusion = {}
    sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
    sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

         -- Resting sets
    sets.resting = {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body="Hiza. Haramaki +2",
        hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
            neck={ name="Bathy Choker +1", augments={'Path: A',}},
            left_ear="Infused Earring",
            left_ring="Chirich Ring +1",
            right_ring="Chirich Ring +1",
        }

    sets.idle = {

        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Danzo Sune-Ate",
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Paguroidea Ring",
        back="Moonlight Cape",
    }
    sets.idle.Field = sets.idle

    sets.idle.Regen = set_combine(sets.idle, {
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body="Hizamaru Haramaki +2",
        ear2="Infused Earring",
        ring2="Paguroidea Ring"
    })

    sets.Adoulin = {
    }
    sets.idle.Town = sets.idle
    sets.idle.Town = set_combine(sets.idle, {feet="Danzo Sune-Ate",})
    --sets.idle.Town.Adoulin = set_combine(sets.idle.Town, {
    --    body="Councilor's Garb"
    --})
    
    sets.idle.Weak = sets.idle

    -- Defense sets
    sets.defense.PDT = {

        ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Unmoving Collar +1", augments={'Path: A',}},
    waist="Carrier's Sash",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    right_ring="Paguroidea Ring",
    back="Moonlight Cape",
    }
    sets.defense.Enmity = {
        ammo="Iron Gobbet",
        head="Malignance Chapeau",
        body={ name="Emet Harness +1", augments={'Path: A',}},
        hands="Kurys Gloves",
        legs={ name="Zoar Subligar +1", augments={'Path: A',}},
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
        neck={ name="Unmoving Collar +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        left_ear="Trux Earring",
        right_ear="Cryptic Earring",
        left_ring="Defending Ring",
        right_ring="Vengeful Ring",
        back="Reiki Cloak",
         }


    sets.defense.TreasureHunter = {
        ammo="Per. Lucky Egg",
        head="Wh. Rarab Cap +1",
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Malignance Tights",
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Moonbeam Nodowa",
        waist="Chaac Belt",
        left_ear="Telos Earring",
        right_ear="Cessance Earring",
        right_ring="Ilabrat Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
         }

    sets.defense.MDT = set_combine(sets.defense.PDT, {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Tuisto Earring",
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
        right_ring="Purity Ring",
        back="Moonlight Cape",
    })

    sets.defense.Evasion = {
        ammo="Yamarang",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Bathy Choker +1", augments={'Path: A',}},
        waist="Svelt. Gouriz +1",
        left_ear="Eabani Earring",
        right_ear="Infused Earring",
        left_ring="Vengeful Ring",
        right_ring="Hizamaru Ring",
        back="Moonlight Cape",
    }

    sets.DayMovement = {feet="Danzo sune-ate"}
    sets.NightMovement = {feet="Danzo sune-ate"}



    -- Normal melee group without buffs
    sets.engaged = {

        ammo="Coiste Bodhar",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    -- assumptions made about targe
    sets.engaged.Mid = set_combine(sets.engaged, {       
        ammo="Yamarang",
        ear2="Telos Earring",
        -- ring2="Ilabrat Ring",
    })

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        neck="Subtlety Spec.",
        left_ear="Crep. Earring",
        ear2="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        waist="Olseni Belt",
    })

    sets.engaged.CRIT =  {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Nefarious Collar +1",
        waist="Reiki Yotai",
        left_ear="Brutal Earring",
        right_ear="Odr Earring",
        left_ring="Mummu Ring",
        right_ring="Hetairoi Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }


    -- set for fooling around without dual wield
    -- using this as weak / proc set now
    sets.NoDW = set_combine(sets.engaged, {  ammo="Coiste Bodhar",
        head="Hizamaru Somen +1",
        neck="Lissome Necklace",
        ear2="Cessance Earring",
        body="Adhemar Jacket +1",
        hands="Adhemar Wristbands +1",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},

    })
    sets.Katanas = {    
    }
    sets.Dagger = {

    }
    sets.Daggers = {

    }
    sets.Proc = {
        -- main="Knife",
        sub=empty,
        ammo="Ginsen",
    }

sets.engaged.Sword = set_combine(sets.engaged, {
    main="Excalipoor II",
    sub=empty,
})
sets.engaged.GK = set_combine(sets.engaged, {
    main="Zanmato +1",
    sub=empty,
})
sets.engaged.Club = set_combine(sets.engaged, {
    main="Caduceus",
    sub=empty,
})
sets.engaged.Staff = set_combine(sets.engaged, {
    main="Profane Staff",
    sub=empty,
})
sets.engaged.Katana = set_combine(sets.engaged, {
    main="Debahocho +1",
    sub=empty,
})
sets.engaged.Dagger = set_combine(sets.engaged, {
    main="Qutrub Knife",
    sub=empty,
})
sets.engaged.Scythe = set_combine(sets.engaged, {
    main="Lost Sickle",
    sub=empty,
})
sets.engaged.GS = set_combine(sets.engaged, {
    main="Lament",
    sub=empty,
})
sets.engaged.Polearm = set_combine(sets.engaged, {
    main="Sha Wujing's La. +1",
    sub=empty,
})

    sets.unProc = set_combine(sets.engaged, {
  
    })

    sets.engaged.Innin = set_combine(sets.engaged, {
    })
    sets.engaged.Innin.Mid = sets.engaged.Mid
    sets.engaged.Innin.Acc = sets.engaged.Acc

    -- Defenseive sets
    sets.NormalPDT = {
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        ring1="Defending Ring",


    }
    sets.AccPDT = {
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        ring1="Defending Ring",
    }

    sets.engaged.PDT = set_combine(sets.engaged, sets.NormalPDT)
    sets.engaged.Mid.PDT = set_combine(sets.engaged.Mid, sets.NormalPDT)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.AccPDT)

    sets.engaged.Innin.PDT = set_combine(sets.engaged.Innin, sets.NormalPDT )
    sets.engaged.Innin.Mid.PDT = sets.engaged.Mid.PDT
    sets.engaged.Innin.Acc.PDT = sets.engaged.Acc.PDT

    sets.engaged.HastePDT = set_combine(sets.engaged,{
        ammo="Staunch Tathlum +1",
        body="Malignance Tabard",
        head="Malignance Chapeau",
        hands="Malignance Gloves",
        ring1="Defending Ring",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
    })

    -- Delay Cap from spell + songs alone
    sets.engaged.MaxHaste = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.engaged.Mid.MaxHaste = set_combine(sets.engaged.Mid, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear="Brutal Earring",
        ear2="Telos Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.Acc, {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        neck="Subtlety Spec.",
        left_ear="Crep. Earring",
        ear2="Telos Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        waist="Olseni Belt",
    })

    sets.engaged.Innin.MaxHaste     = sets.engaged.MaxHaste
    sets.engaged.Innin.Mid.MaxHaste = sets.engaged.Mid.MaxHaste
    sets.engaged.Innin.Acc.MaxHaste = sets.engaged.Acc.MaxHaste

    -- Defensive sets
    sets.engaged.PDT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.HastePDT)
    sets.engaged.Mid.PDT.MaxHaste = set_combine(sets.engaged.Mid.MaxHaste, sets.engaged.HastePDT)
    sets.engaged.Acc.PDT.MaxHaste = set_combine(sets.engaged.Acc.MaxHaste, sets.AccPDT)

    sets.engaged.Innin.PDT.MaxHaste = sets.engaged.Innin.MaxHaste
    sets.engaged.Innin.Mid.PDT.MaxHaste = sets.engaged.Mid.PDT.MaxHaste
    sets.engaged.Innin.Acc.PDT.MaxHaste = sets.engaged.Acc.PDT.MaxHaste

    -- 35% Haste 
    sets.engaged.Haste_35 = set_combine(sets.engaged.MaxHaste, {         ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    body={ name="Tatena. Harama. +1", augments={'Path: A',}},
    hands={ name="Tatena. Gote +1", augments={'Path: A',}},
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
    neck="Lissome Necklace",
    waist="Reiki Yotai",
    left_ear="Telos Earring",
    right_ear="Suppanomimi",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.engaged.Mid.Haste_35 = set_combine(sets.engaged.Mid.MaxHaste, {  
        ear2="Telos Earring",
    })
    sets.engaged.Acc.Haste_35 = set_combine(sets.engaged.Acc.MaxHaste, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        ear2="Telos Earring",
        feet="Hizamaru Sune-ate +2"
    })

    sets.engaged.Innin.Haste_35 = set_combine(sets.engaged.Haste_35, { })
    sets.engaged.Innin.Mid.Haste_35 = sets.engaged.Mid.Haste_35
    sets.engaged.Innin.Acc.Haste_35 = sets.engaged.Acc.Haste_35

    sets.engaged.PDT.Haste_35 = set_combine(sets.engaged.Haste_35, sets.engaged.HastePDT)
    sets.engaged.Mid.PDT.Haste_35 = set_combine(sets.engaged.Mid.Haste_35, sets.engaged.HastePDT)
    sets.engaged.Acc.PDT.Haste_35 = set_combine(sets.engaged.Acc.Haste_35, sets.engaged.AccPDT)

    sets.engaged.Innin.PDT.Haste_35 = set_combine(sets.engaged.Innin.Haste_35, sets.engaged.HastePDT)
    sets.engaged.Innin.Mid.PDT.Haste_35 = sets.engaged.Mid.PDT.Haste_35
    sets.engaged.Innin.Acc.PDT.Haste_35 = sets.engaged.Acc.PDT.Haste_35

    -- 30% Haste 1626 / 798  +260 acc
    sets.engaged.Haste_30 = set_combine(sets.engaged.Haste_35, {  ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        ear1="Brutal Earring",
        ear2="Suppanomimi", 
        body="Adhemar Jacket +1",
        hands="Adhemar Wristbands +1",
        ring1="Epona's Ring",
        waist="Reiki Yotai",
        feet="Hizamaru Sune-ate +2" 
    })
    sets.engaged.Mid.Haste_30 = set_combine(sets.engaged.Haste_30, {  ammo="Coiste Bodhar",
    head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
    })
    sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Mid.Haste_30, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        waist="Olseni Belt",
    })

    sets.engaged.Innin.Haste_30 = set_combine(sets.engaged.Haste_30, { })
    sets.engaged.Innin.Mid.Haste_30 = sets.engaged.Mid.Haste_30
    sets.engaged.Innin.Acc.Haste_30 = sets.engaged.Acc.Haste_30

    sets.engaged.PDT.Haste_30 = set_combine(sets.engaged.Haste_30, sets.engaged.HastePDT)
    sets.engaged.Mid.PDT.Haste_30 = set_combine(sets.engaged.Mid.Haste_30, sets.engaged.HastePDT)
    sets.engaged.Acc.PDT.Haste_30 = set_combine(sets.engaged.Acc.Haste_30, sets.engaged.AccPDT)

    sets.engaged.Innin.PDT.Haste_30 = set_combine(sets.engaged.Innin.Haste_30, sets.engaged.HastePDT)
    sets.engaged.Innin.Mid.PDT.Haste_30 = sets.engaged.Mid.PDT.Haste_30
    sets.engaged.Innin.Acc.PDT.Haste_30 = sets.engaged.Acc.PDT.Haste_30


    -- haste spell - 139 dex | 275 acc | 1150 total acc (with shigi R15)
    sets.engaged.Haste_15 = set_combine(sets.engaged.Haste_30, {  ammo="Coiste Bodhar",
        left_ear="Eabani Earring",
        right_ear="Suppanomimi",
        head={ name="Ryuo Somen +1", augments={'HP+65','"Store TP"+5','"Subtle Blow"+8',}},
        body="Adhemar Jacket +1",
        ring1="Epona's Ring",
        feet="Hizamaru Sune-ate +2",

    })
    sets.engaged.Mid.Haste_15 = set_combine(sets.engaged.Haste_15, { -- 676
    feet="Hizamaru Sune-ate +2",
    left_ear="Eabani Earring",
    right_ear="Suppanomimi",
    })
    sets.engaged.Acc.Haste_15 = set_combine(sets.engaged.Acc.Haste_30, {  
        left_ear="Eabani Earring",
        right_ear="Suppanomimi",
        waist="Olseni Belt",
    })


    
    sets.engaged.Innin.Haste_15 = set_combine(sets.engaged.Haste_15, { })
    sets.engaged.Innin.Mid.Haste_15 = sets.engaged.Mid.Haste_15
    sets.engaged.Innin.Acc.Haste_15 = sets.engaged.Acc.Haste_15
    
    sets.engaged.PDT.Haste_15 = set_combine(sets.engaged.Haste_15, sets.engaged.HastePDT)
    sets.engaged.Mid.PDT.Haste_15 = set_combine(sets.engaged.Mid.Haste_15, sets.engaged.HastePDT)
    sets.engaged.Acc.PDT.Haste_15 = set_combine(sets.engaged.Acc.Haste_15, sets.engaged.AccPDT)
    
    sets.engaged.Innin.PDT.Haste_15 = set_combine(sets.engaged.Innin.Haste_15, sets.engaged.HastePDT)
    sets.engaged.Innin.Mid.PDT.Haste_15 = sets.engaged.Mid.PDT.Haste_15
    sets.engaged.Innin.Acc.PDT.Haste_15 = sets.engaged.Acc.PDT.Haste_15
    
    sets.buff.Migawari = {     neck="Incanter's Torque",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},

}
    
    -- Weaponskills 
    sets.precast.WS = {

    ammo="Yamarang",
    head="Mpaca's Cap",
    body="Nyame Mail",
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Hiza. Hizayoroi +2",
    feet="Malignance Boots",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Telos Earring",
    right_ear="Ishvara Earring",
    right_ring="Regal Ring",
    left_ring="Gere Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    
    sets.precast.WS.Mid = set_combine(sets.precast.WS, { })
    
    sets.precast.WS.Acc = set_combine(sets.precast.WS.Mid, {
        ring1="Regal Ring",
    })
    
    sets.Kamu = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Malignance Gloves",
        legs="Hiza. Hizayoroi +2",
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Balder Earring +1",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, sets.Kamu)
    sets.precast.WS['Blade: Kamu'].Mid = set_combine(sets.precast.WS.Mid, sets.Kamu)
    sets.precast.WS['Blade: Kamu'].Acc = set_combine(sets.precast.WS.Acc, sets.Kamu, {})
    
    -- BLADE: JIN
    sets.Jin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Hiza. Hizayoroi +2",
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},     
        waist="Windbuffet Belt +1",
    }
    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, sets.Jin)
    sets.precast.WS['Blade: Jin'].Mid = set_combine(sets.precast.WS['Blade: Jin'], {
    })
    sets.precast.WS['Blade: Jin'].Acc = set_combine(sets.precast.WS['Blade: Jin'].Mid, {
    })
    
    -- BLADE: HI
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
  
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Nyame Mail",
        hands="Mummu Wrists +2",
        legs="Hiza. Hizayoroi +2",
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    
    sets.precast.WS['Blade: Hi'].Mid = set_combine(sets.precast.WS['Blade: Hi'], {
       
    })
    
    sets.precast.WS['Blade: Hi'].Acc = set_combine(sets.precast.WS['Blade: Hi'].Mid, {
     
    })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
  
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        right_ear="Hattori Earring", 
        left_ear="Friomisi Earring",
        left_ring="Epaminondas's Ring",
        right_ring="Dingir Ring",
        back="Argocham. Mantle",
    })
    
    -- BLADE: SHUN
    sets.Shun = {
    
        ammo="Aurgelmir Orb +1",
        head="Mpaca's Cap",
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs="Mpaca's Hose",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Hattori Earring", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, sets.Shun)
    sets.precast.WS['Blade: Shun'].Mid = set_combine(sets.Shun, {})
    sets.precast.WS['Blade: Shun'].Acc = set_combine(sets.Shun, {})
    sets.precast.WS['Blade: Shun'].SC = set_combine(sets.Shun, {
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    
    -- BLADE: Rin
    sets.Rin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Hiza. Hizayoroi +2",
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
        waist="Windbuffet Belt +1",
    }
    sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Rin)
    sets.precast.WS['Blade: Rin'].Mid = set_combine(sets.precast.WS.Mid, sets.Rin)
    sets.precast.WS['Blade: Rin'].Acc = set_combine(sets.precast.WS.Acc, sets.Rin, {waist="Light Belt"})
    
    -- BLADE: KU 
    sets.Ku = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet="Malignance Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Hattori Earring", 
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, sets.Ku)
    sets.precast.WS['Blade: Ku'].Mid = sets.precast.WS['Blade: Ku']
    sets.precast.WS['Blade: Ku'].Acc = set_combine(sets.precast.WS['Blade: Ku'].Mid, {
  
    })
    
    sets.Ten = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Nyame Mail",
        hands="Mummu Wrists +2",
        legs="Hiza. Hizayoroi +2",
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    }
    
    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, sets.Ten)
    sets.precast.WS['Blade: Ten'].Mid = set_combine(sets.precast.WS['Blade: Ten'], {
        waist="Sailfi Belt +1",
    })
    sets.precast.WS['Blade: Ten'].Acc = set_combine(sets.precast.WS['Blade: Ten'].Mid, {
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
     hands="Nyame Gauntlets",
     legs="Nyame Flanchard",
     feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Ishvara Earring",
        left_ring="Epaminondas's Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ring="Epaminondas's Ring",
        right_ring="Dingir Ring",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring", 
        back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Attack+10','"Dbl.Atk."+10','Occ. inc. resist. to stat. ailments+10',}},
    })
    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        neck="Fotia Gorget",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Friomisi Earring",
        right_ring="Gere Ring",

    })

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','STR+13','Mag. Acc.+3','"Mag.Atk.Bns."+1',}},
        feet={ name="Herculean Boots", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Crit.hit rate+1','INT+2','"Mag.Atk.Bns."+1',}},
        neck="Sibyl Scarf",
        waist="Orpheus's Sash",
        left_ring="Epaminondas's Ring",
        right_ring={ name="Mephitas's Ring +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring",     })
    sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Chi']
    
    sets.Doom = {    neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Blenmot's Ring +1",}
    
    sets.Kiting = {feet="Danzo Sune-ate"}

end



-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    if (spell.type:endswith('Magic') or spell.type == "Ninjutsu") and buffactive.silence then
        --cancel_spell()
        send_command('input /item "Remedy" <me>')
    end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "" then
        if spell.english == "Migawari" then
            classes.CustomClass = "Migawari"
        else
            classes.CustomClass = "SelfNinjutsu"
        end
    end
    if spell.name == 'Spectral Jig' and buffactive.sneak then
        -- If sneak is active when using, cancel before completion
        -- send_command('cancel 71')
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end

end

function job_post_precast(spell, action, spellMap, eventArgs)
    -- Ranged Attacks 
    if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'Acc' then
        equip(  )
    end
    -- protection for lag
    if spell.type == 'WeaponSkill' then
        if spell.english == '' and state.TreasureMode.value ~= 'None' then
            equip()
        end
        -- Mecistopins Mantle rule (if you kill with ws)
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
        if (spell) then
            if wsList:contains(spell.english) then
                equip()
        end
        -- Lugra Earring for some WS
        if LugraWSList:contains(spell.english) then
            if world.time >= (17*60) or world.time <= (7*60) then
                equip(sets.OdrLugra)
            else
                equip(sets.OdrBrutal)
            end
        elseif spell.english == 'Blade: Ten' then
            equip(sets.OdrMoon)
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.english == "Provoke" then
		equip(sets.midcast.enmity)
	end

	if spell.english == "Warcry" then
		equip(sets.midcast.enmity)
	end

	if spell.english == "Animated Flourish" then
		equip(sets.midcast.enmity)
	end
    -- if spell.english == "Monomi: Ichi" then
    --     if buffactive['Sneak'] then
    --         send_command('@wait 2.7;cancel sneak')
    --     end
    -- end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    --if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
    --    equip(sets.TreasureHunter)
    --end
    if spellMap == 'ElementalNinjutsu' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
        end
    end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if midaction() then
        return
    end

    -- Aftermath timer creation
    aw_custom_aftermath_timers_aftercast(spell)
    --if spell.type == 'WeaponSkill' then
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
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    end
    -- if state.CraftingMode then
    --     idleSet = set_combine(idleSet, sets.crafting)
    -- end
    if state.HybridMode.value == 'PDT' then
        if state.Buff.Migawari then
            idleSet = set_combine(idleSet, sets.buff.Migawari)
        else 
            idleSet = set_combine(idleSet, sets.defense.PDT)
        end
    else
        idleSet = set_combine(idleSet)
    end
    --local res = require('resources')
    --local info = windower.ffxi.get_info()
    --local zone = res.zones[info.zone].name
    --if zone:match('Adoulin') then
    --    idleSet = set_combine(idleSet, sets.Adoulin)
    --end
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
    if state.Buff.Migawari and state.HybridMode.value == 'PDT' then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.HybridMode.value == 'Proc' then
        meleeSet = set_combine(meleeSet, sets.NoDW)
    end
    meleeSet = set_combine(meleeSet, select_ammo())
    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)

    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

    if S{'madrigal'}:contains(buff:lower()) then
        if buffactive.madrigal and state.OffenseMode.value == 'Acc' then
            equip(sets.MadrigalBonus)
        end
    end
    if (buff == 'Innin' and gain or buffactive['Innin']) then
        state.CombatForm:set('Innin')
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    else
        state.CombatForm:reset()
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
        if not midaction() then
            handle_equipping_gear(player.status)
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

end

function job_status_change(newStatus, oldStatus, eventArgs)
    --if newStatus == 'Engaged' then
        --update_combat_form()
    --end
end
--mov = {counter=0}
--if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
--    mov.x = windower.ffxi.get_mob_by_index(player.index).x
--    mov.y = windower.ffxi.get_mob_by_index(player.index).y
--    mov.z = windower.ffxi.get_mob_by_index(player.index).z
--end
--moving = false
--windower.raw_register_event('prerender',function()
--    mov.counter = mov.counter + 1;
--    if mov.counter>15 then
--        local pl = windower.ffxi.get_mob_by_index(player.index)
--        if pl and pl.x and mov.x then
--            dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
--            if dist > 1 and not moving then
--                state.Moving.value = true
--                send_command('gs c update')
--                moving = true
--            elseif dist < 1 and moving then
--                state.Moving.value = false
--                --send_command('gs c update')
--                moving = false
--            end
--        end
--        if pl and pl.x then
--            mov.x = pl.x
--            mov.y = pl.y
--            mov.z = pl.z
--        end
--        mov.counter = 0
--    end
--end)

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
   -- local res = require('resources')
   -- local info = windower.ffxi.get_info()
   -- local zone = res.zones[info.zone].name
   -- if state.Moving.value == true then
   --     if zone:match('Adoulin') then
   --         equip(sets.Adoulin)
   --     end
   --     equip(select_movement())
   -- end

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)

end
function sub_job_change(new,old)
    send_command('wait 5;input /lockstyleset 144')
end
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then 
            return true
    end
end

--function select_movement()
    -- world.time is given in minutes into each day
    -- 7:00 AM would be 420 minutes
    -- 17:00 PM would be 1020 minutes
    --if world.time >= (17*60) or world.time <= (7*60) then
        --return sets.NightMovement
    --else
        --return sets.DayMovement
    --end
--end

function determine_haste_group()

    classes.CustomMeleeGroups:clear()
    -- assuming +4 for marches (ghorn has +5)
    -- Haste (white magic) 15%
    -- Haste Samba (Sub) 5%
    -- Haste (Merited DNC) 10% (never account for this)
    -- Victory March +0/+3/+4/+5    9.4/14%/15.6%/17.1% +0
    -- Advancing March +0/+3/+4/+5  6.3/10.9%/12.5%/14%  +0
    -- Embrava 30% with 500 enhancing skill
    -- Mighty Guard - 15%
    -- buffactive[580] = geo haste
    -- buffactive[33] = regular haste
    -- buffactive[604] = mighty guard
    -- state.HasteMode = toggle for when you know Haste II is being cast on you
    -- Hi = Haste II is being cast. This is clunky to use when both haste II and haste I are being cast
    if state.HasteMode.value == 'Hi' then
        if ( ( (buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604]) ) or
             ( buffactive[33] and (buffactive[580] or buffactive.embrava) ) or
             ( buffactive.march == 2 and buffactive[604] ) ) then
            add_to_chat(8, '-------------Max-Haste Mode Enabled--------------')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( (buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba'] ) then
            add_to_chat(8, '-------------Haste 35%-------------')
            classes.CustomMeleeGroups:append('Haste_35')
        elseif ( ( buffactive[580] or buffactive[33] or buffactive.march == 2 ) or
                 ( buffactive.march == 1 and buffactive[604] ) ) then
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif ( buffactive.march == 1 or buffactive[604] ) then
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        end
    else
        if ( buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or  -- geo haste + anything
           ( buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604]) ) or  -- embrava + anything
           ( buffactive.march == 2 and (buffactive[33] or buffactive[604]) ) or  -- two marches + anything
           ( buffactive[33] and buffactive[604] and buffactive.march ) then -- haste + mighty guard + any marches
            add_to_chat(8, '-------------Max Haste Mode Enabled--------------')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( (buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or -- MG or haste + samba with 1 march
               ( buffactive.march == 2 and buffactive['haste samba'] ) or
               ( buffactive[580] and buffactive['haste samba'] ) then 
            add_to_chat(8, '-------------Haste 35%-------------')
            classes.CustomMeleeGroups:append('Haste_35')
        elseif ( buffactive.march == 2 ) or -- two marches from ghorn
               ( (buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
               ( buffactive[580] ) or  -- geo haste
               ( buffactive[33] and buffactive[604] ) then  -- haste with MG
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Capacity Point Mantle' then
        gear.Back = newValue
    elseif stateField == 'Proc' then
        --send_command('@input /console gs enable all')
        equip(sets.Proc)
        --send_command('@input /console gs disable all')
    elseif stateField == 'unProc' then
        send_command('@input /console gs enable all')
        equip(sets.unProc)
    elseif stateField == 'Runes' then
        local msg = ''
        if newValue == 'Ignis' then
            msg = msg .. 'Increasing resistence against ICE and deals FIRE damage.'
        elseif newValue == 'Gelus' then
            msg = msg .. 'Increasing resistence against WIND and deals ICE damage.'
        elseif newValue == 'Flabra' then
            msg = msg .. 'Increasing resistence against EARTH and deals WIND damage.'
        elseif newValue == 'Tellus' then
            msg = msg .. 'Increasing resistence against LIGHTNING and deals EARTH damage.'
        elseif newValue == 'Sulpor' then
            msg = msg .. 'Increasing resistence against WATER and deals LIGHTNING damage.'
        elseif newValue == 'Unda' then
            msg = msg .. 'Increasing resistence against FIRE and deals WATER damage.'
        elseif newValue == 'Lux' then
            msg = msg .. 'Increasing resistence against DARK and deals LIGHT damage.'
        elseif newValue == 'Tenebrae' then
            msg = msg .. 'Increasing resistence against LIGHT and deals DARK damage.'
        end
        add_to_chat(123, msg)
   -- elseif stateField == 'moving' then
   --     if state.Moving.value then
   --         local res = require('resources')
   --         local info = windower.ffxi.get_info()
   --         local zone = res.zones[info.zone].name
   --         if zone:match('Adoulin') then
   --             equip(sets.Adoulin)
   --         end
   --         equip(select_movement())
   --     end
        
    elseif stateField == 'Use Rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    elseif stateField == 'Use Warp' then
        add_to_chat(8, '------------WARPING-----------')
        --equip({ring1="Warp Ring"})
        send_command('input //gs equip sets.Warp;@wait 10.0;input /item "Warp Ring" <me>;')
    end
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

--- Custom spell mapping.
--function job_get_spell_map(spell, default_spell_map)
--    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
--        return 'HighTierNuke'
--    end
--end
-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
    if spell.type == 'Trust' then
        return 'Trust'
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    msg = msg .. 'Offense: '..state.OffenseMode.current
    msg = msg .. ', Hybrid: '..state.HybridMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    if state.HasteMode.value ~= 'Normal' then
        msg = msg .. ', Haste: '..state.HasteMode.current
    end
    if state.RangedMode.value ~= 'Normal' then
        msg = msg .. ', Rng: '..state.RangedMode.current
    end
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end
    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(123, msg)
    eventArgs.handled = true
end

-- Call from job_precast() to setup aftermath information for custom timers.
function aw_custom_aftermath_timers_precast(spell)
    if spell.type == 'WeaponSkill' then
        info.aftermath = {}

        local empy_ws = "Blade: Hi"

        info.aftermath.weaponskill = empy_ws
        info.aftermath.duration = 0

        info.aftermath.level = math.floor(player.tp / 1000)
        if info.aftermath.level == 0 then
            info.aftermath.level = 1
        end

        if spell.english == empy_ws and player.equipment.main == 'Kannagi' then
            -- nothing can overwrite lvl 3
            if buffactive['Aftermath: Lv.3'] then
                return
            end
            -- only lvl 3 can overwrite lvl 2
            if info.aftermath.level ~= 3 and buffactive['Aftermath: Lv.2'] then
                return
            end

            -- duration is based on aftermath level
            info.aftermath.duration = 30 * info.aftermath.level
        end
    end
end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)
    -- prevent gear being locked when it's currently impossible to cast 
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
-- Determine whether we have sufficient tools for the spell being attempted.
function do_ninja_tool_checks(spell, spellMap, eventArgs)
    local ninja_tool_name
    local ninja_tool_min_count = 1

    -- Only checks for universal tools and shihei
    if spell.skill == "Ninjutsu" then
        if spellMap == 'Utsusemi' then
            ninja_tool_name = "Shihei"
        elseif spellMap == 'ElementalNinjutsu' then
            ninja_tool_name = "Inoshishinofuda"
        elseif spellMap == 'EnfeeblingNinjutsu' then
            ninja_tool_name = "Chonofuda"
        elseif spellMap == 'EnhancingNinjutsu' then
            ninja_tool_name = "Shikanofuda"
        else
            return
        end
    end

    local available_ninja_tools = player.inventory[ninja_tool_name] or player.wardrobe[ninja_tool_name]

    -- If no tools are available, end.
    if not available_ninja_tools then
        if spell.skill == "Ninjutsu" then
            return
        end
    end

    -- Low ninja tools warning.
    if spell.skill == "Ninjutsu" and state.warned.value == false
        and available_ninja_tools.count > 1 and available_ninja_tools.count <= options.ninja_tool_warning_limit then
        local msg = '*****  LOW TOOLS WARNING: '..ninja_tool_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_ninja_tools.count > options.ninja_tool_warning_limit and state.warned then
        state.warned:reset()
    end
end

function select_ammo()
    if state.Buff.Sange then
        return sets.SangeAmmo
    else
        return sets.RegularAmmo
    end
end

-- function select_ws_ammo()
--     if world.time >= (18*60) or world.time <= (6*60) then
--         return sets.NightAccAmmo
--     else
--         return sets.DayAccAmmo
--     end
-- end
add_to_chat(159,'Author Aragan NIN.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
function update_combat_form()
    if state.Buff.Innin then
        state.CombatForm:set('Innin')
    else
        state.CombatForm:reset()
    end
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'WAR' then
        set_macro_page(8, 27)
    elseif player.sub_job == 'RUN' then
        set_macro_page(8, 27)
    else
        set_macro_page(8, 27)
    end
end