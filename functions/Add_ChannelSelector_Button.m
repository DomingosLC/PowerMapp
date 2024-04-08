function Add_ChannelSelector_Button(fig,  app, record, seizure_power, channels, groups_idx, bands, filename)

channelSelector_button = uicontrol('Parent',fig,'Style','pushbutton','String','Channel Selector','Units','normalized',...
    'Position',[0.025 0.9 0.07 0.035],'Visible','on','HorizontalAlignment', 'left', 'callback', @openChannelSelector);

channel_list = [];

function openChannelSelector(src,event)
    
    channelsFig = uifigure('position', [300 500, 90, 500]);
    channel_list = uilistbox(channelsFig,'Items', channels,  'ItemsData', [1:numel(channels)],'Position',...
        [15 70 90 400], 'Multiselect','on');
    
    %% Button to open new figure with selected channels
    newFig_button = uibutton(channelsFig,'text','New Figure',...
    'Position',[15 20 90 30 ], 'ButtonPushedFcn', @openFigure);    
end


function openFigure(src,event)
    new_channels_idx = channel_list.Value;
    Results_Figure(app, record(:,new_channels_idx), seizure_power(new_channels_idx, :, :), channels(new_channels_idx), intersect(groups_idx, new_channels_idx), bands, filename)
end


end