function b = standardised_data(data)
        datamean = mean(data);
        datastd = std(data);
        
        % Calculate the discriminant score
        b = (data - datamean) ./ datastd;
end