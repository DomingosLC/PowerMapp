function Add_Colorbar_Buttons(fig, nBands, s)
% fig - handles to the figure
% nBands - number of power bands
% s - handles to the subplots [EEG, powerBand 1, powerBand 2, etc...]

%% Colorbar Zoom Buttons
button_plus = [];
button_minus = [];
b_width = 0.02;
b_hight = 0.03;

for b = 1:nBands
    
    pos = get(s(b+1),'position');
    
    xx = pos(1) + pos(3) + b_width*2.5;
    yy_plus = (pos(2)+pos(4)) - b_hight;
    yy_minus = yy_plus - b_hight;
    
    % Plus button:
    button_plus(b) = uicontrol('Parent',fig,'Style','pushbutton','String','+','Units','normalized',...
        'Position',[xx yy_plus b_width b_hight],'Visible','on', 'callback', {@click_plus, b});
    
    % Minus button:
    button_minus(b) = uicontrol('Parent',fig,'Style','pushbutton','String','-','Units','normalized',...
        'Position',[xx yy_minus b_width b_hight],'Visible','on', 'callback', {@click_minus, b});
end

    function click_plus(src,event, band)
        axs = get(s(band+1));
        clims = axs.CLim;
        caxis(s(band+1), [clims(1) clims(2)*1.2])
    end


    function click_minus(src,event, band)
        axs = get(s(band+1));
        clims = axs.CLim;
        caxis(s(band+1), [clims(1) clims(2)*0.8])
    end

end
