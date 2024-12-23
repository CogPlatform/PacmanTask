function tile = getTargetTile(ghost, pacman)
    global ghosts;
    global BLINKY PINKY INKY CLYDE DIR_UP;
    switch ghost
        case BLINKY 
            tile = pacman.tile;              
        case PINKY
            % pinky targets four tiles ahead of pacman
            tile.x = pacman.tile.x + 4*pacman.dir.x;
            tile.y = pacman.tile.y + 4*pacman.dir.y;
            if (pacman.dirEnum == DIR_UP)
                tile.x = tile.x - 4;
            end
        case INKY
            % inky targets twice the distance from blinky to two tiles ahead of pacman
            tile.x = pacman.tile.x + 2*pacman.dir.x;
            tile.y = pacman.tile.y + 2*pacman.dir.y;
            if (pacman.dirEnum == DIR_UP)
                tile.x = tile.x - 2;
            end
            tile.x = ghosts(BLINKY).tile.x + 2*(tile.x - ghosts(BLINKY).tile.x);
            tile.y = ghosts(BLINKY).tile.y + 2*(tile.y - ghosts(BLINKY).tile.y);
        case CLYDE
            % clyde targets pacman if >=8 tiles away, otherwise targets home
            
            dx = pacman.tile.x - (ghosts(ghost).tile.x + ghosts(ghost).dir.x);
            dy = pacman.tile.y - (ghosts(ghost).tile.y + ghosts(ghost).dir.y);
            dist = dx*dx+dy*dy;
            if (dist >= 64)
                tile = pacman.tile;
            else
                tile = ghosts(ghost).cornerTile;
                ghosts(ghost).targeting = 3;
            end
    end
end      