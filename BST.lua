-------------------------------------------------------------------------------------------------------------------
-- Last Revised: Jul. 4th, 2018 
--
-- alt+F8 cycles through designated Jug Pets
-- ctrl+F8 toggles Monster Correlation between Neutral and Favorable
-- 'Windows Key'+F8 switches between Pet stances for Master/Pet hybrid gearsets
-- alt+= cycles through Pet Food types
-- ctrl+= can swap in the usage of Chaac Belt for Treasure Hunter on common subjob abilities.
-- ctrl+F11 cycles between Magical Defense Modes
--
-- General Gearswap Commands:
-- F9 cycles Accuracy modes
-- ctrl+F9 cycles Hybrid modes
-- 'Windows Key'+F9 cycles Weapon Skill modes
-- F10 equips Physical Defense
-- alt+F10 toggles Kiting on or off
-- ctrl+F10 cycles Physical Defense modes
-- F11 equips Magical Defense
-- alt+F12 turns off Defense modes
-- ctrl+F12 cycles Idle modes
--
-- Keep in mind that any time you Change Jobs/Subjobs, your Pet/Pet Food/etc. reset to default options.
-- F12 will list your current options.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
	include('organizer-lib')
end

function job_setup()
	state.Buff['Killer Instinct'] = buffactive['Killer Instinct'] or false
	state.Buff.Doomed = buffactive.doomed or false
	send_command('wait 2;input /lockstyleset 200')
	get_combat_form()
end

function user_setup()
        state.OffenseMode:options('Normal', 'Shield', 'MedAcc', 'MedAccHaste', 'HighAcc', 'HighAccHaste')
        state.HybridMode:options('Normal', 'Hybrid')
        state.WeaponskillMode:options('Normal', 'WSMedAcc', 'WSHighAcc')
        state.CastingMode:options('Normal')
        state.IdleMode:options('Normal', 'MNormal', 'MDTMaster', 'Turtle', 'MEva')
        state.RestingMode:options('Normal')
        state.PhysicalDefenseMode:options('PDT', 'PetPDT', 'Reraise', 'Killer')
        state.MagicalDefenseMode:options('PetMDT', 'MDTShell', 'MDT')

        -- 'Out of Range' distance; WS will auto-cancel
        target_distance = 6

        -- Set up Jug Pet cycling and keybind Alt+F8
        -- INPUT PREFERRED JUG PETS HERE
        state.JugMode = M{['description']='Jug Mode', 'ChoralLeera',
                }
        send_command('bind !f8 gs c cycle JugMode')

	-- Set up Monster Correlation Modes and keybind Ctrl+F8
        state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral', 'DA', 'Favorable', 'Killer', 'HighAcc', 'ArktoiAcc', 'MaxAcc', 'Vagary'}
        send_command('bind ^f8 gs c cycle CorrelationMode')

        -- Set up Pet Modes for Hybrid sets and keybind 'Windows Key'+F8
        state.PetMode = M{['description']='Pet Mode', 'Normal', 'PetStance', 'PetTank'}
        send_command('bind @f8 gs c cycle PetMode')

	-- Keybind Ctrl+F11 to cycle Magical Defense Modes
	send_command('bind ^f11 gs c cycle MagicalDefenseMode')

	-- Set up Reward Modes and keybind alt+=
        state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Zeta', 'Eta'}
        send_command('bind != gs c cycle RewardMode')

        -- Set up Treasure Modes and keybind Ctrl+=
        state.TreasureMode = M{['description']='Treasure Mode', 'Tag', 'Normal'}
        send_command('bind ^= gs c cycle TreasureMode')

-- Complete list of Ready moves to use with Sic & Ready Recast -5 Desultor Tassets.
ready_moves_to_check = S{'Sic','Whirl Claws','Dust Cloud','Foot Kick','Sheep Song','Sheep Charge','Lamb Chop',
	'Rage','Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang',
	'Roar','Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Venom','Geist Wall','Toxic Spit',
	'Numbing Noise','Nimble Snap','Cyclotail','Spoil','Rhino Guard','Rhino Attack','Power Attack',
	'Hi-Freq Field','Sandpit','Sandblast','Venom Spray','Mandibular Bite','Metallic Body','Bubble Shower',
	'Bubble Curtain','Scissor Guard','Big Scissors','Grapple','Spinning Top','Double Claw','Filamented Hold',
	'Frog Kick','Queasyshroom','Silence Gas','Numbshroom','Spore','Dark Spore','Shakeshroom','Blockhead',
	'Secretion','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics','??? Needles',
	'Needleshot','Chaotic Eye','Blaster','Scythe Tail','Ripper Fang','Chomp Rush','Intimidate','Recoil Dive',
	'Water Wall','Snow Cloud','Wild Carrot','Sudden Lunge','Spiral Spin','Noisome Powder','Wing Slap',
	'Beak Lunge','Suction','Drainkiss','Acid Mist','TP Drainkiss','Back Heel','Jettatura','Choke Breath',
	'Fantod','Charged Whisker','Purulent Ooze','Corrosive Ooze','Tortoise Stomp','Harden Shell','Aqua Breath',
	'Sensilla Blades','Tegmina Buffet','Molting Plumage','Swooping Frenzy','Pentapeck','Sweeping Gouge',
	'Zealous Snort','Somersault ','Tickling Tendrils','Stink Bomb','Nectarous Deluge','Nepenthic Plunge',
        'Pecking Flurry','Pestilent Plume','Foul Waters','Spider Web','Sickle Slash','Frogkick','Ripper Fang','Scythe Tail','Chomp Rush','Infected Leech','Gloom Spray'}

breath_ready_moves = S{
	}
		
mab_ready_moves = S{
	 'Cursed Sphere','Venom','Toxic Spit','Molting Plumage',
	 'Venom Spray','Bubble Shower',
	 'Plague Breath','Fireball',
	 'Snow Cloud','Silence Gas','Dark Spore',
	 'Charged Whisker','Aqua Breath','Stink Bomb'
	  ,'Nepenthic Plunge','Foul Waters','Dust Cloud','Corrosive Ooze'}

macc_ready_moves = S{'Sheep Song','Scream','Dream Flower','Roar','Gloeosuccus','Palsy Pollen',
	 'Soporific','Geist Wall','Numbing Noise','Spoil','Hi-Freq Field',
	 'Sandpit','Sandblast','Filamented Hold',
	 'Spore','Infrasonics','Chaotic Eye',
	 'Blaster','Intimidate','Noisome Powder','Acid Spray','TP Drainkiss','Jettatura','Spider Web',
	 'Molting Plumage','Swooping Frenzy',
	 'Pestilent Plume','Nectarous Deluge','Infected Leech','Gloom Spray','Purulent Ooze'}
		
-- List of abilities to reference for applying Treasure Hunter +1 via Chaac Belt.
abilities_to_check = S{'Feral Howl','Quickstep','Box Step','Stutter Step','Desperate Flourish','Violent Flourish',
	'Animated Flourish','Provoke','Dia','Dia II','Flash','Bio','Bio II','Sleep','Sleep II',
	'Drain','Aspir','Dispel','Steal','Mug','Stone'}
end

function file_unload()
	if binds_on_unload then
		binds_on_unload()
	end

	-- Unbinds the Jug Pet, Reward, Correlation, Treasure, PetMode, MDEF Mode hotkeys.
	send_command('unbind !=')
	send_command('unbind ^=')
	send_command('unbind !f8')
	send_command('unbind ^f8')
	send_command('unbind @f8')
	send_command('unbind ^f11')
end

