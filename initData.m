function initData
global data
%%
data.time.vbl = ones(1,20000) * Inf;
data.time.flip = ones(1,20000) * Inf;
data.time.miss = ones(1,20000) * Inf;
data.time.fps = ones(1,20000) * Inf;
data.time.cost = ones(1,20000) * Inf;
data.time.JSCheckCost = ones(1,20000) * Inf;
data.time.datasavingCost = ones(1,20000) * Inf;
data.time.rewardCost = ones(1,20000) * Inf;
data.time.drawCost = ones(1,20000) * Inf;
data.time.flipCost = ones(1,20000) * Inf;
data.time.ghostUpCost = ones(1,20000) * Inf;
data.time.pacManUpCost = ones(1,20000) * Inf;
%%
data.gameMap.currentTiles = ones(1008,20000) * Inf;
data.gameMap.totalDots = ones(1,20000) * Inf;
%%
data.pacMan.frames = ones(1,20000) * Inf;
data.pacMan.tile_x = ones(1,20000) * Inf;
data.pacMan.tile_y = ones(1,20000) * Inf;
data.pacMan.pixel_x = ones(1,20000) * Inf;
data.pacMan.pixel_y = ones(1,20000) * Inf;
data.pacMan.dir_x = ones(1,20000) * Inf;
data.pacMan.dir_y = ones(1,20000) * Inf;
data.pacMan.dirEnum = ones(1,20000) * Inf;
data.pacMan.nextDirEnum = ones(1,20000) * Inf;
data.pacMan.distToMid_x = ones(1,20000) * Inf;
data.pacMan.distToMid_y = ones(1,20000) * Inf;
%%
data.ghosts.tile_x = ones(2,20000) * Inf;
data.ghosts.tile_y = ones(2,20000) * Inf;
data.ghosts.pixel_x = ones(2,20000) * Inf;
data.ghosts.pixel_y = ones(2,20000) * Inf;
data.ghosts.dir_x = ones(2,20000) * Inf;
data.ghosts.dir_y = ones(2,20000) * Inf;
data.ghosts.dirEnum = ones(2,20000) * Inf;
data.ghosts.distToMid_x = ones(2,20000) * Inf;
data.ghosts.distToMid_y = ones(2,20000) * Inf;

data.ghosts.targetTile_x = ones(2,20000) * Inf;
data.ghosts.targetTile_y = ones(2,20000) * Inf;
data.ghosts.cornerTile_x = ones(2,20000) * Inf;
data.ghosts.cornerTile_y = ones(2,20000) * Inf;
data.ghosts.frames = ones(2,20000) * Inf;
data.ghosts.mode = ones(2,20000) * Inf;
data.ghosts.targeting = ones(2,20000) * Inf;% 1:pacman; 2:door; 3:corner
data.ghosts.scared = ones(2,20000) * Inf;
data.ghosts.sigReverse = ones(2,20000) * Inf;
data.ghosts.sigLeaveHome = ones(2,20000) * Inf;
data.ghosts.faceDirEnum = ones(2,20000) * Inf;


%%
data.energizer.pointsDuration = ones(1,20000) * Inf;
data.energizer.duration = ones(1,20000) * Inf;
data.energizer.flashes = ones(1,20000) * Inf;
data.energizer.flashInterval = ones(1,20000) * Inf;
data.energizer.count = ones(1,20000) * Inf;
data.energizer.active = ones(1,20000) * Inf;
data.energizer.points = ones(1,20000) * Inf;
data.energizer.pointsFramesLeft = ones(1,20000) * Inf;

%%
data.direction.up = ones(1,20000) * Inf;
data.direction.down = ones(1,20000) * Inf;
data.direction.left = ones(1,20000) * Inf;
data.direction.right = ones(1,20000) * Inf;
data.direction.bug = ones(1,20000) * Inf;

%%
data.Voltage.up = ones(1,20000) * Inf;
data.Voltage.down = ones(1,20000) * Inf;
data.Voltage.left = ones(1,20000) * Inf;
data.Voltage.right = ones(1,20000) * Inf;

%% ljs add reward 20190418.
data.rewd.reward = ones(1,20000) * Inf;
data.rewd.rewardWin = ones(1,20000) * Inf;
data.rewd.rewardX = ones(1,20000) * Inf;
data.rewd.magdot = ones(1,20000) * Inf;
data.rewd.magghoast = ones(1,20000) * Inf;
data.rewd.mageneg = ones(1,20000) * Inf;
