function get_sets()
    
    sets.weapons = {sub="Burtgang",main="Xiutleato",ammo="Excalibur"}
    
    sets.aegis = {sub={name="Aegis"}}
    sets.ochain = {sub={name="Ochain"}}
    sets.priwen = {sub={name="Priwen"}}
    current_shield = {name="Ochain"}
    
    sets.items = {sub="Echo Drops"}
    

	
    sets.Enmity = {ammo="Paeapua",
        head="Hero's Galea",neck="Katipo Charm +1",ear1="Trux Earring",ear2="Pluto's Pearl",
        body="Creed Cuirass +2",hands="Cab. Gauntlets +1",ring1="Eihwaz Ring",ring2="Provocare Ring",
        back="Earthcry Mantle",waist="Creed Baudrier",legs="Cab. Breeches +1",feet="Creed Sabatons +2"}
    
    sets.precast = {}
    sets.precast.FC = {ammo="Impatiens",
        head="Cizin Helm +1",ear1="Loquacious Earring",ear2="Moonshade Earring",hands="Buremte Gloves",
        ring1="Veneficium Ring",ring2="Lebeche Ring",legs="Blood Cuisses",feet="Ejekamal Boots"}
    
    sets.midcast = {}
    sets.midcast['Shield Bash'] = set_combine(sets.Enmity,sets.aegis,{hands="Caballarius Gauntlets +1",ear1="Knightly Earring"})
    sets.midcast.Chivalry = {head="Reverence Coronet +1",waist="Pythia Sash +1",
        body="Caballarius Surcoat +1",hands="Caballarius Gauntlets +1",ring1="Leviathan Ring",ring2="Leviathan Ring",ammo="Aqua Sachet",
        back="Tuilha Cape",legs="Caballarius Breeches +1",feet="Whirlpool Greaves",ear1="Lifestorm Earring",ear2="Pluto's Pearl"}
    sets.midcast.Sentinel = {feet="Cab. Leggings +1"}
    sets.midcast.Rampart = set_combine(sets.Enmity,{head="Cab. Coronet +1"})
    sets.midcast.Invincible = set_combine(sets.Enmity,{legs="Cab. Breeches +1"})
    sets.midcast.Fealty = {body="Cab. Surcoat +1"}
    sets.midcast['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.midcast.Cover={
        head="Rev. Coronet +1",
        body={ name="Cab. Surcoat +1", augments={'Enhances "Fealty" effect',}},
        hands={ name="Cab. Gauntlets +1", augments={'Enhances "Chivalry" effect',}},
        legs={ name="Cab. Breeches +1", augments={'Enhances "Invincible" effect',}},
        feet="Scamp's Sollerets",
    }
        
        
        
        
    sets.midcast['Chant du Cygne'] = {
        head="Quiahuiz Helm",neck="Thunder Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Mes. Haubergeon",hands="Umuthi Gloves",ring1="Ramuh Ring",ring2="Ramuh Ring",
        back="Rancorous Mantle",waist="Windbuffet Belt +1",legs="Hct. Subligar +1",feet="Vanir Boots",ammo="Jukukik Feather"}
        
    sets.midcast.Atonement = set_combine(sets.Enmity,{neck="Aqua Gorget",ear1="Moonshade Earring",
        body="Phorcys Korazin",waist="Aqua Belt",legs="Ogier's Breeches"})
        
    sets.midcast['Requiescat'] = {
        head="Quiahuiz Helm",neck="Soil Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Mes'yohi Haubergeon",hands="Umuthi Gloves",ring1="Leviathan Ring",ring2="Leviathan Ring",
        back="Atheling Mantle",waist="Shadow Belt",legs="Mes'yohi Slacks",feet="Whirlpool Greaves",ammo="Aqua Sachet"}
        
	 sets.midcast['Knights of Round'] = {
        head="Yaoyotl Helm",neck="Light Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Phorcys Korazin",hands="Buremte Gloves",ring1="Ifrit Ring +1",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Light Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
        
    sets.midcast.Resolution = {
        head="Yaoyotl Helm",neck="Soil Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Ifrit Ring +1",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Soil Belt",legs="Cab. Breeches +1",feet="Reverence Leggings +1"}
        
    sets.midcast.Torcleaver = {
        head="Yaoyotl Helm",neck="Light Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
        body="Cab. Surcoat +1",hands="Cab. Gauntlets +1",ring1="Ifrit Ring +1",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Light Belt",legs="Cab. Breeches +1",feet="Scamp's Sollerets"}
        
    sets.midcast['Ground Strike'] = {
        head="Yaoyotl Helm",neck="Soil Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Ifrit Ring +1",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Soil Belt",legs="Cab. Breeches +1",feet="Reverence Leggings +1"}
        
    sets.midcast.WS = {
        head="Yaoyotl Helm",neck="Aqua Gorget",ear1="Moonshade Earring",ear2="Brutal Earring",
        body="Phorcys Korazin",hands="Buremte Gloves",ring1="Ramuh Ring +1",ring2="Rajas Ring",
        back="Rancorous Mantle",waist="Windbuffet Belt +1",legs="Reverence Breeches +1",feet="Ejekamal Boots"}
        
	
    sets.midcast.WS = {
        head="Yaoyotl Helm",neck="Thunder Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Mes'yohi Haubergeon",hands="Buremte Gloves",ring1="Ramuh Ring",ring2="Rajas Ring",
        back="Rancorous Mantle",waist="Windbuffet Belt +1",legs="Hct. Subligar +1",feet="Ejekamal Boots"}
        
    
    sets.midcast.WS_Day = { head="Gavialis helm" }
    
    sets.midcast.Cure = {
        neck="Phalaina Locket",body="Reverence Surcoat +1",head="Shabti Armet +1",hands="Buremte Gloves",ring1="Eihwaz Ring",ring2="Kunaji Ring",
		legs="Rev. Breeches +1",feet="Cab. Leggings +1",ear1="Hospitaler Earring",ear2="Oneiros Earring",waist="Chuq'aba Belt",back="Fierabras's Mantle"}
    sets.midcast.Cure_4 = {
        neck="Phalaina Locket",body="Reverence Surcoat +1",head="Shabti Armet +1",hands="Buremte Gloves",ring1="Eihwaz Ring",ring2="Kunaji Ring",
		legs="Rev. Breeches +1",feet="Cab. Leggings +1",ear1="Hospitaler Earring",ear2="Oneiros Earring",waist="Chuq'aba Belt",back="Fierabras's Mantle"}
	
	sets.midcast.Phalanx = {sub="Priwen",legs="Reverence Breeches +1",body="Shabti Cuirass +1",neck="Colossus's Torque",waist="Olympus Sash",
		ear1="Andoaa Earring",ear2="Augmenting Earring",back="Merciful Cape"}
	
	sets.midcast.Enlight = {body="Rev. Surcoat +1",ear2="Beatific Earring",ear1="Divine Earring",waist="Bishop's Sash",back="Altruistic Cape",
		hands="Paragon Moufles",neck="Nesanica Torque"}
	
	sets.midcast.Stoneskin = {neck="Stone Gorget",hands="Stone Mufflers",waist="Siegel Sash",ear1="Earthcry Earring"}
    
    sets.aftercast = {}
    
    TP_sets = {'DD','DT'}
    TP_ind = 1
	
	sets.aftercast.non_DW = {sub=current_shield,ammo="Angha Gem",
        head="Reverence Coronet +1",neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Cab. Surcoat +1",hands="Rev. Gauntlets +1",ring1="Patricius Ring",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Windbuffet Belt +1",legs="Reverence Breeches +1",feet="Ejekamal Boots"}

    sets.aftercast.DW = {ammo="Ginsen",
        head="Gavialis Helm",neck="Lacono Necklace +1",ear1="Suppanomimi",ear2="Brutal Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Ifrit Ring +1",ring2="Rajas Ring",
        back="Rancorous Mantle",waist="Shetal Stone",legs="Cab. Breeches +1",feet="Ejekamal Boots"}
		
	sets.aftercast.DD = sets.aftercast.non_DW
	
    function sets.aftercast.wield(equip_sub)
		if equip_sub == 'Aegis' or equip_sub =='Ochain' then
			sets.aftercast.DD = sets.aftercast.non_DW
		elseif equip_sub == 'Bloodrain Strap' then
            sets.aftercast.DD = sets.aftercast.Ragnarok
        else
			sets.aftercast.DD = sets.aftercast.DW
		end
	end
        
    sets.aftercast.DT = {sub=current_shield,ammo="Angha Gem",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Cab. Surcoat +1",hands="Reverence Gauntlets +1",ring1="Patricius Ring",ring2="Dark Ring",
        back="Weard Mantle",waist="Flume Belt +1",legs="Cab. Breeches +1",feet="Reverence Leggings +1"}
    
    Idle_sets = {'Idle','Kiting','Supertanking'}
    Idle_ind = 1
    sets.aftercast.Idle = {sub=current_shield,ammo="Angha Gem",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Patricius Ring",ring2="Meridian Ring",
        back="Weard Mantle",waist="Phasmida Belt",legs="Reverence Breeches +1",feet="Ejekamal Boots"}
        
    sets.aftercast.Kiting = {sub=current_shield,ammo="Angha Gem",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Patricius Ring",ring2="Meridian Ring",
        back="Weard Mantle",waist="Phasmida Belt",legs="Blood Cuisses",feet="Ejekamal Boots"}
        
    sets.aftercast.Supertanking = {sub=current_shield,ammo="Angha Gem",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Colossus's Earring",ear2="Black Earring",
        body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring1="Patricius Ring",ring2="Dark Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Caballarius Breeches +1",feet="Cizin greaves +1"}
    
    
    sets.pretarget = {}
    sets.pretarget.HP_Down = set_combine(sets.aftercast.Idle,
        {head="Lithelimb Cap",body="Cab. Surcoat +1",hands="Cizin Mufflers +1",ring2="Dark Ring",waist="Flume Belt +1",legs="Cab. Breeches +1",ring1="Bifrost Ring"})

	sets.manual = {main="Buramenk'ah",sub="Aegis",head="Twilight Helm"}
	
    Cure_force = false
    send_command('input /macro book 20;wait .1;input /macro set 1')
    disable('main','sub')
    lock_mode = false
end

function pretarget(spell)
    if spell.name == 'Cure IV' or spell.name == 'Cure III' and player.max_hp - player.hp < 328 and spell.target and spell.target.name == player.name then
        equip(sets.pretarget.HP_Down)
    end
end

function precast(spell)
	sets.aftercast.wield(player.equipment.sub)
    if player.equipment.head == 'Twilight Helm' and player.equipment.body == 'Twilight Mail' then disable('head','body') end
    if spell.action_type == 'Magic' then
        equip(sets.precast.FC)
    end
end

function midcast(spell)
    midaction(false)
    if player.status =='Engaged' then
        equip(sets.aftercast[TP_sets[TP_ind]])
    else
        equip(sets.aftercast[Idle_sets[Idle_ind]])
    end
    
	if spell.type == 'JobAbility' then
		equip(sets.Enmity)
	end
    if sets.midcast[spell.name] then
        equip(sets.midcast[spell.name])
        day_equip(spell)
    elseif spell.type == 'WeaponSkill' then
        equip(sets.precast.WS)
        day_equip(spell)
    elseif string.find(spell.name,'Cure') then
        if spell.name == 'Cure 4' and spell.target.name == player.name then
            equip(sets.Enmity,sets.midcast.Cure_4)
        else
            equip(sets.Enmity,sets.midcast.Cure)
        end
    end
end

function day_equip(spell)
    if not spell.skillchain_a or spell.skillchain_a == '' then return end
    if (check_sc_properties(spell, "Light") or check_sc_properties(spell, "Fusion") or check_sc_properties(spell, "Liquefaction")) and world.day_element == 'Fire' then
    elseif (check_sc_properties(spell, "Light") or check_sc_properties(spell, "Fusion") or check_sc_properties(spell, "Transfixion")) and world.day_element == 'Light' then
    elseif (check_sc_properties(spell, "Light") or check_sc_properties(spell, "Fragmentation") or check_sc_properties(spell, "Detonation")) and world.day_element == 'Wind' then
    elseif (check_sc_properties(spell, "Light") or check_sc_properties(spell, "Fragmentation") or check_sc_properties(spell, "Impaction")) and world.day_element == 'Lightning' then
    elseif (check_sc_properties(spell, "Dark") or check_sc_properties(spell, "Distortion") or check_sc_properties(spell, "Reverberation")) and world.day_element == 'Water' then
    elseif (check_sc_properties(spell, "Dark") or check_sc_properties(spell, "Distortion") or check_sc_properties(spell, "Induration")) and world.day_element == 'Ice' then
    elseif (check_sc_properties(spell, "Dark") or check_sc_properties(spell, "Gravitation") or check_sc_properties(spell, "Scission")) and world.day_element == 'Earth' then
    elseif (check_sc_properties(spell, "Dark") or check_sc_properties(spell, "Gravitation") or check_sc_properties(spell, "Compression")) and world.day_element == 'Dark' then
    else
        return
    end
    equip(sets.midcast.WS_Day)
end

function check_sc_properties(spell,str)
    if spell.skillchain_a == str or spell.skillchain_b == str or spell.skillchain_c == str then return true end
    return false
end

function aftercast(spell)
    if player.status =='Engaged' then
        equip(sets.aftercast[TP_sets[TP_ind]])
    else
        equip(sets.aftercast[Idle_sets[Idle_ind]])
    end
end

function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
        equip(sets.aftercast[Idle_sets[Idle_ind]])
    elseif new == 'Engaged' then
        equip(sets.aftercast[TP_sets[TP_ind]])
    end
end

function buff_change(new,bool)
    if new == 'Reprisal' and bool then
        if current_shield.name == 'Ochain' then
            table.reassign(current_shield,sets.priwen.sub)
            equip({sub=current_shield})
        end
    elseif new == 'Reprisal' and not bool then
        if current_shield.name == 'Priwen' then
            table.reassign(current_shield,sets.ochain.sub)
            equip({sub=current_shield})
        end
    end
end

function self_command(command)
    if command == 'toggle TP set' then
        if TP_ind == 1 then
            TP_ind = 2
            send_command('@input /echo SOLO SET')
        elseif TP_ind == 2 then
            TP_ind = 1
            send_command('@input /echo DD SET')
        end
    elseif command == 'toggle Idle set' then
        if Idle_ind == 1 then
            Idle_ind = 2
            send_command('@input /echo KITING SET')
        elseif Idle_ind == 2 then
            Idle_ind = 3
            send_command('@input /echo SUPERTANKING SET')
        elseif Idle_ind == 3 then
            Idle_ind = 1
            send_command('@input /echo NORMAL SET')
        end
    elseif command == 'DT' then
        equip(sets.DT)
    elseif command == 'PDT Shield' then
        if buffactive['Reprisal'] then
            current_shield = table.reassign(current_shield,sets.priwen.sub)
        else
            current_shield = table.reassign(current_shield,sets.ochain.sub)
        end
        if not lock_mode then send_command('input /equip sub '..current_shield.name)
        else equip({sub=current_shield}) end
    elseif command == 'MDT Shield' then
        current_shield = table.reassign(current_shield,sets.aegis.sub)
        if not lock_mode then send_command('input /equip sub '..current_shield.name)
        else equip({sub=current_shield}) end
    end
end
