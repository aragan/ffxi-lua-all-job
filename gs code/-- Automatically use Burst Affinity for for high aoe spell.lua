-- Automatically use Burst Affinity when it's available for for high aoe spell
--code created by Author Aragan asura
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.english == 'Searing Tempest' or spell.english == 'Spectral Floe' 
	or spell.english == 'Anvil Lightning' or spell.english == 'Scouring Spate' 
    or spell.english == 'Nectarous Deluge' or spell.english == 'Rending Deluge' 
	or spell.english == 'Droning Whirlwind' or spell.english == 'Gates of Hades' 
	or spell.english == 'Thunderbolt' or spell.english == 'Rail Cannon' or spell.english == 'Atra. Libations' 
	or spell.english == 'Entomb' or spell.english == 'Tenebral Crush' 
	or spell.english == 'Palling Salvo' or spell.english == 'Blinding Fulgor' then

        local allRecasts = windower.ffxi.get_ability_recasts()
        local Burst_AffinityCooldown = allRecasts[182]
        
        
        if player.main_job_level >= 25 and Burst_AffinityCooldown < 3 then
            cast_delay(1.1)
            send_command('@input /ja "Burst Affinity" <me>')
        end
        if not midaction() then
            job_update()
        end
    end
end
end