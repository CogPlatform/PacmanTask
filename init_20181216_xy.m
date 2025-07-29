function [edfFile,el] = init_20181216_xy
%%Create a gameWindow
globalDefinitions;
global SubjectName  gameWindow tileSize scale;
sca;
% Screen('Preference', 'VisualDebugLevel', 1);
% Screen('Preference', 'Verbosity', 2);
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);%fyh-skip SYNCHRONIZATION test

screens = Screen('Screens');
screenNumber = max(screens);
[myscreenWidth, myscreenHeight] = Screen('WindowSize', screenNumber);
gamewindowWidth = myscreenWidth / 1;  
gamewindowHeight = myscreenHeight / 1; 
wRect = [0,0,gamewindowWidth,gamewindowHeight];
black = BlackIndex(screenNumber);
PsychImaging('PrepareConfiguration');
[gameWindow0, gameWindowRect0] = PsychImaging('OpenWindow', screenNumber, [0.2 0.2 0.2],[]);
[screenWidth, screenHeight] = Screen('WindowSize', gameWindow0);
tileSize = ceil(screenHeight / 44.125/2)*2-1;          %lzq
midTile = struct('x',floor(tileSize/2),'y',floor(tileSize/2));
scale = tileSize / 8.0;
mapWidth = maxCols*tileSize;
mapHeight = maxRows*tileSize;
gameScreenWidth = mapWidth;
gameScreenHeight = mapHeight;
fitSize = [gameScreenWidth+1, gameScreenHeight];

gameWindow = gameWindow0;
gameWindowRect = gameWindowRect0;
flipInterval = Screen('GetFlipInterval', gameWindow); 

%PsychImaging('AddTask', 'General', 'UsePanelFitter', fitSize, 'Centered');
%% Open an on screen window and color it black
% For help see: Screen OpenWindow?
%[gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, black, [0,0,gamewindowWidth,gamewindowHeight]);
%get the monitor flip interval (reflash rate)

% screens = Screen('Screens');
% screenNumber = max(screens);
% black = BlackIndex(screenNumber);
% [gameWindow0, ~] = PsychImaging('OpenWindow', screenNumber, black, [0,0,1920,1080]);
% [screenWidth, screenHeight] = Screen('WindowSize', gameWindow0);
% tileSize = ceil(screenHeight / 44.125/2)*2-1;          %lzq
% midTile = struct('x',ceil(tileSize/2),'y',ceil(tileSize/2));
% scale = tileSize / 8.0;
% mapWidth = maxCols*tileSize;
% mapHeight = maxRows*tileSize;
% gameScreenWidth = mapWidth;
% gameScreenHeight = mapHeight;
% gameScreenXOffset = (screenWidth - gameScreenWidth)/2;
% gameScreenYOffset = (screenHeight - gameScreenHeight)/2;
% [gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, black, ...
%     [gameScreenXOffset gameScreenYOffset gameScreenXOffset+gameScreenWidth+1 gameScreenYOffset+gameScreenHeight]);
% flipInterval = Screen('GetFlipInterval', gameWindow);


%%
%fyh-delete all eyelink
% %% eyelink initialization ---xy 20181216
% dummymode = 0;
% el  = EyelinkInitDefaults(gameWindow);
% el.backgroundcolour = black;
% el.msgfontcolour = WhiteIndex(el.window);
% el.imgtitlecolour = WhiteIndex(el.window);
% el.targetbeep = 0;
% el.calibrationtargetsize = 3;
% el.calibrationtargetwidth = 1;
% el.calibrationtargetcolour = WhiteIndex(el.window);
% EyelinkUpdateDefaults(el);
% 
% if ~EyelinkInit(dummymode)
%     fprintf('Eyelink Initialization aborted.\n');
%     cleanup_sr;
% end
% 
% time = clock;
% 
% % ELdel
% 
% if strcmp(SubjectName,'Patamon')
%     edfFile = sprintf('p%.2d%.2d%d', time(2), time(3),inum);
% elseif strcmp(SubjectName,'OmegaL')
%     edfFile = sprintf('o%.2d%.2d%d', time(2), time(3),inum);
% else
%     edfFile = sprintf('t%.2d%.2d', time(2), time(3));
% end
% 
% i = Eyelink('Openfile', edfFile);
% if i~=0
%     fprintf('Cannot create EDF file ''%s'' ', edfFile);
%     cleanup_sr;
% end
% 
% if Eyelink('IsConnected')~=1
%     cleanup_sr;
%     error('Eyelink is not connected'); 
% end
% 
% %% SET UP TRACKER CONFIGURATION
% % This command is crucial to map the gaze positions from the tracker to
% % screen pixel positions to determine fixation
% Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld',0,0,gameWindowRect(3)-1,gameWindowRect(4)-1);
% % set calibration type.
% Eyelink('command','calibration_type = HV9');
% Eyelink('command','generate_default_targets = YES');
% % retrieve tracker version and tracker software version
% [v,vs] = Eyelink('GetTrackerVersion');
% fprintf('Receive eye signal from EYELINK version %1d.\n',v);
% fprintf('Running experiment on a ''%s'' tracker.\n', vs);
% % set EDF file contents. Note the FIXUPDATE event for fixation update
% Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT,FIXUPDATE');
% Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
% Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT,FIXUPDATE ');
% Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
% % allow to use the big button on the eyelink gamepad to accept the calibration target
% Eyelink('command','button_function 5 "accept_target_fixation"');
% % Tell the Eyelink to send a fixation update every 50 ms
% Eyelink('command', 'fixation_update_interval = %d', 50);
% Eyelink('command', 'fixation_update_accumulate = %d', 50);
% 
% if ~dummymode
%     Screen('HideCursorHelper',gameWindow);
% end
% EyelinkDoTrackerSetup(el);
% Snd('close');
% Eyelink('Command','set_idle_mode');
% Eyelink('Command', 'clear_screen %d', 0);
%  % calculate locations of target peripheries so that we can draw
% % matching lines and boxes on host pc
% px = [350,350,655,45,45,655,350,45,655,350];
% py = [450,75,75,75,825,825,825,450,450,450];
% for i = 1:9
%     Eyelink('command', 'draw_cross %d %d 2', px(i), py(i));
% end

edfFile=0;
el=0;

end