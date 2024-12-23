function initDoubleFaceGhostTrial_v12(continueTrial)


%% Global value
globalDefinitions;
global doesGhostMove; doesGhostMove = 1;
global NumOfTrials;
global NumOfError;
global NumOfSuccess;
global EndReward; 
global doesGhostWeek; doesGhostWeek = 0;
global NumOfNormal NumOfScared NumOfNormalSuccess NumOfScaredSuccess;
global ghostNumber;

ghostNumber = 2; %ZWY
ghostActive = 1;
ghostEndPosition = 0;

%% Start a new trial
if (continueTrial == 0)
   EndReward = 15;
   
   %% Map
   startTile(:,1:2) = [14 15;18 19];
   pacMan.tile = struct('x',14,'y',27);
   map1 = GenerateRandomMap_V12;
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
    'tilePixel', struct('x',0,'y',0), ...    % pixel location inside tile
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
        ghosts(g).dirEnum = DIR_UP;
        ghosts(g).dir = setDirFromEnum(ghosts(g).dirEnum);
        ghosts(g).faceDirEnum = ghosts(g).dirEnum;
        ghosts(g).cornerTile.x = cornerTile(1,g);
        ghosts(g).cornerTile.y = cornerTile(2,g);
    end
            
    %% Pacman settings
    pacMan.color = [1 1 0 0.8];
    pacMan.flipPerTile = tileSize / flipInterval;
    pacMan.step = 0;
    pacMan.numSteps = 10;
    pacMan.angle = 300;
    pacMan.frames = 0;
    pacMan.eatPauseFramesLeft = 0;
    pacMan.pixel = struct('x',(pacMan.tile.x)*tileSize-midTile.x+1,'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    pacMan.distToMid = struct('x', 0, 'y', 10);
    pacMan.tilePixel = struct('x', -1, 'y', -1);
    
    energizerInit;
    fruitInit;

%% continue a trial after PacMan is dead    
else 
    
    %% initial pacMan start Tile
        startTile(:,1:2) = [14 15;18 19];
        pacMan.tile = struct('x',14,'y',27);
            
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
        ghosts(g).dirEnum = DIR_UP;
        ghosts(g).dir = setDirFromEnum(ghosts(g).dirEnum);
        ghosts(g).faceDirEnum = ghosts(g).dirEnum;
        ghosts(g).scared = false;
    end
    
    %% Pacman settings
    pacMan.pixel = struct('x',(pacMan.tile.x)*tileSize-midTile.x+1,'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    
    energizerInit;
    fruitInit;

end