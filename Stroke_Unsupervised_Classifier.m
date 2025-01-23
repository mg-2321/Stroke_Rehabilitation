% Unsupervised learning (Kmeans)- pre stroke and post stroke - to visualize the actual differences between the models ability to pre_Cluster and differenciate between action

% Do PCA processing
PCA_process;

noise = false;

% Intialise randomisers with a seed
randseed = 12345;
rng(randseed);

doUnsupervised(prestroke_Ur,prestroke_labels,"Prestroke",false);
doUnsupervised(poststroke_Ur,poststroke_labels,"Poststroke",false);

doUnsupervised(presunjil_Ur,presunjil_labels,"Prestroke sunjil",false);
doUnsupervised(postsunjilALT_Ur,postsunjilALT_labels,"Poststroke sunjil",false);


function doUnsupervised(stroke_Ur,stroke_labels, name, noise)
    % Remove rest class as noise
    stroke_restless = stroke_Ur(find(table2array(stroke_labels(:,:))~="Rest"),:);
    
    % Cluster
        
    opts = statset('Display','final');
    
    % Get cluster indexes and centroids
    [stroke_idx,stroke_centroids] = kmeans(stroke_restless,3,'Distance','cityblock','Replicates',5,'Options',opts);
    
    % Plot
    
    % Split datasets by cluster
    cluster1 = stroke_restless(stroke_idx==1,:);
    cluster2 = stroke_restless(stroke_idx==2,:);
    cluster3 = stroke_restless(stroke_idx==3,:);
        

    % Putting cluster data into lists to plot in a single function
    Allclusters = {cluster1, cluster2, cluster3};
    PC_Set = ["PC1" "PC2" "PC3" "PC4"];
    legend = ["Cluster 1", "Cluster 2", "Cluster 3"];
    
    if (noise)
        pre_Rest = stroke_Ur(find(table2array(stroke_labels(:,:))=="Rest"),:); % Unclustered "Noise"
        Allclusters = {cluster1, cluster2, cluster3, pre_Rest};
        legend = ["Cluster 1", "Cluster 2", "Cluster 3", "Uncategorised"];
    end
    
    % 2D scatter plots
    scatterplot2D(Allclusters, PC_Set, 4, legend, strcat(string(name)," k-means clustering 2D"));
    
    % 3D scatter plots
    scatterplot3D(Allclusters, PC_Set, 4, legend, strcat(string(name)," k-means clustering 3D"));
end