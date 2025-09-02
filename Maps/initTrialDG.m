function opts = initTrialDG(opts, continueTrial)


%% Global value
globalDefinitions;
global doesGhostMove; doesGhostMove = 1;
global doesGhostWeek; doesGhostWeek = 0;
global ghostNumber;
global startTile pstartTile;
global map_rand;
global is_scared_train;

ghostActive = 1;
ghostEndPosition = 0;

addpath(opts.mapPath);

tileSize = opts.tileSize;
flipInterval = opts.flipInterval;

%% Start a new trial
if (continueTrial == 0)
    %% Map
    map1 = eval(opts.mapName);
    constructMap(28,36,map1);
    
    %% Ghost settings
    ghost = struct( ...
        'id', 1, ...
        'dir', struct('x',1,'y',0), ...
        'dirEnum', 0, ...
        'mode', 0, ...
        'targeting', 0, ...
        'scared', 0, ...
        'sigReverse', 0, ...
        'sigLeaveHome', 0, ...
        'faceDirEnum', 0, ...
        'pixel', struct('x',0,'y',0), ...        % pixel position
        'tile', struct('x',1,'y',1), ...         % tile position
        'distToMid', struct('x',0,'y',0), ...    % pixel distance to mid-tile
        'targetTile', struct('x',0,'y',0), ...   % tile position used for targeting
        'frames', 0);                            % frame count
    
    ghosts = [ghost ghost]; % ZWY
    cornerTile(:,1:2) = [25 0;0 34];
    
    for g=1:ghostNumber
        ghosts(g).id = g;
        ghosts(g).mode = GHOST_PACING_HOME;
        ghosts(g).color = GHOST_COLOR{g};
        ghosts(g).tile.x = startTile(1,g);
        ghosts(g).tile.y = startTile(2,g);
        ghosts(g).pixel.x = (startTile(1,g)-1)*tileSize + midTile.x;
        ghosts(g).pixel.y = (startTile(2,g)-1)*tileSize + midTile.y;
        ghosts(g).startPixel = ghosts(g).pixel;
        ghosts(g).dirEnum = DIR_DOWN;
%         if ~isempty(map_rand)
%             if map_rand < 0.25
%                 ghosts(g).dirEnum = DIR_RIGHT;
%             elseif map_rand < 0.5
%                 ghosts(g).dirEnum = DIR_LEFT;
%             elseif map_rand < 0.75
%                 ghosts(g).dirEnum = DIR_DOWN;
%             else
%                 ghosts(g).dirEnum = DIR_UP;
%             end
%         end
        ghosts(g).dir = setDirFromEnum(-1);
        ghosts(g).faceDirEnum = ghosts(g).dirEnum;
        ghosts(g).cornerTile.x = cornerTile(1,g);
        ghosts(g).cornerTile.y = cornerTile(2,g);
    end
    
    if is_scared_train == 1
        ghosts(2).scared = 1;
    end
    
    %% Pacman settings
    pacMan.color = [1 1 0 0.8];
    pacMan.flipPerTile = tileSize / flipInterval;
    pacMan.step = 0;
    pacMan.numSteps = 10;
    pacMan.angle = 300;
    pacMan.frames = 0;
    pacMan.eatPauseFramesLeft = 0;
    pacMan.tile = pstartTile;
    pacMan.pixel = struct('x',(pacMan.tile.x-1)*tileSize+midTile.x, ...
        'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    pacMan.distToMid = struct('x', 0, 'y', 10);
    %% other settings
    energizerInit;
    fruitInit;
    
    %% continue a trial after PacMan is dead
else    
    %% Ghost settings
    for g=1:ghostNumber
        ghosts(g).id = g;
        ghosts(g).mode = GHOST_PACING_HOME;
        ghosts(g).color = GHOST_COLOR{g};
        ghosts(g).tile.x = startTile(1,g);
        ghosts(g).tile.y = startTile(2,g);
        ghosts(g).pixel.x = (startTile(1,g)-1)*tileSize + midTile.x;
        ghosts(g).pixel.y = (startTile(2,g)-1)*tileSize + midTile.y;
        ghosts(g).startPixel = ghosts(g).pixel;
        ghosts(g).dirEnum = DIR_DOWN;
        if ~isempty(map_rand)
            if map_rand < 0.25
                ghosts(g).dirEnum = DIR_RIGHT;
            elseif map_rand < 0.5
                ghosts(g).dirEnum = DIR_LEFT;
            elseif map_rand < 0.75
                ghosts(g).dirEnum = DIR_DOWN;
            else
                ghosts(g).dirEnum = DIR_UP;
            end
        end
        ghosts(g).dir = setDirFromEnum(-1);
        ghosts(g).faceDirEnum = ghosts(g).dirEnum;
        ghosts(g).scared = false;
        ghosts(g).frames = 0;
    end
    if is_scared_train == 1
        ghosts(2).scared = 1;
    end
    
    %% Pacman settings
    pacMan.tile = pstartTile;
    pacMan.pixel = struct('x',(pacMan.tile.x-1)*tileSize+midTile.x, ...
        'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    pacMan.frames = 0;
    %% other settings
    energizerInit;
    fruitInit;
    
end