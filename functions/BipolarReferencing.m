function [record, channels, groups_idx] = BipolarReferencing(record, channels, groups_idx)
                
%% Reference Channels:        
nChannels = numel(channels);
groups_idx_borders = [groups_idx;  nChannels+1 ];
new_groups_idx = 1;
 
group_i = 2;
ch_old = 1;
ch_new = 1;
while ch_old < nChannels
    if ch_old + 1 < groups_idx_borders(group_i)
        record(:,ch_new) = record(:,ch_old) - record(:,ch_old + 1);
        channels{ch_new} = [channels{ch_old} ' - '  channels{ch_old+1} ];
        ch_new = ch_new + 1;
    else
        new_groups_idx = [new_groups_idx  ch_new];
        group_i = group_i+1;
    end
    ch_old = ch_old + 1;
end

nChannels = nChannels - length(groups_idx);
record = record(:,1:nChannels);
channels =  channels(1:nChannels);
groups_idx = new_groups_idx(1:end-1)';

end