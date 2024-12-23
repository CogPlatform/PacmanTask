function [ghostNumber, up, down, left, right] = getFrameFromCSV(T_i)
global ghosts pacMan gameMap;
ghostNumber = 2;
%% update map
gameMap.currentTiles = char(T_i.Map);
%% update ghosts
% g1 update
ghosts(1).pixel.x = T_i.g1pX;
ghosts(1).pixel.y = T_i.g1pY;
ghosts(1).tile.x = T_i.ghost1(1);
ghosts(1).tile.y = T_i.ghost1(2);
ghosts(1).frames = T_i.g1Frame;
switch T_i.g1Dir
    case 'up'
        ghosts(1).dirEnum = 0;
    case 'left'
        ghosts(1).dirEnum = 1;
    case 'down'
        ghosts(1).dirEnum = 2;
    case 'right'
        ghosts(1).dirEnum = 3;
end
ghosts(1).scared = T_i.g1Scared;
ghosts(1).mode = T_i.g1ModeR;
% g2 update
ghosts(2).pixel.x = T_i.g2pX;
ghosts(2).pixel.y = T_i.g2pY;
ghosts(2).tile.x = T_i.ghost2(1);
ghosts(2).tile.y = T_i.ghost2(2);
ghosts(2).frames = T_i.g2Frame;
switch T_i.g2Dir
    case 'up'
        ghosts(2).dirEnum = 0;
    case 'left'
        ghosts(2).dirEnum = 1;
    case 'down'
        ghosts(2).dirEnum = 2;
    case 'right'
        ghosts(2).dirEnum = 3;
end
ghosts(2).scared = T_i.g2Scared;
ghosts(2).mode = T_i.g2ModeR;

%% update pacman
pacMan.pixel.x = T_i.ppX;
pacMan.pixel.y = T_i.ppY;
pacMan.tile.x = T_i.pacMan(1);
pacMan.tile.y = T_i.pacMan(2);
switch T_i.pDir
    case 'up'
        pacMan.dirEnum = 0;
    case 'left'
        pacMan.dirEnum = 1;
    case 'down'
        pacMan.dirEnum = 2;
    case 'right'
        pacMan.dirEnum = 3;
    otherwise
        pacMan.dirEnum = -1;
end
pacMan.frames = T_i.pFrame;
up = 0;
down = 0;
right = 0;
left = 0;
switch T_i.JoyStick
    case 'up'
        up = 1;
    case 'down'
        down = 1;
    case 'left'
        left = 1;
    case 'right'
        right = 1;
end
end