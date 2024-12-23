function datasaving(timestep,JSVoltage,reward_round,ifi,vbl,flip,miss,fps,CodeCost, ...
    JSCost,DSCost,rewardCost,drawCost,flipCost,ghostUpCost,pacManUpCost)

global ghostNumber ghostActive;
global data gameMap pacMan ghosts energizer rewd
global up down left right bug;
global mapname;
%%
if timestep == 1
    data.time.ifi = ifi;
end
data.time.vbl(timestep) = vbl;
data.time.flip(timestep) = flip;
data.time.miss(timestep) = miss;
data.time.fps(timestep) = fps;
data.time.cost(timestep) = CodeCost;
data.time.JSCheckCost(timestep) = JSCost;
data.time.datasavingCost(timestep) = DSCost;
data.time.rewardCost(timestep) = rewardCost;
data.time.drawCost(timestep) = drawCost;
data.time.flipCost(timestep) = flipCost;
data.time.ghostUpCost(timestep) = ghostUpCost;
data.time.pacManUpCost(timestep) = pacManUpCost;
%%
data.gameMap.currentTiles(:,timestep) = gameMap.currentTiles;
data.gameMap.totalDots(timestep) = gameMap.totalDots;
if timestep == 1
    data.gameMap.version = mapname;
end
%%
data.pacMan.frames(timestep) = pacMan.frames;
data.pacMan.tile_x(timestep) = pacMan.tile.x;
data.pacMan.tile_y(timestep) = pacMan.tile.y;
data.pacMan.pixel_x(timestep) = pacMan.pixel.x;
data.pacMan.pixel_y(timestep) = pacMan.pixel.y;
data.pacMan.dir_x(timestep) = pacMan.dir.x;
data.pacMan.dir_y(timestep) = pacMan.dir.y;
data.pacMan.dirEnum(timestep) = pacMan.dirEnum;
data.pacMan.nextDirEnum(timestep) = pacMan.nextDirEnum;
data.pacMan.distToMid_x(timestep) = pacMan.distToMid.x;
data.pacMan.distToMid_y(timestep) = pacMan.distToMid.y;
%%
if ghostNumber>0 && ghostActive
    for nGoast = 1:ghostNumber
        data.ghosts.tile_x(nGoast,timestep) = floor(ghosts(nGoast).pixel.x/25) + 1;
        data.ghosts.tile_y(nGoast,timestep) = floor(ghosts(nGoast).pixel.y/25) + 1;
        data.ghosts.pixel_x(nGoast,timestep) = ghosts(nGoast).pixel.x;
        data.ghosts.pixel_y(nGoast,timestep) = ghosts(nGoast).pixel.y;
        data.ghosts.dir_x(nGoast,timestep) = ghosts(nGoast).dir.x;
        data.ghosts.dir_y(nGoast,timestep) = ghosts(nGoast).dir.y;
        data.ghosts.dirEnum(nGoast,timestep) = ghosts(nGoast).dirEnum;
        data.ghosts.distToMid_x(nGoast,timestep) = ghosts(nGoast).distToMid.x;
        data.ghosts.distToMid_y(nGoast,timestep) = ghosts(nGoast).distToMid.y;
        
        data.ghosts.targetTile_x(nGoast,timestep) = ghosts(nGoast).targetTile.x;
        data.ghosts.targetTile_y(nGoast,timestep) = ghosts(nGoast).targetTile.y;
        data.ghosts.cornerTile_x(nGoast,timestep) = ghosts(nGoast).cornerTile.x;
        data.ghosts.cornerTile_y(nGoast,timestep) = ghosts(nGoast).cornerTile.y;
        data.ghosts.frames(nGoast,timestep) = ghosts(nGoast).frames;
        data.ghosts.mode(nGoast,timestep) = ghosts(nGoast).mode;
        data.ghosts.targeting(nGoast,timestep) = ghosts(nGoast).targeting;% 1:pacman; 2:door; 3:corner
        data.ghosts.scared(nGoast,timestep) = ghosts(nGoast).scared;
        data.ghosts.sigReverse(nGoast,timestep) = ghosts(nGoast).sigReverse;
        data.ghosts.sigLeaveHome(nGoast,timestep) = ghosts(nGoast).sigLeaveHome;
        data.ghosts.faceDirEnum(nGoast,timestep) = ghosts(nGoast).faceDirEnum;
    end
end

%%
data.energizer.pointsDuration(timestep) = energizer.pointsDuration;
data.energizer.duration(timestep) = energizer.duration;
data.energizer.flashes(timestep) = energizer.flashes;
data.energizer.flashInterval(timestep) = energizer.flashInterval;
data.energizer.count(timestep) = energizer.count;
data.energizer.active(timestep) = energizer.active;
data.energizer.points(timestep) = energizer.points;
data.energizer.pointsFramesLeft(timestep) = energizer.pointsFramesLeft;

%%
data.direction.up(timestep) = up;
data.direction.down(timestep) = down;
data.direction.left(timestep) = left;
data.direction.right(timestep) = right;
data.direction.bug(timestep) = bug;

%%
data.Voltage.up(timestep) = JSVoltage(2);
data.Voltage.down(timestep) = JSVoltage(4);
data.Voltage.left(timestep) = JSVoltage(3);
data.Voltage.right(timestep) = JSVoltage(1);

%% ljs add reward 20190418.
data.rewd.reward(timestep) = reward_round;
data.rewd.rewardWin(timestep) = rewd.rewardWin;
data.rewd.rewardX(timestep) = rewd.rewardX;
data.rewd.magdot(timestep) = rewd.magdot;
data.rewd.magghoast(timestep) = rewd.maggoast;
data.rewd.mageneg(timestep) = rewd.mageneg;
