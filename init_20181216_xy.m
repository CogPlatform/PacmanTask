function [edfFile,el] = init_20181216_xy
%%Create a gameWindow
sca;
globalDefinitions;

% Screen('Preference', 'Verbosity', 2);
Screen('Preference', 'VisualDebugLevel', 3);
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);%fyh-skip SYNCHRONIZATION test

screens = Screen('Screens');
screenNumber = max(screens);
[myscreenWidth, myscreenHeight] = Screen('WindowSize', screenNumber);
%should be 1920 x 1080
gamewindowWidth = myscreenWidth;  %full size
gamewindowHeight = myscreenHeight; %full size

screenWidth = gamewindowWidth;
screenHeight = gamewindowHeight;
black = BlackIndex(screenNumber);

%so the tile size will be 25(everything depends on it)
tileSize = ceil(screenHeight / 44.125/2)*2-1;          %lzq
midTile = struct('x',floor(tileSize/2),'y',floor(tileSize/2));
scale = tileSize / 8.0;
mapWidth = maxCols*tileSize;
mapHeight = maxRows*tileSize;
gameScreenWidth = mapWidth;
gameScreenHeight = mapHeight;
fitSize = [gameScreenWidth, gameScreenHeight];
PsychImaging('PrepareConfiguration');
if gamewindowWidth ~= 1920 || gamewindowHeight ~= 1080
    warning('Error: gamewindow resolution must be 1920x1080, but got %dx%d.', ...
          gamewindowWidth, gamewindowHeight);
	PsychImaging('AddTask', 'General', 'UsePanelFitter', fitSize, 'Centered');
end
[gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, black, [0,0,gamewindowWidth,gamewindowHeight]);
flipInterval = Screen('GetFlipInterval', gameWindow); 


%%
%fyh-delete all eyelink

edfFile=0;
el=0;

end