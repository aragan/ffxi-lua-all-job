-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    ExtraSongsMode may take one of three values: None, Dummy, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy
    
    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.ExtraSongsMode = M{['description']='Extra Songs', 'None', 'Dummy', 'FullLength'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    -- For tracking current recast timers via the Timers plugin.
    custom_timers = {}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Sword', 'Dagger')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')


    
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 1
    
    -- Set this to false if you don't want to use custom timers.
    state.UseCustomTimers = M(true, 'Use Custom Timers')
    
    -- Additional local binds
    send_command('bind ^` gs c cycle ExtraSongsMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
end

include('organizer-lib')
-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {ring1="Prolix Ring",}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {main={
         name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    left_ear="Loquac. Earring",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",
    back="Solemnity Cape",})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        
    main="Arendsi Fleuret",
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    waist="Cascade Belt",
    left_ear="Loquac. Earring",
    right_ear="Andoaa Earring",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",})

    sets.precast.FC.BardSong = { main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    head="Fili Calot +1",
    body="Fili Hongreline +1",
    hands="Inyan. Dastanas +1",
    legs="Inyanga Shalwar +2",
    feet="Brioso Slippers +2",
    neck="Aoidos' Matinee",
    waist="Kobo Obi",
    left_ear="Loquac. Earring",
    right_ear="Musical Earring",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",
    back={ name="Intarabus's Cape", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},}

    sets.precast.FC.Daurdabla = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
        
    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {feet="Bihu Slippers"}
    sets.precast.JA.Troubadour = {body="Bihu Justaucorps"}
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        
    }
    
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Blistering Sallet +1",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        body="Ayanmo Corazza +2",
        hands="Lustr. Mittens +1",
        ring1="Hetairoi Ring",
        ring2="Epaminondas's Ring",
        back="Intarabus's Cape",
        waist="Fotia Belt",
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
    }
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,{ 
    head="Blistering Sallet +1",
    neck="Fotia Gorget",
    ear1="Moonshade Earring",
    ear2="Brutal Earring",
    body="Ayanmo Corazza +2",
    hands="Bunzi's Gloves",
    ring1="Hetairoi Ring",
    ring2="Epaminondas's Ring",
    back="Intarabus's Cape",
    waist="Fotia Belt",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,{
    head="Blistering Sallet +1",
    neck="Fotia Gorget",
    ear1="Moonshade Earring",
    ear2="Brutal Earring",
    body="Ayanmo Corazza +2",
    hands="Bunzi's Gloves",
    ring1="Hetairoi Ring",
    ring2="Begrudging Ring",
    back="Intarabus's Cape",
    waist="Fotia Belt",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS,{
    head="Blistering Sallet +1",
    neck="Fotia Gorget",
    ear1="Moonshade Earring",
    ear2="Ishvara Earring",
    body="Ayanmo Corazza +2",
    hands="Lustr. Mittens +1",
    ring1="Hetairoi Ring",
    ring2="Epaminondas's Ring",
    back="Intarabus's Cape",
    waist="Fotia Belt",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})

sets.precast.WS['Rudras Storm'] = set_combine(sets.precast.WS,{
    head="Blistering Sallet +1",
    neck="Fotia Gorget",
    ear1="Moonshade Earring",
    ear2="Ishvara Earring",
    body="Ayanmo Corazza +2",
    hands="Lustr. Mittens +1",
    ring1="Hetairoi Ring",
    ring2="Epaminondas's Ring",
    back="Intarabus's Cape",
    waist="Fotia Belt",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})

sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS,{
    head="C. Palug Crown",
    ear1="Moonshade Earring",
    ear2="Friomisi Earring",
    body="Ayanmo Corazza +2",
    hands="Lustr. Mittens +1",
    ring1="Hetairoi Ring",
    ring2="Epaminondas's Ring",
    back="Intarabus's Cape",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})

