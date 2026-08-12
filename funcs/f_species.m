function [species_names, species_initial_values, species_units, species_is_constant, ...
    species_alias, species_alias_conc, reaction_arrow, k_names, reaction_flux_rate, k_values, k_units, k_alias] = f_1(modelObj)

% species
s = size(modelObj.Species);
n = s(1);

species_names = {};
species_initial_values = zeros(n, 1);
species_units = {};
species_is_constant = zeros(n, 1);
species_alias = {};
species_alias_conc = {};

for i=1:n
    species_names{i} = modelObj.Species(i,1).Name; %NOME SPECIE
    species_initial_values(i) = modelObj.Species(i,1).InitialAmount; %CONCENTRAZIONI INIZIALI SPECIE
    species_units{i} = 'nanomole';
    species_is_constant(i) = modelObj.Species(i,1).Constant;
    
    alias = sprintf('A_{%d}',i);
    species_alias{i} = alias;
    
    alias_conc = sprintf('x_{%d}', i);
    species_alias_conc{i} = alias_conc;

end

species_names = species_names';
species_alias = species_alias';

% reactions
s = size(modelObj.Reactions);
r = s(1);

reaction_arrow = {};
for i = 1:r
    reaction_arrow{i} = modelObj.Reactions(i,1).Reaction;
end
reaction_arrow = reaction_arrow';

% parameters
s = size(modelObj.Parameters);
r_sing = s(1);

k_names = {};
k_values = [];
k_units = {};
k_alias = {};
for i = 1:r_sing
    k_names{i} = modelObj.Parameters(i,1).Name;
    alias = sprintf('k_{%d}',i);
    k_alias{i} = alias;
    k_values(i) = modelObj.Parameters(i,1).Value;
    if regexp(modelObj.Parameters(i,1).Units, 'per_nanmol_per_sec')
        k_units{i} = '1/(nanomole*second)';
    else
        k_units{i} = '1/second';
end

k_names = k_names';
k_units = k_units';


% reactions flux rate
reaction_flux_rate = {};
for i = 1:r
    reaction_flux_rate{i} = modelObj.Reactions(i,1).ReactionRate;
end

reaction_flux_rate = reaction_flux_rate';
species_is_constant = logical(species_is_constant);
end
