function [ghostNumber, up, down, left, right] = getFrameFromMAT(data, index)
global ghosts pacMan gameMap;
ghostNumber = 2;
%% update map
gameMap.currentTiles = data.gameMap.currentTiles(:,index);
%% update ghosts
for gNum = 1:ghostNumber
    ghosts(gNum).pixel.x = data.ghosts.pixel_x(gNum,index);
    ghosts(gNum).pixel.y = data.ghosts.pixel_y(gNum,index);
    ghosts(gNum).tile.x = data.ghosts.tile_x(gNum,index);
    ghosts(gNum).tile.y = data.ghosts.tile_y(gNum,index);
    ghosts(gNum).frames = data.ghosts.frames(gNum,index);
    ghosts(gNum).dirEnum = data.ghosts.dirEnum(gNum,index);
    ghosts(gNum).scared = data.ghosts.scared(gNum,index);
    ghosts(gNum).mode = data.ghosts.mode(gNum,index);
end
%% update pacman
pacMan.pixel.x = data.pacMan.pixel_x(index);
pacMan.pixel.y = data.pacMan.pixel_y(index);
pacMan.tile.x = data.pacMan.tile_x(index);
pacMan.tile.y = data.pacMan.tile_y(index);
pacMan.dirEnum = data.pacMan.dirEnum(index);
pacMan.frames = data.pacMan.frames(index);
%% update joystick
up = data.direction.up(index);
down = data.direction.down(index);
left = data.direction.left(index);
right = data.direction.right(index);
end