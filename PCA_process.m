% Just perform PCA stuff, don't do any plotting 
clear;
warning('off','all');
randseed = 12345;
rng(randseed);


% Professor Matthews Data
% ----------------------------------------------------------------------
prestroke_raw = readtable("ProfMatthew_(Arsheya_source)_Prestoke_Redo.csv");
poststroke_raw = readtable("ProfMatthew_(Sunjil_source)_Poststoke_Redo.csv");

[prestroke_Ur,prestroke_labels] = fullprocessPCA(prestroke_raw,4,10);
[poststroke_Ur,poststroke_labels] = fullprocessPCA(poststroke_raw,4,10);

% Sunjils Data
% ----------------------------------------------------------------------
presunjil_raw = readtable("Sunjil_(Sunjil_Source)_prestrokeEEG_wavefistrub_10-7_test1_filtered.csv");
postsunjilALT_raw = readtable("Sunjil_(Ashreya_Source)_ADJUSTED_poststroke_EEG_S1_filtered.csv");

[presunjil_Ur,presunjil_labels] = fullprocessPCA(presunjil_raw,4,10);
[postsunjilALT_Ur,postsunjilALT_labels] = fullprocessPCA(postsunjilALT_raw,4,10);


% Functions
% ----------------------------------------------------------------------
function [stroke_Ur,stroke_labels] = fullprocessPCA(stroke_raw,n_PCs,blocksize)
    [stroke_Ur,stroke_labels] = performPCA(stroke_raw);
    
    % Taking the first n features
    stroke_Ur = stroke_Ur(:, 1:n_PCs);
    
    % Perform block averaging on the results
    % [stroke_Ur,stroke_labels] = block_averaging(stroke_Ur,stroke_labels,blocksize);
    
    % Randomise sets
    randorder = randperm(length(stroke_Ur));
    stroke_Ur = stroke_Ur(randorder,:);
    stroke_labels = stroke_labels(randorder,:);
    
    % stroke_labels = array2table(cellstr(stroke_labels));
end

% Perform all PCA related functions and plot the according screen & loading
% vectors at once, given some dataset
function [Ur,label_data] = performPCA(stroke_raw)

    % Preprocess data; Remove "useless" fields and rows
    stroke_data = rmmissing(stroke_raw);
    label_data = stroke_data(:,14);
    stroke_data = removevars(stroke_data, {'Time', 'Trigger', 'Time_Offset', 'ADC_Status', 'ADC_Sequence', 'Event','Comments'}); 
    
    % Convert the table to numeric array for covariance calculation
    stroke_numeric = table2array(stroke_data);
    
    % Standardise
    stroke_numeric = standardised_data(stroke_numeric);
    


    % PCA function; gives us our matrix X
    [X means vars covs] = PCAfunc(stroke_numeric);

    % SVD function; Gives us values for U, S, V & Ur (Regular Scores matrix, calculated U*S)
    [U S V Ur] = SVDfunc(X, 7);
end

% Basic PCA process script ; base code obtained from class sharepoint
function [X means vars covs] = PCAfunc(yourCoefficientMatrix)
   [nrows, ncols] = size(yourCoefficientMatrix); 
    X = zeros([nrows,ncols]); 
     
    means = mean(yourCoefficientMatrix);    
    vars = var(yourCoefficientMatrix); 
    stdevs = std(yourCoefficientMatrix); 
    covs = cov(yourCoefficientMatrix);

    % Mean center data 
    % This is necessary so that everything is mean centered at 0 
    % facilitates statistical and hypothesis analysis 
    % This bit is the normalisation part
    for i=1:ncols 
        for j=1:nrows 
            X(j,i) = -( means(:,i) - yourCoefficientMatrix(j,i)); 
        end 
    end 
     mean(X)  ;
     
    % 
    % Scale data 
    % This is necessary so that all data has the same order, e.g.,  
    % should not compare values in the thousands vs. values between 0 and 1 
    for i=1:ncols 
        for j=1:nrows 
            X(j,i) = X(j,i) / stdevs(:,i);   
        end 
    end         
     var(X) ;
end

% SVD function; base code obtained from class sharepoint
function [U S V Ur] = SVDfunc(X, nfeatures)
    % X is the original dataset 
    % Ur will be the transformed dataset  
    % S is covariance matrix (not normalized) 
    
    [U S V] = svd(X,0); 
    Ur = U*S;
     
    % Number of features to use 
    f_to_use = nfeatures;      
    feature_vector = 1:f_to_use; 
     
    r = Ur;  % make a copy of Ur to preserve it,  we will randomize r  
end