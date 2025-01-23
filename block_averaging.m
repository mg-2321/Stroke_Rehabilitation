function [averagedData,comments] = block_averaging(dataset,labelset,block_size)
% Define block size for averaging
numBlocks = floor(height(dataset) / block_size);

averagedData = [];
comments = strings(numBlocks, 1);

% Block averaging loop
for i = 1:numBlocks
    % Determine the rows for the current block
    blockRows = (1:block_size) + (i-1)*block_size;
    
    % Average numeric dataset in the block
    blockAvg = mean(dataset(blockRows, 1:end), 1);
    
    % Get most frequent comment in the block
    blockComments = labelset(blockRows,:);
    blockComments = table2array(blockComments);
    comments(i) = mode(categorical(blockComments)); % Use 'mode' for most frequent value

    % Store the averaged dataset
    averagedData = [averagedData; blockAvg];
end

end

