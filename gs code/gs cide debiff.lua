send_command("@input /echo <----- All Cumulative Magic Duration Effects Have Expired ----->")

    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)


function aftercast(spell, act, spellMap, eventArgs)
    if spell.action_type == 'Ability' then
        ac_JA(spell)
    elseif spell.action_type == 'Magic' then
		if Elemental_Aja:contains(spell.english) then	
			if (Aja_Duration_Boost == false or Aja_Current_Boost ~= spell.english) then
				Aja_Current_Boost = spell.english
				Aja_Table_ind = Aja_Table_ind + 1
				table.insert(Aja_Table, tostring(spell.target.name .. " #" .. Aja_Table_ind))
				send_command('timers create "'.. spell.english .. ': ' .. Aja_Table[Aja_Table_ind] .. '" 105 down spells/01015.png')
				Aja_Duration_Boost = true
				send_command('wait 105;input //gs c reset Aja_Duration Timer')
			end
		else
			ac_Magic(spell)
		end
    else
        ac_Item(spell)
    end
    ac_Global()
	
    --Countdowns--
    if not spell.interrupted then
        if spell.english == "Sleep" then
            send_command('wait 50;gs c -cd '..spell.name..': [Off In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Off!]')
			send_command('timers create "S1 ' ..tostring(spell.target.name).. ' " 60 down spells/00235.png')
		elseif spell.english == "Sleepga" then
            send_command('wait 50;gs c -cd '..spell.name..': [Off In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Off!]')
			send_command('timers create "S2 ' ..tostring(spell.target.name).. ' " 60 down spells/00273.png')
        elseif spell.english == "Sleep II" then
            send_command('wait 80;gs c -cd '..spell.name..': [Off In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Off!]')
			send_command('timers create "Sga ' ..tostring(spell.target.name).. ' " 90 down spells/00259.png')
        elseif spell.english == "Sleepga II" then
            send_command('wait 80;gs c -cd '..spell.name..': [Off In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Off!]')
			send_command('timers create "Sga 2 ' ..tostring(spell.target.name).. ' " 90 down spells/00274.png')
		elseif spell.english == 'Impact' then
				send_command('timers create "Impact ' ..tostring(spell.target.name).. ' " 180 down spells/00502.png')
        elseif Elemental_Debuffs:contains(spell.english) then
			if spell.english == 'Burn' then
				send_command('timers create "Burn ' ..tostring(spell.target.name).. ' " 180 down spells/00235.png')
			elseif spell.english == 'Choke' then
				send_command('timers create "Choke ' ..tostring(spell.target.name).. ' " 180 down spells/00237.png')
			elseif spell.english == 'Shock' then
				send_command('timers create "Shock ' ..tostring(spell.target.name).. ' " 180 down spells/00239.png')
			elseif spell.english == 'Frost' then
				send_command('timers create "Frost ' ..tostring(spell.target.name).. ' " 180 down spells/00236.png')
			elseif spell.english == 'Drown' then
				send_command('timers create "Drown ' ..tostring(spell.target.name).. ' " 180 down spells/00240.png')
			elseif spell.english == 'Rasp' then
				send_command('timers create "Rasp ' ..tostring(spell.target.name).. ' " 180 down spells/00238.png')
			end
		elseif spell.english == "Bind" then
            send_command('timers create "Bind" 60 down spells/00258.png')
		elseif spell.english == "Break" then
            send_command('timers create "Break Petrification" 33 down spells/00255.png')
		elseif spell.english == "Breakga" then
            send_command('timers create "Breakga Petrification" 33 down spells/00365.png') 
		end
   end
    
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
            if spell.english == "Sleep II" or spell.english == "Sleepga II" then -- Sleep II Countdown --
                send_command('wait 60;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
            elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
                send_command('wait 30;input /echo Sleep Effect: [WEARING OFF IN 30 SEC.];wait 15;input /echo Sleep Effect: [WEARING OFF IN 15 SEC.];wait 10;input /echo Sleep Effect: [WEARING OFF IN 5 SEC.]')
            elseif spell.english == "Break" or spell.english == "Breakga" then -- Break Countdown --
                send_command('wait 25;input /echo Break Effect: [WEARING OFF IN 5 SEC.]')
            elseif spell.english == "Paralyze" then -- Paralyze Countdown --
                 send_command('wait 115;input /echo Paralyze Effect: [WEARING OFF IN 5 SEC.]')
            elseif spell.english == "Slow" then -- Slow Countdown --
                send_command('wait 115;input /echo Slow Effect: [WEARING OFF IN 5 SEC.]')        
            end
        end
    end

    if spell.english:contains('Sleep') and not spell.interrupted then
        set_debuff_timer(spell)
    end
	if not spell.interrupted then
		if spell.english == "Bind" then
			send_command('timers create "Bind ' ..tostring(spell.target.name).. ' " 120 down spells/00258.png')
		elseif spell.english == "Gravity" then
			send_command('timers create "Gravity ' ..tostring(spell.target.name).. ' " 180 down spells/00216.png')
		elseif spell.english == "Gravity II" then
			send_command('timers create "Gravity II ' ..tostring(spell.target.name).. ' " 280 down spells/00216.png')
		end

            -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
	elseif spell.english == "Gravity" then
        send_command('@timers c "Gravity ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00216.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)

end

--rdm debuff correct code
enfeebling_magic = S{'Bind', 'Break', 'Distract', 'Distract II', 'Frazzle',
'Frazzle II', 'Gravity', 'Gravity II', 'Silence','Sleep', 'Sleep II', 'Sleepga', 'Distract III', 'Frazzle III', 'Poison II'}

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:lower(enfeebling_magic) and not spell.interrupted then
        set_debuff_timer(spell)
    end
end


function set_debuff_timer(spell)
    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then
        base = 60
    end

    if spell.en == "Gravity" then
        base = 110
    end
    if spell.en == "Gravity II" then
        base = 110
    end
	if spell.en == "Bind" then
        base = 40
    end
    if state.Buff.Saboteur then
        if state.NM.value then
            base = base * 1.25
        else
            base = base * 2
        end
    end

    -- Merit Points Duration Bonus
    base = base + self.merits.enfeebling_magic_duration*6

    -- Relic Head Duration Bonus
    if not ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        base = base + self.merits.enfeebling_magic_duration*3
    end

    -- Job Points Duration Bonus
    base = base + self.job_points.rdm.enfeebling_magic_duration

    --Enfeebling duration non-augmented gear total
    gear_mult = 1.40
    --Enfeebling duration augmented gear total
    aug_mult = 1.25
    --Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    empy_mult = 1 --from sets.midcast.Sleep

    if ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
        if buffactive.Stymie then
            base = base + self.job_points.rdm.stymie_effect
        end
        empy_mult = 1.35 --from sets.midcast.SleepMaxDuration
    end

    totalDuration = math.floor(base * gear_mult * aug_mult * empy_mult)

    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
	elseif spell.english == "Gravity" then
        send_command('@timers c "Gravity ' ..tostring(spell.target.name).. ' " ' ..totalDuration.. ' down spells/00216.png')
	elseif spell.english == "Gravity II" then
        send_command('@timers c "Gravity II ' ..tostring(spell.target.name).. ' " ' ..totalDuration.. ' down spells/00217.png')
	elseif spell.english == "Bind" then
        send_command('@timers c "Bind ' ..tostring(spell.target.name).. ' " ' ..totalDuration.. ' down spells/00258.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)

end


--blm debuff correct code

Elemental_Aja = S{'Stoneja', 'Waterja', 'Aeroja', 'Firaja', 'Blizzaja', 'Thundaja', 'Comet'}
Elemental_Debuffs = S {'Shock', 'Rasp', 'Choke', 'Frost', 'Burn', 'Drown'}
element_table = L{'Earth','Wind','Ice','Fire','Water','Lightning'}

if spell.action_type == 'Magic' then
    if Elemental_Aja:contains(spell.english) then	
        send_command('timers create "'.. spell.english .. '" 105 down spells/01015.png')
        send_command("@wait 105;input /echo <----- All Cumulative Magic Duration Effects Have Expired ----->")
    end
end
if not spell.interrupted then
    if spell.english == "Sleep" then
        send_command('timers create "Sleep ' ..tostring(spell.target.name).. ' " 60 down spells/00235.png')
    elseif spell.english == "Sleepga" then
        send_command('timers create "Sleepga ' ..tostring(spell.target.name).. ' " 60 down spells/00273.png')
    elseif spell.english == "Sleep II" then
        send_command('timers create "Sleep II ' ..tostring(spell.target.name).. ' " 90 down spells/00259.png')
    elseif spell.english == "Sleepga II" then
        send_command('timers create "Sleepga II ' ..tostring(spell.target.name).. ' " 90 down spells/00274.png')
    elseif spell.english == 'Impact' then
            send_command('timers create "Impact ' ..tostring(spell.target.name).. ' " 180 down spells/00502.png')
    elseif Elemental_Debuffs:contains(spell.english) then
        if spell.english == 'Burn' then
            send_command('timers create "Burn ' ..tostring(spell.target.name).. ' " 180 down spells/00235.png')
        elseif spell.english == 'Choke' then
            send_command('timers create "Choke ' ..tostring(spell.target.name).. ' " 180 down spells/00237.png')
        elseif spell.english == 'Shock' then
            send_command('timers create "Shock ' ..tostring(spell.target.name).. ' " 180 down spells/00239.png')
        elseif spell.english == 'Frost' then
            send_command('timers create "Frost ' ..tostring(spell.target.name).. ' " 180 down spells/00236.png')
        elseif spell.english == 'Drown' then
            send_command('timers create "Drown ' ..tostring(spell.target.name).. ' " 180 down spells/00240.png')
        elseif spell.english == 'Rasp' then
            send_command('timers create "Rasp ' ..tostring(spell.target.name).. ' " 180 down spells/00238.png')
        end
    elseif spell.english == "Bind" then
        send_command('timers create "Bind" 60 down spells/00258.png')
    elseif spell.english == "Break" then
        send_command('timers create "Break Petrification" 33 down spells/00255.png')
    elseif spell.english == "Breakga" then
        send_command('timers create "Breakga Petrification" 33 down spells/00365.png') 
    end
end
end


if not spell.interrupted and S{'Sleep', 'Sleep II'}:contains(spell.english) then
    local totalDuration = ?
    send_command('timers create "%s %s %d" %d down spells/%05d.png':format(spell.english, spell.target.name, spell.target.index, totalDuration, spell.id))
    send_command('timers create "Sleep II ' ..tostring(spell.target.name).. ' " 90 down spells/00259.png'  )
    send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png':format(spell.english, spell.target.name, spell.target.index, totalDuration, spell.id))


   send_command('timers create "%s %s %d" %d down spells/%05d.png':format(spell.english, spell.target.name, spell.target.index, 60, spell.id))

  --corect update debuff same name same spel work

   send_command('@timers c "Sleep II ['..spell.target.name..'] ' ..(spell.target.index).. ' " ' ..totalDuration.. ' down spells/00259.png':format(spell.english, spell.target.name, spell.target.index, totalDuration, spell.id))
