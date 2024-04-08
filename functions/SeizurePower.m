function [seiz_power] = SeizurePower(record, sampRate, window, step, band)

nBands = size(band,1);

[nPoints, nChannels] = size(record);
T = nPoints/sampRate;

nSlots = floor((T-window)/step + 1);
seiz_power = zeros(nChannels, nSlots, nBands);

%% Calculate PowerBand for each time slot

for i =  1:nSlots  
    ind_i = floor( sampRate * step * (i-1) + 1 );
    ind_f = floor( ind_i + sampRate * window - 1 );
    record_slot = record(ind_i:ind_f, :);
    
    for b = 1:nBands 
        seiz_power(:,i, b) = bandpower(record_slot, sampRate, band(b,:) );    
    end
end

end
