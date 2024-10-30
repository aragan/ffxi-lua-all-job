
function job_setup()

state.phalanxset = M(true,false)



send_command('bind !p gs c toggle phalanxset')


function job_buff_change(buff,gain)

if buff == "phalanx" or "Phalanx II" then
    if gain then
        state.phalanxset:set(false)
    end
end
function job_state_change(stateField, newValue, oldValue)

if state.phalanxset .value == true then
    --equip(sets.midcast.Phalanx)
    send_command('gs equip sets.midcast.Phalanx')
    send_command('input /p Phalanx set equiped [ON] PLZ GIVE ME PHALANX')		
else 
    state.phalanxset:set(false)
end