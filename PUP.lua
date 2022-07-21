----------------------------------------------------------------------------------------
--  __  __           _                     __   _____                        _
-- |  \/  |         | |                   / _| |  __ \                      | |
-- | \  / | __ _ ___| |_ ___ _ __    ___ | |_  | |__) |   _ _ __  _ __   ___| |_ ___
-- | |\/| |/ _` / __| __/ _ \ '__|  / _ \|  _| |  ___/ | | | '_ \| '_ \ / _ \ __/ __|
-- | |  | | (_| \__ \ ||  __/ |    | (_) | |   | |   | |_| | |_) | |_) |  __/ |_\__ \
-- |_|  |_|\__,_|___/\__\___|_|     \___/|_|   |_|    \__,_| .__/| .__/ \___|\__|___/
--                                                         | |   | |
--                                                         |_|   |_|
-----------------------------------------------------------------------------------------
--[[

---------------------------------------------------------------------------------
-- This lua is based off of the Kinematics template and uses Motenten globals. --
--                                                                             --
-----------------------------Authors of this file--------------------------------
------           ******************************************                ------
---                                                                           ---
--	  Aragan (Asura) --------------- [Author Primary]                          -- 
--                                                                             --
---------------------------------------------------------------------------------
    
]]

-- Initialization function for this job file.
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include("Mote-Include.lua")
end

function user_setup()
    -- Alt-F10 - Toggles Kiting Mode.

    --[[
        F9 - Cycle Offense Mode (the offensive half of all 'hybrid' melee modes).
        
        These are for when you are fighting with or without Pet
        When you are IDLE and Pet is ENGAGED that is handled by the Idle Sets
    ]]
    state.OffenseMode:options("MasterPet", "Master", "Trusts")

    --[[
        Ctrl-F9 - Cycle Hybrid Mode (the defensive half of all 'hybrid' melee modes).
        
        Used when you are Engaged with Pet
        Used when you are Idle and Pet is Engaged
    ]]
    state.HybridMode:options("Normal", "Acc", "TP", "DT", "Regen", "Ranged")

    --[[
        Alt-F12 - Turns off any emergency mode
        
        Ctrl-F10 - Cycle type of Physical Defense Mode in use.
        F10 - Activate emergency Physical Defense Mode. Replaces Magical Defense Mode, if that was active.
    ]]
    state.PhysicalDefenseMode:options("PetDT", "MasterDT")

    --[[
        Alt-F12 - Turns off any emergency mode

        F11 - Activate emergency Magical Defense Mode. Replaces Physical Defense Mode, if that was active.
    ]]
    state.MagicalDefenseMode:options("PetMDT")

    --[[ IDLE Mode Notes:

        F12 - Update currently equipped gear, and report current status.
        Ctrl-F12 - Cycle Idle Mode.
        
        Will automatically set IdleMode to Idle when Pet becomes Engaged and you are Idle
    ]]
    state.IdleMode:options("Idle", "MasterDT")

    --Various Cycles for the different types of PetModes
    state.PetStyleCycleTank = M {"NORMAL", "DD", "MAGIC", "SPAM"}
    state.PetStyleCycleMage = M {"NORMAL", "HEAL", "SUPPORT", "MB", "DD"}
    state.PetStyleCycleDD = M {"NORMAL", "BONE", "SPAM", "OD", "ODACC"}

    --The actual Pet Mode and Pet Style cycles
    --Default Mode is Tank
    state.PetModeCycle = M {"TANK", "DD", "MAGE"}
    --Default Pet Cycle is Tank
    state.PetStyleCycle = state.PetStyleCycleTank

    --Toggles
    --[[
        Alt + E will turn on or off Auto Maneuver
    ]]
    state.AutoMan = M(false, "Auto Maneuver")

    --[[
        //gs c toggle autodeploy
    ]]
    state.AutoDeploy = M(false, "Auto Deploy")

    --[[
        Alt + D will turn on or off Lock Pet DT
        (Note this will block all gearswapping when active)
    ]]
    state.LockPetDT = M(false, "Lock Pet DT")

    --[[
        Alt + (tilda) will turn on or off the Lock Weapon
    ]]
    state.LockWeapon = M(false, "Lock Weapon")

    --[[
        //gs c toggle setftp
    ]]
    state.SetFTP = M(false, "Set FTP")

   --[[
        This will hide the entire HUB
        //gs c hub all
    ]]
    state.textHideHUB = M(false, "Hide HUB")

    --[[
        This will hide the Mode on the HUB
        //gs c hub mode
    ]]
    state.textHideMode = M(false, "Hide Mode")

    --[[
        This will hide the State on the HUB
        //gs c hub state
    ]]
    state.textHideState = M(false, "Hide State")

    --[[
        This will hide the Options on the HUB
        //gs c hub options
    ]]
    state.textHideOptions = M(false, "Hide Options")

    --[[
        This will toggle the HUB lite mode
        //gs c hub lite
    ]]  
    state.useLightMode = M(false, "Toggles Lite mode")

    --[[
        This will toggle the default Keybinds set up for any changeable command on the window
        //gs c hub keybinds
    ]]
    state.Keybinds = M(false, "Hide Keybinds")

    --[[ 
        This will toggle the CP Mode 
        //gs c toggle CP 
    ]] 
    state.CP = M(false, "CP") 
    CP_CAPE = "Aptitude Mantle +1" 

    --[[
        Enter the slots you would lock based on a custom set up.
        Can be used in situation like Salvage where you don't want
        certain pieces to change.

        //gs c toggle customgearlock
        ]]
    state.CustomGearLock = M(false, "Custom Gear Lock")
    --Example customGearLock = T{"head", "waist"}
    customGearLock = T{}
    send_command('wait 2;input /lockstyleset 200')
    send_command("bind !f7 gs c cycle PetModeCycle")
    send_command("bind ^f7 gs c cycleback PetModeCycle")
    send_command("bind !f8 gs c cycle PetStyleCycle")
    send_command("bind ^f8 gs c cycleback PetStyleCycle")
    send_command("bind !e gs c toggle AutoMan")
    send_command("bind !d gs c toggle LockPetDT")
    send_command("bind !f6 gs c predict")
    send_command("bind ^` gs c toggle LockWeapon")
    send_command("bind home gs c toggle setftp")
    send_command("bind PAGEUP gs c toggle autodeploy")
    send_command("bind PAGEDOWN gs c hide keybinds")
    send_command("bind end gs c toggle CP") 
    send_command("bind = gs c clear")

    select_default_macro_book()

    -- Adjust the X (horizontal) and Y (vertical) position here to adjust the window
    pos_x = 0
    pos_y = 0
    setupTextWindow(pos_x, pos_y)
    
