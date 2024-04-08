function [channels, record] = Load_Mat_Seiz(filename, sampRate, down_sampRate)

s = load(filename); 

allGood = 1;

try
    channels = s.hdr.label;
    record = s.record';
catch
    % Data doesn't have the expected structure...
    allGood = 0;
end


if allGood
    % It assumes that you have EEG data until you get to the ECG channels
    ecg_channel = find(contains(channels, 'ECG'));
    
    % Downsample:
     if down_sampRate < sampRate
        record = downsample(record(:, 1:ecg_channel(1)-1), round(sampRate/down_sampRate));
     else
        record = record(:, 1:ecg_channel(1)-1);
     end
        channels = channels(1:ecg_channel(1)-1);
else
    
  % Data does not have the expected structure!
  c = struct2cell(s);
  
  % Assumes that you passed a matrix of data with no labels....
  record = c{1};
  size_rec = size(record);
  
  % assumes that you have more time points than labels...  
  if(size_rec(2)> size_rec(1))
      record = record';
  end
  
  nLabels = size(record,2); 
  channel = cell(1);
  
  for ch = 1:nLabels     
      channels{ch} = ['CH' num2str(ch)];
  end
  
end


end