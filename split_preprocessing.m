function [X_Train,X_Test,y_Train,y_Test] = split_preprocessing(stroke_raw,labels,ratio)
    % Data and labels
    X = stroke_raw;
    y = labels;

    % Convert labels from string array to a cell array of character vectors
    y = table2cell(y);

    % Split into test & training sets
    X_Train = X( 1:(round(size(X) * ratio)), :);
    X_Test = X( (round(size(X) * ratio))+1:size(X), :);
    
    y_Train = y( 1:(round(size(y) * ratio)), :);
    y_Test = y( (round(size(y) * ratio))+1:size(y), :);
end