end

function file_unload()
    send_command("unbind !f7")
    send_command("unbind ^f7")
    send_command("unbind !f8")
    send_command("unbind ^f8")
    send_command("unbind !e")
    send_command("unbind !d")
    send_command("unbind !f6")
    send_command("unbind ^`")
    send_command("unbind home")
    send_command("unbind PAGEUP")
    send_command("unbind PAGEDOWN")       
    send_command("unbind end")
    send_command("unbind =")
end

function job_setup()
    include("PUP-LIB.lua")
end

function init_gear_sets()
    --Table of Contents
    ---Gear Variables
    ---Master Only Sets
    ---Hybrid Only Sets
    ---Pet Only Sets
    ---Misc Sets
    include('organizer-lib')
    -------------------------------------------------------------------------
    --  _____                  __      __        _       _     _
    -- / ____|                 \ \    / /       (_)     | |   | |
    --| |  __  ___  __ _ _ __   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___
    --| | |_ |/ _ \/ _` | '__|   \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
    --| |__| |  __/ (_| | |       \  / (_| | |  | | (_| | |_) | |  __/\__ \
    -- \_____|\___|\__,_|_|        \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
    -------------------------------------------------------------------------
    --[[
        This section is best ultilized for defining gear that is used among multiple sets
        You can simply use or ignore the below
    ]]
    Animators = {}
    Animators.Range = "Animator P II"
    Animators.Melee = "Animator P +1"

    --Adjust to your reforge level
    --Sets up a Key, Value Pair
    Artifact_Foire = {}
    Artifact_Foire.Head_PRegen = "Foire Taj +1"
    Artifact_Foire.Body_WSD_PTank = "Foire Tobe +1"
    Artifact_Foire.Hands_Mane_Overload = "Foire Dastanas +2"
    Artifact_Foire.Legs_PCure = "Foire Churidars +1"
    Artifact_Foire.Feet_Repair_PMagic = "Foire Babouches +1"

    Relic_Pitre = {}
    Relic_Pitre.Head_PRegen = "Pitre Taj +3" --Enhances Optimization
    Relic_Pitre.Body_PTP = "Pitre Tobe +3" --Enhances Overdrive
    Relic_Pitre.Hands_WSD = "Pitre Dastanas +2" --Enhances Fine-Tuning
    Relic_Pitre.Legs_PMagic = "Pitre Churidars +2" --Enhances Ventriloquy
    Relic_Pitre.Feet_PMagic = "Pitre Babouches +1" --Role Reversal

    Empy_Karagoz = {}
    Empy_Karagoz.Head_PTPBonus = "Karagoz Capello +1"
    Empy_Karagoz.Body_Overload = "Karagoz Farsetto +1"
    Empy_Karagoz.Hands = "Karagoz Guanti +1"
    Empy_Karagoz.Legs_Combat = "Karagoz Pantaloni +1"
    Empy_Karagoz.Feet_Tatical = "Karagoz Scarpe +1"

    Visucius = {}
    Visucius.PetDT = {
      
        
    }
    Visucius.PetMagic = {
   
        
    }

    --------------------------------------------------------------------------------
    --  __  __           _               ____        _          _____      _
    -- |  \/  |         | |             / __ \      | |        / ____|    | |
    -- | \  / | __ _ ___| |_ ___ _ __  | |  | |_ __ | |_   _  | (___   ___| |_ ___
    -- | |\/| |/ _` / __| __/ _ \ '__| | |  | | '_ \| | | | |  \___ \ / _ \ __/ __|
    -- | |  | | (_| \__ \ ||  __/ |    | |__| | | | | | |_| |  ____) |  __/ |_\__ \
    -- |_|  |_|\__,_|___/\__\___|_|     \____/|_| |_|_|\__, | |_____/ \___|\__|___/
    --                                                  __/ |
    --                                                 |___/
    ---------------------------------------------------------------------------------
    --This section is best utilized for Master Sets
    --[[
        Will be activated when Pet is not active, otherwise refer to sets.idle.Pet
    ]]
    sets.idle = {}

    -------------------------------------Fastcast
    sets.precast.FC = {
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",

    }

    -------------------------------------Midcast
    sets.midcast = {} --Can be left empty

    sets.midcast.FastRecast = {
         waist="Cascade Belt",
    left_ear="Brachyura Earring",
    right_ear="Andoaa Earring",
    left_ring="Sheltered Ring",
    right_ring="Stikini Ring",

    }

    -------------------------------------Kiting
    sets.Kiting = {feet="Hermes' Sandals +1",}

    -------------------------------------JA
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck = "Magoraga Beads", body = "Passion Jacket"})

    -- Precast sets to enhance JAs
    sets.precast.JA = {} -- Can be left empty

    sets.precast.JA["Tactical Switch"] = {feet = Empy_Karagoz.Feet_Tatical}

    sets.precast.JA["Ventriloquy"] = {legs = Relic_Pitre.Legs_PMagic}

    sets.precast.JA["Role Reversal"] = {feet = Relic_Pitre.Feet_PMagic}

    sets.precast.JA["Overdrive"] = {body = Relic_Pitre.Body_PTP}

    sets.precast.JA["Repair"] = {
        
        right_ear="Pratik Earring",
        ammo = "Automat. Oil +3",
        feet = Artifact_Foire.Feet_Repair_PMagic
    }

    sets.precast.JA["Maintenance"] = set_combine(sets.precast.JA["Repair"], { hands="Foire Dastanas +3",})

    sets.precast.JA.Maneuver = {
        
        body = "Karagoz Farsetto +1",
        hands="Foire Dastanas +3",
        back = "Visucius's Mantle",
        ear1 = "Burana Earring"
    }

    sets.precast.JA["Activate"] = {feet="Mpaca's Boots",}

    sets.precast.JA["Deus Ex Automata"] = sets.precast.JA["Activate"]

    sets.precast.JA["Provoke"] = {}

    --Waltz set (chr and vit)
    sets.precast.Waltz = {
       -- Add your set here 
    }

    sets.precast.Waltz["Healing Waltz"] = {}

    -------------------------------------WS
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        
    
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Hiza. Hizayoroi +2",
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Schere Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Epona's Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS["Stringing Pummel"] = set_combine(sets.precast.WS, {
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Schere Earring",
        right_ear="Telos Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Epona's Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},

    })

    sets.precast.WS["Stringing Pummel"].Mod = set_combine(sets.precast.WS, {
        head="Mpaca's Cap",
    body="Mpaca's Doublet",
    hands="Mpaca's Gloves",
    legs="Mpaca's Hose",
    feet="Mpaca's Boots",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Schere Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    })

    sets.precast.WS["Victory Smite"] = set_combine(sets.precast.WS, {
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Schere Earring",
        right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
        left_ring="Niqmaddu Ring",
        right_ring="Epona's Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},

    })

    sets.precast.WS["Shijin Spiral"] =
        set_combine(
        sets.precast.WS, {
        
            head="Malignance Chapeau",
            body="Tali'ah Manteel +2",
            hands="Malignance Gloves",
            legs={ name="Samnuha Tights", augments={'STR+7','DEX+6',}},
            feet="Mpaca's Boots",
            neck="Fotia Gorget",
            waist="Fotia Belt",
            left_ear="Schere Earring",
            right_ear="Telos Earring",
            left_ring="Niqmaddu Ring",
            right_ring="Epona's Ring",
            back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
        }

    )

    sets.precast.WS["Howling Fist"] = set_combine(sets.precast.WS, {
        body="Tali'ah Manteel +2",
    


    })

    -------------------------------------Idle
    --[[
        Pet is not active
        Idle Mode = MasterDT
    ]]
    sets.idle.MasterDT = {
        main={ name="Xiucoatl", augments={'Path: C',}},
        range="Animator P +1",
        ammo="Automat. Oil +3",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Isa Belt",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Odnowa Earring",
        left_ring="Purity Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

    -------------------------------------Engaged
    --[[
        Offense Mode = Master
        Hybrid Mode = Normal
    ]]
    sets.engaged.Master = {
        range="Animator P +1",
        ammo="Automat. Oil +3",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Lissome Necklace",
        waist="Moonbow Belt +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Epona's Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1247 Val: 4',}},
    }

    -------------------------------------Acc
    --[[
        Offense Mode = Master
        Hybrid Mode = Acc
    ]]
    sets.engaged.Master.Acc = {
        range="Neo Animator",
        ammo="Automat. Oil +3",
        head="Hiza. Somen +2",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Lissome Necklace",
        waist="Moonbow Belt +1",
        left_ear="Cessance Earring",
        right_ear="Mache Earring +1",
        left_ring="Epona's Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1247 Val: 4',}},
    }

    -------------------------------------TP
    --[[
        Offense Mode = Master
        Hybrid Mode = TP
    ]]
    sets.engaged.Master.TP = {
        range="Animator P +1",
        ammo="Automat. Oil +3",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Telos Earring",
        right_ear="Crep. Earring",
        left_ring="Thurandaut Ring",
        right_ring="Niqmaddu Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1247 Val: 4',}},
    }

    -------------------------------------DT
    --[[
        Offense Mode = Master
        Hybrid Mode = DT
    ]]
    sets.engaged.Master.DT = {   ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Shadow Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
    
    }

    ----------------------------------------------------------------------------------
    --  __  __         _           ___     _     ___      _
    -- |  \/  |__ _ __| |_ ___ _ _| _ \___| |_  / __| ___| |_ ___
    -- | |\/| / _` (_-<  _/ -_) '_|  _/ -_)  _| \__ \/ -_)  _(_-<
    -- |_|  |_\__,_/__/\__\___|_| |_| \___|\__| |___/\___|\__/__/
    -----------------------------------------------------------------------------------

    --[[
        These sets are designed to be a hybrid of player and pet gear for when you are
        fighting along side your pet. Basically gear used here should benefit both the player
        and the pet.
    ]]
    --[[
        Offense Mode = MasterPet
        Hybrid Mode = Normal
    ]]
    sets.engaged.MasterPet = {
    
        range="Animator P +1",
    ammo="Automat. Oil +3",
    head="Heyoka Cap",
    body="Mpaca's Doublet",
    hands="Mpaca's Gloves",
    legs="Heyoka Subligar",
    feet="Mpaca's Boots",
    neck="Shulmanu Collar",
    waist="Moonbow Belt",
    left_ear="Crep. Earring",
    right_ear="Mache Earring +1",
    left_ring="Epona's Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1247 Val: 4',}},
    }

    -------------------------------------Acc
    --[[
        Offense Mode = MasterPet
        Hybrid Mode = Acc
    ]]
    sets.engaged.MasterPet.Acc = {
        range="Animator P +1",
    ammo="Automat. Oil +3",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Lissome Necklace",
    waist="Moonbow Belt",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Epona's Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1247 Val: 4',}},
    }

    -------------------------------------TP
    --[[
        Offense Mode = MasterPet
        Hybrid Mode = TP
    ]]
    sets.engaged.MasterPet.TP = {
        range="Animator P +1",
        head="Mpaca's Cap",
        body="Mpaca's Doublet",
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Cessance Earring",
        right_ear="Telos Earring",
        left_ring="Niqmaddu Ring",
        right_ring="Epona's Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    }

    -------------------------------------DT
    --[[
        Offense Mode = MasterPet
        Hybrid Mode = DT
    ]]
    sets.engaged.MasterPet.DT = {
       -- Add your set here 
    }

    -------------------------------------Regen
    --[[
        Offense Mode = MasterPet
        Hybrid Mode = Regen
    ]]
    sets.engaged.MasterPet.Regen = {
        range="Animator P +1",
        head="Mpaca's Cap",
        body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        feet="Mpaca's Boots",
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Kyrene's Earring",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="C. Palug Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    }

    ----------------------------------------------------------------
    --  _____     _      ____        _          _____      _
    -- |  __ \   | |    / __ \      | |        / ____|    | |
    -- | |__) |__| |_  | |  | |_ __ | |_   _  | (___   ___| |_ ___
    -- |  ___/ _ \ __| | |  | | '_ \| | | | |  \___ \ / _ \ __/ __|
    -- | |  |  __/ |_  | |__| | | | | | |_| |  ____) |  __/ |_\__ \
    -- |_|   \___|\__|  \____/|_| |_|_|\__, | |_____/ \___|\__|___/
    --                                  __/ |
    --                                 |___/
    ----------------------------------------------------------------

    -------------------------------------Magic Midcast
    sets.midcast.Pet = {
       -- Add your set here 
    }

    sets.midcast.Pet.Cure = {
       -- Add your set here 
    }

    sets.midcast.Pet["Healing Magic"] = {
       -- Add your set here 
    }

    sets.midcast.Pet["Elemental Magic"] = {
       -- Add your set here 
    }

    sets.midcast.Pet["Enfeebling Magic"] = {
       -- Add your set here 
    }

    sets.midcast.Pet["Dark Magic"] = {
       -- Add your set here 
    }

    sets.midcast.Pet["Divine Magic"] = {
       -- Add your set here 
    }

    sets.midcast.Pet["Enhancing Magic"] = {
       -- Add your set here 
    }

    -------------------------------------Idle
    --[[
        This set will become default Idle Set when the Pet is Active 
        and sets.idle will be ignored
        Player = Idle and not fighting
        Pet = Idle and not fighting

        Idle Mode = Idle
    ]]
    sets.idle.Pet = {
       -- Add your set here 
    }

    --[[
        If pet is active and you are idle and pet is idle
        Player = idle and not fighting
        Pet = idle and not fighting

        Idle Mode = MasterDT
    ]]
    sets.idle.Pet.MasterDT = {
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring +1 +1",
    right_ring="Varar Ring +1 +1",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1246 Val: 4',}},    }

    -------------------------------------Enmity
    sets.pet = {} -- Not Used

    --Equipped automatically
    sets.pet.Enmity = {
       -- Add your set here 
    }

    --[[
        Activated by Alt+D or
        F10 if Physical Defense Mode = PetDT
    ]]
    sets.pet.EmergencyDT = {
        main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
        range="Animator P +1",
        ammo="Automat. Oil +3",
        head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        body={ name="Rao Togi +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
        neck="Shepherd's Chain",
        waist="Isa Belt",
        left_ear="Rimeice Earring",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="Overbearing Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1246 Val: 4',}},    }

    -------------------------------------Engaged for Pet Only
    --[[
      For Technical Users - This is layout of below
      sets.idle[idleScope][state.IdleMode][ Pet[Engaged] ][CustomIdleGroups] 

      For Non-Technical Users:
      If you the player is not fighting and your pet is fighting the first set that will activate is sets.idle.Pet.Engaged
      You can further adjust this by changing the HyrbidMode using Ctrl+F9 to activate the Acc/TP/DT/Regen/Ranged sets
    ]]
    --[[
        Idle Mode = Idle
        Hybrid Mode = Normal
    ]]
    sets.idle.Pet.Engaged = {
           range="Animator P +1",
          head={ name="Herculean Helm", augments={'Pet: Accuracy+9 Pet: Rng. Acc.+9','Pet: "Store TP"+11','Pet: CHR+2','Pet: "Mag.Atk.Bns."+8',}},
         body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
         hands={ name="Herculean Gloves", augments={'Pet: Mag. Acc.+25','Pet: "Store TP"+11','Pet: VIT+9','Pet: Attack+14 Pet: Rng.Atk.+14','Pet: "Mag.Atk.Bns."+5',}},
        legs={ name="Herculean Trousers", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Pet: "Store TP"+11',}},
         feet={ name="Herculean Boots", augments={'Pet: Accuracy+12 Pet: Rng. Acc.+12','Pet: "Store TP"+11','Pet: MND+2','Pet: "Mag.Atk.Bns."+13',}},
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Crep. Earring",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="Varar Ring +1",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    
   }

    --[[
        Idle Mode = Idle
        Hybrid Mode = Acc
    ]]
    sets.idle.Pet.Engaged.Acc = {
        main={ name="Xiucoatl", augments={'Path: C',}},
    range="Animator P +1",
    head={ name="Taeon Chapeau", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Taeon Gloves", augments={'Pet: Attack+23 Pet: Rng.Atk.+23','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Attack+22 Pet: Rng.Atk.+22','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    feet="Mpaca's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    }  
    --[[
        Idle Mode = Idle
        Hybrid Mode = TP
    ]]
    sets.idle.Pet.Engaged.TP = {
        main={ name="Xiucoatl", augments={'Path: C',}},
        range="Animator P +1",
        head={ name="Herculean Helm", augments={'Pet: Accuracy+9 Pet: Rng. Acc.+9','Pet: "Store TP"+11','Pet: CHR+2','Pet: "Mag.Atk.Bns."+8',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: Mag. Acc.+25','Pet: "Store TP"+11','Pet: VIT+9','Pet: Attack+14 Pet: Rng.Atk.+14','Pet: "Mag.Atk.Bns."+5',}},
    legs={ name="Herculean Trousers", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Pet: "Store TP"+11',}},
    feet={ name="Herculean Boots", augments={'Pet: Accuracy+12 Pet: Rng. Acc.+12','Pet: "Store TP"+11','Pet: MND+2','Pet: "Mag.Atk.Bns."+13',}},
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Rimeice Earring",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="C. Palug Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    }

    --[[        Idle Mode = Idle
        Hybrid Mode = DT
    ]]
    sets.idle.Pet.Engaged.DT = {
        main={ name="Xiucoatl", augments={'Path: C',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body={ name="Rao Togi +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
    
    }
    --[[
        Idle Mode = Idle
        Hybrid Mode = Regen
    ]]
    sets.idle.Pet.Engaged.Regen = {  
         main={ name="Ohtas", augments={'Accuracy+70','Pet: Accuracy+70','Pet: Haste+10%',}},
    range="Animator P +1",
    head={ name="Taeon Chapeau", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Taeon Gloves", augments={'Pet: Attack+23 Pet: Rng.Atk.+23','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Attack+22 Pet: Rng.Atk.+22','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    feet="Mpaca's Boots",
    neck="Shulmanu Collar",
    waist="Incarnation Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
        }

    --[[
        Idle Mode = Idle
        Hybrid Mode = Ranged
    ]]
    sets.idle.Pet.Engaged.Ranged ={

        main={ name="Ohtas", augments={'Accuracy+70','Pet: Accuracy+70','Pet: Haste+10%',}},
        range="Animator P +1",
        head="Mpaca's Cap",
        body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
        hands="Mpaca's Gloves",
        legs="Mpaca's Hose",
        feet="Mpaca's Boots",
        feet="Mpaca's Boots",
        neck="Shulmanu Collar",
        waist="Klouskap Sash +1",
        left_ear="Kyrene's Earring",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="C. Palug Ring",
        back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10',}},
        }
    

    -------------------------------------WS
    --[[
        WSNoFTP is the default weaponskill set used
    ]]
    sets.midcast.Pet.WSNoFTP = {
    head={ name="Taeon Chapeau", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    hands="Mpaca's Gloves",
    legs={ name="Taeon Tights", augments={'Pet: Attack+22 Pet: Rng.Atk.+22','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    feet="Mpaca's Boots",
    waist="Incarnation Sash",
    left_ring="Thurandaut Ring",right_ring="C. Palug Ring",
    left_ear="Kyrene's Earring",right_ear="Domes. Earring",
    
    
    }

    --[[
        If we have a pet weaponskill that can benefit from WSFTP
        then this set will be equipped
    ]]
    sets.midcast.Pet.WSFTP = {
         
        head="Karagoz Capello +1",
        hands="Mpaca's Gloves",
        legs={ name="Herculean Trousers", augments={'Pet: "Mag.Atk.Bns."+18','Pet: "Store TP"+7','Pet: DEX+12','Pet: Attack+14 Pet: Rng.Atk.+14',}},
        feet="Mpaca's Boots",
        right_ear="Enmerkar Earring",
        left_ring="Thurandaut Ring",
        right_ring="C. Palug Ring",
        back={ name="Dispersal Mantle", augments={'STR+1','Pet: TP Bonus+480',}},
    }

    --[[
        Base Weapon Skill Set
        Used by default if no modifier is found
    ]]
    sets.midcast.Pet.WS = {
    head={ name="Taeon Chapeau", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    hands="Mpaca's Gloves",
    legs={ name="Taeon Tights", augments={'Pet: Attack+22 Pet: Rng.Atk.+22','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    feet="Mpaca's Boots",
    waist="Incarnation Sash",
    left_ring="Thurandaut Ring",right_ring="C. Palug Ring",
    left_ear="Kyrene's Earring",right_ear="Domes. Earring",
    

    }

    --Chimera Ripper, String Clipper
    sets.midcast.Pet.WS["STR"] = set_combine(sets.midcast.Pet.WSNoFTP, {})

    -- Bone crusher, String Shredder
    sets.midcast.Pet.WS["VIT"] =
        set_combine(
        sets.midcast.Pet.WSNoFTP,
        {
            
           
         
        }
    )

    -- Cannibal Blade
    sets.midcast.Pet.WS["MND"] = set_combine(sets.midcast.Pet.WSNoFTP, {}
    )

    -- Armor Piercer, Armor Shatterer
    sets.midcast.Pet.WS["DEX"] = set_combine(sets.midcast.Pet.WSNoFTP, {
        }
    )

    -- Arcuballista, Daze
    sets.midcast.Pet.WS["DEXFTP"] =
        set_combine(
        sets.midcast.Pet.WSFTP,
        {
            head = Empy_Karagoz.Head_PTPBonus
        }
    )

    ---------------------------------------------
    --  __  __ _             _____      _
    -- |  \/  (_)           / ____|    | |
    -- | \  / |_ ___  ___  | (___   ___| |_ ___
    -- | |\/| | / __|/ __|  \___ \ / _ \ __/ __|
    -- | |  | | \__ \ (__   ____) |  __/ |_\__ \
    -- |_|  |_|_|___/\___| |_____/ \___|\__|___/
    ---------------------------------------------
    -- Town Set
    sets.idle.Town = {
        main="Tauret",
        ammo="Staunch Tathlum +1",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Hermes' Sandals +1",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        waist="Carrier's Sash",
        left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
        right_ear="Odnowa Earring",
        left_ring="Warden's Ring",
        right_ring="Defending Ring",
        back="Moonlight Cape",
    }

    -- Resting sets
    sets.resting = {
       -- Add your set here
    }

    sets.defense.MasterDT = sets.idle.MasterDT

    sets.defense.PetDT = {main="Tauret",
    ammo="Staunch Tathlum +1",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Eschan Stone",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Odnowa Earring",
    left_ring="Purity Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",}

    sets.defense.PetMDT = set_combine(sets.pet.EmergencyDT, {


    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Rao Kabuto +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    body={ name="Rao Togi +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    hands={ name="Rao Kote +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    legs={ name="Rao Haidate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    feet={ name="Rao Sune-Ate +1", augments={'Pet: HP+125','Pet: Accuracy+20','Pet: Damage taken -4%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Thurandaut Ring",
    right_ring="Overbearing Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','System: 1 ID: 1246 Val: 4',}},    })
end
add_to_chat(159,'Author Aragan PUP.Lua File (from Asura)')
add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == "WAR" then
        set_macro_page(9, 2)
    elseif player.sub_job == "NIN" then
        set_macro_page(9, 2)
    elseif player.sub_job == "DNC" then
        set_macro_page(9, 2)
    else
        set_macro_page(9, 2)
    end
end

