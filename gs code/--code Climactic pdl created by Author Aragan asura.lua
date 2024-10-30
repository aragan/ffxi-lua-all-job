

function init_gear_sets()

    sets.precast.WS["Rudra's Storm"].Clim = set_combine(sets.precast.WS["Rudra's Storm"], {})
    sets.precast.WS["Rudra's Storm"].PDL.Clim = set_combine(sets.precast.WS["Rudra's Storm"], {})
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
        if buffactive["Climactic Flourish"] and spell.name == "Rudra's Storm" then --code Climactic pdl created by Author Aragan asura
            if state.WeaponskillMode.value == 'PDL' then
                equip(sets.precast.WS["Rudra's Storm"].PDL.Clim)
            elseif state.WeaponskillMode.value ~= 'PDL' then
            equip(sets.precast.WS["Rudra's Storm"].Clim)
            end
        end
    end