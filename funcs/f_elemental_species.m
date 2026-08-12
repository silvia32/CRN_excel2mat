function [sp_elementari, colonne_trovate, N, v]  = f_elemental_species(S, species_names, v)
    
N = f_compute_semipositive_conservations(S);
    
    [n, m] = size(N);
    
    % Inizializza un vettore per salvare i numeri di colonna trovati
    colonne_trovate = [];
    sp_elementari = [];
    cons_laws_check = [];
    % Per ogni colonna della matrice
    for col = 1:m
        % Trova gli indici degli elementi non nulli nella colonna corrente
        indici_non_nulli = find(N(:, col));
    
        % Se c'è esattamente un elemento non nullo e questo è uguale a 1, aggiungi il numero di colonna al vettore
        
        if numel(indici_non_nulli) == 1 && N(indici_non_nulli, col) == 1 
            if isempty(find(cons_laws_check == indici_non_nulli, 1))
                colonne_trovate = [colonne_trovate, col];
                sp_elementari = [sp_elementari, species_names(col)];
                cons_laws_check = [cons_laws_check; indici_non_nulli];
                v(col) = 1;
            end
        end
        % Se abbiamo trovato il numero di colonne desiderato, interrompi la ricerca
        if length(colonne_trovate) == n
            disp(sp_elementari)
            return;
        end
    end
    
end
    

   