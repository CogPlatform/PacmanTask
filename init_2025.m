function opts = init_2025(opts)
%%Create a gameWindow

% globals 
globalDefinitions;
global gameWindow tileSize scale;
sca;

% PTB setup
PsychDefaultSetup(2);
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SkipSyncTests', 1);

% screen setup
screenNumber = max( Screen('Screens'));
[gamewindowWidth, gamewindowHeight] = Screen('WindowSize', screenNumber);

%should be 1920 x 1080
if gamewindowWidth ~= 1920 || gamewindowHeight ~= 1080
	warning('Warning: gamewindow resolution must be 1920x1080, but got %dx%d.', ...
		gamewindowWidth, gamewindowHeight);
end

 %so the tile size will be 25(everything depends on it)
tileSize = ceil(gamewindowHeight / 44.125/2)*2-1;          %lzq
midTile = struct('x',floor(tileSize/2),'y',floor(tileSize/2));
scale = tileSize / 8.0;
mapWidth = maxCols*tileSize;
mapHeight = maxRows*tileSize;
gameScreenWidth = mapWidth;
gameScreenHeight = mapHeight;
fitSize = [gameScreenWidth, gameScreenHeight];

% open PTB screen
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UsePanelFitter', fitSize, 'Centered');
[gameWindow, gameWindowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0], [0,0,gamewindowWidth,gamewindowHeight]);
opts.flipInterval = Screen('GetFlipInterval', gameWindow); 
opts.scale = scale;
opts.tileSize = tileSize;
opts.gameWindow = gameWindow;
opts.gameWindowRect = gameWindowRect;

end