sets.precast.WS['Savage Blade '] = set_combine(sets.precast.WS,{
    head="Blistering Sallet +1",
    neck="Fotia Gorget",
    ear1="Moonshade Earring",
    ear2="Ishvara Earring",
    body="Ayanmo Corazza +2",
    hands="Lustr. Mittens +1",
    ring1="Hetairoi Ring",
    ring2="Epaminondas's Ring",
    back="Intarabus's Cape",
    waist="Sailfi Belt +1",
    legs="Lustr. Subligar +1",
    feet="Lustra. Leggings +1",
})
    
    
    -- Midcast Sets

    -- General set for recast times.
    sets.midcast.FastRecast = {ear2="Loquacious Earring",
        ring1="Prolix Ring",
        }
        
    -- Gear to enhance certain classes of songs.  No instruments added here since Gjallarhorn is being used.
    sets.midcast.Ballad = {legs="Aoidos' Rhing. +2"}
    sets.midcast.Lullaby = {hands="Brioso Cuffs"}
    sets.midcast.Madrigal = {head="Aoidos' Calot +2"}
    sets.midcast.March = {hands="Aoidos' Manchettes +2"}
    sets.midcast.Minuet = {body="Aoidos' Hongreline +2"}
    sets.midcast.Minne = {}
    sets.midcast.Paeon = {head="Brioso Roundlet +1"}
    sets.midcast.Carol = {head="Aoidos' Calot +2",
        body="Aoidos' Hongreline +2",hands="Aoidos' Manchettes +2",
        legs="Aoidos' Rhing. +2",feet="Aoidos' Cothrn. +2"}
    sets.midcast["Sentinel's Scherzo"] = {feet="Aoidos' Cothrn. +2"}
    sets.midcast['Magic Finale'] = {neck="Wind Torque",waist="Corvax Sash",legs="Aoidos' Rhing. +2"}

    sets.midcast.Mazurka = {range=info.ExtraSongInstrument}
    

    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEffect = {
        main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
    head="Fili Calot +1",
    body="Fili Hongreline +1",
    hands="Inyan. Dastanas +1",
    legs="Inyanga Shalwar +2",
    feet="Brioso Slippers +2",
    neck="Mnbw. Whistle +1",
    waist="Kobo Obi",
    left_ear="Loquac. Earring",
    right_ear="Musical Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Intarabus's Cape", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
}

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongDebuff = {
        range="Gjallarhorn",
        head="Fili Calot +1",
        body="Aoidos' Hongreline +2",
        hands="Aoidos' Manchettes +2",    
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +2",
        neck="Mnbw. Whistle +1",
        waist="Kobo Obi",
        left_ear="Digni. Earring",
        right_ear="Musical Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Intarabus's Cape", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},

    }


    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.ResistantSongDebuff = {
        range="Gjallarhorn",
        head="Fili Calot +1",
        body="Aoidos' Hongreline +2",
        hands="Aoidos' Manchettes +2",    
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +2",
        neck="Mnbw. Whistle +1",
        waist="Kobo Obi",
        left_ear="Digni. Earring",
        right_ear="Musical Earring",
        left_ring="Stikini Ring +1",
        right_ring="Stikini Ring +1",
        back={ name="Intarabus's Cape", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
    }

    -- Song-specific recast reduction
    sets.midcast.SongRecast = {ear2="Loquacious Earring",
        ring1="Prolix Ring",
        back="Harmony Cape",legs="Aoidos' Rhing. +2"}

    --sets.midcast.Daurdabla = set_combine(sets.midcast.FastRecast, sets.midcast.SongRecast, {range=info.ExtraSongInstrument})

    -- Cast spell with normal gear, except using Daurdabla instead
    sets.midcast.Daurdabla = {range=info.ExtraSongInstrument}

    -- Dummy song with Daurdabla; minimize duration to make it easy to overwrite.
    sets.midcast.DaurdablaDummy = {
        }

    -- Other general spells and classes.
    sets.midcast.Cure = {
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Chironic Doublet", augments={'"Mag.Atk.Bns."+5','"Cure" potency +10%','MND+4','Mag. Acc.+1',}},
    hands={ name="Chironic Gloves", augments={'"Cure" potency +7%','MND+9','Mag. Acc.+5','"Mag.Atk.Bns."+5',}},
    legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
    left_ear="Loquac. Earring",
    right_ear="Mendi. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Kishar Ring",
    back="Solemnity Cape",
}
        
    sets.midcast.Curaga = sets.midcast.Cure
        
    sets.midcast.Stoneskin = {
        }
        
    sets.midcast.Cursna = {
        neck="Malison Medallion",
        hands="Hieros Mittens",ring1="Ephedra Ring"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main=gear.Staff.HMP, 
       }
    
    
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Loricate Torque +1", augments={'Path: A',}},
        back="Moonlight Cape",
    }

    sets.idle.PDT = {
       
    }

    sets.idle.Town = {}
    
    sets.idle.Weak = {
        
    }
    
    
    -- Defense sets

    sets.defense.PDT = {
        head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    back="Moonlight Cape",
    }

    sets.defense.MDT = {
        
    }

    sets.Kiting = {feet="Aoidos' Cothurnes +2"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {

    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Bunzi's Gloves",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Lissome Necklace",
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ear="Cessance Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    -- Sets with weapons defined.
    sets.engaged.Dagger = {
        main="Tauret",
        sub="Gleti's Knife",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.engaged.Sword = {
        main="Naegling",
        sub="Gleti's Knife",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Bunzi's Gloves",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Lissome Necklace",
        waist="Reiki Yotai",
        left_ear="Suppanomimi",
        right_ear="Cessance Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        if state.ExtraSongsMode.value == 'FullLength' then
            equip(sets.midcast.Daurdabla)
        end

        state.ExtraSongsMode:reset()
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.interrupted then
        if spell.target and spell.target.type == 'SELF' then
            adjust_timers(spell, spellMap)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','ammo')
        else
            enable('main','sub','ammo')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
   
end


-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    elseif state.ExtraSongsMode.value == 'Dummy' then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end


-- Function to create custom buff-remaining timers with the Timers plugin,
-- keeping only the actual valid songs rather than spamming the default
-- buff remaining timers.
function adjust_timers(spell, spellMap)
    if state.UseCustomTimers.value == false then
        return
    end
    
    local current_time = os.time()
    
    -- custom_timers contains a table of song names, with the os time when they
    -- will expire.
    
    -- Eliminate songs that have already expired from our local list.
    local temp_timer_list = {}
    for song_name,expires in pairs(custom_timers) do
        if expires < current_time then
            temp_timer_list[song_name] = true
        end
    end
    for song_name,expires in pairs(temp_timer_list) do
        custom_timers[song_name] = nil
    end
    
    local dur = calculate_duration(spell.name, spellMap)
    if custom_timers[spell.name] then
        -- Songs always overwrite themselves now, unless the new song has
        -- less duration than the old one (ie: old one was NT version, new
        -- one has less duration than what's remaining).
        
        -- If new song will outlast the one in our list, replace it.
        if custom_timers[spell.name] < (current_time + dur) then
            send_command('timers delete "'..spell.name..'"')
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        end
    else
        -- Figure out how many songs we can maintain.
        local maxsongs = 2
        if player.equipment.range == info.ExtraSongInstrument then
            maxsongs = maxsongs + info.ExtraSongs
        end
        if buffactive['Clarion Call'] then
            maxsongs = maxsongs + 1
        end
        -- If we have more songs active than is currently apparent, we can still overwrite
        -- them while they're active, even if not using appropriate gear bonuses (ie: Daur).
        if maxsongs < table.length(custom_timers) then
            maxsongs = table.length(custom_timers)
        end
        
        -- Create or update new song timers.
        if table.length(custom_timers) < maxsongs then
            custom_timers[spell.name] = current_time + dur
            send_command('timers create "'..spell.name..'" '..dur..' down')
        else
            local rep,repsong
            for song_name,expires in pairs(custom_timers) do
                if current_time + dur > expires then
                    if not rep or rep > expires then
                        rep = expires
                        repsong = song_name
                    end
                end
            end
            if repsong then
                custom_timers[repsong] = nil
                send_command('timers delete "'..repsong..'"')
                custom_timers[spell.name] = current_time + dur
                send_command('timers create "'..spell.name..'" '..dur..' down')
            end
        end
    end
end

-- Function to calculate the duration of a song based on the equipment used to cast it.
-- Called from adjust_timers(), which is only called on aftercast().
function calculate_duration(spellName, spellMap)
    local mult = 1
    if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
    if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
    
    if player.equipment.main == "Carnwenhan" then mult = mult + 0.1 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
    if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
    if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
    if player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if player.equipment.legs == "Mdk. Shalwar +1" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
    if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
    
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet" then mult = mult + 0.1 end
    if spellMap == 'Paeon' and player.equipment.head == "Brioso Roundlet +1" then mult = mult + 0.1 end
    if spellMap == 'Madrigal' and player.equipment.head == "Aoidos' Calot +2" then mult = mult + 0.1 end
    if spellMap == 'Minuet' and player.equipment.body == "Aoidos' Hngrln. +2" then mult = mult + 0.1 end
    if spellMap == 'March' and player.equipment.hands == 'Ad. Mnchtte. +2' then mult = mult + 0.1 end
    if spellMap == 'Ballad' and player.equipment.legs == "Aoidos' Rhing. +2" then mult = mult + 0.1 end
    if spellName == "Sentinel's Scherzo" and player.equipment.feet == "Aoidos' Cothrn. +2" then mult = mult + 0.1 end
    
    if buffactive.Troubadour then
        mult = mult*2
    end
    if spellName == "Sentinel's Scherzo" then
        if buffactive['Soul Voice'] then
            mult = mult*2
        elseif buffactive['Marcato'] then
            mult = mult*1.5
        end
    end
    
    local totalDuration = math.floor(mult*120)

    return totalDuration
end


-- Examine equipment to determine what our current TP weapon is.
function pick_tp_weapon()

end

-- Function to reset timers.
function reset_timers()
    for i,v in pairs(custom_timers) do
        send_command('timers delete "'..i..'"')
    end
    custom_timers = {}
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 2)
end


windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)

