
###############################################################################
# Excel-to-SBML converter for Chemical Reaction Networks (CRN)
#
# This script reads the list of species from the worksheet 'Table_S1'
# and the list of reactions from the worksheet 'Table_S3' of an Excel
# workbook, and generates an SBML model.
#
# Supported reaction types:
#
# Reversible reactions:
#   - A <-> B
#   - A + B <-> C
#   - A <-> B + C
#   - A + B <-> C + D
#
# Irreversible reactions:
#   - A -> B
#   - A + B -> C
#   - A -> B + C
#   - A + B -> C + D
#   - A -> B + C + D
#   - A + B -> C + D + E
#
# Notes:
# - Mass-action kinetics are automatically assigned according to the number
#   of reactants.
# - Irreversible reactions support up to three products.
# - Reversible reactions currently support up to two products.
# - Reactions exceeding these limits must be handled by extending the parser.
###############################################################################

#%% Import packages
from libsbml import *
import pandas as pd
import os.path as op
import numpy as np
import re


#%% Load info from excel file
target = op.join('.', 'excel_data')

xlsx_file = 'smallCRN.xlsx'
species_info = pd.read_excel(op.join(target, xlsx_file), sheet_name='table_S1')
reactions_info = pd.read_excel(op.join(target, xlsx_file), sheet_name='table_S3')

n_species = len(species_info['Protein'])
# Irreversible reactions counted once
n_reactions_forward = len(reactions_info['kf'])
# Reversible reactions counted twice (forward + reverse)
n_reactions_total = len(reactions_info['kf'])-np.sum(np.isnan(reactions_info['kf']))+len(reactions_info['kr'])-np.sum(np.isnan(reactions_info['kr']))


#%% Define species ID
species_ids = species_info['Protein'].to_list()
for idx_species, sp in enumerate(species_ids):
    if '^' in sp:
        old_name = sp
        species_ids[idx_species] = species_ids[idx_species].replace('^', 'e')
        print('Replacing {} with {}'.format(old_name, species_ids[idx_species]))


#%% Define parameters ID
k_names = ['k{}'.format(idx_reaction+1) for idx_reaction in range(n_reactions_total)]


#%% Initialize
document = SBMLDocument(3, 1)
model = document.createModel()
model.setTimeUnits("second")
model.setSubstanceUnits('mole')

c1 = model.createCompartment()
c1.setId('c1')


#%% Define units
nano_mole = model.createUnitDefinition()
nano_mole.setId('nanmol')
unit = nano_mole.createUnit()
unit.setKind(UNIT_KIND_MOLE)
unit.setExponent(1)
unit.setScale(-9)
unit.setMultiplier(1)

per_sec = model.createUnitDefinition()
per_sec.setId('per_sec')
unit = per_sec.createUnit()
unit.setKind(UNIT_KIND_SECOND)
unit.setExponent(-1)
unit.setScale(0)
unit.setMultiplier(1)

per_nM_per_sec = model.createUnitDefinition()
per_nM_per_sec.setId('per_nanmol_per_sec')
unit = per_nM_per_sec.createUnit()
unit.setKind(UNIT_KIND_MOLE)
unit.setExponent(-1)
unit.setScale(9)
unit.setMultiplier(1)
unit = per_nM_per_sec.createUnit()
unit.setKind(UNIT_KIND_SECOND)
unit.setExponent(-1)
unit.setScale(0)
unit.setMultiplier(1)


#%% Add species
for idx_species in range(n_species):
    sp = model.createSpecies()
    sp.setId(species_ids[idx_species])
    sp.setCompartment('c1')
    sp.setInitialAmount(float(species_info['x0 [Nm]'][idx_species]))
    sp.setConstant(bool(species_info['IsConstant'][idx_species]))
    sp.setUnits('nanmol')


#%%


def is_reversible(string):
    return '<->' in string


#%%


def extract_reactants_and_products(reaction):
    if '<->' in reaction:
        elements = reaction.split('<->')
    elif '->' in reaction:
        elements = reaction.split('->')
    else:
        return None, None

    reactants = elements[0].strip()
    products = elements[1].strip() if len(elements) > 1 else ""

    return reactants, products


#%%


def extract_1(string):
    if '+' in string:
        match = re.match(r'^\s*([^+\s]+)\s*', string)
        if match:
            return match.group(1)
        else:
            return None
    else:
        return string.strip()


def extract_2(string):
    if '+' in string:
        match = re.match(r'\s*[^+\s]+\s*\+\s*([^+\s:]+)\s*', string)
        if match:
            return match.group(1)
        else:
            return None
    else:
        return None
    
def extract_3(string):
    if string.count('+') >= 2:
        match = re.match(
            r'\s*[^+\s]+\s*\+\s*[^+\s]+\s*\+\s*([^+\s:]+)\s*',
            string
        )
        if match:
            return match.group(1)
    return None


