function Add_ChannelSelector_and_Wavelet(fig, s, app, record, t, seizure_power, channels, groups_idx, bands, filename)

obj_width = 0.08;

%% Path to save Figures:
savePath = app.dataPath;
saveTiff = 1;
saveFig = 1;
deleteFigs = 1;
    
logscale = 1;
ylims = [0 150]; % only used for linear
    
%% Time buttons:
text_t_start = uicontrol('Parent',fig,'Style','text','String','Start [s]','Units','normalized',...
    'Position',[0.025 0.2 0.05 0.022],'Visible','on','HorizontalAlignment', 'left');

edit_t_start = uicontrol('Parent',fig,'Style','edit','Units','normalized',...
    'string', num2str(0), 'Position',[0.025 0.17 obj_width/2 0.025],'Visible','on');

text_t_end = uicontrol('Parent',fig,'Style','text','String','End [s]','Units','normalized',...
    'Position',[0.06 0.2 0.05 0.022],'Visible','on','HorizontalAlignment', 'left');

edit_t_end = uicontrol('Parent',fig,'Style','edit','Units','normalized',...
    'string', num2str(t(end)), 'Position',[0.025+obj_width/2 0.17 obj_width/2 0.025],'Visible','on');

set_t = uicontrol('Parent',fig,'Style','pushbutton','String','Set','Units','normalized',...
    'Position',[0.025 0.14 obj_width 0.03],'Visible','on','HorizontalAlignment', 'left', 'callback', @click_set_t_lims);

% Set Time Start/End Callback:
    function click_set_t_lims(src,event)
        t_start = str2double(get(edit_t_start, 'string'));
        t_end = str2double(get(edit_t_end, 'string'));
        xlim(s(1), [t_start t_end])
    end

%% Channel ListBox
channel_list = uicontrol('Style', 'listbox', 'Parent', fig, 'String', channels, ...
    'Units', 'Normalized', 'Position',[0.025 0.28 obj_width 0.65 ], 'min', 1, 'max', 10, 'Callback', @selectChannel);

uicontrol('Style', 'text', 'String', 'Channel Labels', 'Units', 'Normalized', ...
    'position', [0.025 0.95 0.12 0.02 ], 'fontSize', 10, 'HorizontalAlignment', 'left')

last_ch_i = [];
h = [];

    function selectChannel(src, event)
        
        delete(h);
        ch_idxs = src.Value;
        nBands = numel(s)- 1;
        
        for i = 1:length(ch_idxs)
            % Plot selected EEG signal:
            h = [h, plot(s(1), t, record(:,ch_idxs(i))*0.0005 + ch_idxs(i), 'g', 'linewidth', 1.5 )];
            
            % Plot mark at beggining and end of PowerMap imagescs:
            if numel(s) > 1
                xlims = get(s(2), 'xlim');
                for b = 1:nBands
                    h = [h, plot(s(b+1), [xlims(1); xlims(1)], [ch_idxs(i) ch_idxs(i)-1], 'g', 'linewidth', 5)];
                    h = [h, plot(s(b+1), [xlims(2); xlims(2)], [ch_idxs(i) ch_idxs(i)-1], 'g', 'linewidth', 5)];
                end
            end
        end
    end

%% Button to open new figure with selected channels
newFig_button = uicontrol('Style', 'pushbutton', 'Parent', fig, 'String','New Figure', 'Units', 'Normalized',...
    'Position',[0.025 0.25 obj_width 0.03 ], 'Callback', @openFigure);

% New Figure Button Callback:
    function openFigure(src,event)
        new_channels_idx = channel_list.Value;
        new_groups_idx = Get_Groups_Idx(channels(new_channels_idx));
        Results_Figure(app, record(:,new_channels_idx), seizure_power(new_channels_idx, :, :), ...
            channels(new_channels_idx), new_groups_idx, bands, filename)
    end


