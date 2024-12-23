function is = isPacmanCollide
% handles collision between pac-man and ghosts
% returns true if collision happened
% when the pacman is killed // zzw 20161014
global pacMan ghosts energizer ghostNumber rewd
global tileSize
global GHOST_OUTSIDE GHOST_EATEN GHOST_LEAVING_HOME % ghostReward
is = 0;
for i = 1:ghostNumber
    g = ghosts(i);
    
    if g.scared
        if (g.tile.x == pacMan.tile.x && g.tile.y == pacMan.tile.y ...
                && (g.mode == GHOST_OUTSIDE || g.mode == GHOST_LEAVING_HOME))%fyh-add "|| g.mode == GHOST_LEAVING_HOME" for incage
            energizer.pointsFramesLeft = energizer.pointsDuration*20;
            rewd.numgoast = rewd.numgoast + rewd.maggoast;
            energizer.points = energizer.points*2;
            ghosts(i).scared = 0;
            ghosts(i).mode = GHOST_EATEN;
        end
    else
        if abs(g.pixel.x - pacMan.pixel.x) < tileSize ...
                && abs(g.pixel.y - pacMan.pixel.y) < tileSize ...
                && (g.mode == GHOST_OUTSIDE || g.mode == GHOST_LEAVING_HOME)%fyh-add "|| g.mode == GHOST_LEAVING_HOME" for incage
            is = 1;
        end
    end
end
end