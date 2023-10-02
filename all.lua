-- Initialization function for this job file.
 
local jobs = T{ "BLU", "COR", "DNC", "DRG", "MNK", "NIN", "RUN", "THF" }
 
mysets = {}
 
for k,v in pairs(jobs) do
    include(v .. '.lua')
    get_sets()
    mysets[v] = sets
    sets = {}
 end
 
 
function get_sets()
    include('organizer-lib')
    include('Mote-TreasureHunter')
    for k,v in pairs(mysets) do sets[k] = v end
end