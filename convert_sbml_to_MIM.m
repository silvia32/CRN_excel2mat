clear all
close all
clc

addpath('./funcs')

% Load data
file_name = 'smallCRN';
modelObj = sbmlimport(fullfile('CRN_sbml', sprintf('%s.sbml', file_name)));

% Create MIM structure and fill it
FMIM = struct;

[species_names, species_initial_values, species_units, species_is_constant, species_alias, ...
    species_alias_conc, reaction_arrow, k_names, reaction_flux_rate, k_values, k_units, k_alias] = f_species(modelObj);
FMIM.species.names = species_names;
FMIM.species.std_initial_values = species_initial_values;
FMIM.species.units = species_units';
FMIM.species.is_constant = species_is_constant;
FMIM.species.alias = species_alias;
FMIM.species.alias_conc = species_alias_conc;

[reaction_flux_decoded, reaction_flux_decoded_ind,...
    species_products, species_products_ind,...
    complexes, complexes_ind, reactions, reactions_ind,...
    nr_single_arrow, nr_double_arrow, reactions2flux_rates] = ...
    f_decode_reactions(reaction_arrow, reaction_flux_rate, species_names, k_names);

FMIM.reactions.arrow = reaction_arrow;
FMIM.reactions.Flux_rate = reaction_flux_rate;
FMIM.reactions.Flux_decoded = reaction_flux_decoded;
FMIM.reactions.Flux_decoded_ind = reaction_flux_decoded_ind;
FMIM.species.products = species_products;
FMIM.species.products_ind = species_products_ind;

reactions_lastcolumn = arrayfun(@(i) sprintf('R_{%d}', i+1), 1:length(k_names), 'UniformOutput', false);
FMIM.reactions.details = [reactions, reactions_lastcolumn'];

FMIM.reactions.details_ind = reactions_ind;
FMIM.reactions.nr_irreversible = nr_single_arrow;
FMIM.reactions.nr_reversible = nr_double_arrow;
FMIM.reactions.reactions2flux_rates = reactions2flux_rates;

[new_reactions, reactions_idx] = f_rates(reaction_arrow);
FMIM.rates.names = k_names;
FMIM.rates.in_reactions = new_reactions;
FMIM.rates.std_values = k_values';
FMIM.rates.units = k_units;
FMIM.rates.in_reactions_idx = reactions_idx;
FMIM.rates.alias = k_alias;

[S,v,Z,B,ind_one] = ...
    matrix_ZBv(species_names, complexes_ind, reactions_ind);
S(species_is_constant,:) = zeros(length(find(species_is_constant == 1)),size(S,2));
FMIM.matrix.S = S;
FMIM.matrix.v = v;
FMIM.matrix.Z = Z;
FMIM.matrix.B = B;
FMIM.matrix.ind_one = ind_one;
FMIM.matrix.Nl = f_compute_semipositive_conservations(S);

[~, ~, ~, ~] = f_elemental_species(S, species_names, FMIM.species.std_initial_values);
FMIM = f_elemental_species_values_smallCRN(FMIM);

%% Save
save_path = './CRN_mat';
save(fullfile(save_path, sprintf('%s.mat', file_name)), 'FMIM')