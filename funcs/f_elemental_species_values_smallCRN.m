function MIM = f_elemental_species_values_smallCRN(MIM)

MIM.species.std_initial_values(ismember(MIM.species.names, 'A')) = 100;
MIM.species.std_initial_values(ismember(MIM.species.names, 'B')) = 150;
MIM.species.std_initial_values(ismember(MIM.species.names, 'C')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'D')) = 300;
MIM.species.std_initial_values(ismember(MIM.species.names, 'E')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'F')) = 20;
MIM.species.std_initial_values(ismember(MIM.species.names, 'G')) = 200;