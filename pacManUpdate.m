function pacManUpdate

global pacMan tileSize gameMap rewd
global DIR_UP DIR_RIGHT DIR_DOWN DIR_LEFT;
global JSMoved JSCode JSup JSdown JSleft JSright;
global idx;

% request to advance one step, and increment count if step taken
pacMan.pixel.x = pacMan.pixel.x+pacMan.dir.x;
pacMan.pixel.y = pacMan.pixel.y+pacMan.dir.y;
if (pacMan.dir.x==0)&&(pacMan.dir.y==0)
    idx=idx+1;
else
    idx=0;
end

pacMan.tile.x = floor(pacMan.pixel.x / tileSize)+1;
pacMan.tile.y = floor(pacMan.pixel.y / tileSize)+1;
%detect if pacman is in the middle of a tile
pacMan.distToMid.x = (pacMan.tile.x-1)*tileSize+floor(tileSize/2) - pacMan.pixel.x;%origin tileSize=25,*25+12
pacMan.distToMid.y = (pacMan.tile.y-1)*tileSize+floor(tileSize/2) - pacMan.pixel.y;
pacMan.frames = pacMan.frames + 1;

t = getTile(pacMan.tile.x,pacMan.tile.y);
if (t == '.' || t == 'o' || t == 'C' || t == 'S' || t == 'O' || t == 'A' || t == 'M')
    ind = posToIndex(pacMan.tile.x,pacMan.tile.y);
    gameMap.currentTiles(ind)=' ';
    
    % apply eating drag (unless in turbo mode)
    if (t=='.')
        gameMap.totalDots = gameMap.totalDots - 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numdot = rewd.numdot + rewd.magdot;
    elseif (t=='o')
        activateEnergizer;
        rewd.numeneg = rewd.numeneg + rewd.mageneg;
    elseif (t == 'C')
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magcherry;
    elseif (t == 'S')
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magstrawberry;
    elseif (t == 'O')
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magorange;
    elseif (t == 'A')
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magapple;
    elseif (t == 'M')
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magmelon;   
    end
end   

if (gameMap.tunnelRows(pacMan.tile.y).leftExit~=-1 && ...
        pacMan.pixel.x < (gameMap.tunnelRows(pacMan.tile.y).leftExit+1)*tileSize)
    pacMan.pixel.x = gameMap.tunnelRows(pacMan.tile.y).rightExit*tileSize-1;
end

if (gameMap.tunnelRows(pacMan.tile.y).rightExit~=-1 && ...
        pacMan.pixel.x > gameMap.tunnelRows(pacMan.tile.y).rightExit*tileSize-1)
    pacMan.pixel.x = (gameMap.tunnelRows(pacMan.tile.y).leftExit+1)*tileSize;
end

if (pacMan.distToMid.x == 0 && pacMan.distToMid.y == 0)
    if pacMan.nextDirEnum>=0
        turn = 0;
        switch pacMan.nextDirEnum
            case DIR_UP
                if isFloorTile(pacMan.tile.x, pacMan.tile.y-1)
                    pacMan.dirEnum = pacMan.nextDirEnum;
                    turn = 1;
                end
            case DIR_LEFT
                if isFloorTile(pacMan.tile.x-1, pacMan.tile.y)
                    pacMan.dirEnum = pacMan.nextDirEnum;
                    turn = 1;
                end
            case DIR_DOWN
                if isFloorTile(pacMan.tile.x, pacMan.tile.y+1)
                    pacMan.dirEnum = pacMan.nextDirEnum;
                    turn = 1;
                end
            case DIR_RIGHT
                if isFloorTile(pacMan.tile.x+1, pacMan.tile.y)
                    pacMan.dirEnum = pacMan.nextDirEnum;
                    turn = 1;
                end
        end
        if turn
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
    end
    switch pacMan.dirEnum
        case DIR_UP
            if ~isFloorTile(pacMan.tile.x, pacMan.tile.y-1)
                pacMan.dirEnum = -1;
            end
        case DIR_LEFT
            if ~isFloorTile(pacMan.tile.x-1, pacMan.tile.y)
                pacMan.dirEnum = -1;
            end
        case DIR_DOWN
            if ~isFloorTile(pacMan.tile.x, pacMan.tile.y+1)
                pacMan.dirEnum = -1;
            end
        case DIR_RIGHT
            if ~isFloorTile(pacMan.tile.x+1, pacMan.tile.y)
                pacMan.dirEnum = -1;
            end
    end
    pacMan.dir = setDirFromEnum(pacMan.dirEnum);  
end

%only when the pacman is in the mid of a tile(pacMan.distToMid.x/y=0)...
%...pacman can turn
%if it just move horizontally or vertically it can change dir anytime
if JSMoved
    if JSCode(JSleft)
        pacMan.nextDirEnum = DIR_LEFT;
        if (pacMan.dirEnum == DIR_RIGHT && isFloorTile(pacMan.tile.x-1, pacMan.tile.y)) || ...
                pacMan.distToMid.y == 0 && isFloorTile(pacMan.tile.x-1, pacMan.tile.y)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
    elseif JSCode(JSup)
        pacMan.nextDirEnum = DIR_UP;
        if (pacMan.dirEnum == DIR_DOWN && isFloorTile(pacMan.tile.x, pacMan.tile.y-1)) || ...
                pacMan.distToMid.x==0 && isFloorTile(pacMan.tile.x, pacMan.tile.y-1)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
    elseif JSCode(JSright)
        pacMan.nextDirEnum = DIR_RIGHT;
        if (pacMan.dirEnum == DIR_LEFT && isFloorTile(pacMan.tile.x+1, pacMan.tile.y)) || ...
                pacMan.distToMid.y==0 && isFloorTile(pacMan.tile.x+1, pacMan.tile.y)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
    elseif JSCode(JSdown)
         pacMan.nextDirEnum = DIR_DOWN;
        if (pacMan.dirEnum == DIR_UP && isFloorTile(pacMan.tile.x, pacMan.tile.y+1)) || ...
                pacMan.distToMid.x==0 && isFloorTile(pacMan.tile.x, pacMan.tile.y+1)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
    else
        return;
    end
end

end