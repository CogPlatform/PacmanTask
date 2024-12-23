function steerGhost(ghost)
% determine direction
global ghosts gameMap pacMan midTile CLYDE;
global GHOST_GOING_HOME GHOST_ENTERING_HOME GHOST_PACING_HOME GHOST_LEAVING_HOME GHOST_OUTSIDE;
global DIR_DOWN DIR_RIGHT DIR_LEFT DIR_UP;
global tileSize doesGhostMove

% special gameMap-specific steering when going to, entering, pacing inside, or leaving home
switch ghosts(ghost).mode
    case GHOST_GOING_HOME
        % at the doormat
        if (ghosts(ghost).tile.x == gameMap.doorTile.x && ghosts(ghost).tile.y == gameMap.doorTile.y - 1)
            ghosts(ghost).faceDirEnum = DIR_DOWN;
            ghosts(ghost).targeting = 0;
            % walk to the door, or go through if already there
            if (ghosts(ghost).pixel.x == gameMap.doorPixel.x - 1)
                ghosts(ghost).mode = GHOST_ENTERING_HOME;
                ghosts(ghost).dir = setDirFromEnum(DIR_DOWN);
                ghosts(ghost).dirEnum = DIR_DOWN;
                ghosts(ghost).faceDirEnum = ghosts(ghost).dirEnum;
            else
                ghosts(ghost).dir = setDirFromEnum(DIR_RIGHT);
                ghosts(ghost).dirEnum = DIR_RIGHT;
                ghosts(ghost).faceDirEnum = ghosts(ghost).dirEnum;
            end
        end
    case GHOST_ENTERING_HOME
        if (ghosts(ghost).pixel.y == gameMap.homeBottomPixel)
            % revive if reached its seat
            if (ghosts(ghost).pixel.x == ghosts(ghost).startPixel.x)
                ghosts(ghost).dir = setDirFromEnum(DIR_UP);
                ghosts(ghost).dirEnum = DIR_UP;
                ghosts(ghost).mode = GHOST_PACING_HOME;
                %                 doesGhostMove = 0; % DoubleFaceGhostTrial_v6
            else
                if ghosts(ghost).startPixel.x < ghosts(ghost).pixel.x
                    ghosts(ghost).dir = setDirFromEnum(DIR_LEFT);
                    ghosts(ghost).dirEnum = DIR_LEFT;
                else
                    ghosts(ghost).dir = setDirFromEnum(DIR_RIGHT);
                    ghosts(ghost).dirEnum = DIR_RIGHT;
                end
            end
            
            ghosts(ghost).faceDirEnum = ghosts(ghost).dirEnum;
        end
        %%
    case GHOST_PACING_HOME
        % head for the door
        if doesGhostMove == 0
            if (mod(ghosts(ghost).pixel.y,tileSize) < round(midTile.y))
                ghosts(ghost).dir = setDirFromEnum(DIR_DOWN);
                ghosts(ghost).dirEnum = DIR_DOWN;
            elseif (mod(ghosts(ghost).pixel.y,tileSize) > round(midTile.y))
                ghosts(ghost).dir = setDirFromEnum(DIR_UP);
                ghosts(ghost).dirEnum = DIR_UP;
            end
        elseif (ghosts(ghost).sigLeaveHome)
            ghosts(ghost).sigLeaveHome = 0;
            ghosts(ghost).mode = GHOST_LEAVING_HOME;
            if (ghosts(ghost).pixel.x == gameMap.doorPixel.x)
                ghosts(ghost).dir = setDirFromEnum(DIR_UP);
                ghosts(ghost).dirEnum = DIR_UP;
            else
                if ghosts(ghost).pixel.x < gameMap.doorPixel.x
                    ghosts(ghost).dir = setDirFromEnum(DIR_RIGHT);
                    ghosts(ghost).dirEnum = DIR_RIGHT;
                else
                    ghosts(ghost).dir = setDirFromEnum(DIR_LEFT);
                    ghosts(ghost).dirEnum = DIR_LEFT;
                end
            end
        else % pace back and forth
            if (ghosts(ghost).pixel.y == gameMap.homeTopPixel)
                ghosts(ghost).dir = setDirFromEnum(DIR_DOWN);
                ghosts(ghost).dirEnum = DIR_DOWN;
            elseif (ghosts(ghost).pixel.y == gameMap.homeBottomPixel)
                ghosts(ghost).dir = setDirFromEnum(DIR_UP);
                ghosts(ghost).dirEnum = DIR_UP;
            end
        end
        %             ghosts(ghost).faceDirEnum = ghosts(ghost).dirEnum;
        ghosts(ghost).faceDirEnum = DIR_DOWN;
        %%
    case GHOST_LEAVING_HOME
        if (ghosts(ghost).pixel.x == gameMap.doorPixel.x)
            % reached door
            if (ghosts(ghost).pixel.y == gameMap.doorPixel.y)
                %                % ------stay home for a while----
                %                homeTime = 5;% unit:second
                %                stayTime = 0;
                %                tic;
                %                while stayTime < homeTime
                %                    stayTime = toc;
                %                end
                %                %--------------------------------
                ghosts(ghost).mode = GHOST_OUTSIDE;
                %                 % always turn left at door?
                %                 switch randsrc(1, 1, [[0 1]; [0.3 0.7]]);
                %                        case 0
                %                            ghosts(ghost).dir = setDirFromEnum(DIR_LEFT);
                %                            ghosts(ghost).dirEnum = DIR_LEFT;
                %                        case 1
                %                            ghosts(ghost).dir = setDirFromEnum(DIR_RIGHT);
                %                            ghosts(ghost).dirEnum = DIR_RIGHT;
                %                  end
                ghosts(ghost).dir = setDirFromEnum(DIR_RIGHT);
                ghosts(ghost).dirEnum = DIR_RIGHT;
            else
                ghosts(ghost).dir = setDirFromEnum(DIR_UP);
                ghosts(ghost).dirEnum = DIR_UP;
            end
            ghosts(ghost).faceDirEnum = ghosts(ghost).dirEnum;
        end
        
