prestroke = readtable("prestrokeEEG_profMatthew_WaveFistRub_testALL_filtered.csv");
poststroke = readtable("poststrokeEEG_profMatthew_WaveFistRub_testALL_filtered.csv");

prestroke = rmmissing(prestroke); % this is all the data at once
poststroke = rmmissing(poststroke);

% % Get class data
% classes = prestroke(:,'Comments');

% Preprocess data; Remove "useless" fields
prestroke = removevars(prestroke, {'Time', 'Trigger', 'Time_Offset', 'ADC_Status', 'ADC_Sequence', 'Event'}); 
poststroke = removevars(poststroke, {'Time', 'Trigger', 'Time_Offset', 'ADC_Status', 'ADC_Sequence', 'Event'}); 

% Split datasets by class
pre_Rest = prestroke(find(prestroke.Comments=="Rest"), :);
pre_Wave = prestroke(find(prestroke.Comments=="Hand Wave"), :);
pre_Clench = prestroke(find(prestroke.Comments=="Hand Clench"), :);
pre_Rub = prestroke(find(prestroke.Comments=="Face Rub"), :);

post_Rest = poststroke(find(poststroke.Comments=="Rest"), :);
post_Wave = poststroke(find(poststroke.Comments=="Hand Wave"), :);
post_Clench = poststroke(find(poststroke.Comments=="Hand Clench"), :);
post_Rub = poststroke(find(poststroke.Comments=="Face Rub"), :);


setClasses = ["Rest" "Hand Wave" "Hand Clench" "Face Rub"];

% 2D scatter plot of the initial untransformed matrix and features
scatterplot2D(pre_Rest, post_Rest,["LE" "F4" "C4" "P4" "P3" "C3" "F3"], 7,"Rest action", "reef");
scatterplot2D(pre_Wave, post_Wave,["LE" "F4" "C4" "P4" "P3" "C3" "F3"], 7,"Hand wave action", "meadow");
scatterplot2D(pre_Clench, post_Clench,["LE" "F4" "C4" "P4" "P3" "C3" "F3"], 7,"Hand clench action", "dye");
scatterplot2D(pre_Rub, post_Rub,["LE" "F4" "C4" "P4" "P3" "C3" "F3"], 7,"Face Rub action", "earth");

% Functions
% ----------------------------------------------------------------------
% 2D Scatter plot function; similar to the plot triangles from HW2Part0.
function scatterplot2D(preSet, postSet, setNames, nfeatures, titleString, colours)
    figure('Name', titleString);
    colororder(colours)

    % Create tile layout
    tiledlayout(nfeatures-1,nfeatures-1,'TileSpacing','compact','Padding','compact')
    
    % Convert to numeric and remove class field
    preSet = table2array(removevars(preSet,{'Comments'})); 
    postSet = table2array(removevars(postSet,{'Comments'})); 
    
    % standardise data
    preSet = standardized_data(preSet);
    postSet = standardized_data(postSet);

    % Iterate through tile layout and plot each measure with every other,
    % without redundancies
    for n = nfeatures-1 : -1 : 1
        for m = nfeatures : -1 : 2

            if (m >= n + 1)
                nexttile(((nfeatures-1-n)*(nfeatures-1)) + (nfeatures+1-m))
                

                % Plot for pre & post stroke
                scatter(preSet(:,m), preSet(:,n), 'o'); 
                hold on 
                scatter(postSet(:,m), postSet(:,n),'o'); 

                % Title plots with what is compared to what
                title(strcat(setNames(:,n)," against ",setNames(:,m)));
                hold off 

                % Remove axis for plots not at the edges to reduce clutter
                if ((m ~= nfeatures) && (n ~= 1))
                    set(gca,'XTick',[], 'YTick', [])
                elseif ((m == nfeatures) && (n ~= 1))
                    set(gca,'XTick',[])
                elseif ((m ~= nfeatures) && (n == 1))
                    set(gca,'YTick',[])
                end

            end


        end
    end


    % Set legend
    legend('prestroke','poststroke'); 
end

% Data standardisation/normalisation function
function b = standardized_data(data)
        data = data;
        datamean = mean(data);
        datastd = std(data);
        
        % Calculate the discriminant score
        b = (data - datamean) ./ datastd;
end
