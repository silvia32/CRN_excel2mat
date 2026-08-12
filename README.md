# CRN_excel2mat

Workflow to convert Excel CRNs data into SBML and MATLAB (.mat) formats. Uses Python for SBML generation and MATLAB for structure finalization. Useful for analyzing chemical reaction networks and doing simulations.

**Authors:** Silvia Berra, Francesca Costantini, Vincenzo Di Trani.

##  Repository Structure

```text
CRN_excel2mat/
│
├── excel_data/                 # Folder containing input excel files (table_S3 sheet)
├── CRN_sbml/                   # Generated SBML models output folder
├── extract_excel_species.py    # Extracts species from reactions and creates table_S1 sheet
├── convert_excel_to_sbml.py    # Parses excel data and generates SBML models
└── convert_sbml_to_mat.m       # Converts SBML structures into MATLAB (.mat) format
```

##  How to use this workflow with your own data.

Step 1: Prepare your input in xlsx format
Create or place your excel file inside the excel_data/ folder.
Ensure the file contains a sheet named table_S3 with the complete list of your chemical reactions.

Step 2: Extract chemical species
To build a valid model, the tool needs a sheet defining all chemical species and whether they are constant or dynamic.
Run the extract_excel_species.py script to automatically read your reactions from table_S3 and generate the table_S1 sheet directly inside your Excel file.

Step 3: Convert the xlsx list of reactions into a SBML structure
Once your Excel file contains both table_S3 (reactions) and table_S1 (species), run the convert_excel_to_sbml.py script to parse the data and build the standard SBML structure. The resulting files will be automatically saved in the CRN_sbml/ folder.

Step 4: Convert the SBML into a MATLAB (.mat) structure
Open MATLAB, set your working directory to the project folder, and run the MATLAB script. This will load the SBML files from CRN_sbml/ and save the final finalized model structures into the CRN_mat/ folder.

## 
Once the conversion process is complete, the final .mat structures can be directly loaded and used for network analysis and simulations using external tools, such as the CRC_CRN repository developed by the MIDA group https://github.com/theMIDAgroup/CRC_CRN.