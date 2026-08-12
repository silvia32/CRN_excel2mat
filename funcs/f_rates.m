function [nuove_reazioni, reactions_idx] = f_2(reaction_arrow)
nuove_reazioni = {};    
reactions_idx = {};

for i = 1:length(reaction_arrow)
    
    if regexp(reaction_arrow{i}, '<->')
       nuove_reazioni = [nuove_reazioni; reaction_arrow{i}; reaction_arrow{i}];
       reactions_idx = [reactions_idx; i; i];
    else 
        nuove_reazioni = [nuove_reazioni; reaction_arrow{i}];
        reactions_idx = [reactions_idx; i];
    end
end

