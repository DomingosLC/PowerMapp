function plot_EEG(EEG, t, channels, groups_idx, gain, color)   

    [~, nChannels] = size(EEG);
         
    for i = 1:nChannels
%         yy = nChannels - i + 1;
        yy = i;
        plot(t, ones(size(t)).*yy, '--', 'color', [0.6 0.6 0.6],'linewidth', 0.5), hold on
        plot(t, EEG(:, i)*gain + yy, 'color', color, 'linewidth', 1),
        ylabel('Channels ID') 
    end
   
%     groups_ticks = flip(numel(channels) - groups_idx + 1);
    groups_ticks = groups_idx;
    plot([ones(length(groups_idx), 1) ones(length(groups_idx),1)*t(end)]',[groups_ticks groups_ticks]', 'r')
    
    yticks(groups_ticks)
%     yticklabels(flip(channels(groups_idx)))
    yticklabels(channels(groups_idx));
%     ax = gca;
%     ax.FontSize = 7; 
        
    ylim([min(EEG(:, nChannels))*gain+1  max(EEG(:, 1))*gain + nChannels])
    xlim([0 max(t)])
  
    set(gca, 'Ydir', 'reverse')