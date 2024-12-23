function show_online(InputString)
% show_online(InputString)
% display the input string on a online window while
% running the pac-man paradigm
%
% by ZQ-Lin, 2017.1.19

global ol_info_win

if isempty(ol_info_win.Window)
    ol_info_win.Window = figure('menubar','none','NumberTitle','off',...
        'position',[3600 1000 300 999],'name','online information',...
        'Visible','on','CloseRequestFcn',@onlinewinclosefcn);
    ol_info_win.Axes = axes('visible','off','units','normalized','position',[0,0,1,1],'Parent',ol_info_win.Window);
    ol_info_win.CurrentLine = .98;
end

if ol_info_win.CurrentLine<0.02
    ol_info_win.Window = figure('menubar','none','NumberTitle','off',...
        'position',[3600 1000 300 999],'name','online information',...
        'Visible','on','CloseRequestFcn',@onlinewinclosefcn);
    ol_info_win.Axes = axes('visible','off','units','normalized','position',[0,0,1,1],'Parent',ol_info_win.Window);
    ol_info_win.CurrentLine = .98;
end

text('string',InputString,'position',[.05, ol_info_win.CurrentLine], ...
    'FontSize', 11, 'Parent',ol_info_win.Axes);
ol_info_win.CurrentLine = ol_info_win.CurrentLine - 0.02;


end