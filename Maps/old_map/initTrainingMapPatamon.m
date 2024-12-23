function initTrainingMapPatamon(continueTrial)


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
global randomfig;

ghostNumber = 0; %ZWY
ghostActive = 1;
ghostEndPosition = 0;

%% Start a new trial
if (continueTrial == 0)
   EndReward = 5;
%    EndReward = 10; % before
   if mod(NumOfTrials,50)==0 && NumOfTrials ~=0
        show_online(sprintf('Correct number/error/total/CR/NR/SR= %d %d %d %.2f %.2f %.2f/  %s\n', ...
            NumOfSuccess, NumOfError, NumOfTrials, (NumOfSuccess/NumOfTrials), ...
            NumOfNormalSuccess/NumOfNormal, NumOfScaredSuccess/NumOfScared, datestr(now)));
        fprintf('Correct number/error/total/CR/NR/SR= %d %d %d %.2f %.2f %.2f/  %s\n', ...
            NumOfSuccess, NumOfError, NumOfTrials, (NumOfSuccess/NumOfTrials), ...
            NumOfNormalSuccess/NumOfNormal, NumOfScaredSuccess/NumOfScared, datestr(now));
        NumOfTrials=0;
        NumOfSuccess=0;
        NumOfError=0;
        NumOfNormal = 0;
        NumOfScared = 0;
        NumOfNormalSuccess = 0;
        NumOfScaredSuccess = 0;
   end
   
   %% Map
   startTile(:,1:2) = [14 15;18 19];
   pacMan.tile = struct('x',14,'y',27);
   map1 = GenerateTrainingMapPatamon;
   constructMap(28,36,map1);
   NumOfTrials=NumOfTrials+1;
   NumOfNormal = NumOfNormal + 1;
                                
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
    EndReward = 3;
%    EndReward = 7; % before
    if mod(NumOfTrials,50)==0 && NumOfTrials ~=0
        show_online(sprintf('Correct number/error/total/CR/NR/SR= %d %d %d %.2f %.2f %.2f/  %s\n', ...
            NumOfSuccess, NumOfError, NumOfTrials, (NumOfSuccess/NumOfTrials), ...
            NumOfNormalSuccess/NumOfNormal, NumOfScaredSuccess/NumOfScared, datestr(now)));
        NumOfTrials=0;
        NumOfSuccess=0;
        NumOfError=0;
        NumOfNormal = 0;
        NumOfScared = 0;
        NumOfNormalSuccess = 0;
        NumOfScaredSuccess = 0;
    end
    NumOfTrials=NumOfTrials+1;
    NumOfNormal = NumOfNormal + 1;
    
    %% initial pacMan start Tile
        startTile(:,1:2) = [14 15;18 19];
        pacMan.tile = struct('x',14,'y',27);
    
    %% Pacman settings
    pacMan.pixel = struct('x',(pacMan.tile.x)*tileSize-midTile.x+1,'y',(pacMan.tile.y-1)*tileSize+midTile.y);
    pacMan.dirEnum = -1;
    pacMan.nextDirEnum = -1;
    pacMan.dir = setDirFromEnum(-1);
    
    energizerInit;
    fruitInit;

end