%% Button to calculate Fourier Transform Spectrogram of selected channels
% spectrogram_button = uicontrol('Style', 'pushbutton', 'Parent', fig, 'String','Fourier Spect', 'Units', 'Normalized',...
%     'Position',[0.025 0.08 obj_width 0.03 ], 'Callback', @calcSpectrogram);
%
% % Spectrogram Button Callback:
%     function calcSpectrogram(src,event)
%         selected_idx = channel_list.Value;
%         time_start_s = str2double(edit_t_start.String);
%         time_start_i = max(time_start_s*app.down_sampRate, 1);
%         time_end_i = str2double(edit_t_end.String)*app.down_sampRate;
%
%         Spectrogram_Fig(record(time_start_i:time_end_i,selected_idx), app.settings.window_size, app.settings.window_step,...
%             app.down_sampRate, channels(selected_idx), time_start_s)
%     end


%% Button to calculate Wavelet Transform Spectrogram of selected channels
waveletTransform_button = uicontrol('Style', 'pushbutton', 'Parent', fig, 'String','Wavelet Spect.', 'Units', 'Normalized',...
    'Position',[0.025 0.08 obj_width 0.03 ], 'Callback', @PrepareWaveletRun); % [0.025 0.04 obj_width 0.03 ],



%% Save Wavelet Options Figure
    function PrepareWaveletRun(src,event)
        
        optFig = uifigure;
%         optFig.Position = [500 400 455 176];
        optFig.Position = [500 400 455 230];
        
        saveTiff = 1;
        saveFig = 1;
        deleteFigs = 1;
 
        
        % Create SaveOptionsLabel
        saveOptionsLabel = uilabel(optFig);
        saveOptionsLabel.FontSize = 15;
        saveOptionsLabel.FontWeight = 'bold';
        saveOptionsLabel.FontColor = [0 0.4471 0.7412];
        saveOptionsLabel.Position = [27 200 101 22];
        saveOptionsLabel.Text = 'Save Options';
        
        % Create SaveFolderButton
        saveFolderButton = uibutton(optFig, 'push','ButtonPushedFcn', @selectFolder);
        saveFolderButton.Position = [153 200 85 22];
        saveFolderButton.Text = 'Save Folder';
        
        % Create EditField
        saveDataField = uieditfield(optFig, 'text', 'Value', savePath);
        saveDataField.Position = [247 200 189 22];
        
        % Create SaveastiffCheckBox
        saveastiffCheckBox = uicheckbox(optFig, 'ValueChangedFcn', @SaveAsTiffChange);
        saveastiffCheckBox.Text = 'Save as .tiff';
        saveastiffCheckBox.FontWeight = 'bold';
        saveastiffCheckBox.Position = [24 103 89 22];
        saveastiffCheckBox.Value = true;
        
        
        %% Set Y scale of wavelets:
        infoLabel_yscale = uilabel(optFig);
        infoLabel_yscale.Position = [27 170 150 22];
        infoLabel_yscale.Text = 'Wavelet Y scale:';
        infoLabel_yscale.FontWeight = 'bold';
        
        logButton = uibutton(optFig, 'push','ButtonPushedFcn', @LogButtonClick);
        logButton.Position = [27 150 74 22];
        logButton.Text = 'Log';
        logButton.BackgroundColor = [0 0.4471 0.7412];
        logButton.FontWeight = 'bold';
        logButton.FontColor = [1 1 1];
        
        linButton = uibutton(optFig, 'push','ButtonPushedFcn', @LinButtonClick);
        linButton.Position = [108 150 74 22];
        linButton.Text = 'Linear';
        linButton.BackgroundColor = [0.9 0.9 0.9];
        linButton.FontWeight = 'normal';
        linButton.FontColor = [0 0 0];
        
        function LogButtonClick(src, event)
            logscale = 1;      
            logButton.BackgroundColor = [0 0.4471 0.7412];                       
            logButton.FontColor = [1 1 1];
            logButton.FontWeight = 'bold';            
            linButton.BackgroundColor = [0.9 0.9 0.9];            
            linButton.FontColor = [0 0 0];
            linButton.FontWeight = 'normal';            
        end
        
        
        function LinButtonClick(src, event)
            logscale = 0;           
            linButton.BackgroundColor = [0 0.4471 0.7412];                       
            linButton.FontColor = [1 1 1];
            linButton.FontWeight = 'bold';            
            logButton.BackgroundColor = [0.9 0.9 0.9];           
            logButton.FontColor = [0 0 0];
            logButton.FontWeight = 'normal';            
            
        end
        
        %% Create SaveasfigCheckBox
        saveasfigCheckBox = uicheckbox(optFig, 'ValueChangedFcn', @SaveAsFigChange);
        saveasfigCheckBox.Text = 'Save as .fig';
        saveasfigCheckBox.FontWeight = 'bold';
        saveasfigCheckBox.Position = [24 77 88 22];
        saveasfigCheckBox.Value = true;
        
        % Create DeletefigureaftersavingCheckBox
        deletefigureaftersavingCheckBox = uicheckbox(optFig, 'ValueChangedFcn', @DeleteFigsChange);
        deletefigureaftersavingCheckBox.Text = 'Delete figure after saving';
        deletefigureaftersavingCheckBox.FontWeight = 'bold';
        deletefigureaftersavingCheckBox.Position = [24 52 165 22];
        deletefigureaftersavingCheckBox.Value = true;
        
        % Create youcanreopeninMatlabLabel
        infobLabel = uilabel(optFig);
        infobLabel.Position = [112 77 148 22];
        infobLabel.Text = '- you can reopen in Matlab';
        
        % Create improvedperformanceLabel
        infoLabel_2 = uilabel(optFig);
        infoLabel_2.Position = [188 52 133 22];
        infoLabel_2.Text = '- improved performance';
        
        % Create CancelButton
        cancelButton = uibutton(optFig, 'push','ButtonPushedFcn', @cancelButtonPush);
        cancelButton.Position = [25 16 74 22];
        cancelButton.Text = 'Cancel';
        
        % Create OkButton
        okButton = uibutton(optFig, 'push','ButtonPushedFcn', @calcWaveletSpectrogram);
        okButton.BackgroundColor = [0 0.4471 0.7412];
        okButton.FontWeight = 'bold';
        okButton.FontColor = [1 1 1];
        okButton.Position = [108 16 74 22];
        okButton.Text = 'Ok';
        

              
        
        
    end

    function cancelButtonPush(src, event)
        delete(src.Parent)       
    end



    function selectFolder(src, event)
        try
            savePath = uigetdir;
            parentFig = src.Parent;
            parentFig.Children(8).Value = savePath; % Position 8 is the saveDataField
        catch
        end
    end

    function SaveAsTiffChange(src, event)
        saveTiff = src.Value;
    end

    function SaveAsFigChange(src, event)
        saveFig = src.Value;
    end

    function DeleteFigsChange(src, event)
        deleteFigs = src.Value;
    end

