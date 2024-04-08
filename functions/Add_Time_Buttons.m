function Add_Time_Buttons(fig, s)
% fig - handles to the figure
% s - handles to the subplots [EEG, powerBand 1, powerBand 2, etc...]

% %% Time buttons:
% text_t_start = uicontrol('Parent',fig,'Style','text','String','Start','Units','normalized',...
% 'Position',[0.025 0.2 0.05 0.022],'Visible','on','HorizontalAlignment', 'left');
% 
% edit_t_start = uicontrol('Parent',fig,'Style','edit','Units','normalized',...
%      'Position',[0.025 0.17 0.025 0.022],'Visible','on');
% 
% 
% text_t_end = uicontrol('Parent',fig,'Style','text','String','End [s]','Units','normalized',...
%     'Position',[0.05 0.2 0.05 0.022],'Visible','on','HorizontalAlignment', 'left');
% 
% 
% edit_t_end = uicontrol('Parent',fig,'Style','edit','Units','normalized',...
%     'Position',[0.05 0.17 0.025 0.022],'Visible','on');
% 
% 
% set_t = uicontrol('Parent',fig,'Style','pushbutton','String','Set','Units','normalized',...
%     'Position',[0.025 0.14 0.05 0.025],'Visible','on','HorizontalAlignment', 'left', 'callback', @click_set_t_lims);
% 
%     function click_set_t_lims(src,event)
%         t_start = str2double(get(edit_t_start, 'string'));
%         t_end = str2double(get(edit_t_end, 'string'));
%         xlim(s(1), [t_start t_end])
%     end

end