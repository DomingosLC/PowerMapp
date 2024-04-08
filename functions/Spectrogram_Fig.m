function Spectrogram_Fig(channels_signal, window_size_s, window_step_s, sampRate, channels_txt, time_start_s)

nChannels = size(channels_signal,2);
try
    for ch = 1:nChannels
        
        figure
        spectrogram(channels_signal(:,ch), window_size_s*sampRate, window_step_s*sampRate, [], sampRate,'yaxis')
        title(['Spectrogram - Channel: ' channels_txt{ch}]);
        axes = gca;
        
        
        xlabel_str = get(get(axes,'xlabel'),'string');
        scale = 1;
        if strcmp(xlabel_str, 'Time (secs)')
            scale = 1;
        elseif strcmp(xlabel_str, 'Time (mins)')
            scale = 60;
        elseif strcmp(xlabel_str, 'Time (h)')
            scale = 3600;
        end
        
        xdata = axes.Children.XData*scale  + time_start_s - window_step_s/2;
        set(axes.Children, 'XData', xdata);
        xlim([time_start_s xdata(end) + window_step_s/2])
        xlabel('Time [s]')        
    end
    
catch e
    if strcmp(e.message, 'The number of samples to overlap must be less than the length of the segments.')
        warndlg(['Spectrogram Error! ' newline 'Your windows do not overlap! The Window Step needs to be smaller than Window Width'])
    end
end
end