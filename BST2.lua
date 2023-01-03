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
        state.OffenseMode:options('Normal', 'Shield', 'MedAcc', 'MedAccHaste', 'HighAcc', 'HighAccHaste', 'CRIT')
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
	'Numbing Noise','Nimble Snap','Cyclotail','Spoil','Rhino Guard','Rhino Attack','Power Attack','Fluid Toss','Fluid Spread',
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
	 'Spore','Infrasonics','Chaotic Eye','Digest',
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
        sets.precast.JA['Killer Instinct'] = {   
		range="Killer Shortbow",
		body="Nukumi Gausape +1",}
		
		sets.precast.JA['Bestial Loyalty'] = {
				hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
				body="Mirke Wardecors",
				feet="Adaman Sollerets",
				head="Acro Helm",
				legs={ name="Acro Breeches", augments={'"Call Beast" ability delay -4',}},
			}
		
		sets.precast.JA['Call Beast'] = sets.precast.JA['Bestial Loyalty']
		
        sets.precast.JA.Familiar = {    legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
	}
		
		sets.precast.JA.Tame = {head="Totemic Helm +1",ear1="Tamer's Earring",legs="Stout Kecks"}
		
		sets.precast.JA.Spur = {
			
		feet="Nukumi Ocreae +1",back="Artio's Mantle"
	}

        sets.precast.JA['Feral Howl'] = {
				ammo="Plumose Sachet",
				head="Seiokona Beret",
				neck="Voltsurge Torque",
				ear1="Gwati Earring",
				ear2="Enchanter Earring +1",
                body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
				hands="Sombra Mittens +1",
				ring1="Perception Ring",
				ring2="Sangoma Ring",
				back="Aput Mantle +1",
				waist="Salire Belt",
				legs="Iuitl Tights +1",
				feet="Scamp's Sollerets"}

		sets.precast.JA.Reward = {    
			ammo="Pet Food Theta",
			body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
    legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
    feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	
	
	sets.precast.JA.Charm = {
				ammo="Tsar's Egg",
				head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
				body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
				hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
				legs={ name="Ankusa Trousers +1", augments={'Enhances "Familiar" effect',}},
				feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
				neck={ name="Unmoving Collar +1", augments={'Path: A',}},
				waist="Chaac Belt",
				left_ear="Handler's Earring",
				right_ear={ name="Handler's Earring +1", augments={'Path: A',}},
				left_ring="Thurandaut Ring",
				right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
				back="Tantalic Cape",
	
			}

        -- CURING WALTZ
        sets.precast.Waltz = {
			body="Gleti's Cuirass",
			legs="Dashing Subligar",
			}
                
        -- HEALING WALTZ
        sets.precast.Waltz['Healing Waltz'] = {		body="Gleti's Cuirass",
		legs="Dashing Subligar",}

	-- STEPS
	sets.precast.RA = {	 ammo=empty,
		range="Trollbane",
	 head="Malignance Chapeau",
	 body="Malignance Tabard",
	 hands="Malignance Gloves",
	 legs="Malignance Tights",
	 feet="Malignance Boots",
	 neck="Sanctity Necklace",
	 waist="Eschan Stone",
	 left_ear="Telos Earring",
	 right_ear="Crep. Earring",
	 left_ring="Cacoethic Ring",
	 right_ring="Crepuscular Ring",}
	
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
				neck="Magoraga Beads",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                left_ear="Etiolation Earring",
                right_ear="Loquac. Earring",
                left_ring="Thurandaut Ring",
                right_ring="Prolix Ring",})
				
		sets.precast.FC.Cure = set_combine(sets.precast.FC, {
				ammo="Sapience Orb",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                right_ear="Loquac. Earring",
				neck="Diemer Gorget",
				left_ear="Mendi. Earring",
				right_ring="Prolix Ring",
				})
			

        -- MIDCAST SETS
        sets.midcast.FastRecast = {
			ammo="Sapience Orb",
                hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
                left_ear="Etiolation Earring",
                right_ear="Loquac. Earring",
                left_ring="Thurandaut Ring",
                right_ring="Prolix Ring",
			}
				
 
        sets.midcast.Utsusemi = sets.midcast.FastRecast

	sets.midcast.Cure = {
			body="Jumalik Mail",
			hands="Leyline Gloves",
			waist="Gishdubar Sash",
			ear2="Mendi. Earring",
			back="Solemnity Cape",
			left_ring="Stikini Ring +1",
			right_ring="Stikini Ring +1",
		}

	sets.midcast.Curaga = sets.midcast.Cure

	sets.midcast.Stoneskin = {
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",

		}
	
	sets.midcast.Refresh = {    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
	left_ring="Stikini Ring +1",
	right_ring="Stikini Ring +1",

		}
			
	sets.midcast.Haste = {
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		}
			
	sets.midcast.Flash = {
			head="Jumalik Helm",
			body="Jumalik Mail",
			hands={ name="Leyline Gloves", augments={'Accuracy+1','Mag. Acc.+5','"Mag.Atk.Bns."+5','"Fast Cast"+1',}},
			neck="Voltsurge Torque",
			legs="Augury Cuisses",
			ear1={ name="Moonshade Earring", augments={'Mag. Acc.+4','Latent effect: "Refresh"+1',}},
			back="Izdubar Mantle",
		}

	sets.midcast.Cursna = set_combine(sets.midcast.FastRecast, {
			ring1="Haoma's Ring",
			neck="Malison Medallion",
			waist="Gishdubar Sash",
			legs="Augury Cuisses",
			ring2="Haoma's Ring"
		})

	sets.midcast.Protect = {neck="Incanter's Torque",
    waist="Olympus Sash",
    righ_ear="Andoaa Earring",
		left_ear="Brachyura Earring",
		left_ring="Sheltered Ring",
		right_ring="Stikini Ring +1",
	}
	sets.midcast.Protectra = sets.midcast.Protect

	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Protect

	sets.midcast['Enfeebling Magic'] = {
		ammo="Plumose Sachet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Enmerkar Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		}

	sets.midcast['Divine Magic'] = {
		ammo="Plumose Sachet",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
				feet="Malignance Boots",
				neck="Sanctity Necklace",
				waist="Eschan Stone",
				left_ear="Enmerkar Earring",
				right_ear="Crep. Earring",
				left_ring="Stikini Ring +1",
				right_ring="Stikini Ring +1",
		}		
			
	sets.midcast['Dark Magic'] = {
	
		ammo="Plumose Sachet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Enmerkar Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		}		
			
	sets.midcast['Elemental Magic'] = {
		
		ammo="Plumose Sachet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Enmerkar Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		}
			
	sets.midcast.Stun = set_combine(sets.midcast['Elemental Magic'], {
	
		ammo="Plumose Sachet",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Enmerkar Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
				})
				
		sets.precast.FC.Stun = set_combine(sets.precast.FC, {

				ammo="Plumose Sachet",
				head="Malignance Chapeau",
				body="Malignance Tabard",
				hands="Malignance Gloves",
				legs="Malignance Tights",
				feet="Malignance Boots",
				neck="Sanctity Necklace",
				waist="Eschan Stone",
				left_ear="Enmerkar Earring",
				right_ear="Crep. Earring",
				left_ring="Stikini Ring +1",
				right_ring="Stikini Ring +1",
				})
			
			
        -- WEAPONSKILLS
        -- Default weaponskill sets.
		
		
		--Met(ft.), Yilan, Hanbi
		
	sets.precast.WS = {
			ammo="Ginsen",
			head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
			body="Nyame Mail",
			hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
			legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
			feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
			neck="Shulmanu Collar",
			waist={ name="Sailfi Belt +1", augments={'Path: A',}},
			left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
			right_ear="Thrud Earring",
			left_ring="Regal Ring",
			right_ring="Epaminondas's Ring",
			back="Atheling Mantle",
		}

	sets.precast.WS.WSMedAcc = {
		ammo="Ginsen",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nyame Mail",
		hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
		legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
		neck="Shulmanu Collar",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Atheling Mantle",
	}

	sets.precast.WS.WSHighAcc = {
		ammo="Ginsen",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nyame Mail",
		hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
		legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
		neck="Shulmanu Collar",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Atheling Mantle",
		}

        -- Specific weaponskill sets.
        sets.precast.WS['Ruinator'] = set_combine(sets.precast.WS, {
		    ammo="Coiste Bodhar",
             head={ name="Blistering Sallet +1", augments={'Path: A',}},
            body={ name="Emicho Haubert +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
            hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
         legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
            feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
             neck="Fotia Gorget",
            waist="Fotia Belt",
            left_ear="Brutal Earring",
           right_ear="Sherida Earring",
            left_ring="Epona's Ring",
            right_ring="Gere Ring",
           back="Atheling Mantle",
		})
		
		sets.precast.WS['Ruinator'].Mekira = set_combine(sets.precast.WS['Ruinator'], {head="Gavialis Helm"})
		
        sets.precast.WS['Ruinator'].WSMedAcc = set_combine(sets.precast.WS.WSMedAcc, {})
		
        sets.precast.WS['Ruinator'].WSHighAcc = set_combine(sets.precast.WS.WSHighAcc, {})

        sets.precast.WS['Onslaught'] = set_combine(sets.precast.WS, {})
			
    sets.precast.WS['Onslaught'].WSMedAcc = set_combine(sets.precast.WSMedAcc, {})
	
    sets.precast.WS['Onslaught'].WSHighAcc = set_combine(sets.precast.WSHighAcc, {})

	sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {
		ammo="Coiste Bodhar",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
	   body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
	   hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
	legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
	   feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Fotia Gorget",
	   waist="Fotia Belt",
	   left_ear="Brutal Earring",
	  right_ear="Sherida Earring",
	   left_ring="Epona's Ring",
	   right_ring="Gere Ring",
	  back="Atheling Mantle",
	})
	sets.precast.WS['Decimation'].WSMedAcc = set_combine(sets.precast.WS['Decimation'], {
		ammo="Coiste Bodhar",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
	   body={ name="Emicho Haubert", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
	   hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
     	legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
	   feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Fotia Gorget",
	   waist="Fotia Belt",
	   left_ear="Brutal Earring",
	  right_ear="Sherida Earring",
	   left_ring="Epona's Ring",
	   right_ring="Gere Ring",
	  back="Atheling Mantle",
	})

	sets.precast.WS['Rampage '] = set_combine(sets.precast.WS['Decimation'], {})
	sets.precast.WS['Rampage '].WSMedAcc = set_combine(sets.precast.WS['Decimation'], {})


	sets.precast.WS['Calamity'] = set_combine(sets.precast.WS, {
		ammo="Aurgelmir Orb +1",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nyame Mail",
		hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
		legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
		neck="Shulmanu Collar",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Atheling Mantle",
	})
	sets.precast.WS['Calamity'].WSMedAcc = set_combine(sets.precast.WS['Calamity'], {
		ammo="Aurgelmir Orb +1",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nyame Mail",
		hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
		legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
		neck="Shulmanu Collar",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Atheling Mantle",
	})

	sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS['Calamity'], {})
	sets.precast.WS['Mistral Axe'].WSMedAcc = set_combine(sets.precast.WS['Calamity'], {})

		
	sets.precast.WS['Primal Rend'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body="Nyame Mail",
		hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
		legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Beithir Ring",
		right_ring="Epaminondas's Ring",
}	
sets.precast.WS['Primal Rend'].WSMedAcc = set_combine(sets.precast.WS['CalaPrimal Rendmity'], {
		ammo="Pemphredo Tathlum",
	head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
	body="Nyame Mail",
	hands={ name="Valorous Mitts", augments={'"Store TP"+1','MND+1','Weapon skill damage +8%','Accuracy+8 Attack+8','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
	legs={ name="Valorous Hose", augments={'Weapon skill damage +5%','CHR+7','Accuracy+12 Attack+12','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
	feet={ name="Valorous Greaves", augments={'Weapon skill damage +5%','STR+6','Attack+6',}},
	neck="Baetyl Pendant",
	waist="Orpheus's Sash",
	left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
	right_ear="Friomisi Earring",
	left_ring="Beithir Ring",
	right_ring="Epaminondas's Ring",
})

    sets.precast.WS['Aeolian Edge'] = {
    ammo="Pemphredo Tathlum",
    head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
    body="Nyame Mail",
    hands="Meg. Gloves +2",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Epaminondas's Ring",
    back="Moonlight Cape",
}       
sets.precast.WS['Aeolian Edge'].WSMedAcc = set_combine(sets.precast.WS['Aeolian Edge'], {
    ammo="Pemphredo Tathlum",
    head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
    body="Nyame Mail",
    hands="Meg. Gloves +2",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck="Baetyl Pendant",
    waist="Orpheus's Sash",
    left_ear="Friomisi Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Regal Ring",
    right_ring="Epaminondas's Ring",
    back="Moonlight Cape",
 })

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
	
	
	sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'],{})			
		sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Primal Rend'],{})
	
	 sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS['Primal Rend'],{})

			
			
	 sets.midcast.RA = {			range="Trollbane",
	 ammo=empty,
	 head="Malignance Chapeau",
	 body="Malignance Tabard",
	 hands="Malignance Gloves",
	 legs="Malignance Tights",
	 feet="Malignance Boots",
	 neck="Sanctity Necklace",
	 waist="Eschan Stone",
	 left_ear="Telos Earring",
	 right_ear="Crep. Earring",
	 left_ring="Cacoethic Ring",
	 right_ring="Crepuscular Ring",}
	-- PET SIC & READY MOVES
	sets.midcast.Pet.WS = {
		ammo="Voluspa Tathlum",
		head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
		body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		hands="Nukumi Manoplas +1",
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet="Gleti's Boots",
		neck="Shulmanu Collar",
		waist="Klouskap Sash +1",
		left_ear="Sroda Earring",
		right_ear="Kyrene's Earring",
		left_ring="Thurandaut Ring",
		right_ring="C. Palug Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
			
	sets.midcast.Pet.DA = {
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
	body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
    hands="Nukumi Manoplas +1",
    legs={ name="Emicho Hose", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Incarnation Sash",
    left_ear="Sroda Earring",
    right_ear="Domes. Earring",
    left_ring="Thurandaut Ring",
    right_ring="C. Palug Ring",
    back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}

	sets.midcast.Pet.MabReady = set_combine(sets.midcast.Pet.WS, {
			
		ammo="Voluspa Tathlum",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Subtle Blow"+10','Pet: STR+2',}},
		body="Udug Jacket",
		hands="Nukumi Manoplas +1",
		legs={ name="Valorous Hose", augments={'Pet: "Mag.Atk.Bns."+29','Pet: "Dbl. Atk."+2','Pet: Accuracy+7 Pet: Rng. Acc.+7','Pet: Attack+10 Pet: Rng.Atk.+10',}},
		feet="Gleti's Boots",
		neck="Adad Amulet",
		waist="Incarnation Sash",
		left_ear="Enmerkar Earring",
		right_ear="Crep. Earring",
		left_ring="C. Palug Ring",
		right_ring="Tali'ah Ring",
		back="Argocham. Mantle",
})
		
		--	head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','System: 1 ID: 1794 Val: 12','Pet: Accuracy+10 Pet: Rng. Acc.+10',}},
		--	body={ name="Valorous Mail", augments={'Pet: "Mag.Atk.Bns."+30','Pet: Haste+2','Pet: STR+9','Pet: Attack+7 Pet: Rng.Atk.+7',}},
		--	hands="Nukumi Manoplas +1",
		--	legs={ name="Valor. Hose", augments={'Pet: "Mag.Atk.Bns."+30','Pet: CHR+8',}},
		--	feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: Phys. dmg. taken -1%','Pet: STR+3',}},
		--	back={ name="Artio's Mantle", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Mag. Acc.+10',}},
		--	back="Argocham. Mantle",
		
	sets.midcast.Pet.MaccReady = set_combine(sets.midcast.Pet.WS, {
		ammo="Voluspa Tathlum",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Adad Amulet",
		waist="Incarnation Sash",
		left_ear="Enmerkar Earring",
		right_ear="Kyrene's Earring",
		left_ring="C. Palug Ring",
		right_ring="Tali'ah Ring",
		back="Argocham. Mantle",
})
	
	sets.midcast.Pet.BreathReady = set_combine(sets.midcast.Pet.WS, {
			--MAB
			ammo="Voluspa Tathlum",
			head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Subtle Blow"+10','Pet: STR+2',}},
			body="Udug Jacket",
			hands="Nukumi Manoplas +1",
			legs={ name="Valorous Hose", augments={'Pet: "Mag.Atk.Bns."+29','Pet: "Dbl. Atk."+2','Pet: Accuracy+7 Pet: Rng. Acc.+7','Pet: Attack+10 Pet: Rng.Atk.+10',}},
			feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+28','Pet: DEX+7','Pet: Accuracy+2 Pet: Rng. Acc.+2','Pet: Attack+6 Pet: Rng.Atk.+6',}},
			neck="Adad Amulet",
			waist="Incarnation Sash",
			left_ear="Enmerkar Earring",
			right_ear="Kyrene's Earring",
			left_ring="C. Palug Ring",
			right_ring="Tali'ah Ring",
			back="Argocham. Mantle",
			--MACC
			ammo="Voluspa Tathlum",
			head="Gleti's Mask",
			body="Gleti's Cuirass",
			hands="Gleti's Gauntlets",
			legs="Gleti's Breeches",
			feet="Gleti's Boots",
			neck="Adad Amulet",
			waist="Incarnation Sash",
			left_ear="Enmerkar Earring",
			right_ear="Kyrene's Earring",
			left_ring="C. Palug Ring",
			right_ring="Tali'ah Ring",
			back="Argocham. Mantle",
			})
			
		
	sets.midcast.Pet.Neutral = {  }
	
	sets.midcast.Pet.Favorable = {

	range="Killer Shortbow",
	head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
	body="Nukumi Gausape +1",
	hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
    legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
	feet="Tali'ah Crackows +2",
	neck="Shulmanu Collar",
	waist="Incarnation Sash",
	left_ear="Sroda Earring",
	right_ear="Enmerkar Earring",
	left_ring="Varar Ring +1",
	right_ring="Varar Ring +1",
	back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
}
			
	sets.midcast.Pet.Killer = {
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		sub="Kaidate",
		range="Killer Shortbow",
		body="Nukumi Gausape +1",
	}
			
	sets.midcast.Pet.HighAcc = {
			ear1="Enmerkar Earring",
			ring2="Varar Ring +1 +1",
			head="Totemic Helm +3",
			body={ name="Valorous Mail", augments={'Pet: Accuracy+27 Pet: Rng. Acc.+27','Pet: "Store TP"+1','Pet: DEX+14','Pet: Attack+13 Pet: Rng.Atk.+13',}},
			legs={ name="Valor. Hose", augments={'Pet: Accuracy+28 Pet: Rng. Acc.+28','Pet: "Regen"+4','Pet: Attack+13 Pet: Rng.Atk.+13',}},
			feet="Tot. Gaiters +3",
			hands="Nukumi Manoplas +1",
			ammo="Demonry Core",
			neck="Shulmanu Collar",
			waist="Incarnation Sash",
			ear2="Hija Earring",
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},
		}
			
	sets.midcast.Pet.MaxAcc = {
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
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			
	sets.midcast.Pet.ArktoiAcc = {
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
			ring1="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			
	sets.midcast.Pet.Vagary = {
		head="Tali'ah Turban +2",
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
	    legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet="Tali'ah Crackows +2",
		neck="Shulmanu Collar",
		waist="Incarnation Sash",
		left_ear="Sroda Earring",
		right_ear="Enmerkar Earring",
		left_ring="Varar Ring +1",
		right_ring="Varar Ring +1",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},}
	
	sets.midcast.Pet.TPBonus = {hands="Nukumi Manoplas +1",}
		
	sets.midcast.Pet.ReadyRecast = {
		legs="Gleti's Breeches",
	} 


        -- RESTING
        sets.resting = {		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		left_ring="Paguroidea Ring",}
        
        -- IDLE SETS
	sets.ExtraRegen = {
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		left_ear="Infused Earring",
		left_ring="Paguroidea Ring",
	}
	
	sets.WaterRegen = {       
	body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    neck={ name="Bathy Choker +1", augments={'Path: A',}},
    left_ear="Infused Earring",
    left_ring="Paguroidea Ring",}

	
    sets.idle = {
		range="Trollbane",
		ammo=empty,
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck={ name="Loricate Torque +1", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Tuisto Earring",
		left_ring="Fortified Ring",
		right_ring="Warden's Ring",
		back="Moonlight Cape",
}
			
	sets.idle.MDTMaster = {		
		head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','Attack+3','Pet: "Regen"+1',}},
		body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		neck="Shepherd's Chain",
		waist="Isa Belt",
		left_ear="Rimeice Earring",
		right_ear="Enmerkar Earring",
		left_ring="Thurandaut Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
}
			
	sets.idle.MNormal = set_combine(sets.idle, {
		range="Trollbane",
		ammo=empty,
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sanare Earring",
		left_ring="Shadow Ring",
		right_ring="Defending Ring",
		back="Engulfer Cape +1",
})

	sets.idle.Turtle = set_combine(sets.idle, {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sanare Earring",
		left_ring="Shadow Ring",
		right_ring="Defending Ring",
		back="Engulfer Cape +1",
})
			
	sets.idle.MEva = set_combine(sets.idle, {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sanare Earring",
		left_ring="Shadow Ring",
		right_ring="Defending Ring",
		back="Engulfer Cape +1",
		})
			
    sets.idle.Refresh = set_combine(sets.idle, {
		body="Twilight Mail"
})
			
	sets.idle.Reraise = set_combine(sets.idle, {head="Twilight Helm",body="Twilight Mail"})

	sets.idle.Pet = set_combine(sets.idle, { 
		head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','ATTACK+3','PET: "REGEN"+1',}},		
		body="Tot. Jackcoat +2",
		hands="Gleti's Gauntlets",
	  legs="Tali'ah Sera. +2",
	  feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
	  neck="Shepherd's Chain",
	  waist="Isa Belt",
	  left_ear="Hypaspist Earring",
	  right_ear={ name="Handler's Earring +1", augments={'Path: A',}},
	  left_ring="Thurandaut Ring",
	  back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
})


			
	sets.idle.Pet.Engaged = set_combine(sets.idle, {
		head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','ATTACK+3','PET: "REGEN"+1',}},		
		body="Tot. Jackcoat +2",
		hands="Gleti's Gauntlets",
	  legs="Tali'ah Sera. +2",
	  feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
	  neck="Shepherd's Chain",
	  waist="Isa Belt",
	  left_ear="Hypaspist Earring",
	  right_ear={ name="Handler's Earring +1", augments={'Path: A',}},
	  left_ring="Thurandaut Ring",
	  back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
	})
        
        -- DEFENSE SETS
   sets.defense.PDT = {
    ammo="Iron Gobbet",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Loricate Torque +1", augments={'Path: A',}},
    waist="Flume Belt +1",
    left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
    right_ear="Tuisto Earring",
    left_ring="Fortified Ring",
    right_ring="Warden's Ring",
	back="Moonlight Cape",
}

    sets.defense.PetPDT = {		
		head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','Attack+3','Pet: "Regen"+1',}},
		body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck="Shepherd's Chain",
		waist="Isa Belt",
		left_ear="Hypaspist Earring",
		right_ear={ name="Handler's Earring +1", augments={'Path: A',}},
		left_ring="Thurandaut Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
	}
	sets.defense.Killer = {
		
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
    body={ name="Emicho Haubert +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
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
    ammo="Voluspa Tathlum",
    head={ name="Emicho Coronet +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
    body={ name="Emicho Haubert +1", augments={'Pet: Accuracy+20','Pet: Attack+20','Pet: "Dbl. Atk."+4',}},
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
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sanare Earring",
		left_ring="Shadow Ring",
		right_ring="Defending Ring",
		back="Engulfer Cape +1",
})

	sets.defense.MDTShell =  {
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Warder's Charm +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear={ name="Odnowa Earring +1", augments={'Path: A',}},
		right_ear="Sanare Earring",
		left_ring="Shadow Ring",
		right_ring="Defending Ring",
		back="Engulfer Cape +1",
}

	sets.defense.PetMDT =  {
		    head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','Attack+3','Pet: "Regen"+1',}},
			body={ name="Taeon Tabard", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
			hands="Gleti's Gauntlets",
			legs="Tali'ah Sera. +2",
			feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
			neck="Shepherd's Chain",
			waist="Isa Belt",
			left_ear="Rimeice Earring",
			right_ear="Enmerkar Earring",
			left_ring="Thurandaut Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
}

	sets.Kiting = {feet="Skadi's Jambeaux +1"}

        -- MELEE (SINGLE-WIELD) SETS
	
	--1066 ACC
	sets.engaged = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Ainia Collar",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Atheling Mantle",
}
		
		
	--1172 ACC
	sets.engaged.Shield = {
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
		ammo="Paeapua",
		head="Malignance Chapeau",
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		neck="Anu Torque",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Suppanomimi",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: "Regen"+10','Pet: Damage taken -5%',}},
		}
		sets.engaged.CRIT = {
			ammo="Coiste Bodhar",
			head={ name="Blistering Sallet +1", augments={'Path: A',}},
			body="Meg. Cuirie +2",
			hands="Gleti's Gauntlets",
			legs="Heyoka Subligar",
			feet="Thereoid Greaves",
			neck="Nefarious Collar +1",
			waist="Gerdr Belt",
			left_ear="Sherida Earring",
			right_ear="Brutal Earring",
			left_ring="Gere Ring",
			right_ring="Hetairoi Ring",
			back="Atheling Mantle",
			}
			
	sets.engaged.MedAccHaste = {
		}
			
	sets.engaged.HighAcc = {
}
			
	sets.engaged.HighAccHaste = {
}
			
	-- MELEE (SINGLE-WIELD) HYBRID SETS
	
	sets.engaged.Hybrid = set_combine(sets.engaged, {
})
			
	sets.engaged.Shield.Hybrid = set_combine(sets.engaged.Shield, {
})
			
	sets.engaged.MedAcc.Hybrid = set_combine(sets.engaged.MedAcc, {
})
			
	sets.engaged.MedAccHaste.Hybrid = set_combine(sets.engaged.MedAccHaste, {
})
			
	sets.engaged.HighAcc.Hybrid = set_combine(sets.engaged.HighAcc, {
})
			
	sets.engaged.HighAccHaste.Hybrid = set_combine(sets.engaged.HighAccHaste, {
})

        -- MELEE (DUAL-WIELD) SETS FOR DNC AND NIN SUBJOB
		
	sets.engaged.DW = {
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Atheling Mantle",
			}
			
	sets.engaged.DW.Shield = {
		
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
			left_ring="Gere Ring",
			right_ring="Epona's Ring",
			back={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Dbl.Atk."+10',}},}
			sets.engaged.DW.CRIT = {
				ammo="Coiste Bodhar",
				head={ name="Blistering Sallet +1", augments={'Path: A',}},
				body="Meg. Cuirie +2",
				hands="Gleti's Gauntlets",
				legs="Heyoka Subligar",
				feet="Thereoid Greaves",
				neck="Nefarious Collar +1",
				waist="Gerdr Belt",
				left_ear="Sherida Earring",
				right_ear="Brutal Earring",
				left_ring="Gere Ring",
				right_ring="Hetairoi Ring",
				back="Atheling Mantle",
				}
		-- MedAcc intended for but not limited to Hybrid pet DT/DW use 
		
	sets.engaged.DW.MedAcc = {    ammo="Coiste Bodhar",
    head={ name="Blistering Sallet +1", augments={'Path: A',}},
    body="Tali'ah Manteel +2",
    hands="Malignance Gloves",
    legs="Meg. Chausses +2",
	feet="Malignance Boots",
    neck="Anu Torque",
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back="Atheling Mantle",
}
			
	sets.engaged.DW.MedAccHaste = {
		ammo="Coiste Bodhar",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet={ name="Taeon Boots", augments={'Pet: Attack+25 Pet: Rng.Atk.+25','Pet: "Dbl. Atk."+5','Pet: Damage taken -4%',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Atheling Mantle",}
			
	sets.engaged.DW.HighAcc = {
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
			back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		}
			
	sets.engaged.DW.HighAccHaste = {
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
		ammo="Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Ainia Collar",
		waist="Reiki Yotai",
		left_ear="Eabani Earring",
		right_ear="Sherida Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back="Atheling Mantle",
		})
			
	sets.engaged.DW.Shield.Hybrid = set_combine(sets.engaged.DW.Shield, {
 })
			
	sets.engaged.DW.MedAcc.Hybrid = set_combine(sets.engaged.DW.MedAcc, {
})
			
	sets.engaged.DW.MedAccHaste.Hybrid = set_combine(sets.engaged.DW.MedAccHaste, {
})
			
	sets.engaged.DW.HighAcc.Hybrid = set_combine(sets.engaged.DW.HighAcc, {
})
			
	sets.engaged.DW.HighAccHaste.Hybrid = set_combine(sets.engaged.DW.HighAccHaste, {
})

	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET ENGAGED
	sets.engaged.PetStance = set_combine(sets.engaged, {

		})
			
	sets.engaged.PetStance.Shield = set_combine(sets.engaged.Shield, {
	    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",})
			
	sets.engaged.PetStance.MedAcc = set_combine(sets.engaged.MedAcc, {
})
			
	sets.engaged.PetStance.MedAccHaste = set_combine(sets.engaged.MedAccHaste, {
	    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",})
			
	sets.engaged.PetStance.HighAcc = set_combine(sets.engaged.HighAcc, {
	    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",})
			
	sets.engaged.PetStance.HighAccHaste = set_combine(sets.engaged.HighAccHaste, {
	    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",})

	-- GEARSETS FOR MASTER ENGAGED (SINGLE-WIELD) & PET TANKING
	
	sets.engaged.PetTank = set_combine(sets.engaged, {
			})
			
	sets.engaged.PetTank.Shield = set_combine(sets.engaged.Shield, {
			})
			
	sets.engaged.PetTank.MedAcc = set_combine(sets.engaged.MedAcc, {
			head="Anwig Salade",
    hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.PetTank.MedAccHaste = set_combine(sets.engaged.MedAccHaste, {
			head="Anwig Salade",
                       hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
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
	    head="Gleti's Mask",
    body="Gleti's Cuirass",
    hands="Gleti's Gauntlets",
    legs="Gleti's Breeches",
    feet="Gleti's Boots",
    neck="Shulmanu Collar",
    waist="Klouskap Sash +1",
		})
			
	sets.engaged.DW.PetStance.Shield = set_combine(sets.engaged.DW.Shield, {
			head="Anwig Salade",
                      body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
			hands="Regimen Mittens",
			waist="Incarnation Sash",
			legs="Wisent Kecks",
			feet="Armada Sollerets"})
			
	sets.engaged.DW.PetStance.MedAcc = set_combine(sets.engaged.DW.MedAcc, {
                     head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
			hands="Regimen Mittens",
			waist="Incarnation Sash"})
			
	sets.engaged.DW.PetStance.MedAccHaste = set_combine(sets.engaged.DW.MedAccHaste, {
                     head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
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
                       hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.DW.PetTank.MedAccHaste = set_combine(sets.engaged.DW.MedAccHaste, {
			head="Anwig Salade",
                       hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
			back="Oneiros Cappa",
			legs="Nukumi Quijotes +1"})
			
	sets.engaged.DW.PetTank.HighAcc = set_combine(sets.engaged.DW.HighAcc, {
			head="Anwig Salade",
			hands="Regimen Mittens"})
			
	sets.engaged.DW.PetTank.HighAccHaste = set_combine(sets.engaged.DW.HighAccHaste, {
			head="Anwig Salade",
			hands="Regimen Mittens"})

sets.buff['Killer Instinct'] = {
head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
body="Nukumi Gausape +1",

}

sets.buff.Doomed = {neck="Nicander's Necklace",
    waist="Gishdubar Sash",
    left_ring="Purity Ring",
    right_ring="Saida Ring",}

sets.THBelt = {	
			}

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
                hands={ name="Valorous Mitts", augments={'Pet: Attack+30 Pet: Rng.Atk.+30','Pet: "Store TP"+10','Pet: Accuracy+3 Pet: Rng. Acc.+3',}}
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
		organizer_items = {
			item="Gyudon",
			item="Revival Root",
			item="Silver Voucher",
			item="Holy Water",
			item="Gyudon",
			item="Grape Daifuku",
			item="Miso Ramen",
			item="Remedy",
			item="Fiend Blood",
			item="Sanjaku-Tenugui",
			item="Shinobi-Tabi",
			feet="Thereoid Greaves",
			waist="Gerdr Belt",
			neck="Nefarious Collar +1",
			item="Copper Voucher",
			range="Trollbane",
			left_ring="Haoma's Ring",
			item="Bambrox's Shawl",
			item="Centurio's Armor",
			item="Tumult's Blood",
			item="Vidmapire's Claw",
			item="Vedrfolnir's Wing",
			item="Trump Card",
			item="Silent Oil",
			item="Shihei",
			item="Hidhaegg's Scale",
			item="SP Gobbie Key",
			left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
			item="Sublime Sushi",
			neck="Magoraga Beads",
			waist="Windbuffet Belt +1",
		}
		add_to_chat(159,'Author Aragan BST.Lua File (from Asura)')
		add_to_chat(159,'For details, visit https://github.com/aragan/ffxi-lua-all-job')
		
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(9, 11)
	elseif player.sub_job == 'WAR' then
		set_macro_page(9, 11)
	elseif player.sub_job == 'NIN' then
		set_macro_page(9, 11)
	else
		set_macro_page(9, 11)
	end
	
end