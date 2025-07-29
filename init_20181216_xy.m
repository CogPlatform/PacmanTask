function [edfFile,el] = init_20181216_xy
%%Create a gameWindow
globalDefinitions;
global gameWindow tileSize scale;
sca;
% Screen('Preference', 'VisualDebugLevel', 1);
% Screen('Preference', 'Verbosity', 2);
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);%fyh-skip SYNCHRONIZATION test

screens = Screen('Screens');
screenNumber = max(screens);
[myscreenWidth, myscreenHeight] = Screen('WindowSize', screenNumber);
gamewindowWidth = myscreenWidth;  %full size
gamewindowHeight = myscreenHeight; %full size
screenWidth = gamewindowWidth;
screenHeight = gamewindowHeight;
black = BlackIndex(screenNumber);

PsychImaging('PrepareConfiguration');

tileSize = ceil(screenHeight / 44.125/2)*2-1;          %lzq
midTile = struct('x',floor(tileSize/2),'y',floor(tileSize/2));
scale = tileSize / 8.0;
mapWidth = maxCols*tileSize;
mapHeight = maxRows*tileSize;
gameScreenWidth = mapWidth;
gameScreenHeight = mapHeight;
fitSize = [gameScreenWidth, gameScreenHeight];
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UsePanelFitter', fitSize, 'Centered');
%% Open an on screen window and color it black
% For help see: Screen OpenWindow?
[gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, black, [0,0,gamewindowWidth,gamewindowHeight]);
flipInterval = Screen('GetFlipInterval', gameWindow); 


%%
%fyh-delete all eyelink

edfFile=0;
el=0;

end