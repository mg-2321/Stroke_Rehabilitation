% Supervised learning (KNN) - training the model using pre-stroke - testing using post stroke

% Do PCA processing
PCA_process;

% Remove rest class from everything as noise
prestroke_Ur = prestroke_Ur(find(table2array(prestroke_labels(:,:))~="Rest"),:);
prestroke_labels = prestroke_labels(find(table2array(prestroke_labels(:,:))~="Rest"),:);
poststroke_Ur = poststroke_Ur(find(table2array(poststroke_labels(:,:))~="Rest"),:);
poststroke_labels = poststroke_labels(find(table2array(poststroke_labels(:,:))~="Rest"),:);

% Train and optimise on pre-data, test on post
% z = throwoaway variable
[pre_X_Train,z,pre_y_Train,z] = split_preprocessing(prestroke_Ur,prestroke_labels,1);
[post_X_Test,z,post_y_Test,z] = split_preprocessing(poststroke_Ur,poststroke_labels,1);


% Perform the classification
descTreePlot(pre_X_Train, post_X_Test, pre_y_Train, post_y_Test); 
KNNPlot(pre_X_Train, post_X_Test, pre_y_Train, post_y_Test);
SVMPlot(pre_X_Train, post_X_Test, pre_y_Train, post_y_Test);
NeuralNetPlot(pre_X_Train, post_X_Test, pre_y_Train, post_y_Test);

% Functions
% ----------------------------------------------------------------------
% Classifier 1: Classification decision tree
function descTreePlot(X_Train,X_Test,y_Train,y_Test)

    % Find the optimal hyperparameters
    % classifier = fitctree(X_Train,y_Train,'OptimizeHyperparameters','auto');
    % Optimal params for full prestroke training
    % 'MinLeafSize',14
    
    % Training
    classifier = fitctree(X_Train,y_Train,'MinLeafSize',14);

    figure;
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

    % Prestroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Train);
    confusionchart(y_predicted,y_Train,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Prestroke Classification Decision Tree");

    % Poststroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Test);
    confusionchart(y_predicted,y_Test,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Prostroke Classification Decision Tree");
end

% Classifier 2: KNN
% Testing with 3 nieghbors 
function KNNPlot(X_Train,X_Test,y_Train,y_Test)

    % Find the optimal hyperparameters
    % classifier = fitcknn(X_Train,y_Train,'OptimizeHyperparameters','auto');
    % Optimal params for full prestroke training
    % 'NumNeighbors',29,'Distance','chebychev','Standardize',true
    
    % Training
    neighbors = 29;
    classifier = fitcknn(X_Train,y_Train,'NumNeighbors',neighbors,'Distance','chebychev','Standardize',true);
    
    figure;
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
    
    % Prestroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Train);
    confusionchart(y_predicted,y_Train,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title(strcat("Prestroke ", string(neighbors)," Neighbors KNN"));
    
    % Poststroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Test);
    confusionchart(y_predicted,y_Test,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title(strcat("Poststroke ", string(neighbors)," Neighbors KNN"));
end

% Classifier 3: SVM
% Using error-correcting output codes (ECOC) for multiclass SVM
function SVMPlot(X_Train,X_Test,y_Train,y_Test)

    % Find the optimal hyperparameters
    % classifier = fitcecoc(X_Train,y_Train,'OptimizeHyperparameters','auto');
    % Optimal params for full prestroke training
    % 'Coding','onevsone','BoxConstraint',0.020079,'KernelScale',34.362,'Standardize',true

    % Training
    classifier = fitcecoc(X_Train,y_Train,'Coding','onevsone','Learners','svm');

    figure;
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

    % Prestroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Train);
    confusionchart(y_predicted,y_Train,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Prestroke ECOC SVM");

    % Poststroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Test);
    confusionchart(y_predicted,y_Test,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Poststroke ECOC SVM");

end


% Classifier 4: Feedforward Neural Network
% Feedforward neural network classifier with fully connected layers
function NeuralNetPlot(X_Train,X_Test,y_Train,y_Test)

    % Find the optimal hyperparameters
    % classifier = fitcnet(X_Train,y_Train,'OptimizeHyperparameters','auto');
    % Optimal params for full prestroke training
    % 'Activations','relu','Standardize',true,'Lambda',0.00020709,'LayerSizes',114
    
    % Training
    classifier = fitcnet(X_Train,y_Train,'Activations','relu','Standardize',true,'Lambda',0.00020709,'LayerSizes',114);

    figure;
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

    % Prestroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Train);
    confusionchart(y_predicted,y_Train,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Prestroke Neural Network");

    % Poststroke Testing
    nexttile;
    y_predicted = predict(classifier,X_Test);
    confusionchart(y_predicted,y_Test,'RowSummary','row-normalized','ColumnSummary','column-normalized');
    title("Prostroke Neural Network");
end