#%%


t = 0
created_parameter_ids = set()

for idx_reaction_row in range(n_reactions_forward):
    
    if is_reversible(reactions_info['Reaction'][idx_reaction_row]):

        k = model.createParameter()
        k.setId(k_names[t])
        k.setValue(float(reactions_info['kf'][idx_reaction_row]))
        
        if reactions_info['Units_f'][idx_reaction_row] == '1/s':
            k.setUnits('per_sec')
        elif reactions_info['Units_f'][idx_reaction_row] == '1/(nM*s)':
            k.setUnits('per_nanmol_per_sec')


        k = model.createParameter()
        k.setId(k_names[t+1])
        k.setValue(float(reactions_info['kr'][idx_reaction_row]))
        
        if reactions_info['Units_r'][idx_reaction_row] == '1/s':
            k.setUnits('per_sec')
        elif reactions_info['Units_r'][idx_reaction_row] == '1/(nM*s)':
            k.setUnits('per_nanmol_per_sec')

        reactants, products = extract_reactants_and_products(reactions_info['Reaction'][idx_reaction_row])
        reactant_1 = extract_1(reactants)
        reactant_2 = extract_2(reactants)
        product_1 = extract_1(products)
        product_2 = extract_2(products)
        
    
        r1 = model.createReaction()
        r1.setId(reactions_info['Notation'][idx_reaction_row])
        r1.setReversible(True)

        species_ref1 = r1.createReactant()
        species_ref1.setSpecies(reactant_1)

        species_ref2 = r1.createProduct()
        species_ref2.setSpecies(product_1)

        if reactant_2 is not None and product_2 is not None:
            species_ref1 = r1.createReactant()
            species_ref1.setSpecies(reactant_2)

            species_ref2 = r1.createProduct()
            species_ref2.setSpecies(product_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} * {reactant_2} -{k_names[t+1]} * {product_1} * {product_2}'))
    
        if reactant_2 is not None and product_2 is None:
            species_ref1 = r1.createReactant()
            species_ref1.setSpecies(reactant_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} * {reactant_2} -{k_names[t+1]} * {product_1}'))


        if reactant_2 is None and product_2 is not None:
            species_ref2 = r1.createProduct()
            species_ref2.setSpecies(product_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} -{k_names[t+1]} * {product_1} * {product_2}'))
            
        if reactant_2 is None and product_2 is None:
            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} -{k_names[t+1]} * {product_1}'))
        
        t = t+2

    else:

        k = model.createParameter()
        k.setId(k_names[t])
        k.setValue(float(reactions_info['kf'][idx_reaction_row]))
        
        if reactions_info['Units_f'][idx_reaction_row] == '1/s':
            k.setUnits('per_sec')
        elif reactions_info['Units_f'][idx_reaction_row] == '1/(nM*s)':
            k.setUnits('per_nanmol_per_sec')

        reactants, products = extract_reactants_and_products(reactions_info['Reaction'][idx_reaction_row])
        reactant_1 = extract_1(reactants)
        reactant_2 = extract_2(reactants)
        product_1 = extract_1(products)
        product_2 = extract_2(products)
        product_3 = extract_3(products)
       
    
        r1 = model.createReaction()
        r1.setId(reactions_info['Notation'][idx_reaction_row])
        r1.setReversible(False)

        species_ref1 = r1.createReactant()
        species_ref1.setSpecies(reactant_1)

        species_ref2 = r1.createProduct()
        species_ref2.setSpecies(product_1)

        if reactant_2 is not None and product_2 is not None:
            species_ref1 = r1.createReactant()
            species_ref1.setSpecies(reactant_2)

            species_ref2 = r1.createProduct()
            species_ref2.setSpecies(product_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} * {reactant_2}'))
    
        if reactant_2 is not None and product_2 is None:
            species_ref1 = r1.createReactant()
            species_ref1.setSpecies(reactant_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1} * {reactant_2}'))


        if reactant_2 is None and product_2 is not None:
            species_ref2 = r1.createProduct()
            species_ref2.setSpecies(product_2)

            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1}'))

        if reactant_2 is None and product_2 is None:           
            kinetic_law = r1.createKineticLaw()
            kinetic_law.setMath(parseL3Formula(f'{k_names[t]} * {reactant_1}'))
            
        if product_3 is not None:
            species_ref3 = r1.createProduct()
            species_ref3.setSpecies(product_3)
                                               
        t = t+1


#%%


print(writeSBMLToString(document))
base_name = op.splitext(xlsx_file)[0]
file_output = op.join('CRN_sbml', base_name + '.sbml')
sbml_file = open(file_output, 'w')
print(writeSBMLToString(document), file=sbml_file)
sbml_file.close()


# In[ ]:




