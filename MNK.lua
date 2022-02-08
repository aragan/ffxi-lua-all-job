function get_sets()

	send_command('bind f9 gs c toggle TP set')
	send_command('bind f10 gs c toggle Idle set')

	
	function file_unload()
      
 
        send_command('unbind ^f9')
        send_command('unbind ^f10')
		send_command('unbind ^f11')
		send_command('unbind ^f12')
       
        send_command('unbind !f9')
        send_command('unbind !f10')
		send_command('unbind !f11')
        send_command('unbind !f12')
 
        send_command('unbind f9')
        send_command('unbind f10')
        send_command('unbind f11')
        send_command('unbind f12')
 
       
 
	end	
		
	--Idle Sets--	
	sets.Idle = {}
	
	sets.Idle.index = {'Standard', 'DT'}
	Idle_ind = 1			
	
	sets.Idle.Standard = {
    ammo="Ginsen",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Cetl Belt",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back="Atheling Mantle",
	 }
						  
	sets.Idle.DT = { 
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Isa Belt",
    left_ear="Odnowa Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
	}
	
	
	--TP Sets--
	sets.TP = {
    ammo="Ginsen",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Cetl Belt",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back="Atheling Mantle",

	}

	sets.TP.index = {'Standard', 'Hybrid', 'DT'}
	TP_ind = 1
	
	sets.TP.Standard = { 
    ammo="Ginsen",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Moonbeam Nodowa",
    waist="Cetl Belt",
    left_ear="Cessance Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back="Atheling Mantle",
	}
						
	
	sets.TP.Hybrid = { 
		body={ name="Tatena. Harama. +1", augments={'Path: A',}},
		hands={ name="Tatena. Gote +1", augments={'Path: A',}},
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet={ name="Tatena. Sune. +1", augments={'Path: A',}},

	}
	

	sets.TP.DT = { 
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Nyame Mail",
    hands="Malignance Gloves",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Isa Belt",
    left_ear="Odnowa Earring",
    right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",
	}

	
	
		--Weaponskill Sets--
	sets.WS = {
       
    ammo="Knobkierrie",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+5','Accuracy+20 Attack+20','Weapon skill damage +10%',}},

	}
	
	sets.WS.VictorySmite = { }

	sets.WS.HowlingFist = { }

	sets.WS.RagingFist = { }
		
	sets.WS.ShijinSpiral = { 
    ammo="Falcon Eye",
    head="Malignance Chapeau",
    body={ name="Adhemar Jacket", augments={'DEX+10','AGI+10','Accuracy+15',}},
    hands={ name="Adhemar Wristbands", augments={'Accuracy+15','Attack+15','"Subtle Blow"+7',}},
    legs="Hiza. Hizayoroi +2",
    feet="Malignance Boots",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Ishvara Earring",
    right_ear="Telos Earring",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+5','Accuracy+20 Attack+20','Weapon skill damage +10%',}},

	}
	
	sets.WS.AsuranFists = { }
	
	sets.WS.TornadoKick = { }


		--Job Ability Sets--
	sets.JA = {}
	
	sets.JA.Chakra = { }
	
	sets.JA.Focus = { }
	
	sets.JA.Boost = { }
	
	sets.JA.Dodge = { }
	
	sets.JA.Impetus = {body="Bhikku Cyclas +1"}
	
	sets.JA.Mantra = {}
	
		--Fast Cast--
	
	sets.FC = {}
	
	sets.FC.precast = { }
	
	
	
	
	
	
	
	
	
end



function precast(spell)
	
	
	if spell.action_type == 'Magic' then
		equip(sets.FC.precast)
	end
	
	if spell.english == 'Victory Smite' then
		equip(sets.WS.VictorySmite)
	end
	if spell.english == 'Shijin Spiral' then
		equip(sets.WS.ShijinSpiral)
	end
	if spell.english == 'Tornado Kick' or spell.english == 'Dragon Kick' then
		equip(sets.WS.TornadoKick)
	end
	if spell.english == 'Howling Fist' then
		equip(sets.WS.HowlingFist)
	end 
	if spell.english == 'Raging Fists' then
		equip(sets.WS.RagingFist)
	end
	if spell.english == 'Asuran Fists' then
		equip(sets.WS.AsuranFists)
	end
	if spell.english == 'Focus' then	
		equip(sets.JA.Focus)
	end	
	if spell.english == 'Chakra' then	
		equip(sets.JA.Chakra)
	end
	if spell.english == 'Impetus' then	
		equip(sets.JA.Impetus)
	end
	if spell.english == 'Boost' then	
		equip(sets.JA.Boost)
	end	
	if spell.english == 'Dodge' then	
		equip(sets.JA.Dodge)
	end
	if buffactive["Impetus"] and spell.english == "Victory Smite"  then
      equip(
        set_combine(
          sets.WS[spell.english],
          sets.JA.Impetus)
		  )
	end
	
	
end
	


function aftercast(spell)
	if player.status == 'Engaged' then
		equip(sets.TP[sets.TP.index[TP_ind]])
	else
		equip(sets.Idle[sets.Idle.index[Idle_ind]])
	end
	if buffactive["Impetus"] then
        equip(sets.JA.Impetus)
      end
	
	if spell.action_type == 'Weaponskill' then
		add_to_chat(158,'TP Return: ['..tostring(player.tp)..']')
	end
end

function status_change(new,old)
	if new == 'Engaged' then
		equip(sets.TP[sets.TP.index[TP_ind]])
		if buffactive["Impetus"] then
        equip(sets.JA.Impetus)
		end
	else
		equip(sets.Idle[sets.Idle.index[Idle_ind]])
	end
end

function self_command(command)
	if command == 'toggle TP set' then
		TP_ind = TP_ind +1
		if TP_ind > #sets.TP.index then TP_ind = 1 end
		send_command('@input /echo <----- TP Set changed to '..sets.TP.index[TP_ind]..' ----->')
		equip(sets.TP[sets.TP.index[TP_ind]])
	elseif command == 'toggle Idle set' then
		Idle_ind = Idle_ind +1
		if Idle_ind > #sets.Idle.index then Idle_ind = 1 end
		send_command('@input /echo <----- Idle Set changed to '..sets.Idle.index[Idle_ind]..' ----->')
		equip(sets.Idle[sets.Idle.index[Idle_ind]])
	elseif command == 'equip TP set' then
		equip(sets.TP[sets.TP.index[TP_ind]])
	elseif command == 'equip Idle set' then
		equip(sets.Idle[sets.Idle.index[Idle_ind]])
	end
end
