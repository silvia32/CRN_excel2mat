function MIM = f_elemental_species_values_ALS(MIM)

MIM.species.std_initial_values(ismember(MIM.species.names, 'I')) = 100;
MIM.species.std_initial_values(ismember(MIM.species.names, 'IR')) = 150;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PTP1B')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'IRS1')) = 300;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PTEN')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PP')) = 20;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PI3K')) = 200;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PIP2gen')) = 0.15;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PDK1')) = 100;
MIM.species.std_initial_values(ismember(MIM.species.names, 'mTORC2')) = 300;
MIM.species.std_initial_values(ismember(MIM.species.names, 'Akt')) = 100;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PP2A')) = 20;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PHLPP')) = 20;
MIM.species.std_initial_values(ismember(MIM.species.names, 'GSK3beta')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'PhoC')) = 20;
MIM.species.std_initial_values(ismember(MIM.species.names, 'TSC12')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'RhebGTP')) = 100;
MIM.species.std_initial_values(ismember(MIM.species.names, 'mTORC1')) = 400;
MIM.species.std_initial_values(ismember(MIM.species.names, 'AMPK')) = 325;
MIM.species.std_initial_values(ismember(MIM.species.names, 'S6K1')) = 50;
MIM.species.std_initial_values(ismember(MIM.species.names, 'ppERK')) = 200;
MIM.species.std_initial_values(ismember(MIM.species.names, 'S6')) = 20;
if sum(ismember(MIM.species.names, 'TFEB'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'TFEB')) = 100;
end
if sum(ismember(MIM.species.names, 'DEPTOR'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'DEPTOR')) = 100;
end

if sum(ismember(MIM.species.names, 'PASE'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'PASE')) = 100;
end

if sum(ismember(MIM.species.names, 'BP'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'BP')) = 100;
end

if sum(ismember(MIM.species.names, 'eIF4E'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'eIF4E')) = 100;
end

if sum(ismember(MIM.species.names, 'eIF4G'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'eIF4G')) = 100;
end

if sum(ismember(MIM.species.names, 'eIF4A'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'eIF4A')) = 100;
end

if sum(ismember(MIM.species.names, 'PRAS40'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'PRAS40')) = 100;
end

if sum(ismember(MIM.species.names, 'P1433'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'P1433')) = 100;
end

if sum(ismember(MIM.species.names, 'CNstar'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'CNstar')) = 100;
end

if sum(ismember(MIM.species.names, 'CA'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'CA')) = 100;
end

if sum(ismember(MIM.species.names, 'ULK1'))
    MIM.species.std_initial_values(ismember(MIM.species.names, 'ULK1')) = 100;
end