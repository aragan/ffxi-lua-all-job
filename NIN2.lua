-------------------------------------------------------------------------------------------------------------------
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
    organizer_items = {
        "Irradiance Blade",
        "Toolbag (Shihe)",
        "Chonofuda",
        "Shikanofuda",
        "Inoshishinofuda",
        "Sanjaku-Tenugui",
        "Toolbag (Cho)",   
        "Toolbag (Shika)",
        "Toolbag (Ino)",
        "Shihei",
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
    state.Buff.Sange = buffactive.sange or false
    state.Buff.Innin = buffactive.innin or false

    include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')

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

    gear.RegularAmmo = 'Seki Shuriken'
    gear.SangeAmmo = 'Happo Shuriken'

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
    state.OffenseMode:options('Normal', 'Sword', 'GK', 'Club', 'Staff', 'Dagger', 'Katana', 'Scythe', 'GS', 'Polearm')
    state.HybridMode:options('Normal', 'PDT', 'Proc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'SC', 'vagary')
    state.PhysicalDefenseMode:options('PDT', 'TreasureHunter', 'Evasion')
    state.MagicalDefenseMode:options('MDT')

	select_default_macro_book()

    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind ^[ gs c toggle UseWarp')
    send_command('bind ![ input /lockstyle off')
    send_command('bind != gs c toggle CapacityMode')
    send_command('bind @f9 gs c cycle HasteMode')
    send_command('bind @[ gs c cycle Runes')
    send_command('bind ^] gs c toggle UseRune')
    -- send_command('bind !- gs equip sets.crafting')

end


function file_unload()
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind @f9')
    send_command('unbind @[')
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
    -- Job Abilties
    --------------------------------------
    sets.precast.JA['Mijin Gakure'] = { legs="Mochizuki Hakama +3" }
    sets.precast.JA['Futae'] = { hands="Hattori Tekko +1" }
    sets.precast.JA['Provoke'] = { 
        -- ear1="Cryptic Earring",
        ear2="Trux Earring", 
        ring1="Petrov Ring",

        
    }
    sets.precast.JA.Sange = { }

    -- Waltz (chr and vit)
    sets.precast.Waltz = {

    }
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {
}
    -- Set for acc on steps, since Yonin drops acc a fair bit
    sets.precast.Step = {
        body="Hattori Ningi +1",
        neck="Defiant Collar",
        hands="Ryuo Tekko",
        waist="Olseni Belt",
        legs="Kendatsuba Hakama +1",
    }
    sets.MadrigalBonus = {
        hands="Composer's Mitts"
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
    sets.CapacityMantle = { }
    sets.WSDayBonus     = {  }
    -- sets.WSBack         = { back="Trepidity Mantle" }
    sets.OdrLugra    = { ear1="Odr Earring", ear2="Lugra Earring +1" }
    sets.OdrIshvara  = { ear1="Odr Earring", ear2="Ishvara Earring" }
    sets.OdrBrutal  = { ear1="Odr Earring", ear2="Brutal Earring" }
    sets.OdrMoon     = { ear1="Odr Earring", ear2="Moonshade Earring" }

    sets.RegularAmmo    = { ammo=gear.RegularAmmo }
    sets.SangeAmmo      = { ammo=gear.SangeAmmo }

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
        head="Malignance Chapeau",
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        feet="Hiza. Sune-Ate +2",
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
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
}
    sets.midcast.Utsusemi = set_combine(sets.midcast.Ninjutsu, {       
    feet="Hattori Kyahan +1",
    back="Andartia's Mantle", 
    })
    sets.midcast.Migawari = {    neck="Incanter's Torque",
        back="Andartia's Mantle", 
    }

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
    sets.Burst = set_combine(sets.midcast.ElementalNinjutsu, { 
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        left_ring="Locus Ring",
        right_ring="Mujin Band",
})

    -- Effusions
    sets.precast.Effusion = {}
    sets.precast.Effusion.Lunge = sets.midcast.ElementalNinjutsu
    sets.precast.Effusion.Swipe = sets.midcast.ElementalNinjutsu

    sets.idle = {
    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Danzo Sune-Ate",
    neck="Moonbeam Nodowa",
    waist="Sarissapho. Belt",
    left_ear="Telos Earring",
    right_ear="Cessance Earring",
    left_ring="Ilabrat Ring",
    right_ring="Epona's Ring",
    back="Andartia's Mantle", 
    }
    sets.idle.Field = sets.idle

    sets.idle.Regen = set_combine(sets.idle, {
        head="Rao Kabuto",
        body="Hizamaru Haramaki +2",
        ear2="Infused Earring",
        ring2="Paguroidea Ring"
    })


    sets.idle.Town = sets.idle
    sets.idle.Town = set_combine(sets.idle, {    feet="Danzo Sune-Ate",
    })
    sets.Kiting = {feet="Danzo Sune-ate"}
    sets.Adoulin = {body="Councilor's Garb",}
    sets.MoveSpeed = {feet="Danzo Sune-Ate",}
    --sets.idle.Town.Adoulin = set_combine(sets.idle.Town, {
    --    body="Councilor's Garb"
    --})
    
    sets.idle.Weak = sets.idle

    -- Defense sets
    sets.defense.PDT = {
        main="Tauret",
        sub="Kunimitsu",
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
        left_ring="Ilabrat Ring",
        right_ring="Epona's Ring",
        back="Andartia's Mantle", 
    }

    sets.defense.TreasureHunter = set_combine(sets.engaged, {
        main={ name="Heishi Shorinken", augments={'Path: A',}},
        sub="Kunimitsu",
        ammo="Per. Lucky Egg", 
        head="Wh. Rarab Cap +1",
        waist="Chaac Belt",
    })

    sets.defense.MDT = set_combine(sets.engaged, {
        main="Tauret",
        sub="Kunimitsu",
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
        left_ring="Defending Ring",
        right_ring="Hizamaru Ring",
        back="Moonlight Cape",
    }

    sets.DayMovement = {feet="Danzo sune-ate"}
    sets.NightMovement = {feet="Danzo sune-ate"}

    sets.Organizer = {

    }

    -- Normal melee group without buffs
    sets.engaged = {

        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet={ name="Herculean Boots", augments={'Attack+5','"Triple Atk."+4','AGI+4','Accuracy+1',}},
        neck="Moonbeam Nodowa",
        waist="Windbuffet Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back="Andartia's Mantle",
    }
    -- assumptions made about targe
    sets.engaged.Mid = set_combine(sets.engaged, {        ammo="Coiste Bodhar",

        ear1="Telos Earring",
        -- ring2="Ilabrat Ring",
    })

    sets.engaged.Acc = set_combine(sets.engaged.Mid, {
        hands="Adhemar Wristbands +1",
        ring1="Regal Ring",
        waist="Olseni Belt",
    })
        sets.engaged.Sword = set_combine(sets.engaged, {
            main="Fermion Sword",
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
            main="Maven's Scythe",
            sub=empty,
        })
        sets.engaged.GS = set_combine(sets.engaged, {
            main="Irradiance Blade",
            sub=empty,
        })
        sets.engaged.Polearm = set_combine(sets.engaged, {
            main="Sha Wujing's La. +1",
            sub=empty,
        })

    -- set for fooling around without dual wield
    -- using this as weak / proc set now
    sets.NoDW = set_combine(sets.engaged, {  ammo="Coiste Bodhar",
        head="Hizamaru Somen +1",
        neck="Lissome Necklace",
        ear2="Cessance Earring",
        body="Adhemar Jacket +1",
        hands="Adhemar Wristbands +1",
        waist="Windbuffet Belt +1",
        back="Andartia's Mantle", 

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
      
    }
    sets.unProc = set_combine(sets.engaged, {

    })

    sets.engaged.Innin = set_combine(sets.engaged, {
    })
    sets.engaged.Innin.Mid = sets.engaged.Mid
    sets.engaged.Innin.Acc = sets.engaged.Acc

    -- Defenseive sets
    sets.NormalPDT = {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        neck="Agitator's Collar",
        hands="Malignance Gloves",
        right_ear="Genmei Earring",
        ring2={ name="Gelatinous Ring +1", augments={'Path: A',}},
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Flume Belt +1",
        ring1="Defending Ring",
        legs="Malignance Tights",
        feet="Malignance Boots",
        back="Moonlight Cape",
    }
    sets.AccPDT = {

    ammo="Coiste Bodhar",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Sarissapho. Belt",
    left_ear="Telos Earring",
    right_ear="Cessance Earring",
    left_ring="Ilabrat Ring",
    right_ring="Epona's Ring",
    back="Andartia's Mantle", 
    }

    sets.engaged.PDT = set_combine(sets.engaged, sets.NormalPDT)
    sets.engaged.Mid.PDT = set_combine(sets.engaged.Mid, sets.NormalPDT)
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.AccPDT)

    sets.engaged.Innin.PDT = set_combine(sets.engaged.Innin, sets.NormalPDT )
    sets.engaged.Innin.Mid.PDT = sets.engaged.Mid.PDT
    sets.engaged.Innin.Acc.PDT = sets.engaged.Acc.PDT

    sets.engaged.HastePDT = {
        neck="Agitator's Collar",
        body="Malignance Tabard",
        head="Malignance Chapeau",
        waist="Flume Belt",
        hands="Malignance Gloves",
        ring1="Defending Ring",
        legs="Malignance Tights",
        feet="Malignance Boots"
    }

    -- Delay Cap from spell + songs alone
    sets.engaged.MaxHaste = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist="Windbuffet Belt +1",
        left_ear="Brutal Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back="Andartia's Mantle", 
    })
    sets.engaged.Mid.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist="Windbuffet Belt +1",
        left_ear="Brutal Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back="Andartia's Mantle", 
    })
    sets.engaged.Acc.MaxHaste = set_combine(sets.engaged.Mid.MaxHaste, {
        ammo="Coiste Bodhar",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Tatena. Harama. +1", augments={'Path: A',}},
        hands={ name="Tatena. Gote +1", augments={'Path: A',}},
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet={ name="Tatena. Sune. +1", augments={'Path: A',}},
        neck="Lissome Necklace",
        waist="Windbuffet Belt +1",
        left_ear="Brutal Earring",
        right_ear="Dedition Earring",
        left_ring="Gere Ring",
        right_ring="Epona's Ring",
        back="Andartia's Mantle", 
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
    head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
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
    back="Andartia's Mantle", 
    })
    sets.engaged.Mid.Haste_35 = set_combine(sets.engaged.Mid.MaxHaste, {  ammo="Coiste Bodhar",
        ear1="Telos Earring",
        ear2="Brutal Earring",
    })
    sets.engaged.Acc.Haste_35 = set_combine(sets.engaged.Acc.MaxHaste, {  ammo="Coiste Bodhar",
        ear1="Telos Earring",
        ear2="Brutal Earring",
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
        head="Adhemar Bonnet",
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
    ear2="Cessance Earring",
        ring1="Ilabrat Ring",
    })
    sets.engaged.Acc.Haste_30 = set_combine(sets.engaged.Mid.Haste_30, {  ammo="Coiste Bodhar",
        ring1="Cacoethic Ring +1",
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
    ammo="Coiste Bodhar",
    feet="Hizamaru Sune-ate +2",
    left_ear="Eabani Earring",
    right_ear="Suppanomimi",
    })
    sets.engaged.Acc.Haste_15 = set_combine(sets.engaged.Acc.Haste_30, {  ammo="Coiste Bodhar",
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
        back="Andartia's Mantle", 

}
    
    -- Weaponskills 
    sets.precast.WS = {

    }
        
    sets.precast.WS.SC = set_combine(sets.precast.WS, { 
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    
    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS.vagary =  {}

    sets.Kamu = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist={ name="Sailfi Belt +1", augments={'Path: A',}},
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, sets.Kamu)
    sets.precast.WS['Blade: Kamu'].SC = set_combine(sets.precast.WS, sets.Kamu, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},    })
    sets.precast.WS['Blade: Kamu'].PDL = set_combine(sets.precast.WS, sets.Kamu, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring",     })
    
    -- BLADE: JIN
    sets.Jin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Jin'] = set_combine(sets.precast.WS, sets.Jin)
    sets.precast.WS['Blade: Jin'].SC = set_combine(sets.precast.WS['Blade: Jin'], {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Jin'].PDL = set_combine(sets.precast.WS['Blade: Jin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},       
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: HI
    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Hi'].SC = set_combine(sets.precast.WS['Blade: Hi'], {
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Hi'].PDL = set_combine(sets.precast.WS['Blade: Hi'], {
        head={ name="Nyame Helm", augments={'Path: B',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},   
        right_ear="Hattori Earring +1", 
        left_ring="Cornelia's Ring",
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: SHUN
    sets.Shun = {
        ammo="Aurgelmir Orb +1",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        hands={ name="Adhemar Wrist. +1", augments={'Accuracy+20','Attack+20','"Subtle Blow"+8',}},
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear="Hattori Earring +1", 
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    
    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, sets.Shun)
    sets.precast.WS['Blade: Shun'].PDL = set_combine(sets.Shun, {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},       
        right_ring="Sroda Ring", 
    })
    sets.precast.WS['Blade: Shun'].SC = set_combine(sets.Shun, {
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Exenterator'] = set_combine(sets.Shun, {})
    sets.precast.WS['Viper Bite'] = set_combine(sets.Shun, {})

    
    -- BLADE: Rin
    sets.Rin = {
        ammo="Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Gerdr Belt",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear="Odr Earring",
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Rin'] = set_combine(sets.precast.WS, sets.Rin)
    sets.precast.WS['Blade: Rin'].SC = set_combine(sets.precast.WS.SC, sets.Rin)
    sets.precast.WS['Blade: Rin'].PDL = set_combine(sets.precast.WS['Blade: Rin'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},        
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    
    -- BLADE: KU 
    sets.Ku = {
        ammo="Coiste Bodhar",
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        right_ear="Brutal Earring",
        left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        right_ring="Regal Ring",
        left_ring="Gere Ring",
        back="Andartia's Mantle",
    }
    sets.precast.WS['Blade: Ku'] = set_combine(sets.precast.WS, sets.Ku)
    sets.precast.WS['Blade: Ku'].SC = sets.precast.WS['Blade: Ku']
    sets.precast.WS['Blade: Ku'].PDL = set_combine(sets.precast.WS['Blade: Ku'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},       
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    
    sets.Ten = {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
     hands="Nyame Gauntlets",
     legs="Nyame Flanchard",
     feet="Nyame Sollerets",
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    }
    
    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, sets.Ten)
    sets.precast.WS['Blade: Ten'].SC = set_combine(sets.precast.WS['Blade: Ten'], {
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: Ten'].PDL = set_combine(sets.precast.WS['Blade: Ten'], {
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, { 
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mpaca's Cap", augments={'Path: A',}},
        body="Nyame Mail",
     hands="Nyame Gauntlets",
     legs="Nyame Flanchard",
     feet="Nyame Sollerets",
     neck="Rep. Plat. Medal",
     waist="Sailfi Belt +1",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Cornelia's Ring",
        right_ring="Regal Ring",
        back="Sacro Mantle",
    })
    sets.precast.WS['Savage Blade'].PDL = set_combine(sets.precast.WS['Savage Blade'], { 
        ammo="Crepuscular Pebble",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS['Savage Blade'].SC = set_combine(sets.precast.WS['Savage Blade'], { 
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS.Evisceration = {
        ammo="Yetshila +1",
        head={ name="Blistering Sallet +1", augments={'Path: A',}},
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs={ name="Mpaca's Hose", augments={'Path: A',}},
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Odr Earring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ring="Regal Ring",
        right_ring="Gere Ring",
        back="Andartia's Mantle", 
    }
    sets.precast.WS.Evisceration.PDL = set_combine(sets.precast.WS.Evisceration, {
        right_ear="Hattori Earring +1", 
        right_ring="Sroda Ring", 
    })
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Dingir Ring",
        right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.vagary =  {}
    sets.precast.WS['Aeolian Edge'].vagary = {}
    sets.precast.WS['Aeolian Edge'].PDL = set_combine(sets.precast.WS['Aeolian Edge'],{
    --range="Wingcutter +1",
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })

    sets.precast.WS['Gust Slash'] = set_combine(sets.precast.WS['Aeolian Edge'],{})
    sets.precast.WS['Gust Slash'].PDL = set_combine(sets.precast.WS['Aeolian Edge'].PDL,{})


    sets.precast.WS['Shining Blade'] =  {
    }
    sets.precast.WS['Shining Blade'].PDL = set_combine(sets.precast.WS['Aeolian Edge'], {
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        neck={ name="Warder's Charm +1", augments={'Path: A',}},

        })
    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS['Aeolian Edge'], {
    })
    sets.precast.WS['Tachi: Jinpu'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'], {
        --range="Wingcutter +1",
        neck={ name="Warder's Charm +1", augments={'Path: A',}},

    })
    sets.precast.WS['Tachi: Jinpu'].SC = set_combine(sets.precast.WS['Tachi: Jinpu'], {

    })
    sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Kagero'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS['Tachi: Jinpu'], {})
    sets.precast.WS['Tachi: Goten'].PDL = set_combine(sets.precast.WS['Tachi: Jinpu'].PDL, {})
    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {
    ammo="Pemphredo Tathlum",
    head={ name="Nyame Helm", augments={'Path: B',}},
    body={ name="Nyame Mail", augments={'Path: B',}},
    hands={ name="Nyame Gauntlets", augments={'Path: B',}},
    legs={ name="Nyame Flanchard", augments={'Path: B',}},
    feet={ name="Nyame Sollerets", augments={'Path: B',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Crep. Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    back="Sacro Mantle",
    })

    sets.precast.WS['Blade: Chi'] = set_combine(sets.precast.WS['Aeolian Edge'], {
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring="Gere Ring",
        back="Sacro Mantle",
       })
       
    sets.precast.WS['Blade: Chi'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
        neck={ name="Warder's Charm +1", augments={'Path: A',}},
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+11','Accuracy+5','"Triple Atk."+2',}},
    })

    sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Chi']
    sets.precast.WS['Blade: Teki'].PDL = set_combine(sets.precast.WS['Blade: Chi'], {
    head="Genmei Kabuto",    
    neck={ name="Warder's Charm +1", augments={'Path: A',}},
    })
    sets.precast.WS['Blade: To'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: To'].PDL = sets.precast.WS['Blade: Teki'].PDL
    
    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {       
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        waist="Orpheus's Sash",
        left_ring="Cornelia's Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        right_ear="Friomisi Earring",
        left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        back="Sacro Mantle",
    })
    sets.precast.WS['Blade: Yu'] = sets.precast.WS['Blade: Teki']
    sets.precast.WS['Blade: Yu'].PDL = sets.precast.WS['Blade: Yu'].PDL

    sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {

       })
       sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Asuran Fists'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Spinning Attack'].PDL= set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 
       sets.precast.WS['Backhand Blow'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Backhand Blow'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS)
       sets.precast.WS['Shoulder Tackle'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS)
       sets.precast.WS['Combo'] = set_combine(sets.precast.WS['Blade: Shun'], sets.precast.WS) 
       sets.precast.WS['Combo'].PDL = set_combine(sets.precast.WS['Blade: Shun'].PDL, sets.precast.WS) 


    
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
    if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "Utsusemi" then
        if spell.english == "Migawari" then
            classes.CustomClass = "Migawari"
        else
            classes.CustomClass = "SelfNinjutsu"
        end
    end
    if spell.skill == "Ninjutsu" then
        if spellMap == 'ElementalNinjutsu' then
            equip(sets.midcast.ElementalNinjutsu)
        end
    end
    if spell.name == 'Spectral Jig' and buffactive.sneak then
        -- If sneak is active when using, cancel before completion
        -- send_command('cancel 71')
    end

end



function job_post_precast(spell, action, spellMap, eventArgs)
    -- Ranged Attacks 
    if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'Acc' then
        equip( sets.SangeAmmo )
    end
    if spell.skill == "Ninjutsu" then
        if spellMap == 'ElementalNinjutsu' then
            equip(sets.midcast.ElementalNinjutsu)
        end
    end
    -- protection for lag
    if spell.name == 'Sange' and player.equipment.ammo == gear.RegularAmmo then
        state.Buff.Sange = false
        eventArgs.cancel = true
    end
    if spell.type == 'WeaponSkill' then
        -- Mecistopins Mantle rule (if you kill with ws)
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if nukeList:contains(spell.english) and buffactive['Futae'] then
        equip(sets.Burst)
    end
    if spell.skill == "Ninjutsu" then
        if spellMap == 'ElementalNinjutsu' then
            equip(sets.midcast.ElementalNinjutsu)
        end
    end
    function midcast(spell)
        if spell.name == 'Utsusemi: Ichi' and overwrite then
            send_command('cancel Copy Image|Copy Image (2)')
        end
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
        idleSet = set_combine(idleSet, select_movement())
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

end

function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Engaged' then
        update_combat_form()
    end
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
    if mov.counter>15 then
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
    select_ammo()
    --determine_haste_group()
    update_combat_form()
    run_sj = player.sub_job == 'RUN' or false
    --select_movement()
    th_update(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = false
    end
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

function select_movement()
    -- world.time is given in minutes into each day
    -- 7:00 AM would be 420 minutes
    -- 17:00 PM would be 1020 minutes
    if world.time >= (17*60) or world.time <= (7*60) then
        return sets.NightMovement
    else
        return sets.DayMovement
    end
end

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
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( (buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba'] ) then
            classes.CustomMeleeGroups:append('Haste_35')
        elseif ( ( buffactive[580] or buffactive[33] or buffactive.march == 2 ) or
                 ( buffactive.march == 1 and buffactive[604] ) ) then
            classes.CustomMeleeGroups:append('Haste_30')
        elseif ( buffactive.march == 1 or buffactive[604] ) then
            classes.CustomMeleeGroups:append('Haste_15')
        end
    else
        if ( buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or  -- geo haste + anything
           ( buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604]) ) or  -- embrava + anything
           ( buffactive.march == 2 and (buffactive[33] or buffactive[604]) ) or  -- two marches + anything
           ( buffactive[33] and buffactive[604] and buffactive.march ) then -- haste + mighty guard + any marches
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( (buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or -- MG or haste + samba with 1 march
               ( buffactive.march == 2 and buffactive['haste samba'] ) or
               ( buffactive[580] and buffactive['haste samba'] ) then 
            classes.CustomMeleeGroups:append('Haste_35')
        elseif ( buffactive.march == 2 ) or -- two marches from ghorn
               ( (buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
               ( buffactive[580] ) or  -- geo haste
               ( buffactive[33] and buffactive[604] ) then  -- haste with MG
            classes.CustomMeleeGroups:append('Haste_30')
        elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
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

function update_combat_form()
    if state.Buff.Innin then
        state.CombatForm:set('Innin')
    else
        state.CombatForm:reset()
    end
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(3, 27)
    elseif player.sub_job == 'WAR' then
        set_macro_page(3, 27)
    elseif player.sub_job == 'RUN' then
        set_macro_page(3, 27)
    else
        set_macro_page(3, 27)
    end
end