end



% current opposite direction enum
oppDirEnum = rotateAboutFace(ghosts(ghost).dirEnum);
% only execute rest of the steering logic if we're pursuing a target tile
if (ghosts(ghost).mode ~= GHOST_OUTSIDE && ghosts(ghost).mode ~= GHOST_GOING_HOME)
    ghosts(ghost).targeting = 0;
    return;
end

% AT MID-TILE (update movement direction)
if (ghosts(ghost).distToMid.x == 0 && ghosts(ghost).distToMid.y == 0)
    % trigger reversal
    if (ghosts(ghost).sigReverse)
        ghosts(ghost).faceDirEnum = oppDirEnum;
        ghosts(ghost).sigReverse = 0;
    end
    % commit previous direction
    ghosts(ghost).dirEnum = ghosts(ghost).faceDirEnum;
    ghosts(ghost).dir = setDirFromEnum(ghosts(ghost).dirEnum);
    %fprintf('(%d,%d,%d)\n', ghosts(ghost).tile.x, ghosts(ghost).tile.y, ghosts(ghost).dirEnum);
    
    %JUST PASSED MID-TILE (update face direction)
elseif ( ...
        ghosts(ghost).dirEnum == DIR_RIGHT && ghosts(ghost).distToMid.x == -1 || ...
        ghosts(ghost).dirEnum == DIR_LEFT  && ghosts(ghost).distToMid.x == 1 || ...
        ghosts(ghost).dirEnum == DIR_UP    && ghosts(ghost).distToMid.y == 1 || ...
        ghosts(ghost).dirEnum == DIR_DOWN  && ghosts(ghost).distToMid.y == -1)
    
    % get next tile
    nextTile.x = ghosts(ghost).tile.x + ghosts(ghost).dir.x;
    nextTile.y = ghosts(ghost).tile.y + ghosts(ghost).dir.y;
    
    % get tiles surrounding next tile and their open indication
    openTiles(DIR_UP    + 1) = isFloorTile(nextTile.x, nextTile.y-1);
    openTiles(DIR_RIGHT + 1) = isFloorTile(nextTile.x+1, nextTile.y);
    openTiles(DIR_DOWN  + 1) = isFloorTile(nextTile.x, nextTile.y+1);
    openTiles(DIR_LEFT  + 1) = isFloorTile(nextTile.x-1, nextTile.y);
    
    % By design, no mazes should have dead ends,
    % but allow player to turn around if and only if it's necessary.
    % Only close the passage behind the player if there are other openings.
    if (sum(openTiles) > 1)
        openTiles(oppDirEnum+1) = 0;
    end
    
    if (ghosts(ghost).scared)
        % choose a random turn
        dirEnum = randi(4) -1;
        while (~openTiles(dirEnum+1))
            dirEnum = mod(dirEnum+1,4); % look at likelihood of random turns
        end
        ghosts(ghost).targeting = 0;
    else
        % SET TARGET
        
        % target ghosts(ghost) door
        if (ghosts(ghost).mode == GHOST_GOING_HOME)
            ghosts(ghost).targetTile.x = gameMap.doorTile.x;
            ghosts(ghost).targetTile.y = gameMap.doorTile.y;
            %             elseif (ghostCommander.getCommand() == GHOST_CMD_SCATTER) % target corner when scattering
            %                 ghosts(ghost).targetTile.x = ghosts(ghost).cornerTile.x;
            %                 ghosts(ghost).targetTile.y = ghosts(ghost).cornerTile.y;
            %                 ghosts(ghost).targeting = 3; %'corner';
        else % use custom function for each ghosts(ghost) when in attack mode
            ghosts(ghost).targetTile = getTargetTile(ghost, pacMan); %
            if (ghost ~= CLYDE)
                ghosts(ghost).targeting = 1;% pacman
            end
        end
        
        % CHOOSE TURN
        
        
        % Do not constrain turns for ghosts going home. (thanks bitwave)
        %             if (ghosts(ghost).mode ~= GHOST_GOING_HOME)
        %                 if (gameMap.constrainGhostTurns)
        %                     % edit openTiles to reflect the current gameMap's special contraints
        %                     gameMap.constrainGhostTurns(nextTile, openTiles, this.dirEnum);
        %                 end
        %             end
        
        % choose direction that minimizes distance to target
        minDist = 99999;
        dirEnum = ghosts(ghost).dirEnum;
        
        %% setting blinky direction randomly
        %  hy 20170323
% % %         dirEnum=3*round(rand);
        
        
        %% original code for setting ghosts direction
        %  cannot be deleted!!!
        
        for i=0:3
            if (openTiles(i+1))
                dir=setDirFromEnum(i);
                dx = dir.x + nextTile.x - ghosts(ghost).targetTile.x;
                dy = dir.y + nextTile.y - ghosts(ghost).targetTile.y;
                dist = dx*dx+dy*dy;
                if (dist < minDist)
                    minDist = dist;
                    dirEnum = i;
                end
            end
        end
        
    end
    % Point eyeballs to the determined direction.
    ghosts(ghost).faceDirEnum = dirEnum;
    %fprintf('{%d,%d,%d}\n', ghosts(ghost).tile.x, ghosts(ghost).tile.y, dirEnum);
    
end
end