function Wavelet_Fig(signal, t, sampRate, channel_label, wavelet_type, logscale, ylims)

ss(1) = subplot(5,1,1);
plot(t, signal)
xlabel('Time [secs]')
ylabel('Voltage [uV]')
title(['Mortlet Wavelet Transform - Channel ' channel_label])
xlim([t(1) t(end)])

[wt,f] = cwt( signal, wavelet_type, sampRate);
ss(2) = subplot(5,1,2:5);
Plot_Wavelet(logscale, ylims)
    

%% Radio buttons - linear/log y scales

pos = [0.01 0.1 0.08 0.1];  % [left bottom width height]

group = uibuttongroup('Position', pos);

radioButtonPos = [0.05 0.01 1 0.5];
radioLin = uicontrol('Style', 'radiobutton', 'Parent', group, ...
        'Units', 'normalized', 'Position', radioButtonPos, 'String', 'Lin', 'Value', ~logscale,  'Callback', @radioLinCallback);

radioButtonPos = [0.05 0.5 1 0.5];
radioLog = uicontrol('Style', 'radiobutton', 'Parent', group, ...
        'Units', 'normalized', 'Position', radioButtonPos, 'String', 'Log', 'Value', logscale, 'Callback', @radioLogCallback);    
    
% set(radioLin, 'SelectionChangedFcn', @radioLinCallback);

function radioLinCallback(source, event)
    ss(2) = subplot(5,1,2:5);
    logscale = 0;
    Plot_Wavelet(logscale, ylims)
end

function radioLogCallback(source, event)
    ss(2) = subplot(5,1,2:5);
    logscale = 1;
    Plot_Wavelet(logscale, [])
end


%% Data Cursor:
datacursor_obj = datacursormode(gcf);
set(datacursor_obj, 'UpdateFcn', @myupdatefcn)


function txt = myupdatefcn(src,event_obj)
    
pos = get(event_obj,'Position');

time_s = pos(1);
freq_hz= pos(2);

txt = {['Time [s]: ',num2str(time_s)],...
       ['Freq [Hz]: ',num2str(freq_hz)]};
 
end



function Plot_Wavelet(logscale, ylims)
    pcolor(t, f, abs(wt))
    shading flat
    xlabel('Time [secs]')
    ylabel('Freq [Hz]')
    
    if logscale
        set(ss(2), 'yscale', 'log')
        set(gca,'YTick',[0.1 1 10 100 1000],...
            'YTickLabel',{'0.1' '1' '10' '100' '1000'})
    else
        ylim(ylims);
    end

    % Colorbar:
    hcb = colorbar(ss(2));
    colorLabelHandle = get(hcb,'Label');
    set(colorLabelHandle ,'String','Magnitude');
    hcb_props = get(hcb); %gets properties of colorbar
    radio_pos = hcb_props.Position;
    set(hcb, 'Position', [radio_pos(1)*1.1, radio_pos(2) radio_pos(3)*0.5 radio_pos(4)])
    colormap('hot')

    linkaxes(ss, 'x')
    set(ss(2), 'Layer','top') % put yy axis in front of imagesc 

end


end