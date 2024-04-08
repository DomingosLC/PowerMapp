function Results_Figure(app, record, seizure_power, channels, groups_idx, bands, filename)

fig = figure('units','normalized','outerposition',[0 0 1 1],'Name', filename);

[nSteps, ~] = size(record);
T = (nSteps-1)/app.down_sampRate;
dt = 1/app.down_sampRate;
t = 0:dt:T;

nBands = size(bands,1);

%% Plot sEEG
if nBands > 0
    s(1) = subplot(1,2,1);
    s(1).Position = [0.2    0.11    0.3347    0.8150];
else
    s(1) = subplot(1,1,1);
    s(1).Position = [0.2    0.11    0.7    0.8150];
end
plot_EEG(record, t, channels, groups_idx, 0.0005, 'k')
title(filename, 'interpreter', 'none')

% Add_Gain_Button();

%% Plot PowerBands
[nSteps, ~] = size(record);
T = (nSteps-1)/app.down_sampRate;


for b = 1:nBands
    % Plot PowerBand
    s(1+b) = subplot(nBands, 2, b*2);
    pos = s(1+b).Position;
    s(1+b).Position = [pos(1)+0.04 pos(2) pos(3) pos(4)];
    
    h = imagesc(seizure_power(:,:,b), 'XData', 1/2);
    xData = get(h, 'XData');
    set(h, 'XData', [app.settings.window_step/2 : app.settings.window_step : T-app.settings.window_step/2]);
    
    % Set color limits:
    mean_powers = mean(seizure_power(:,:,b),2);
    std_powers = std(seizure_power(:,:,b),[],2);
    color_lim = median(mean_powers) + median(std_powers)*10;
    caxis([0 color_lim])
    colorbar
    
    hold on
    % Plot Group Divisions
    plot([zeros(length(groups_idx), 1) ones(length(groups_idx),1)*size(seizure_power(:,:,b),2)*app.settings.window_step]',[groups_idx groups_idx]', 'r')
    yticks(groups_idx)
    yticklabels(channels(groups_idx))
    xlim([0 T])
    title(['band: [', num2str(bands(b,1)), '-' num2str(bands(b,2)) '] Hz'])
end

xlabel('Time [s]')
linkaxes(s)


%% Channel Selector and Power Wavelet Buttons:
Add_ChannelSelector_and_Wavelet(fig, s, app, record, t, seizure_power, channels, groups_idx, bands, filename);


%% Buttons to ajust scale in PowerBand images:
Add_Colorbar_Buttons(fig, nBands, s)


%% Data Cursor:
datacursor_obj = datacursormode(fig);
set(datacursor_obj, 'UpdateFcn', @myupdatefcn)
hh = [];

    function txt = myupdatefcn(src,event_obj)
        
        delete(hh);
        pos = get(event_obj,'Position');
        I = get(event_obj, 'DataIndex');
        
        time_s = pos(1);
        channel = pos(2);
        
        txt = {['Time [s]: ',num2str(time_s)],...
            ['Channel: ',channels{channel}]};
        
        for band = 1:nBands
            hold(s(1+band), 'on')
            hh = [ hh  plot(s(1+band), time_s, channel, 'r*') ];
        end
        
        start_i = max(round((time_s - app.settings.window_step/2)*app.down_sampRate),1);
        end_i = round(start_i + app.settings.window_size*app.down_sampRate);
        
        hh = [hh plot(s(1), t(start_i:end_i) , record(start_i:end_i, channel)*0.0005 + channel, 'r', 'linewidth', 2) ];
        
    end

end