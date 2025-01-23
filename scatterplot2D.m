% 2D Scatter plot function; similar to the plot triangles from HW2Part0.
function scatterplot2D(AllSet, setNames, nfeatures, legendVal, titleVal)

% Create tile layout
figure;
    t = tiledlayout(nfeatures-1,nfeatures-1,'TileSpacing','compact','Padding','compact');
    title(t,titleVal)
    
    % Iterate through tile layout and plot each measure with every other,
    % without redundancies
    for n = nfeatures-1 : -1 : 1
        for m = nfeatures : -1 : 2
            
            if (m >= n + 1)
                nexttile(((nfeatures-1-n)*(nfeatures-1)) + (nfeatures+1-m))
                hold on 
    
                % Plot for each cluster
                for x = 1: size(AllSet,2)
                    subSet = AllSet{x};
                    scatter(subSet(:,m), subSet(:,n), '.'); 
                end

                
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
    legend(legendVal); 
end
