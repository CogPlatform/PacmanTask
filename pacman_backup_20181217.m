function varargout = pacman(varargin)
% PACMAN MATLAB code for pacman.fig
%      PACMAN, by itself, creates a new PACMAN or raises the existing
%      singleton*.
%
%      H = PACMAN returns the handle to a new PACMAN or the handle to
%      the existing singleton*.
%
%      PACMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PACMAN.M with the given input arguments.
%
%      PACMAN('Property','Value',...) creates a new PACMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pacman_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pacman_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pacman

% Last Modified by GUIDE v2.5 21-Jan-2017 19:08:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pacman_OpeningFcn, ...
    'gui_OutputFcn',  @pacman_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%%%% created by zzw 20170121
%%%% run pacman code, save the data in each floder/ subject's name
%%%% /choose the condition file(map file)/pause and resume the task
%%%% stop the task/ combine the data in each figure

clearvars


% --- Executes just before pacman is made visible.
function pacman_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pacman (see VARARGIN)

% Choose default command line output for pacman
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes pacman wait for user response (see UIRESUME)
% uiwait(handles.PacMan);

% % user define
% % % close the figures;
% % % there would be only one figure even the function is restarted

global ol_info_win %% close the figure defined by function 'show_online' which is created by zq
try
    close(ol_info_win.Window);
end
set(hObject,'HandleVisibility','off');
% % % try
    close all
% % % catch
% % %     close all force
% % %     return
% % % end
set(hObject,'HandleVisibility','on');
clearvars -global


set(handles.map_name,'string','no map is chosen');
set(handles.start,'Enable','off','BackgroundColor',[0.702 0.702 0.702]);
set(handles.PacMan,'units','normalized','Position',[0.7 0.6 0.15 0.4]);
set(handles.name,'string','Subject''s name');

uistack(handles.PacMan,'top');


% --- Outputs from this function are returned to the command line.
function varargout = pacman_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 1: run; 2:time out; 3:not in a run
clearvars -global -except ol_info_win
global current_state mapname ol_info_win;

% % % change the state of other objects, inactive all the objects except
% % % that the objects controning the pause/resueme and stop
set(hObject,'Enable','off','BackgroundColor',[0.702 0.702 0.702]);
set(handles.pause,'Enable','on','BackgroundColor',[0.757 0.867 0.776]);
set(handles.stop,'Enable','on','BackgroundColor',[0.757 0.867 0.776]);

set(handles.name,'Enable','off','BackgroundColor',[0.702 0.702 0.702]);
set(handles.ch_map,'Enable','off','BackgroundColor',[0.8 0.8 0.8]);
set(handles.datacombin,'Enable','off','BackgroundColor',[0.8 0.8 0.8]);
set(findall(0,'Tag','ch_path'),'Enable','off','BackgroundColor',[0.6 0.6 0.6]);
drawnow;

current_state = 1;
% % % get the name of the subject and set up a new folder to save data
name_Callback(findall(0,'Tag','name'));
mkdir(get(findall(0,'Tag','savepath'),'string'));
mapname = get(handles.map_name,'string');

try %% close the figure defined by function 'show_online' which is created by zq
    close(ol_info_win.Window);
end

% % % start the trial
main;


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % % pause the task if current state is run, resueme the task if current
% % % state is pause
global current_state gameWindow
if current_state == 1
    current_state = 2;
    set(hObject,'string','Resume');
    Screen('Flip', gameWindow);
    Screen('Flip', gameWindow);%% could not delete the repeat one
    drawnow;
    uiwait;
elseif current_state == 2
    current_state = 1;
    uiresume;
    set(hObject,'string','Time out');
    drawnow;
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global current_state
% % % if the current state is Pause, then resume and stop the trial
if current_state == 2
    uiresume;
    set(findall(0,'Tag','pause'),'string','Time out');
    drawnow;
end
% % % stop the trial
current_state = 3;

% % % enable other objects and change color
set(handles.pause,'string','Time out','Enable','off',...
    'BackgroundColor',[0.8 0.8 0.8]);