-- BST gearsets
function init_gear_sets()
	-- PRECAST SETS
        sets.precast.JA['Killer Instinct'] = {head="Ankusa Helm +1"}
		
		sets.precast.JA['Bestial Loyalty'] = {
				hands={ name="Ankusa Gloves +1", augments={'Enhances "Beast Affinity" effect',}},
				body="Mirke Wardecors",
				feet="Adaman Sollerets",
				head="Acro Helm",
				legs={ name="Acro Breeches", augments={'"Call Beast" ability delay -4',}},}
		
		sets.precast.JA['Call Beast'] = sets.precast.JA['Bestial Loyalty']
		
        sets.precast.JA.Familiar = {legs="Ankusa Trousers +2"}
		
		sets.precast.JA.Tame = {head="Totemic Helm +1",ear1="Tamer's Earring",legs="Stout Kecks"}
		
		sets.precast.JA.Spur = {main={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
		sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
		feet="Nukumi Ocreae +1",back="Artio's Mantle"
	}

        sets.precast.JA['Feral Howl'] = {
				ammo="Plumose Sachet",
				head="Seiokona Beret",
				neck="Voltsurge Torque",
				ear1="Gwati Earring",
				ear2="Enchanter Earring +1",
				body="Ankusa Jackcoat +2",
				hands="Sombra Mittens +1",
				ring1="Perception Ring",
				ring2="Sangoma Ring",
				back="Aput Mantle +1",
				waist="Salire Belt",
				legs="Iuitl Tights +1",
				feet="Scamp's Sollerets"}

		sets.precast.JA.Reward = {
				main="Mdomo Axe +1",
    ammo="Pet Food Theta",
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet={ name="Ankusa Gaiters +1", augments={'Enhances "Beast Healer" effect',}},
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	
	
	sets.precast.JA.Charm = {
				ammo="Tsar's Egg",
				head="Ankusa Helm +1",
				neck="Shulmanu Collar",
				ear1="Enmerkar Earring",
				ear2="Handler's Earring +1",
				body="Totemic Jackcoat +3",
				hands="Totemic Gloves +1",
				ring1="Dawnsoul Ring",
				ring2="Carbuncle Ring",
				back="Aisance Mantle +1",
				waist="Aristo Belt",
				legs="Ankusa Trousers +2",
				feet="Ankusa Gaiters +1"}

        -- CURING WALTZ
        sets.precast.Waltz = {
				head="Highwing Helm",
				neck="Shulmanu Collar",
				ear1="Enmerkar Earring",
				ear2="Handler's Earring +1",
				body="Totemic Jackcoat +3",
				hands="Buremte Gloves",
				ring1="Dawnsoul Ring",
				ring2="Dawnsoul Ring",
				back="Oneiros Cappa",
				waist="Aristo Belt",
				legs="Zoar Subligar +1",
				feet="Whirlpool Greaves"}
                
        -- HEALING WALTZ
        sets.precast.Waltz['Healing Waltz'] = {body="Passion Jacket",}

	-- STEPS
	
	
	sets.precast.Step = {
				ammo="Ginsen",
				head="Tali'ah Turban +2",
				body="Tali'ah Manteel +2",
				hands="Tali'ah Gages +2",
				legs="Tali'ah Seraweels +2",
				feet="Tali'ah Crackows +2",
				neck="Sanctity Necklace",
				waist="Eschan Stone",
				left_ear="Lifestorm Earring",
				right_ear="Psystorm Earring",
				left_ring="Etana Ring",
				right_ring="Varar Ring +1 +1",
				back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}}

	-- VIOLENT FLOURISH
	sets.precast.Flourish1 = {}
	sets.precast.Flourish1['Violent Flourish'] = {
				main="Tri-edge",
				ammo="Ginsen",
				head="Tali'ah Turban +2",
				body="Tali'ah Manteel +2",
				hands="Tali'ah Gages +2",
				legs="Tali'ah Seraweels +2",
				feet="Tali'ah Crackows +2",
				neck="Sanctity Necklace",
				waist="Eschan Stone",
				left_ear="Lifestorm Earring",
				right_ear="Psystorm Earring",
				left_ring="Etana Ring",
				right_ring="Varar Ring +1 +1",
				back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},}

        sets.precast.FC = {
				ammo="Sapience Orb",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                left_ear="Etiolation Earring",
                right_ear="Loquac. Earring",
                left_ring="Thurandaut Ring",
                right_ring="Prolix Ring",}
				
        sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
				
			    ammo="Sapience Orb",
                body="Passion Jacket",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                left_ear="Etiolation Earring",
                right_ear="Loquac. Earring",
                left_ring="Thurandaut Ring",
                right_ring="Prolix Ring",})
				
		sets.precast.FC.Cure = set_combine(sets.precast.FC, {
				ammo="Sapience Orb",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                left_ear="Etiolation Earring",
                right_ear="Loquac. Earring",
                left_ring="Thurandaut Ring",
                right_ring="Prolix Ring",
				})
			

        -- MIDCAST SETS
        sets.midcast.FastRecast = {
				main="Shukuyu's Scythe",
				ring2="Lebeche Ring",
				ammo="Impatiens",
				neck="Voltsurge Torque",
				head={ name="Taeon Chapeau", augments={'"Fast Cast"+2',}},
				body={ name="Taeon Tabard", augments={'Attack+20','"Fast Cast"+5','VIT+10',}},
				hands="Leyline Gloves",
				back={ name="Artio's Mantle", augments={'MND+20','"Fast Cast"+10',}},
				legs={ name="Taeon Tights", augments={'Pet: DEF+17','"Fast Cast"+4',}},
				feet={ name="Taeon Boots", augments={'"Fast Cast"+5',}},
				ring1="Prolix Ring",
				waist="Klouskap Sash",}
				
 
        sets.midcast.Utsusemi = sets.midcast.FastRecast

	sets.midcast.Cure = {
			main={ name="Kumbhakarna", augments={'"Cure" potency +13%',}},
			ring1="Sirona's Ring",
			head={ name="Taeon Chapeau", augments={'"Cure" potency +4%',}},
			body="Jumalik Mail",
			hands="Leyline Gloves",
			legs={ name="Taeon Tights", augments={'"Fast Cast"+5',}},
			feet={ name="Taeon Boots", augments={'"Cure" potency +4%',}},
			sub="Beatific Shield +1",
			neck="Phalaina Locket",
			waist="Gishdubar Sash",
			ear2="Mendi. Earring",
			ring2="Haoma's Ring",
			back="Solemnity Cape",}

	sets.midcast.Curaga = sets.midcast.Cure

	sets.midcast.Stoneskin = {
			head="Anwig Salade",
			neck="Stone Gorget",
			ear1="Earthcry Earring",
			ear2="Handler's Earring +1",
			body={ name="Acro Surcoat", augments={'Pet: DEF+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
			hands="Stone Mufflers",
			ring1="Thurandaut Ring",
			ring2="Leviathan Ring +1",
			back="Pastoralist's Mantle",
			waist="Isa Belt",
			legs="Haven Hose",
			feet={ name="Acro Leggings", augments={'Pet: DEF+23','Pet: "Regen"+3','Pet: Damage taken -3%',}},}
	
	sets.midcast.Refresh = {
			main="Izizoeksi",
			head="Anwig Salade",
			neck="Shulmanu Collar",
			ammo="Demonry Core",
			ear2="Handler's Earring +1",
			ring1="Thurandaut Ring",
			body={ name="Acro Surcoat", augments={'Pet: DEF+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
			hands={ name="Acro Gauntlets", augments={'Pet: DEF+20','Pet: "Regen"+3','Pet: Damage taken -4%',}},
			legs="Nukumi Quijotes +1",
			feet={ name="Acro Leggings", augments={'Pet: DEF+23','Pet: "Regen"+3','Pet: Damage taken -3%',}},
			back="Pastoralist's Mantle",
			waist="Gishdubar Sash",
			ring2="Lebeche Ring",
			ear1="Enmerkar Earring",}
			
	sets.midcast.Haste = {
			main="Izizoeksi",
			head="Anwig Salade",
			neck="Shulmanu Collar",
			ammo="Demonry Core",
			ear2="Handler's Earring +1",
			ring1="Thurandaut Ring",
			body={ name="Acro Surcoat", augments={'Pet: DEF+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
			hands={ name="Acro Gauntlets", augments={'Pet: DEF+20','Pet: "Regen"+3','Pet: Damage taken -4%',}},
			legs="Nukumi Quijotes +1",
			feet={ name="Acro Leggings", augments={'Pet: DEF+23','Pet: "Regen"+3','Pet: Damage taken -3%',}},
			back="Pastoralist's Mantle",
			waist="Isa Belt",
			ring2="Lebeche Ring",
			ear1="Enmerkar Earring",}
			
	sets.midcast.Flash = {
			main="Shukuyu's Scythe",
			head="Jumalik Helm",
			body="Jumalik Mail",
			hands={ name="Leyline Gloves", augments={'Accuracy+1','Mag. Acc.+5','"Mag.Atk.Bns."+5','"Fast Cast"+1',}},
			neck="Voltsurge Torque",
			legs="Augury Cuisses",
			ear1={ name="Moonshade Earring", augments={'Mag. Acc.+4','Latent effect: "Refresh"+1',}},
			back="Izdubar Mantle",}

	sets.midcast.Cursna = set_combine(sets.midcast.FastRecast, {
			ring1="Haoma's Ring",
			neck="Malison Medallion",
			waist="Gishdubar Sash",
			legs="Augury Cuisses",
			ring2="Haoma's Ring"})

	sets.midcast.Protect = {ring2="Lebeche Ring"}
	sets.midcast.Protectra = sets.midcast.Protect

	sets.midcast.Shell = {ring2="Lebeche Ring"}
	sets.midcast.Shellra = sets.midcast.Shell

	sets.midcast['Enfeebling Magic'] = {
			main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
			sub="Beatific Shield +1",
			range="Aureole",
			head="Tali'ah Turban +2",
			body="Tali'ah Manteel +2",
			hands="Tali'ah Gages +2",
			legs="Tali'ah Seraweels +2",
			feet="Tali'ah Crackows +2",
			neck="Adad Amulet",
			waist="Eschan Stone",
			left_ear="Psystorm Earring",
			right_ear="Lifestorm Earring",
			left_ring="Sangoma Ring",
			right_ring="Etana Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},}

	sets.midcast['Divine Magic'] = {
			main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
			sub="Beatific Shield +1",
			ammo="Plumose Sachet",
			head="Tali'ah Turban +2",
			body="Tali'ah Manteel +2",
			hands="Tali'ah Gages +2",
			legs="Tali'ah Seraweels +2",
			feet="Tali'ah Crackows +2",
			neck="Adad Amulet",
			waist="Eschan Stone",
			left_ear="Psystorm Earring",
			right_ear="Lifestorm Earring",
			left_ring="Sangoma Ring",
			right_ring="Etana Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},}		
			
	sets.midcast['Dark Magic'] = {
			main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
			sub="Beatific Shield +1",
			ammo="Plumose Sachet",
			head="Tali'ah Turban +2",
			body="Tali'ah Manteel +2",
			hands="Tali'ah Gages +2",
			legs="Tali'ah Seraweels +2",
			feet="Tali'ah Crackows +2",
			neck="Adad Amulet",
			waist="Eschan Stone",
			left_ear="Psystorm Earring",
			right_ear="Lifestorm Earring",
			left_ring="Sangoma Ring",
			right_ring="Etana Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},}		
			
	sets.midcast['Elemental Magic'] = {
			main={ name="Malevolence", augments={'INT+10','Mag. Acc.+10','"Mag.Atk.Bns."+10','"Fast Cast"+5',}},
			sub="Beatific Shield +1",
			ammo="Plumose Sachet",
			head="Tali'ah Turban +2",
			body="Tali'ah Manteel +2",
			hands="Tali'ah Gages +2",
			legs="Tali'ah Seraweels +2",
			feet="Tali'ah Crackows +2",
			neck="Adad Amulet",
			waist="Eschan Stone",
			left_ear="Psystorm Earring",
			right_ear="Lifestorm Earring",
			left_ring="Sangoma Ring",
			right_ring="Etana Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},}
			
	sets.midcast.Stun = set_combine(sets.midcast['Elemental Magic'], {
				main={ name="Shukuyu's Scythe", augments={'INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+9','"Fast Cast"+4',}},
				sub="Beatific Shield +1",
				ammo="Plumose Sachet",
				ear1="Psystorm Earring",
				ring1="Etana Ring",
				head="Tali'ah Turban +2",
				body="Tali'ah Manteel +2",
				hands="Tali'ah Gages +2",
				legs="Tali'ah Seraweels +2",
				feet="Tali'ah Crackows +2",
				neck="Voltsurge Torque",
				waist="Eschan Stone",
				ear2="Lifestorm Earring",
				ring2="Sangoma Ring",
				back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},
				})
				
		sets.precast.FC.Stun = set_combine(sets.precast.FC, {
				main={ name="Shukuyu's Scythe", augments={'INT+9','Mag. Acc.+10','"Mag.Atk.Bns."+9','"Fast Cast"+4',}},
				sub="Beatific Shield +1",
				ammo="Plumose Sachet",
				ear1="Psystorm Earring",
				ring1="Etana Ring",
				head="Jumalik Helm",
				body={ name="Taeon Tabard", augments={'Attack+20','"Fast Cast"+5','VIT+10',}},
				hands={ name="Leyline Gloves", augments={'Accuracy+1','Mag. Acc.+5','"Mag.Atk.Bns."+5','"Fast Cast"+1',}},
				legs={ name="Taeon Tights", augments={'Mag. Acc.+17',}},
				feet={ name="Taeon Boots", augments={'Mag. Acc.+19',}},
				neck="Voltsurge Torque",
				waist="Eschan Stone",
				ear2="Lifestorm Earring",
				ring2="Sangoma Ring",
				back="Izdubar Mantle",
				})
			
			
        -- WEAPONSKILLS
        -- Default weaponskill sets.
		
		
		--Met(ft.), Yilan, Hanbi
		
	sets.precast.WS = {
			ammo="Ginsen",
			head="Totemic Helm +3",
			body="Tot. Jackcoat +3",
			hands="Totemic Gloves +3",
			legs="Tot. Trousers +3",
			feet="Tot. Gaiters +3",
			neck="Shulmanu Collar",
			waist="Patentia Sash",
			left_ear="Suppanomimi",
			right_ear="Digni. Earring",
			left_ring="Rajas Ring",
			right_ring="Varar Ring +1 +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},}

	sets.precast.WS.WSMedAcc = {
			ammo="Ginsen",
			head="Gavialis Helm",
			neck="Shulmanu Collar",
			ear1="Flame Pearl",
			ear2="Brutal Earring",
			body="Nukumi Gausape +1",
			hands={ name="Taeon Gloves", augments={'Accuracy+18 Attack+18','"Triple Atk."+2',}},
			ring1="Pyrosoul Ring",
			ring2="Ifrit Ring",
			back="Pastoralist's Mantle",
			waist="Windbuffet Belt +1",
			legs="Nukumi Quijotes +1",
			feet="Nukumi Ocreae +1"}

	sets.precast.WS.WSHighAcc = {
			ammo="Ginsen",
			head="Yaoyotl Helm",
			neck="Iqabi Necklace",
			ear1="Steelflash Earring",
			ear2="Bladeborn Earring",
			body="Nukumi Gausape +1",
			hands="Buremte Gloves",
			ring1="Mars's Ring",
			ring2="Ramuh's Ring +1",
			back="Pastoralist's Mantle", 
			waist="Incarnation Sash",
			feet="Nukumi Ocreae +1"}

        -- Specific weaponskill sets.
        sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {
			head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','System: 1 ID: 1794 Val: 12','Pet: Accuracy+10 Pet: Rng. Acc.+10',}},
			body="Mes. Haubergeon",
			hands="Nukumi Manoplas +1",
			legs={ name="Valor. Hose", augments={'Pet: Attack+30 Pet: Rng.Atk.+30','Pet: "Regen"+2','System: 1 ID: 1797 Val: 5','Pet: Accuracy+14 Pet: Rng. Acc.+14',}},
			feet={ name="Valorous Greaves", augments={'Pet: Attack+29 Pet: Rng.Atk.+29','System: 1 ID: 1794 Val: 8','Pet: Accuracy+12 Pet: Rng. Acc.+12',}},
			neck="Breeze Gorget",
			waist="Breeze Belt",
			left_ear="Sherida Earring",
			right_ear="Brutal Earring",
			left_ring="Pyrosoul Ring",
			right_ring="Pyrosoul Ring",
			back="Buquwik Cape",})
		
		sets.precast.WS['Ruinator'].Mekira = set_combine(sets.precast.WS['Ruinator'], {head="Gavialis Helm"})
		
        sets.precast.WS['Ruinator'].WSMedAcc = set_combine(sets.precast.WS.WSMedAcc, {neck="Breeze Gorget",waist="Breeze Belt"})
		
        sets.precast.WS['Ruinator'].WSHighAcc = set_combine(sets.precast.WS.WSHighAcc, {neck="Breeze Gorget",waist="Breeze Belt"})

        sets.precast.WS['Onslaught'] = set_combine(sets.precast.WS, {
			ammo="Floestone",
            neck="Justiciar's Torque",
			ear1="Tati Earring +1",
			ear2="Brutal Earring",
			body="Mes'yohi Haubergeon",
			hands="Nomkahpa Mittens +1",
			ring1="Ramuh Ring +1",
            back="Vespid Mantle",
			legs="Mikinaak Cuisses",
			feet="Vanir Boots"})
			
    sets.precast.WS['Onslaught'].WSMedAcc = set_combine(sets.precast.WSMedAcc, {hands="Buremte Gloves",ring1="Ramuh Ring +1"})
	
    sets.precast.WS['Onslaught'].WSHighAcc = set_combine(sets.precast.WSHighAcc, {hands="Buremte Gloves"})
		 
		
	sets.precast.WS['Primal Rend'] = {
			ammo="Voluspa Tathlum",
    head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+26','Pet: VIT+14','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+12 Pet: Rng.Atk.+12',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands="Nukumi Manoplas +1",
    legs={ name="Valorous Hose", augments={'Pet: "Mag.Atk.Bns."+23','Pet: INT+3','Pet: Accuracy+5 Pet: Rng. Acc.+5','Pet: Attack+4 Pet: Rng.Atk.+4',}},
    feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+28','Pet: DEX+7','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+6 Pet: Rng.Atk.+6',}},
    neck="Adad Amulet",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Rimeice Earring",
    left_ring="Thurandaut Ring",
    right_ring="Tali'ah Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	-- Calamity, Meditate, Sekkanoki > brain > tail, leave, cb, fight > Primal Rend > tegmina > Clerrrdplerrterrr
	--------------------------------------------------------------------------------		
	-- tail   >  tegmi  >  sensi >  brain  >  tail  >  " "
	-- razor  >  brain  >  claw  >  brain  >  tail  >  Clerrrdplerrterrr
	-- (impac)	(lique)   (sciss)  (lique)   (impac)    (fragment)
	
	-- Up In Arms
	-- Wild oats > frogkick > raging axe OR head butt > rampage > frogkick
	-- blockhead > spinning top > doubleclaw (fireball) > spinning top (fireball)
	-- Razor Fang > Brain Crush > Claw Cyclone > Brain Crush > Razor Fang > fireball

	
	--poop3
	
	
		sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'],{
			ammo="Plumose Sachet",
			head="Jumalik Helm",
			body={ name="Valorous Mail", augments={'"Mag.Atk.Bns."+20','Mag. Acc.+21','Accuracy+13 Attack+13','Mag. Acc.+9 "Mag.Atk.Bns."+9',}},
			hands={ name="Valorous Mitts", augments={'"Mag.Atk.Bns."+16','Pet: Attack+18 Pet: Rng.Atk.+18','Accuracy+4 Attack+4','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
			legs={ name="Valor. Hose", augments={'Attack+5','"Mag.Atk.Bns."+25','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
			feet="Sombra Leggings +1",
			neck="Sanctity Necklace",
			waist="Eschan Stone",
			ear1="Moonshade Earring",
			ear2="Friomisi Earring",
			ring1="Thurandaut Ring",
			ring2="Sangoma Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},})

			
		sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Primal Rend'],{
			ammo="Plumose Sachet",
			head="Jumalik Helm",
			body={ name="Valorous Mail", augments={'"Mag.Atk.Bns."+20','Mag. Acc.+21','Accuracy+13 Attack+13','Mag. Acc.+9 "Mag.Atk.Bns."+9',}},
			hands={ name="Valorous Mitts", augments={'"Mag.Atk.Bns."+16','Pet: Attack+18 Pet: Rng.Atk.+18','Accuracy+4 Attack+4','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
			legs={ name="Valor. Hose", augments={'Attack+5','"Mag.Atk.Bns."+25','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
			feet="Sombra Leggings +1",
			neck="Sanctity Necklace",
			waist="Eschan Stone",
			ear1="Moonshade Earring",
			ear2="Friomisi Earring",
			ring1="Thurandaut Ring",
			ring2="Sangoma Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},})
	
	sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS['Primal Rend'],{
			ammo="Plumose Sachet",
			head="Jumalik Helm",
			body={ name="Valorous Mail", augments={'"Mag.Atk.Bns."+20','Mag. Acc.+21','Accuracy+13 Attack+13','Mag. Acc.+9 "Mag.Atk.Bns."+9',}},
			hands={ name="Valorous Mitts", augments={'"Mag.Atk.Bns."+16','Pet: Attack+18 Pet: Rng.Atk.+18','Accuracy+4 Attack+4','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
			legs={ name="Valor. Hose", augments={'Attack+5','"Mag.Atk.Bns."+25','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
			feet="Sombra Leggings +1",
			neck="Sanctity Necklace",
			waist="Eschan Stone",
			ear1="Moonshade Earring",
			ear2="Friomisi Earring",
			ring1="Thurandaut Ring",
			ring2="Sangoma Ring",
			back={ name="Artio's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},})

			
			
			
	-- PET SIC & READY MOVES
	sets.midcast.Pet.WS = {
	main="Agwu's Axe",
    sub={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands="Nukumi Manoplas +1",
    legs="Despair Cuisses",
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Kyrene's Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.midcast.Pet.DA = {
	main={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Emicho Hose", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25',}},
    neck="Shulmanu Collar",
    waist="Incarnation Sash",
    left_ear="Kyrene's Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.midcast.Pet.MabReady = set_combine(sets.midcast.Pet.WS, {
			
	main={ name="Kumbhakarna", augments={'Pet: "Mag.Atk.Bns."+18','Pet: Haste+3','Pet: TP Bonus+160',}},
    sub={ name="Kumbhakarna", augments={'Pet: "Mag.Atk.Bns."+16','Pet: Phys. dmg. taken -1%','Pet: TP Bonus+160',}},
    ammo="Voluspa Tathlum",
    head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+26','Pet: VIT+14','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+12 Pet: Rng.Atk.+12',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands="Nukumi Manoplas +1",
    legs={ name="Valorous Hose", augments={'Pet: "Mag.Atk.Bns."+23','Pet: INT+3','Pet: Accuracy+5 Pet: Rng. Acc.+5','Pet: Attack+4 Pet: Rng.Atk.+4',}},
    feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+28','Pet: DEX+7','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+6 Pet: Rng.Atk.+6',}},
    neck="Adad Amulet",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Rimeice Earring",
    left_ring="Thurandaut Ring",
    right_ring="Tali'ah Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})
		
		--	head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','System: 1 ID: 1794 Val: 12','Pet: Accuracy+10 Pet: Rng. Acc.+10',}},
		--	body={ name="Valorous Mail", augments={'Pet: "Mag.Atk.Bns."+30','Pet: Haste+2','Pet: STR+9','Pet: Attack+7 Pet: Rng.Atk.+7',}},
		--	hands="Nukumi Manoplas +1",
		--	legs={ name="Valor. Hose", augments={'Pet: "Mag.Atk.Bns."+30','Pet: CHR+8',}},
		--	feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: Phys. dmg. taken -1%','Pet: STR+3',}},
		--	back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Mag. Acc.+10',}},
		--	back="Argocham. Mantle",
		
	sets.midcast.Pet.MaccReady = set_combine(sets.midcast.Pet.WS, {
			main="Deacon Tabar",
    sub="Mdomo Axe +1",
    ammo="Voluspa Tathlum",
    head="Tali'ah Turban +2",
    body="Tali'ah Manteel +1",
    hands="Tali'ah Gages +1",
    legs="Tali'ah Sera. +2",
    feet="Tali'ah Crackows +2",
    neck="Adad Amulet",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Tali'ah Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})
	
	sets.midcast.Pet.BreathReady = set_combine(sets.midcast.Pet.WS, {
			--MAB
			main="Deacon Tabar",
    sub="Mdomo Axe +1",
    ammo="Voluspa Tathlum",
    head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+26','Pet: VIT+14','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+12 Pet: Rng.Atk.+12',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands="Nukumi Manoplas +1",
    legs={ name="Valorous Hose", augments={'Pet: "Mag.Atk.Bns."+23','Pet: INT+3','Pet: Accuracy+5 Pet: Rng. Acc.+5','Pet: Attack+4 Pet: Rng.Atk.+4',}},
    feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+28','Pet: DEX+7','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+6 Pet: Rng.Atk.+6',}},
    neck="Adad Amulet",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Rimeice Earring",
    left_ring="Thurandaut Ring",
    right_ring="Tali'ah Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
			--MACC
			main="Deacon Tabar",
    sub="Mdomo Axe +1",
    ammo="Voluspa Tathlum",
    head="Tali'ah Turban +2",
    body="Tali'ah Manteel +1",
    hands="Tali'ah Gages +1",
    legs="Tali'ah Sera. +2",
    feet="Tali'ah Crackows +2",
    neck="Adad Amulet",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Tali'ah Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
			})
			
		
	sets.midcast.Pet.Neutral = {  head="Emicho Coronet +1",}
	
	sets.midcast.Pet.Favorable = {
	main={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
    sub={ name="Digirbalag", augments={'"Store TP"+1','Pet: CHR+1','Pet: Accuracy+12 Pet: Rng. Acc.+12','Pet: Attack+30 Pet: Rng.Atk.+30','DMG:+3',}},
    ammo="Voluspa Tathlum",
    head="Tali'ah Turban +2",
    body="Tali'ah Manteel +1",
    hands="Tali'ah Gages +1",
    legs="Tali'ah Sera. +2",
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.midcast.Pet.Killer = {
			main="Izizoeksi",
    sub={ name="Digirbalag", augments={'Pet: "Dbl. Atk."+4','Pet: DEX+2','Pet: Accuracy+3 Pet: Rng. Acc.+3','DMG:+8',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.midcast.Pet.HighAcc = {
			main="Aymur",
			ear1="Enmerkar Earring",
			ring2="Varar Ring +1 +1",
			head="Totemic Helm +3",
			body={ name="Valorous Mail", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','Pet: "Store TP"+1','Pet: DEX+14','Pet: Attack+13 Pet: Rng.Atk.+13',}},
			legs={ name="Valor. Hose", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Pet: "Regen"+4','System: 1 ID: 1793 Val: 11','Pet: Attack+13 Pet: Rng.Atk.+13',}},
			feet="Tot. Gaiters +3",
			hands="Nukumi Manoplas +1",
			ammo="Demonry Core",
			neck="Shulmanu Collar",
			waist="Incarnation Sash",
			ear2="Hija Earring",
			sub="Arktoi",
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			
	sets.midcast.Pet.MaxAcc = {
			main="Arktoi",
			ear1="Enmerkar Earring",
			ring2="Varar Ring +1 +1",
			head="Totemic Helm +3",
			body="Tali'ah Manteel +2",
			hands="Tali'ah Gages +2",
			legs="Tali'ah Seraweels +2",
			feet="Tali'ah Crackows +2",
			ammo="Demonry Core",
			neck="Shulmanu Collar",
			waist="Incarnation Sash",
			ear2="Hija Earring",
			sub="Digirbalag",
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			
	sets.midcast.Pet.ArktoiAcc = {
			main="Aymur",
			ear1="Enmerkar Earring",
			ring2="Varar Ring +1 +1",
			head="Totemic Helm +3",
			body={ name="Valorous Mail", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','Pet: "Store TP"+1','Pet: DEX+14','Pet: Attack+13 Pet: Rng.Atk.+13',}},
			legs="Tali'ah Seraweels +2",
			feet="Tot. Gaiters +3",
			hands="Nukumi Manoplas +1",
			ammo="Demonry Core",
			neck="Shulmanu Collar",
			waist="Incarnation Sash",
			ear2="Hija Earring",
			sub="Arktoi",
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			
	sets.midcast.Pet.Vagary = {
			main={name="Hunahpu",priority=15},
			ear1="Enmerkar Earring",
			ring2="Varar Ring +1 +1",
			head={name="Tali'ah Turban +2",priority=10},
			body={name="Tali'ah Manteel +2",priority=14},
			hands={name="Tali'ah Gages +2",priority=12},
			legs={name="Tali'ah Seraweels +2",priority=13},
			feet={name="Tali'ah Crackows +2",priority=11},
			ammo="Demonry Core",
			neck="Shulmanu Collar",
			waist="Incarnation Sash",
			ear2="Handler's Earring +1",
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
	
	sets.midcast.Pet.TPBonus = {hands="Nukumi Manoplas +1",}
		
	sets.midcast.Pet.ReadyRecast = {
			main="Aymur",sub="Charmer's Merlin",legs="Desultor Tassets",body="Tali'ah Manteel +2",feet="Totemic Gaiters +3",neck="Shulmanu Collar"} 
			--main="Charmer's Merlin",legs="Desultor Tassets",body="Tali'ah Manteel +2",feet="Totemic Gaiters +3",neck="Shulmanu Collar"}
			--main={name="Aymur",priority=15},ear2="Hija Earring",ring2="Varar Ring +1 +1",head="Emicho Coronet +1",body={ name="Valorous Mail", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','Pet: "Store TP"+1','Pet: DEX+14','Pet: Attack+13 Pet: Rng.Atk.+13',priority=12}},legs="Desultor Tassets",feet={name="Tot. Gaiters +3",priority=13},hands={name="Nukumi Manoplas +1",priority=11},ammo="Demonry Core",neck="Shulmanu Collar",waist="Incarnation Sash",ear1="Enmerkar Earring",sub={name="Charmer's Merlin",priority=14},ring1="Thurandaut Ring",back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
	
	-- poop2
		-- main="Aymur",sub="Charmer's Merlin",legs="Desultor Tassets",body="Tali'ah Manteel +2",feet="Totemic Gaiters +3",neck="Shulmanu Collar"} 
		
		-- main="Charmer's Merlin",legs="Desultor Tassets",body="Tali'ah Manteel +2",feet="Totemic Gaiters +3",neck="Shulmanu Collar"}

        -- RESTING
        sets.resting = {}
        
        -- IDLE SETS
	sets.ExtraRegen = {waist="Muscle Belt +1"}
	
	sets.WaterRegen = {ear2="Hibernation Earring"}

	
    sets.idle = {main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
	head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Hypaspist Earringg",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.idle.MDTMaster = {		
	main="Izizoeksi",
    ammo="Staunch Tathlum +1",
    head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Orochi Nodowa",
    waist="Isa Belt",
    left_ear="Hypaspist Earring",
    right_ear="Handler's Earring +1",
    left_ring="Waterfall Ring",
    right_ring="Thundersoul Ring",
    back="Tantalic Cape",}
			
	sets.idle.MNormal = set_combine(sets.idle, {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})

	sets.idle.Turtle = set_combine(sets.idle, {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})
			
	sets.idle.MEva = set_combine(sets.idle, {
			main="Odium",
			sub={ name="Beatific Shield +1", augments={'Phys. dmg. taken -4%','Spell interruption rate down -7%','Magic dmg. taken -4%',}},
			ammo="Staunch Tathlum",
			head="Totemic Helm +3",
			body="Totemic Jackcoat +3",
			hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
			legs="Sombra Tights",
			feet="Sombra Leg. +1",
			neck="Warder's Charm",
			waist="Asklepian Belt",
			left_ear="Flashward Earring",
			right_ear="Hearty Earring",
			left_ring="Purity Ring",
			right_ring="Vengeful Ring",
			back="Fugacity Mantle +1",})
			
    sets.idle.Refresh = set_combine(sets.idle, {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})
			
	sets.idle.Reraise = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})

	sets.idle.Pet = set_combine(sets.idle, {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
	head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Hypaspist Earringg",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})

		-- sub="Beatific Shield +1",
		
		-- sub="Astolfo",
			
	sets.idle.Pet.Engaged = set_combine(sets.idle, {
	main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
	head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Hypaspist Earringg",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},})
        
        -- DEFENSE SETS
   sets.defense.PDT = {
			ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Tartarus Platemail",
    hands="Meg. Gloves +2",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Nierenschutz",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Genmei Earring",
    left_ring="Patricius Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",}

    sets.defense.PetPDT = {
			main="Izizoeksi",
	head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Hypaspist Earringg",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.defense.Killer = {
		
		main={ name="Skullrender", augments={'DMG:+15','Pet: Accuracy+20','Pet: Attack+20',}},
    sub={ name="Skullrender", augments={'DMG:+15','Pet: Accuracy+20','Pet: Attack+20',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Emicho Hose", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Sabong Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
	
	sets.defense.Reraise =  {
		main={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
    sub={ name="Digirbalag", augments={'"Store TP"+1','Pet: CHR+1','Pet: Accuracy+12 Pet: Rng. Acc.+12','Pet: Attack+30 Pet: Rng.Atk.+30','DMG:+3',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    hands="Nukumi Manoplas +1",
    legs="Despair Cuisses",
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25',}},
    neck="Shulmanu Collar",
    waist="Incarnation Sash",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.defense.MDT = set_combine(sets.defense.PDT, {
	ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Tartarus Platemail",
    hands="Meg. Gloves +2",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Nierenschutz",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Etiolation Earring",
    left_ring="Fortified Ring",
    right_ring="Defending Ring",
    back="Moonlight Cape",})

	sets.defense.MDTShell =  {
    main="Izizoeksi",
    ammo="Staunch Tathlum +1",
    head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Anu Torque",
    waist="Isa Belt",
    left_ear="Dominance Earring",
    right_ear="Hypaspist Earring",
    left_ring="Thurandaut Ring",
    right_ring="Defending Ring",
    back="Tantalic Cape",}

	sets.defense.PetMDT =  {
			main="Izizoeksi",
    head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.Kiting = {feet="Skadi's Jambeaux +1"}

        -- MELEE (SINGLE-WIELD) SETS
	
	--1066 ACC
	sets.engaged = {main="Izizoeksi",
	head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Shepherd's Chain",
    waist="Isa Belt",
    left_ear="Hypaspist Earringg",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
		
		
	--1172 ACC
	sets.engaged.Shield = {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Taeon Chapeau", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+2','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Taeon Gloves", augments={'Pet: Mag. Evasion+22','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    legs={ name="Taeon Tights", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
    feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    neck="Empath Necklace",
    waist="Isa Belt",
    left_ear="Enmerkar Earring",
    right_ear="Handler's Earring +1",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.engaged.MedAcc = {
		main="Dolichenus",
		head="Anwig Salade",
			ring2="Shadow Ring",
			neck="Adad Amulet",
			ear2="Handler's Earring +1",
			ammo="Demonry Core",
			body="Totemic Jackcoat +3",
			hands={ name="Acro Gauntlets", augments={'Pet: DEF+20','Pet: "Regen"+3','Pet: Damage taken -4%',}},
			legs={ name="Acro Breeches", augments={'Pet: Mag. Evasion+24','Pet: "Regen"+3','Pet: Damage taken -4%',}},
			feet={ name="Acro Leggings", augments={'Pet: DEF+25','Pet: "Regen"+3','Pet: Damage taken -4%',}},
			ring1="Thurandaut Ring",
			sub="Beatific Shield +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},
			waist="Isa Belt",
			ear1="Enmerkar Earring",}
			
	sets.engaged.MedAccHaste = {
		main="Dolichenus",
		}
			
	sets.engaged.HighAcc = {
		main="Dolichenus",
			ammo="Jukukik Feather",
			head="Yaoyotl Helm",
			neck="Iqabi Necklace",
			ear1="Steelflash Earring",
			ear2="Bladeborn Earring",
			body="Mes'yohi Haubergeon",
			hands="Buremte Gloves",
			ring1="Mars's Ring",
			ring2="Ramuh's Ring +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},
			waist="Olseni Belt",
			legs="Xaddi Cuisses",
			feet="Ejekamal Boots"}
			
	sets.engaged.HighAccHaste = {
			ammo="Jukukik Feather",
			head="Yaoyotl Helm",
			neck="Iqabi Necklace",
			ear1="Steelflash Earring",
			ear2="Bladeborn Earring",
			body="Mes'yohi Haubergeon",
			hands="Buremte Gloves",
			ring1="Mars's Ring",
			ring2="Ramuh's Ring +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},
			waist="Olseni Belt",
			legs="Xaddi Cuisses",
			feet="Ejekamal Boots"}
			
	-- MELEE (SINGLE-WIELD) HYBRID SETS
	
	sets.engaged.Hybrid = set_combine(sets.engaged, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			back="Solemnity Cape",
			hands="Iuitl Wristbands +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.Shield.Hybrid = set_combine(sets.engaged.Shield, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			back="Solemnity Cape",
			hands="Iuitl Wristbands +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.MedAcc.Hybrid = set_combine(sets.engaged.MedAcc, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.MedAccHaste.Hybrid = set_combine(sets.engaged.MedAccHaste, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.HighAcc.Hybrid = set_combine(sets.engaged.HighAcc, {
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.HighAccHaste.Hybrid = set_combine(sets.engaged.HighAccHaste, {
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})

        -- MELEE (DUAL-WIELD) SETS FOR DNC AND NIN SUBJOB
		
	sets.engaged.DW = {
			}
			
	sets.engaged.DW.Shield = {
			main="Blurred Axe +1",
			sub="Adapa Shield",
			ammo="Staunch Tathlum",
			head="Skormoth Mask",
			body={ name="Valorous Mail", augments={'Enmity+1','CHR+15','Quadruple Attack +3','Accuracy+13 Attack+13',}},
			hands="Tali'ah Gages +2",
			legs={ name="Valor. Hose", augments={'Phys. dmg. taken -3%','Accuracy+30','Quadruple Attack +3','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
			feet={ name="Valorous Greaves", augments={'Accuracy+23 Attack+23','Sklchn.dmg.+2%','STR+11','Accuracy+5','Attack+2',}},
			neck="Shulmanu Collar",
			waist="Windbuffet Belt +1",
			left_ear="Brutal Earring",
			right_ear="Sherida Earring",
			left_ring="Hetairoi Ring",
			right_ring="Epona's Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
	
		-- MedAcc intended for but not limited to Hybrid pet DT/DW use 
		
	sets.engaged.DW.MedAcc = {
			main="Izizoeksi",
    sub={ name="Skullrender", augments={'DMG:+13','Pet: Accuracy+18','Pet: Attack+18',}},
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    body={ name="An. Jackcoat +2", augments={'Enhances "Feral Howl" effect',}},
    hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +2", augments={'Enhances "Familiar" effect',}},
    feet="Tali'ah Crackows +2",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
    left_ear="Enmerkar Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="Varar Ring +1",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.engaged.DW.MedAccHaste = {
			main={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
			sub="Kraken Club",
			ammo="Ginsen",
			head="Totemic Helm +3",
			body="Tot. Jackcoat +3",
			hands="Totemic Gloves +3",
			legs="Tot. Trousers +3",
			feet="Tot. Gaiters +3",
			neck="Shulmanu Collar",
			waist="Patentia Sash",
			left_ear="Suppanomimi",
			right_ear="Digni. Earring",
			left_ring="Rajas Ring",
			right_ring="Varar Ring +1 +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},}
			
	sets.engaged.DW.HighAcc = {
			main="Blurred Axe +1",
			sub="Hunahpu",
			ammo="Ginsen",
			head="Totemic Helm +3",
			body="Tot. Jackcoat +3",
			hands="Totemic Gloves +3",
			legs="Tot. Trousers +3",
			feet="Tot. Gaiters +3",
			neck="Shulmanu Collar",
			waist="Patentia Sash",
			left_ear="Suppanomimi",
			right_ear="Eabani Earring",
			left_ring="Rajas Ring",
			right_ring="Varar Ring +1 +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},}
			
	sets.engaged.DW.HighAccHaste = {
			main={ name="Arktoi", augments={'Accuracy+50','Pet: Accuracy+50','Pet: Attack+30',}},
			sub="Blurred Axe +1",
			ammo="Ginsen",
			head="Totemic Helm +3",
			body="Tot. Jackcoat +3",
			hands="Totemic Gloves +3",
			legs="Tot. Trousers +3",
			feet="Tot. Gaiters +3",
			neck="Shulmanu Collar",
			waist="Patentia Sash",
			left_ear="Suppanomimi",
			right_ear="Digni. Earring",
			left_ring="Rajas Ring",
			right_ring="Varar Ring +1 +1",
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},}
			
	-- MELEE (DUAL-WIELD) HYBRID SETS
	
	sets.engaged.DW.Hybrid = set_combine(sets.engaged.DW, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			back="Solemnity Cape",
			hands="Iuitl Wristbands +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.DW.Shield.Hybrid = set_combine(sets.engaged.DW.Shield, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			back="Solemnity Cape",
			hands="Iuitl Wristbands +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.DW.MedAcc.Hybrid = set_combine(sets.engaged.DW.MedAcc, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.DW.MedAccHaste.Hybrid = set_combine(sets.engaged.DW.MedAccHaste, {
			head="Iuitl Headgear +1",
			body="Iuitl Vest +1",
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.DW.HighAcc.Hybrid = set_combine(sets.engaged.DW.HighAcc, {
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})
			
	sets.engaged.DW.HighAccHaste.Hybrid = set_combine(sets.engaged.DW.HighAccHaste, {
			legs="Iuitl Tights +1",
			feet="Iuitl Gaiters +1"})

	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET ENGAGED
	sets.engaged.PetStance = set_combine(sets.engaged, {
			head="Anwig Salade",
			body="Ankusa Jackcoat +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash",
			legs="Wisent Kecks",
			feet="Armada Sollerets"})
			
	sets.engaged.PetStance.Shield = set_combine(sets.engaged.Shield, {
			head="Anwig Salade",
			body="Ankusa Jackcoat +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash",
			legs="Wisent Kecks",
			feet="Armada Sollerets"})
			
	sets.engaged.PetStance.MedAcc = set_combine(sets.engaged.MedAcc, {
			head="Ankusa Helm +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.PetStance.MedAccHaste = set_combine(sets.engaged.MedAccHaste, {
			head="Ankusa Helm +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.PetStance.HighAcc = set_combine(sets.engaged.HighAcc, {
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.PetStance.HighAccHaste = set_combine(sets.engaged.HighAccHaste, {
			hands="Regimen Mittens",
			waist="Incarnation Sash"})

	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET TANKING
	
	sets.engaged.PetTank = set_combine(sets.engaged, {
			})
			
	sets.engaged.PetTank.Shield = set_combine(sets.engaged.Shield, {
			})
			
	sets.engaged.PetTank.MedAcc = set_combine(sets.engaged.MedAcc, {
			head="Anwig Salade",
			hands="Ankusa Gloves +1",
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.PetTank.MedAccHaste = set_combine(sets.engaged.MedAccHaste, {
			head="Anwig Salade",
			hands="Ankusa Gloves +1",
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.PetTank.HighAcc = set_combine(sets.engaged.HighAcc, {
			head="Anwig Salade",
			hands="Regimen Mittens"})
			
	sets.engaged.PetTank.HighAccHaste = set_combine(sets.engaged.HighAccHaste, {
			head="Anwig Salade",
			hands="Regimen Mittens"})

	-- GEARSETS FOR MASTER ENGAGED (DUAL-WIELD) & PET ENGAGED
	sets.engaged.DW.PetStance = set_combine(sets.engaged.DW, {
			head="Anwig Salade",
			body="Ankusa Jackcoat +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash",
			legs="Wisent Kecks",
			feet="Armada Sollerets"})
			
	sets.engaged.DW.PetStance.Shield = set_combine(sets.engaged.DW.Shield, {
			head="Anwig Salade",
			body="Ankusa Jackcoat +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash",
			legs="Wisent Kecks",
			feet="Armada Sollerets"})
			
	sets.engaged.DW.PetStance.MedAcc = set_combine(sets.engaged.DW.MedAcc, {
			head="Ankusa Helm +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.DW.PetStance.MedAccHaste = set_combine(sets.engaged.DW.MedAccHaste, {
			head="Ankusa Helm +1",
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.DW.PetStance.HighAcc = set_combine(sets.engaged.DW.HighAcc, {
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.DW.PetStance.HighAccHaste = set_combine(sets.engaged.DW.HighAccHaste, {
			hands="Regimen Mittens",
			waist="Incarnation Sash"})

	-- GEARSETS FOR MASTER ENGAGED (DUAL-WIELD) & PET TANKING
	sets.engaged.DW.PetTank = set_combine(sets.engaged.DW, {
			})
			
	sets.engaged.DW.PetTank.Shield = set_combine(sets.engaged.DW.Shield, {
			})
			
	sets.engaged.DW.PetTank.MedAcc = set_combine(sets.engaged.DW.MedAcc, {
			head="Anwig Salade",
			hands="Ankusa Gloves +1",
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.DW.PetTank.MedAccHaste = set_combine(sets.engaged.DW.MedAccHaste, {
			head="Anwig Salade",
			hands="Ankusa Gloves +1",
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.DW.PetTank.HighAcc = set_combine(sets.engaged.DW.HighAcc, {
			head="Anwig Salade",
			hands="Regimen Mittens"})
			
	sets.engaged.DW.PetTank.HighAccHaste = set_combine(sets.engaged.DW.HighAccHaste, {
			head="Anwig Salade",
			hands="Regimen Mittens"})

sets.buff['Killer Instinct'] = {body="Nukumi Gausape +1"}

sets.buff.Doomed = {neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Saida Ring",}

sets.THBelt = {	ammo="Ginsen",
				head="Tali'ah Turban +2",
				body="Tali'ah Manteel +2",
				hands="Tali'ah Gages +2",
				legs="Tali'ah Seraweels +2",
				feet="Tali'ah Crackows +2",
				neck="Warder's Charm",
				waist="Eschan Stone",
				left_ear="Lifestorm Earring",
				right_ear="Psystorm Earring",
				left_ring="Etana Ring",
				right_ring="Varar Ring +1 +1",
				back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}},}

-------------------------------------------------------------------------------------------------------------------
-- Complete Lvl 76-99 Jug Pet Precast List +Funguar +Courier +Amigo
-------------------------------------------------------------------------------------------------------------------

	sets.precast.JA['Bestial Loyalty'].FunguarFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Seedbed Soil"})
	sets.precast.JA['Bestial Loyalty'].CourierCarrie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Fish Oil Broth"})
	sets.precast.JA['Bestial Loyalty'].AmigoSabotender = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sun Water"})
	sets.precast.JA['Bestial Loyalty'].NurseryNazuna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="D. Herbal Broth"})
	sets.precast.JA['Bestial Loyalty'].CraftyClyvonne = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Cng. Brain Broth"})
	sets.precast.JA['Bestial Loyalty'].PrestoJulio = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="C. Grass. Broth"})
	sets.precast.JA['Bestial Loyalty'].SwiftSieghard = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Mlw. Bird Broth"})
	sets.precast.JA['Bestial Loyalty'].MailbusterCetas = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Gob. Bug Broth"})
	sets.precast.JA['Bestial Loyalty'].AudaciousAnna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="B. Carrion Broth"})
	sets.precast.JA['Bestial Loyalty'].TurbidToloi = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Auroral Broth"})
	sets.precast.JA['Bestial Loyalty'].LuckyLulush = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="L. Carrot Broth"})
	sets.precast.JA['Bestial Loyalty'].DipperYuly = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Wool Grease"})
	sets.precast.JA['Bestial Loyalty'].FlowerpotMerle = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Vermihumus"})
	sets.precast.JA['Bestial Loyalty'].DapperMac = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Briny Broth"})
	sets.precast.JA['Bestial Loyalty'].DiscreetLouise = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Deepbed Soil"})
	sets.precast.JA['Bestial Loyalty'].FatsoFargann = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="C. Plasma Broth"})
	sets.precast.JA['Bestial Loyalty'].FaithfulFalcorr = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Lucky Broth"})
	sets.precast.JA['Bestial Loyalty'].BugeyedBroncha = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Svg. Mole Broth"})
	sets.precast.JA['Bestial Loyalty'].BloodclawShasra = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Rzr. Brain Broth"})
	sets.precast.JA['Bestial Loyalty'].GorefangHobs = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="B. Carrion Broth"})
	sets.precast.JA['Bestial Loyalty'].GooeyGerard = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Cl. Wheat Broth"})
	sets.precast.JA['Bestial Loyalty'].CrudeRaphie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Shadowy Broth"})

-------------------------------------------------------------------------------------------------------------------
-- Complete iLvl Jug Pet Precast List
-------------------------------------------------------------------------------------------------------------------

	sets.precast.JA['Bestial Loyalty'].DroopyDortwin = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Swirling Broth"})
	sets.precast.JA['Bestial Loyalty'].PonderingPeter = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Vis. Broth"})
	sets.precast.JA['Bestial Loyalty'].SunburstMalfik = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Shimmering Broth"})
	sets.precast.JA['Bestial Loyalty'].AgedAngus = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Ferm. Broth"})
	sets.precast.JA['Bestial Loyalty'].WarlikePatrick = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Livid Broth"})
	sets.precast.JA['Bestial Loyalty'].ScissorlegXerin = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Spicy Broth"})
	sets.precast.JA['Bestial Loyalty'].BouncingBertha = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Bubbly Broth"})
	sets.precast.JA['Bestial Loyalty'].RhymingShizuna = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Lyrical Broth"})
	sets.precast.JA['Bestial Loyalty'].AttentiveIbuki = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Salubrious Broth"})
	sets.precast.JA['Bestial Loyalty'].SwoopingZhivago = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Windy Greens"})
	sets.precast.JA['Bestial Loyalty'].AmiableRoche = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Airy Broth"})
	sets.precast.JA['Bestial Loyalty'].HeraldHenry = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Trans. Broth"})
	sets.precast.JA['Bestial Loyalty'].BrainyWaluis = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Crumbly Soil"})
	sets.precast.JA['Bestial Loyalty'].HeadbreakerKen = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Blackwater Broth"})
	sets.precast.JA['Bestial Loyalty'].RedolentCandi = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Electrified Broth"})
	sets.precast.JA['Bestial Loyalty'].AlluringHoney = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Bug-Ridden Broth"})
	sets.precast.JA['Bestial Loyalty'].CaringKiyomaro = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Fizzy Broth"})
	sets.precast.JA['Bestial Loyalty'].VivaciousVickie = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Tant. Broth"})
	sets.precast.JA['Bestial Loyalty'].HurlerPercival = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Pale Sap"})
	sets.precast.JA['Bestial Loyalty'].BlackbeardRandy = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Meaty Broth"})
	sets.precast.JA['Bestial Loyalty'].GenerousArthur = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Dire Broth"})
	sets.precast.JA['Bestial Loyalty'].ThreestarLynn = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Muddy Broth"})
	sets.precast.JA['Bestial Loyalty'].BraveHeroGlenn = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Wispy Broth"})
	sets.precast.JA['Bestial Loyalty'].SharpwitHermes = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Saline Broth"})
	sets.precast.JA['Bestial Loyalty'].ColibriFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sugary Broth"})
	sets.precast.JA['Bestial Loyalty'].ChoralLeera = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Glazed Broth"})
	sets.precast.JA['Bestial Loyalty'].SpiderFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Sticky Webbing"})
	sets.precast.JA['Bestial Loyalty'].GussyHachirobe = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Slimy Webbing"})
	sets.precast.JA['Bestial Loyalty'].AcuexFamiliar = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Poisonous Broth"})
	sets.precast.JA['Bestial Loyalty'].FluffyBredo = set_combine(sets.precast.JA['Bestial Loyalty'], {ammo="Venomous Broth"})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
	cancel_conflicting_buffs(spell, action, spellMap, eventArgs)

        if spell.type == "WeaponSkill" and spell.name ~= 'Mistral Axe' and spell.name ~= 'Bora Axe' and spell.target.distance > target_distance then
                cancel_spell()
                add_to_chat(123, spell.name..' Canceled: [Out of /eq]')
                return
        end

	if spell.english == 'Reward' then
		if state.RewardMode.value == 'Theta' then
			equip(sets.precast.JA.Reward.Theta)
		elseif state.RewardMode.value == 'Zeta' then
			equip(sets.precast.JA.Reward.Zeta)
		elseif state.RewardMode.value == 'Eta' then
			equip(sets.precast.JA.Reward.Eta)
		end
	end

	if spell.english == 'Bestial Loyalty' or spell.english == 'Call Beast' then
                if state.JugMode.value == 'FunguarFamiliar' then
			equip(sets.precast.JA['Bestial Loyalty'].FunguarFamiliar)
                elseif state.JugMode.value == 'CourierCarrie' then
			equip(sets.precast.JA['Bestial Loyalty'].CourierCarrie)
                elseif state.JugMode.value == 'AmigoSabotender' then
			equip(sets.precast.JA['Bestial Loyalty'].AmigoSabotender)
                elseif state.JugMode.value == 'NurseryNazuna' then
			equip(sets.precast.JA['Bestial Loyalty'].NurseryNazuna)
                elseif state.JugMode.value == 'CraftyClyvonne' then
			equip(sets.precast.JA['Bestial Loyalty'].CraftyClyvonne)
                elseif state.JugMode.value == 'PrestoJulio' then
			equip(sets.precast.JA['Bestial Loyalty'].PrestoJulio)
                elseif state.JugMode.value == 'SwiftSieghard' then
			equip(sets.precast.JA['Bestial Loyalty'].SwiftSieghard)
                elseif state.JugMode.value == 'MailbusterCetas' then
			equip(sets.precast.JA['Bestial Loyalty'].MailbusterCetas)
                elseif state.JugMode.value == 'AudaciousAnna' then
			equip(sets.precast.JA['Bestial Loyalty'].AudaciousAnna)
                elseif state.JugMode.value == 'TurbidToloi' then
			equip(sets.precast.JA['Bestial Loyalty'].TurbidToloi)
                elseif state.JugMode.value == 'SlipperySilas' then
			equip(sets.precast.JA['Bestial Loyalty'].SlipperySilas)
                elseif state.JugMode.value == 'LuckyLulush' then
			equip(sets.precast.JA['Bestial Loyalty'].LuckyLulush)
                elseif state.JugMode.value == 'DipperYuly' then
			equip(sets.precast.JA['Bestial Loyalty'].DipperYuly)
                elseif state.JugMode.value == 'FlowerpotMerle' then
			equip(sets.precast.JA['Bestial Loyalty'].FlowerpotMerle)
                elseif state.JugMode.value == 'DapperMac' then
			equip(sets.precast.JA['Bestial Loyalty'].DapperMac)
                elseif state.JugMode.value == 'DiscreetLouise' then
			equip(sets.precast.JA['Bestial Loyalty'].DiscreetLouise)
                elseif state.JugMode.value == 'FatsoFargann' then
			equip(sets.precast.JA['Bestial Loyalty'].FatsoFargann)
                elseif state.JugMode.value == 'FaithfulFalcorr' then
			equip(sets.precast.JA['Bestial Loyalty'].FaithfulFalcorr)
                elseif state.JugMode.value == 'BugeyedBroncha' then
			equip(sets.precast.JA['Bestial Loyalty'].BugeyedBroncha)
                elseif state.JugMode.value == 'BloodclawShasra' then
			equip(sets.precast.JA['Bestial Loyalty'].BloodclawShasra)
                elseif state.JugMode.value == 'GorefangHobs' then
			equip(sets.precast.JA['Bestial Loyalty'].GorefangHobs)
                elseif state.JugMode.value == 'GooeyGerard' then
			equip(sets.precast.JA['Bestial Loyalty'].GooeyGerard)
                elseif state.JugMode.value == 'CrudeRaphie' then
			equip(sets.precast.JA['Bestial Loyalty'].CrudeRaphie)
                elseif state.JugMode.value == 'DroopyDortwin' then
			equip(sets.precast.JA['Bestial Loyalty'].DroopyDortwin)
                elseif state.JugMode.value == 'PonderingPeter' then
                        equip(sets.precast.JA['Bestial Loyalty'].PonderingPeter)
                elseif state.JugMode.value == 'SunburstMalfik' then
                        equip(sets.precast.JA['Bestial Loyalty'].SunburstMalfik)
                elseif state.JugMode.value == 'AgedAngus' then
                        equip(sets.precast.JA['Bestial Loyalty'].AgedAngus)
                elseif state.JugMode.value == 'WarlikePatrick' then
                        equip(sets.precast.JA['Bestial Loyalty'].WarlikePatrick)
                elseif state.JugMode.value == 'ScissorlegXerin' then
                        equip(sets.precast.JA['Bestial Loyalty'].ScissorlegXerin)
                elseif state.JugMode.value == 'BouncingBertha' then
                        equip(sets.precast.JA['Bestial Loyalty'].BouncingBertha)
                elseif state.JugMode.value == 'RhymingShizuna' then
                        equip(sets.precast.JA['Bestial Loyalty'].RhymingShizuna)
                elseif state.JugMode.value == 'AttentiveIbuki' then
                        equip(sets.precast.JA['Bestial Loyalty'].AttentiveIbuki)
                elseif state.JugMode.value == 'SwoopingZhivago' then
                        equip(sets.precast.JA['Bestial Loyalty'].SwoopingZhivago)
                elseif state.JugMode.value == 'AmiableRoche' then
                        equip(sets.precast.JA['Bestial Loyalty'].AmiableRoche)
                elseif state.JugMode.value == 'HeraldHenry' then
                        equip(sets.precast.JA['Bestial Loyalty'].HeraldHenry)
                elseif state.JugMode.value == 'BrainyWaluis' then
                        equip(sets.precast.JA['Bestial Loyalty'].BrainyWaluis)
                elseif state.JugMode.value == 'HeadbreakerKen' then
                        equip(sets.precast.JA['Bestial Loyalty'].HeadbreakerKen)
                elseif state.JugMode.value == 'RedolentCandi' then
                        equip(sets.precast.JA['Bestial Loyalty'].RedolentCandi)
                elseif state.JugMode.value == 'AlluringHoney' then
                        equip(sets.precast.JA['Bestial Loyalty'].AlluringHoney)
                elseif state.JugMode.value == 'CaringKiyomaro' then
                        equip(sets.precast.JA['Bestial Loyalty'].CaringKiyomaro)
                elseif state.JugMode.value == 'VivaciousVickie' then
                        equip(sets.precast.JA['Bestial Loyalty'].VivaciousVickie)
                elseif state.JugMode.value == 'HurlerPercival' then
                        equip(sets.precast.JA['Bestial Loyalty'].HurlerPercival)
                elseif state.JugMode.value == 'BlackbeardRandy' then
                        equip(sets.precast.JA['Bestial Loyalty'].BlackbeardRandy)
                elseif state.JugMode.value == 'GenerousArthur' then
                        equip(sets.precast.JA['Bestial Loyalty'].GenerousArthur)
                elseif state.JugMode.value == 'ThreestarLynn' then
                        equip(sets.precast.JA['Bestial Loyalty'].ThreestarLynn)
                elseif state.JugMode.value == 'BraveHeroGlenn' then
                        equip(sets.precast.JA['Bestial Loyalty'].BraveHeroGlenn)
                elseif state.JugMode.value == 'SharpwitHermes' then
                        equip(sets.precast.JA['Bestial Loyalty'].SharpwitHermes)
                elseif state.JugMode.value == 'ColibriFamiliar' then
                        equip(sets.precast.JA['Bestial Loyalty'].ColibriFamiliar)
                elseif state.JugMode.value == 'ChoralLeera' then
                        equip(sets.precast.JA['Bestial Loyalty'].ChoralLeera)
                elseif state.JugMode.value == 'SpiderFamiliar' then
                        equip(sets.precast.JA['Bestial Loyalty'].SpiderFamiliar)
                elseif state.JugMode.value == 'GussyHachirobe' then
                        equip(sets.precast.JA['Bestial Loyalty'].GussyHachirobe)
                elseif state.JugMode.value == 'AcuexFamiliar' then
                        equip(sets.precast.JA['Bestial Loyalty'].AcuexFamiliar)
                elseif state.JugMode.value == 'FluffyBredo' then
                        equip(sets.precast.JA['Bestial Loyalty'].FluffyBredo)
		end
	end

-- Define class for Sic and Ready moves.
        if ready_moves_to_check:contains(spell.name) and pet.status == 'Engaged' then
                classes.CustomClass = "WS"
		equip(sets.midcast.Pet.ReadyRecast)
        end
end

function job_post_precast(spell, action, spellMap, eventArgs)
-- If Killer Instinct is active during WS, equip Nukumi Gausape +1.
	if spell.type:lower() == 'weaponskill' and buffactive['Killer Instinct'] then
                equip(sets.buff['Killer Instinct'])
        end
		
	-- Equip Chaac Belt for TH+1 on common Subjob Abilities or Spells.
	if abilities_to_check:contains(spell.english) and state.TreasureMode.value == 'Tag' then
                equip(sets.THBelt)
	end
end



function job_pet_midcast(spell, action, spellMap, eventArgs)
-- Equip monster correlation gear, as appropriate
        
		
		
	-- If Pet TP, before bonuses, is less than a certain value, equip Ferine Manoplas +1 or +2
	--if PetJob == 'Warrior' then
               -- if pet.tp < 2000 then
				
                       -- equip(sets.midcast.Pet.TPBonus)
               -- end
      -- elseif PetJob == 'Paladin' or PetJob == 'Thief' or PetJob == 'Monk' or PetJob == 'Red Mage' or PetJob == 'Black Mage' then
                --if pet.tp < 2500 then
                       -- equip(sets.midcast.Pet.TPBonus)
              --  end
       -- end
end

-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)

if spell.type == "Monster" and not spell.interrupted then

 equip(set_combine(sets.midcast.Pet.WS, sets.midcast.Pet[state.CorrelationMode.value]))

	if mab_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
 equip(sets.midcast.Pet.MabReady)
 end
 
	if buffactive['Unleash'] then
                hands={ name="Valorous Mitts", augments={'Pet: Attack+30 Pet: Rng.Atk.+30','Pet: "Store TP"+10','System: 1 ID: 1792 Val: 13','Pet: Accuracy+3 Pet: Rng. Acc.+3',}}
        end
 
	if macc_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
 equip(sets.midcast.Pet.MaccReady)
 end
 
 if breath_ready_moves:contains(spell.english) and pet.status == 'Engaged' then
 equip(sets.midcast.Pet.BreathReady)
 end

 eventArgs.handled = true
 end
 
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hook for idle sets.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
	if player.hpp < 50 and pet.status ~= 'Engaged' then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end
	if world.day_element == 'Water' then
		idleSet = set_combine(idleSet, sets.WaterRegen)
	end
	return idleSet
end

-------------------------------------------------------------------------------------------------------------------
-- Hooks for Reward, Correlation, Treasure Hunter, and Pet Mode handling.
-------------------------------------------------------------------------------------------------------------------

function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Correlation Mode' then
		state.CorrelationMode:set(newValue)
	elseif stateField == 'Reward Mode' then
                state.RewardMode:set(newValue)
	elseif stateField == 'Treasure Mode' then
		state.TreasureMode:set(newValue)
        elseif stateField == 'Pet Mode' then
                state.CombatWeapon:set(newValue)
        elseif stateField == 'Jug Mode' then
                state.JugMode:set(newValue)
        end
end

function get_custom_wsmode(spell, spellMap, default_wsmode)
        if default_wsmode == 'Normal' then
                if spell.english == "Ruinator" and (world.day_element == 'Water' or world.day_element == 'Wind' or world.day_element == 'Ice') then
                        return 'Mekira'
                end
        end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)    	
	if player.equipment.back == 'Mecisto. Mantle' or player.equipment.back == 'Mecisto. Mantle' or player.equipment.back == 'Mecisto. Mantle' then
		disable('back')
	else
		enable('back')
	end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	get_combat_form()

        if state.JugMode.value == 'FunguarFamiliar' then
                PetInfo = "Funguar, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'CourierCarrie' then
                PetInfo = "Crab, Aquan"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'AmigoSabotender' then
                PetInfo = "Cactuar, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'NurseryNazuna' then
                PetInfo = "Sheep, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'CraftyClyvonne' then
                PetInfo = "Coeurl, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'PrestoJulio' then
                PetInfo = "Flytrap, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'SwiftSieghard' then
                PetInfo = "Raptor, Lizard"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'MailbusterCetas' then
                PetInfo = "Fly, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'AudaciousAnna' then
                PetInfo = "Lizard, Lizard"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'TurbidToloi' then
                PetInfo = "Pugil, Aquan"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'SlipperySilas' then
                PetInfo = "Toad, Aquan"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'LuckyLulush' then
                PetInfo = "Rabbit, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'DipperYuly' then
                PetInfo = "Ladybug, Vermin"
                PetJob = 'Thief'
        elseif state.JugMode.value == 'FlowerpotMerle' then
                PetInfo = "Mandragora, Plantoid"
                PetJob = 'Monk'
        elseif state.JugMode.value == 'DapperMac' then
                PetInfo = "Apkallu, Bird"
                PetJob = 'Monk'
        elseif state.JugMode.value == 'DiscreetLouise' then
                PetInfo = "Funguar, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'FatsoFargann' then
                PetInfo = "Leech, Amorph"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'FaithfulFalcorr' then
                PetInfo = "Hippogryph, Bird"
                PetJob = 'Thief'
        elseif state.JugMode.value == 'BugeyedBroncha' then
                PetInfo = "Eft, Lizard"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'BloodclawShasra' then
                PetInfo = "Lynx, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'GorefangHobs' then
                PetInfo = "Tiger, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'GooeyGerard' then
                PetInfo = "Slug, Amorph"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'CrudeRaphie' then
                PetInfo = "Adamantoise, Lizard"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'DroopyDortwin' then
                PetInfo = "Rabbit, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'PonderingPeter' then
                PetInfo = "HQ Rabbit, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'SunburstMalfik' then
                PetInfo = "Crab, Aquan"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'AgedAngus' then
                PetInfo = "HQ Crab, Aquan"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'WarlikePatrick' then
                PetInfo = "Lizard, Lizard"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'ScissorlegXerin' then
                PetInfo = "Chapuli, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'BouncingBertha' then
                PetInfo = "HQ Chapuli, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'RhymingShizuna' then
                PetInfo = "Sheep, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'AttentiveIbuki' then
                PetInfo = "Tulfaire, Bird"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'SwoopingZhivago' then
                PetInfo = "HQ Tulfaire, Bird"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'AmiableRoche' then
                PetInfo = "Pugil, Aquan"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'HeraldHenry' then
                PetInfo = "Crab, Aquan"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'BrainyWaluis' then
                PetInfo = "Funguar, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'HeadbreakerKen' then
                PetInfo = "Fly, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'RedolentCandi' then
                PetInfo = "Snapweed, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'AlluringHoney' then
                PetInfo = "HQ Snapweed, Plantoid"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'CaringKiyomaro' then
                PetInfo = "Raaz, Beast"
                PetJob = 'Monk'
        elseif state.JugMode.value == 'VivaciousVickie' then
                PetInfo = "HQ Raaz, Beast"
                PetJob = 'Monk'
        elseif state.JugMode.value == 'HurlerPercival' then
                PetInfo = "Beetle, Vermin"
                PetJob = 'Paladin'
        elseif state.JugMode.value == 'BlackbeardRandy' then
                PetInfo = "Tiger, Beast"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'GenerousArthur' then
                PetInfo = "Slug, Amorph"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'ThreestarLynn' then
                PetInfo = "Ladybug, Vermin"
                PetJob = 'Thief'
        elseif state.JugMode.value == 'BraveHeroGlenn' then
                PetInfo = "Frog, Aquan"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'SharpwitHermes' then
                PetInfo = "Mandragora, Plantoid"
                PetJob = 'Monk'
        elseif state.JugMode.value == 'ColibriFamiliar' then
                PetInfo = "Colibri, Bird"
                PetJob = 'Red Mage'
        elseif state.JugMode.value == 'ChoralLeera' then
                PetInfo = "HQ Colibri, Bird"
                PetJob = 'Red Mage'
        elseif state.JugMode.value == 'SpiderFamiliar' then
                PetInfo = "Spider, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'GussyHachirobe' then
                PetInfo = "HQ Spider, Vermin"
                PetJob = 'Warrior'
        elseif state.JugMode.value == 'AcuexFamiliar' then
                PetInfo = "Acuex, Amorph"
                PetJob = 'Black Mage'
        elseif state.JugMode.value == 'FluffyBredo' then
                PetInfo = "HQ Acuex, Amorph"
                PetJob = 'Black Mage'
        end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', Reward: '..state.RewardMode.value..', Corr.: '..state.CorrelationMode.value

    if state.JugMode.value ~= 'None' then
        add_to_chat(8,'--- Jug Pet: '.. state.JugMode.value ..' --- ('.. PetInfo ..', '.. PetJob ..')')
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function get_combat_form()
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                state.CombatForm:set('DW')
	else
		state.CombatForm:reset()
        end
		
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(9, 8)
	elseif player.sub_job == 'WAR' then
		set_macro_page(9, 8)
	elseif player.sub_job == 'NIN' then
		set_macro_page(9, 8)
	else
		set_macro_page(9, 8)
	end
	
end