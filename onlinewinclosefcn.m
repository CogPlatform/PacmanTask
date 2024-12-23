function onlinewinclosefcn(src,evnt)

global ol_info_win
% display('test')
delete(ol_info_win.Window)
% display('test2')

ol_info_win.Window = [];
ol_info_win.Axes = [];
ol_info_win.CurrentLine = .98;


return
end