function clearData
global data
%%
data.time.vbl(data.time.vbl == Inf) = [];
data.time.flip(data.time.flip == Inf) = [];
data.time.miss(data.time.miss == Inf) = [];
data.time.fps(data.time.fps == Inf) = [];
data.time.cost(data.time.cost == Inf) = [];
data.time.JSCheckCost(data.time.JSCheckCost == Inf) = [];
data.time.datasavingCost(data.time.datasavingCost == Inf) = [];
data.time.rewardCost(data.time.rewardCost == Inf) = [];
data.time.drawCost(data.time.drawCost == Inf) = [];
data.time.flipCost(data.time.flipCost == Inf) = [];
data.time.ghostUpCost(data.time.ghostUpCost == Inf) = [];
data.time.pacManUpCost(data.time.pacManUpCost == Inf) = [];
%%
data.gameMap.currentTiles = data.gameMap.currentTiles(:,data.gameMap.currentTiles(1,:) ~= Inf);
for i = 1:length(data.gameMap.currentTiles(1,:))
    currentTiles(:,i) = native2unicode(data.gameMap.currentTiles(:,i));
end
data.gameMap.currentTiles = '';
data.gameMap.currentTiles = currentTiles;
data.gameMap.totalDots(data.gameMap.totalDots == Inf) = [];
%%
data.pacMan.frames(data.pacMan.frames == Inf) = [];
data.pacMan.tile_x(data.pacMan.tile_x == Inf) = [];
data.pacMan.tile_y(data.pacMan.tile_y == Inf) = [];
data.pacMan.pixel_x(data.pacMan.pixel_x == Inf) = [];
data.pacMan.pixel_y(data.pacMan.pixel_y == Inf) = [];
data.pacMan.dir_x(data.pacMan.dir_x == Inf) = [];
data.pacMan.dir_y(data.pacMan.dir_y == Inf) = [];
data.pacMan.dirEnum(data.pacMan.dirEnum == Inf) = [];
data.pacMan.nextDirEnum(data.pacMan.nextDirEnum == Inf) = [];
data.pacMan.distToMid_x(data.pacMan.distToMid_x == Inf) = [];
data.pacMan.distToMid_y(data.pacMan.distToMid_y == Inf) = [];
%%
data.ghosts.tile_x = data.ghosts.tile_x(:,data.ghosts.tile_x(1,:) ~= Inf);
data.ghosts.tile_y = data.ghosts.tile_y(:,data.ghosts.tile_y(1,:) ~= Inf);
data.ghosts.pixel_x = data.ghosts.pixel_x(:,data.ghosts.pixel_x(1,:) ~= Inf);
data.ghosts.pixel_y = data.ghosts.pixel_y(:,data.ghosts.pixel_y(1,:) ~= Inf);
data.ghosts.dir_x = data.ghosts.dir_x(:,data.ghosts.dir_x(1,:) ~= Inf);
data.ghosts.dir_y = data.ghosts.dir_y(:,data.ghosts.dir_y(1,:) ~= Inf);
data.ghosts.dirEnum = data.ghosts.dirEnum(:,data.ghosts.dirEnum(1,:) ~= Inf);
data.ghosts.distToMid_x = data.ghosts.distToMid_x(:,data.ghosts.distToMid_x(1,:) ~= Inf);
data.ghosts.distToMid_y = data.ghosts.distToMid_y(:,data.ghosts.distToMid_y(1,:) ~= Inf);

data.ghosts.targetTile_x = data.ghosts.targetTile_x(:,data.ghosts.targetTile_x(1,:) ~= Inf);
data.ghosts.targetTile_y = data.ghosts.targetTile_y(:,data.ghosts.targetTile_y(1,:) ~= Inf);
data.ghosts.cornerTile_x = data.ghosts.cornerTile_x(:,data.ghosts.cornerTile_x(1,:) ~= Inf);
data.ghosts.cornerTile_y = data.ghosts.cornerTile_y(:,data.ghosts.cornerTile_y(1,:) ~= Inf);
data.ghosts.frames = data.ghosts.frames(:,data.ghosts.frames(1,:) ~= Inf);
data.ghosts.mode = data.ghosts.mode(:,data.ghosts.mode(1,:) ~= Inf);
data.ghosts.targeting = data.ghosts.targeting(:,data.ghosts.targeting(1,:) ~= Inf);% 1:pacman; 2:door; 3:corner
data.ghosts.scared = data.ghosts.scared(:,data.ghosts.scared(1,:) ~= Inf);
data.ghosts.sigReverse = data.ghosts.sigReverse(:,data.ghosts.sigReverse(1,:) ~= Inf);
data.ghosts.sigLeaveHome = data.ghosts.sigLeaveHome(:,data.ghosts.sigLeaveHome(1,:) ~= Inf);
data.ghosts.faceDirEnum = data.ghosts.faceDirEnum(:,data.ghosts.faceDirEnum (1,:) ~= Inf);


%%
data.energizer.pointsDuration(data.energizer.pointsDuration == Inf) = [];
data.energizer.duration(data.energizer.duration == Inf) = [];
data.energizer.flashes(data.energizer.flashes == Inf) = [];
data.energizer.flashInterval(data.energizer.flashInterval == Inf) = [];
data.energizer.count(data.energizer.count == Inf) = [];
data.energizer.active(data.energizer.active == Inf) = [];
data.energizer.points(data.energizer.points == Inf) = [];
data.energizer.pointsFramesLeft(data.energizer.pointsFramesLeft == Inf) = [];

%%
data.direction.up(data.direction.up == Inf) = [];
data.direction.down(data.direction.down == Inf) = [];
data.direction.left(data.direction.left == Inf) = [];
data.direction.right(data.direction.right == Inf) = [];
data.direction.bug(data.direction.bug == Inf) = [];

%%
data.Voltage.up(data.Voltage.up == Inf) = [];
data.Voltage.down(data.Voltage.down == Inf) = [];
data.Voltage.left(data.Voltage.left == Inf) = [];
data.Voltage.right(data.Voltage.right == Inf) = [];

%% ljs add reward 20190418.
data.rewd.reward(data.rewd.reward == Inf) = [];
data.rewd.rewardWin(data.rewd.rewardWin == Inf) = [];
data.rewd.rewardX(data.rewd.rewardX == Inf) = [];
data.rewd.magdot(data.rewd.magdot == Inf) = [];
data.rewd.magghoast(data.rewd.magghoast == Inf) = [];
data.rewd.mageneg(data.rewd.mageneg == Inf) = [];
