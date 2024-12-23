function initDoubleFaceGhostTrial_v3(continueTrial)

%% Global value
globalDefinitions;
global doesGhostMove; doesGhostMove = 0;
global randomfig;
global NumOfTrials;
global NumOfError;
global NumOfSuccess;
global EndReward; 
global doesGhostWeek;
global NumOfNormal NumOfScared NumOfNormalSuccess NumOfScaredSuccess;

ghostNumber = 1;
ghostActive = 1;
ghostEndPosition = 1;



%% Start a new trial
if (continueTrial == 0)
   EndReward = 3;
   if mod(NumOfTrials,10)==0 && NumOfTrials ~=0
        show_online(['Correct number/error/total/CR/NR/SR= ',num2str([NumOfSuccess NumOfError NumOfTrials (NumOfSuccess/NumOfTrials) NumOfNormalSuccess/NumOfNormal NumOfScaredSuccess/NumOfScared]),'/',num2str(datestr(now,0))]);
        NumOfTrials=0;
        NumOfSuccess=0;
        NumOfError=0;
        NumOfNormal = 0;
        NumOfScared = 0;
        NumOfNormalSuccess = 0;
        NumOfScaredSuccess = 0;
   end
   randomfig = randsrc(1, 1, [[0 1]; [1 0]]);
   switch randomfig
       case 0
           doesGhostWeek = 0; fprintf(2, 'Ghost is not scared Ghost is not scared Ghost is not scared\n');
       case 1
           doesGhostWeek = 1; fprintf(2, 'Ghost is scared Ghost is scared Ghost is scared\n');
   end
    %% Map 
    startTile(:,1) = [15;12];
    pacMan.tile = struct('x',15,'y',2);    
    constructMap(28, 36, [ ...
    '_____|||||||||||||||||||____' ...
    '_____|                 |____' ...
    '_____| ||||||||||||||| |____' ...
    '_____| |             | |____' ...
    '_____| |             | |____' ...
    '_____| |             | |____' ...
    '_____| |             | |____' ...
    '_____| ||||||||||||||| |____' ...
    '_____|                 |____' ...
    '_____| || ||||-|||| || |____' ...
    '_____| || |_______| || |____' ...
    '_____| || |_______| || |____' ...
    '_____| || |_______| || |____' ...
    '_____| || ||||||||| || |____' ...
    '_____| ||  ... ...  || |____' ...
    '_____| ||||||| ||||||| |____' ...
    '_____| ||||||| ||||||| |____' ...
    '_____|.... ..   .. ....|____' ...
    '_____|||||||||||||||||||____' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '____________________________']);
    NumOfTrials=NumOfTrials+1;
    
    switch randomfig
        case 0
            NumOfNormal = NumOfNormal + 1;
        case 1 
            NumOfScared = NumOfScared + 1;
    end
            
    % Ghost settings 
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

    ghosts = ghost;
    cornerTile(:,1) = [25;0];

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
            
    % Pacman settings
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
    EndReward = 1;
    if mod(NumOfTrials,10)==0 && NumOfTrials ~=0
        show_online(['Correct number/error/total/CR/NR/SR= ',num2str([NumOfSuccess NumOfError NumOfTrials (NumOfSuccess/NumOfTrials) NumOfNormalSuccess/NumOfNormal NumOfScaredSuccess/NumOfScared]),'/',num2str(datestr(now,0))]);
        NumOfTrials=0;
        NumOfSuccess=0;
        NumOfError=0;
        NumOfNormal = 0;
        NumOfScared = 0;
        NumOfNormalSuccess = 0;
        NumOfScaredSuccess = 0;
    end
    NumOfTrials=NumOfTrials+1;
    
    switch randomfig
        case 0
            NumOfNormal = NumOfNormal + 1;
        case 1 
            NumOfScared = NumOfScared + 1;
    end
    
    switch randomfig
        case 0
            doesGhostWeek = 0; fprintf(2, 'Ghost is not scared Ghost is not scared Ghost is not scared\n');
        case 1
            doesGhostWeek = 1; fprintf(2, ' Ghost is scared Ghost is scared Ghost is scared\n');
            doesGhostMove = 0;
    end
    startTile(:,1) = [15;12];
    pacMan.tile = struct('x',15,'y',2);
            
    % Ghost settings
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
    end
    
    % Pacman settings
    pacMan.pixel = struct('x',(pacMan.tile.x)*tileSize-midTile.x+1,'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    
    energizerInit;
    fruitInit;
end