set(handles.start,'Enable','on','BackgroundColor',[0.757 0.867 0.776])
set(hObject,'Enable','off','BackgroundColor',[0.8 0.8 0.8]);
set(handles.name,'Enable','on','BackgroundColor',[1 1 1]);
set(handles.ch_map,'Enable','on','BackgroundColor',[1 1 1]);
set(handles.datacombin,'Enable','on','BackgroundColor',[1 1 1]);
set(findall(0,'Tag','ch_path'),'Enable','on','BackgroundColor',[1 1 1]);
drawnow;



function name_Callback(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name as text
%        str2double(get(hObject,'String')) returns contents of name as a double

% % % get the subject's name, and name it according to subject's name, data
% % % and how many time the subject has done the trial in the current day
% % % Creat a subfolder in current fold to save the data
global datapath SubjectName
inum = 1;
SubjectName = get(hObject,'String');
if ~iscell(SubjectName)
    while exist(strcat(SubjectName, '-', date, '-', num2str(inum)),'dir')
        inum = inum+1;
    end
    if strcmp(SubjectName, 'Omega')
        current_path = [cd,'/Omega/'];
    elseif strcmp(SubjectName, 'Patamon')
        current_path = [cd,'/Patamon/'];
    else
        current_path = [cd, '/'];
    end
    if exist('handles','var') && ~isempty(getappdata(handles.ch_map,'mappath'))
            current_path = getappdata(handles.ch_map,'mappath');  
    end
    datapath = strcat(current_path,SubjectName, '-', date, '-', num2str(inum));
    set(findall(0,'Tag','savepath'),'string',datapath);
    drawnow;
else
    er = errordlg('There is already a pacman window, please close one of them','Too many windows');
    uistack(er,'top');
    set(er,'units','normalized','position',[0.7 0.65 0.115 0.09])
    uiwait(er);
end
        

% --- Executes during object creation, after setting all properties.
function name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%% initialize parameters
name_Callback(hObject);


% --- Executes on button press in ch_map.
function ch_map_Callback(hObject, eventdata, handles)
% hObject    handle to ch_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % % map should be at the same folder with all other code
[mapname_temp, mappath, filterindex] = uigetfile({'*.m'},'Choose .m file for map',...
    'MultiSelect','on');    %%% the number of maps could be more than one
if ~filterindex
    mb = errordlg('no map file selected','choose map');
    set(mb,'units','normalized','position',[0.7 0.65 0.06 0.09])
    uistack(mb,'top');
    uiwait(mb);
else
    set(handles.map_name,'string',mapname_temp);
    set(handles.start,'Enable','on','BackgroundColor',[0.757 0.867 0.776])
    setappdata(hObject,'mappath',mappath);
    name_Callback(handles.name, eventdata, handles);
    drawnow;
end


% --- Executes on button press in datacombin.
function datacombin_Callback(hObject, eventdata, handles)
% hObject    handle to datacombin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % % it would be better that the files in the folder are never changed,
% especically the files' name
path_combin = uigetdir('/home/yanglab-lin/Documents/code20170121/',...
    'Choose the folder in whcih the data is saved');
if isempty(path_combin)
    msgbox('no file selected');
else
    file_list = dir([path_combin,'/*.mat']);
    nFile = size(file_list,1);
    order = zeros(nFile,2);
    for nf = 1:nFile
        sega_(nf,:) = strfind(file_list(nf).name,'-');
        order(nf,:) = [str2double(file_list(nf).name(1:sega_(nf,1)-1))...
            str2double(file_list(nf).name(sega_(nf,1)+1:sega_(nf,2)-1))];
    end
    
    nround = max(order(:,1));
    all_file = cell(1,nround);
    for nr = 1:nround;
        ntrial = max(order(order(:,1)==nr,2));
        all_file{nr}=cell(1,ntrial);
        for nt = 1:ntrial
            nNum = (order(:,1)==nr & order(:,2)==nt);
            temp_data = load([path_combin,'/',file_list(nNum).name]);
            all_file{nr}{nt} = temp_data.data;
        end
    end
    sega = strfind(path_combin,'/');
    final_name = strcat(path_combin,'/',path_combin(sega(end)+1:end),'-all.mat');
    save(final_name,'all_file' ,'-v7.3');
    msgbox('data is combined, and the raw data is not deleted');
    
end



% --- Executes on key press with focus on pause and none of its controls.
function pause_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
