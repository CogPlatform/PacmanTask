function ghostUpdate_origin(ghost)
global ghosts tileSize gameMap;
global GHOST_GOING_HOME GHOST_ENTERING_HOME GHOST_LEAVING_HOME GHOST_PACING_HOME;

% ghost speed
ghostNormalStepSize=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]; %ZWY
% ghostNormalStepSize=[0,0,0];
% ghostNormalStepSize=[1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0]; 
ghostFrightStepSize=[0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0];
% ghostFrightStepSize=[0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1];
ghostTunnelStepSize=[0 1];
if (ghosts(ghost).mode == GHOST_GOING_HOME || ghosts(ghost).mode == GHOST_ENTERING_HOME)
    numSteps = 2;
elseif (ghosts(ghost).mode == GHOST_LEAVING_HOME || ghosts(ghost).mode == GHOST_PACING_HOME)
    numSteps = ghostTunnelStepSize(mod(ghosts(ghost).frames,2)+1);
elseif (isTunnelTile(ghosts(ghost).tile.x, ghosts(ghost).tile.y))
    numSteps = ghostTunnelStepSize(mod(ghosts(ghost).frames,2)+1);
elseif (ghosts(ghost).scared)
    numSteps = ghostFrightStepSize(mod(ghosts(ghost).frames,16)+1);
else
    numSteps = ghostNormalStepSize(mod(ghosts(ghost).frames,16)+1);
end

% numSteps = 0; %for test 

if (numSteps~=0)
    ghosts(ghost).pixel.x = ghosts(ghost).pixel.x+ghosts(ghost).dir.x;
    ghosts(ghost).pixel.y = ghosts(ghost).pixel.y+ghosts(ghost).dir.y;
    ghosts(ghost).tile.x = floor(ghosts(ghost).pixel.x / tileSize)+1;
    ghosts(ghost).tile.y = floor(ghosts(ghost).pixel.y / tileSize)+1;
    ghosts(ghost).distToMid.x = (ghosts(ghost).tile.x-1)*25+12 - ghosts(ghost).pixel.x;
    ghosts(ghost).distToMid.y = (ghosts(ghost).tile.y-1)*25+12 - ghosts(ghost).pixel.y;
    % update head direction
    steerGhost(ghost);
end

if (gameMap.tunnelRows(ghosts(ghost).tile.y).leftExit~=-1 &&...
        ghosts(ghost).pixel.x < (gameMap.tunnelRows(ghosts(ghost).tile.y).leftExit+1)*tileSize)
    ghosts(ghost).pixel.x = gameMap.tunnelRows(ghosts(ghost).tile.y).rightExit*tileSize-1;
end

if (gameMap.tunnelRows(ghosts(ghost).tile.y).rightExit~=-1 &&...
        ghosts(ghost).pixel.x > gameMap.tunnelRows(ghosts(ghost).tile.y).rightExit*tileSize-1)
    ghosts(ghost).pixel.x = (gameMap.tunnelRows(ghosts(ghost).tile.y).leftExit+1)*tileSize;
end

ghosts(ghost).frames = ghosts(ghost).frames + 1;

end