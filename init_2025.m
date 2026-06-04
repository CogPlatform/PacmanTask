function opts = init_2025(opts)
	% Create a gameWindow

	%% =========================== globals 
	globalDefinitions; % define global variables and constants
	
	%% =========================== debug mode?
	sf = []; windowed = [];
	if (opts.screen==0 || max(Screen('Screens'))==0) && opts.debug
		if IsLinux || IsOSX
			sf = kPsychGUIWindow; 
			windowed = [0 0 1920 1080]; 
		else
			PsychDebugWindowConfiguration; %for windows only, kPsychGUIWindow is better
		end
	end
	
	%% ============================ PTB setup
	PsychDefaultSetup(2);
	Screen('Preference', 'VisualDebugLevel', 3);
	if opts.disableSync
		Screen('Preference', 'SkipSyncTests', 2);
	else
		Screen('Preference', 'SkipSyncTests', 0);
	end
	
	% screen setup
	[gamewindowWidth, gamewindowHeight] = Screen('WindowSize', opts.screen);
	
	% should be 1920 x 1080
	if gamewindowWidth ~= 1920 || gamewindowHeight ~= 1080
		warning('Warning: gamewindow resolution must be 1920x1080, but got %dx%d.', ...
			gamewindowWidth, gamewindowHeight);
		gamewindowHeight = 1080; % Reset to default height
		gamewindowWidth = 1920;  % Reset to default width
	end
	
 	% so the tile size will be 25(everything depends on it)
	tileSize = ceil( gamewindowHeight / 44.125 /2 ) * 2 - 1;          %lzq
	midTile = struct('x', floor(tileSize/2),'y', floor(tileSize/2));
	scale = tileSize / 8.0;
	mapWidth = maxCols*tileSize;
	mapHeight = maxRows*tileSize;
	gameScreenWidth = mapWidth;
	gameScreenHeight = mapHeight;
	fitSize = [mapWidth, mapHeight];
	
	% open PTB screen
	PsychImaging('PrepareConfiguration');
	PsychImaging('AddTask', 'General', 'UseFastOffscreenWindows');
	PsychImaging('AddTask', 'General', 'UseVirtualFramebuffer');
	PsychImaging('AddTask', 'General', 'UsePanelFitter', fitSize, 'Centered');
	[gameWindow, gameWindowRect] = PsychImaging('OpenWindow', opts.screen, ...
		[0 0 0], windowed, [],[],[],[],[], sf);
	opts.flipInterval = Screen('GetFlipInterval', gameWindow); 
	opts.scale = scale;
	opts.tileSize = tileSize;
	opts.gameWindow = gameWindow;
	opts.gameWindowRect = gameWindowRect;
	opts.mapWidth = mapWidth;
	opts.mapHeight = mapHeight;
	opts.mapRect = CenterRect([0 0 mapWidth mapHeight],gameWindowRect);

end
