function groups_idx = Get_Groups_Idx(channels)


%% Electrode Groups:
nChannels = numel(channels);
groups_idx = 1;

label_pre = channels{1};
label_pre = label_pre(isletter(channels{1}));

for elec = 2:nChannels
    label_pos = channels{elec};
    label_pos = label_pos(isletter(channels{elec}));
    
    if ~strcmp(label_pre, label_pos)
        groups_idx = [groups_idx; elec];
    end
    
    label_pre = label_pos;
end

end