%% Wavelet Function Callback:
    function calcWaveletSpectrogram(src,event)        
        
        delete(src.Parent)
        
        selected_idx = channel_list.Value;
        time_start_s = str2double(edit_t_start.String);
        nPoints = size(record,1);
        time_start_i = max(time_start_s*app.down_sampRate, 1);
        time_end_i = min(str2double(edit_t_end.String)*app.down_sampRate, nPoints);
        
        ch_i = 0;
        wb_channels = waitbar(0,'Calculating Wavelet Transforms...');
        
        for ch = selected_idx
            tic
            
            % waitbar
            ch_i = ch_i + 1;
            waitbar(ch_i/numel(selected_idx), wb_channels)
            
            % Calculate Wavelet
            wavelet_fig = figure;
            Wavelet_Fig(record(time_start_i:time_end_i, ch), t(time_start_i:time_end_i),...
                app.down_sampRate, channels{ch}, 'amor', logscale, ylims)
            
            % Save Figs
            if saveTiff
                saveas(wavelet_fig, [savePath, '\', filename '_Channel_' channels{ch} '.tiff'])
            end         
            
            if saveFig
                savefig(wavelet_fig, [savePath, '\', filename '_Channel_' channels{ch} '.fig'],'compact')
            end        
            
            if deleteFigs
                close(wavelet_fig)
            end
            toc
        end

        
        try
            delete(wb_channels)
        catch
        end
    end




end