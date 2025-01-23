% 3D Scatter plot function; Plotting on the heaviest PCs
function scatterplot3D(AllSet, setNames, nfeatures, legendVal, titleVal)
figure;
    % Create tile layout
    t = tiledlayout(nfeatures-2,nfeatures-2,'TileSpacing','compact','Padding','compact');
    title(t,titleVal)

    % Iterate through tile layout and plot each measure with every other,
    % without redundancies
    for n = nfeatures-2 : -1 : 1
        for m = nfeatures-1 : -1 : 2
            for l = nfeatures : -1 : 3
                
                if ((m >= n + 1) && (l >= m + 1))
                    nexttile
                    hold on 
        
                    % Plot for United states, Australia & India
                    for x = 1: size(AllSet,2)
                        subSet = AllSet{x};
                        scatter3(subSet(:,m), subSet(:,n), subSet(:,l) , '.'); 
                    end
                    view(40,35)
        
                    % Title axis
                    xlabel(setNames(:,m))
                    ylabel(setNames(:,n))
                    zlabel(setNames(:,l))

                    % Title plots with what is compared to what
                    title(strcat(setNames(:,n)," against ",setNames(:,m)," against ",setNames(:,l) ));
                    hold off 
                    
                 end
            end
        end
    end
    
    % Set legend
    legend(legendVal); 
end
