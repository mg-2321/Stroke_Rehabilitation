prestroke = readtable("Arsheya_prestroke_EEG_ProfMatthew_S1_filtered.csv");
poststroke = readtable("Melody_poststrokeEEG_profMatthew_WaveFistRub_testALL_filtered.csv");

stroke = poststroke;

% Intialise randomisers with a seed
randseed = 12345;
rng(randseed);


for n = 1:1
    % Increment randomiser for each iteration
    rng(randseed + n)

    % Preprocess sets
    [X_Train,X_Test,y_Train,y_Test] = preprocessing(stroke,3/4);
    
    % Classifier 1: KNN
    % Testing different numbers of nieghbor 
    for m = 1:5
        % Training
        classifierKNN = fitcknn(X_Train,y_Train,'NumNeighbors',2+m,'Standardize',1);
        
        % Testing
    
        y_predicted = predict(classifierKNN,X_Test);
        
        figure;
        confusionchart(y_predicted,y_Test);
        title(strcat("Neighbors ", string(2+m)));
    end
end


% Data standardisation/normalisation function
function b = standardized_data(data)
        datamean = mean(data);
        datastd = std(data);
        
        % Calculate the discriminant score
        b = (data - datamean) ./ datastd;
end


function [X_Train,X_Test,y_Train,y_Test] = preprocessing(stroke_raw,ratio)
    % Preprocess data; Remove "useless" fields and rows
    stroke_data = rmmissing(stroke_raw);
    stroke_data = removevars(stroke_data, {'Time', 'Trigger', 'Time_Offset', 'ADC_Status', 'ADC_Sequence', 'Event'}); 
    
    % Data and labels
    X = stroke_data(:,1:7);
    y = stroke_data(:,8);

    % Convert data to a numeric array and standardise
    X = standardized_data(table2array(X)); 

    % Convert labels from string array to a cell array of character vectors
    y = table2cell(y);

    % Split into test & training sets
    X_Train = X( 1:(round(size(X) * ratio)), :);
    X_Test = X( (round(size(X) * ratio))+1:size(X), :);
    
    y_Train = y( 1:(round(size(y) * ratio)), :);
    y_Test = y( (round(size(y) * ratio))+1:size(y), :);
end