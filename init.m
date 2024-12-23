function init
    %%
    globalDefinitions;
    
    % Clear the workspace and the screen
    sca;
% % %     close all force;
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    % For help see: Screen Screens?
    screens = Screen('Screens');
    
    % Draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen. When only one screen is attached to the monitor we will draw to
    % this.
    % For help see: help max
    screenNumber = max(screens);
    
    % Define black (white will be 1 and black 0). This is because
    % luminace values are (in general) defined between 0 and 1.
    % For help see: help BlackIndex
    black = BlackIndex(screenNumber);
    
    
    % Open an on screen window and color it black
    % For help see: Screen OpenWindow?
%================= WINDOW SIZE -lzq ==========================
% 	   [gameWindow0, gameWindowRect0] = PsychImaging('OpenWindow',screenNumber , black,[0,0,640,800]);
% 	[gameWindow0, gameWindowRect0] = PsychImaging('OpenWindow', screenNumber, black,[0,0,1920,1920]);
[gameWindow0, gameWindowRect0] = PsychImaging('OpenWindow', screenNumber, black,[0,0,1920,1080]);
% 	    [gameWindow0, gameWindowRect0] = PsychImaging('OpenWindow', screenNumber, black);
%================= WINDOW SIZE -lzq ==========================
    % Get the size of the on screen window in pixels
    % For help see: Screen WindowSize?
    [screenWidth, screenHeight] = Screen('WindowSize', gameWindow0);
    
    tileSize = ceil(screenHeight / 44.125/2)*2-1;          %lzq
    midTile = struct('x',ceil(tileSize/2),'y',ceil(tileSize/2));
    scale = tileSize / 8.0;
    
    mapWidth = maxCols*tileSize;
    mapHeight = maxRows*tileSize;
    gameScreenWidth = mapWidth;
    gameScreenHeight = mapHeight;
    gameScreenXOffset = (screenWidth - gameScreenWidth)/2;
    gameScreenYOffset = (screenHeight - gameScreenHeight)/2;
    
    %% Open an on screen window and color it black
    % For help see: Screen OpenWindow?
    [gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, black, ...
        [gameScreenXOffset gameScreenYOffset gameScreenXOffset+gameScreenWidth+1 gameScreenYOffset+gameScreenHeight]);
    flipInterval = Screen('GetFlipInterval', gameWindow); %get the monitor flip interval (reflash rate?)
    StimulusOnsetTime = Screen('Flip', gameWindow);
    topPriorityLevel = MaxPriority(gameWindow);
    OldPriority = Priority(topPriorityLevel);
    
    totalReward = 0;
    %% online information window --lzq 20170119
	%     global ol_info_win
    ol_info_win = struct(...
    'Window',[],...
    'Axes',[],...
    'CurrentLine',.98);
    ol_info_win.Window = figure('menubar','none','NumberTitle','off',...
        'position',[3600 1000 300 999],'name','online information',...
        'Visible','on','CloseRequestFcn',@onlinewinclosefcn);
    ol_info_win.Axes = axes('visible','off','units','normalized','position',[0,0,1,1],'Parent',ol_info_win.Window);
%% 

end