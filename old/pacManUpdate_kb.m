function pacManUpdate_kb

global pacMan tileSize midTile gameMap rewd
% % global energizerReward pelletReward;
global DIR_UP DIR_RIGHT DIR_DOWN DIR_LEFT;
global keyDown keyCode upKey downKey leftKey rightKey up down left right;
global idx;
% skip frames if eating pellets
up = 0;
down = 0;
left = 0;
right = 0;

if (pacMan.eatPauseFramesLeft > 0)
    pacMan.eatPauseFramesLeft = pacMan.eatPauseFramesLeft - 1;
    return;
end
% lastpacmanpixel_x=pacMan.pixel.x;
% lastpacmanpixel_y=pacMan.pixel.y;

% request to advance one step, and increment count if step taken
pacMan.pixel.x = pacMan.pixel.x+pacMan.dir.x;
pacMan.pixel.y = pacMan.pixel.y+pacMan.dir.y;

% currentpacmanpixel_x=pacMan.pixel.x;
% currentpacmanpixel_y=pacMan.pixel.y;
% if (lastpacmanpixel_x==currentpacmanpixel_x)&&(lastpacmanpixel_y==currentpacmanpixel_y)
if (pacMan.dir.x==0)&&(pacMan.dir.y==0)
    idx=idx+1;
else
    idx=0;
end;

%fprintf('[%d,%d]',pacMan.pixel.x,pacMan.pixel.y);
% use gameMap-specific tunnel teleport
%     if (gameMap) {
%         gameMap.teleport(pacMan);
%     }

pacMan.tile.x = floor(pacMan.pixel.x / tileSize)+1;
pacMan.tile.y = floor(pacMan.pixel.y / tileSize)+1;
pacMan.tilePixel = getTilePixel(pacMan.pixel, tileSize);
pacMan.distToMid.x = midTile.x - pacMan.tilePixel.x;
pacMan.distToMid.y = midTile.y - pacMan.tilePixel.y;
pacMan.frames = pacMan.frames + 1;

%     ind = posToIndex(pacMan.tile.x,pacMan.tile.y);
%     t = gameMap.currentTiles(ind);
t = getTile(pacMan.tile.x,pacMan.tile.y);
if (t == '.' || t == 'o' || t == 'C' || t == 'S' || t == 'O' || t == 'A' || t == 'M')
    ind = posToIndex(pacMan.tile.x,pacMan.tile.y);
    gameMap.currentTiles(ind)=' ';
    
    % apply eating drag (unless in turbo mode)
    if (t=='.')
       % gameMap.currentTiles(ind)=' ';
        gameMap.totalDots = gameMap.totalDots - 1;
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
% %         deliverReward(pelletReward);
        rewd.numdot = rewd.numdot + rewd.magdot;
        % do fruits
    elseif (t=='o')
        pacMan.eatPauseFramesLeft = 3;
        activateEnergizer;
        rewd.numeneg = rewd.numeneg + rewd.mageneg;
% %         deliverReward(energizerReward);
    elseif (t == 'C')
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magcherry;
% %         deliverReward(fruitReward(1));
    elseif (t == 'S')
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magstrawberry;
    elseif (t == 'O')
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magorange;
    elseif (t == 'A')
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magapple;
    elseif (t == 'M')
        pacMan.eatPauseFramesLeft = 1;
        ghostReleaseUpdate(5); %onDotEat
        rewd.numeneg = rewd.numeneg + rewd.magmelon;   
    end
end  


if (gameMap.tunnelRows(pacMan.tile.y).leftExit~=-1 && ...
        pacMan.pixel.x < (gameMap.tunnelRows(pacMan.tile.y).leftExit+1)*tileSize)
    pacMan.pixel.x = gameMap.tunnelRows(pacMan.tile.y).rightExit*tileSize;
end

if (gameMap.tunnelRows(pacMan.tile.y).rightExit~=-1 && ...
        pacMan.pixel.x > gameMap.tunnelRows(pacMan.tile.y).rightExit*tileSize)
    pacMan.pixel.x = (gameMap.tunnelRows(pacMan.tile.y).leftExit+1)*tileSize;
end


%     if (gameMap.currentTiles(ind)=='.')
%         gameMap.currentTiles(ind)=' ';
%         gameMap.totalDots = gameMap.totalDots - 1;
%     elseif (gameMap.currentTiles(ind)=='o')
%         for i=1:4
%             ghosts(i).scared = 1;
%         end
%     end

% update head direction
%[keyDown, secs, keyCode] = KbCheck;

if (pacMan.distToMid.x == 0 && pacMan.distToMid.y == 0)
    if pacMan.nextDirEnum>=0 %|| (pacMan.dirEnum<0 && pacMan.nextDirEnum>=0)
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

if keyDown
    if keyCode(leftKey)
%         close; fig=figure(1); set(fig,'Position',[1980,300,600,600])
%         delete(h); h=annotation('textarrow',[0.5,0.5],[0.25,0.5]);
        up = 0;
        down = 0;
        left = 1;
        right = 0;
        
        pacMan.nextDirEnum = DIR_LEFT;
        if pacMan.dirEnum == DIR_RIGHT && pacMan.tilePixel.x>midTile.x || ...
                pacMan.distToMid.y==0 && isFloorTile(pacMan.tile.x-1, pacMan.tile.y)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
        %             if pacMan.dirEnum ==  pacMan.distToMid.y==0 && (pacMan.tilePixel.x>midTile.x || ...
        %                     isFloorTile(pacMan.tile.x-1, pacMan.tile.y))
        %                 pacMan.dirEnum = pacMan.nextDirEnum;
        %                 pacMan.nextDirEnum = -1;
        %                 pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        %             end
    elseif keyCode(upKey)
%          close;
%          fig=figure(1);
%          set(fig,'Position',[1980,300,600,600])
%         delete(h);
%          h=annotation('textarrow',[0.5,0.5],[0.5,0.75]);
        up = 1;
        down = 0;
        left = 0;
        right = 0;
        
        pacMan.nextDirEnum = DIR_UP;
        if pacMan.dirEnum == DIR_DOWN && pacMan.tilePixel.y>midTile.y || ...
                pacMan.distToMid.x==0 && isFloorTile(pacMan.tile.x, pacMan.tile.y-1)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
        %             if pacMan.dirEnum == pacMan.distToMid.x==0 && (pacMan.tilePixel.y>midTile.y ||...
        %                  isFloorTile(pacMan.tile.x, pacMan.tile.y-1))
        %                 pacMan.dirEnum = pacMan.nextDirEnum;
        %                 pacMan.nextDirEnum = -1;
        %                 pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        %             end
    elseif keyCode(rightKey)
%         close;
%         fig=figure(1);
%         set(fig,'Position',[1980,300,600,600])
%         delete(h);
%         h=annotation('textarrow',[0.5,0.5],[0.75,0.5]);
        up = 0;
        down = 0;
        left = 0;
        right = 1;
        
        pacMan.nextDirEnum = DIR_RIGHT;
        if pacMan.dirEnum == DIR_LEFT && pacMan.tilePixel.x<midTile.x || ...
                pacMan.distToMid.y==0 && isFloorTile(pacMan.tile.x+1, pacMan.tile.y)...
                && isFloorTile(pacMan.tile.x, pacMan.tile.y)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
        %             if pacMan.dirEnum == pacMan.distToMid.y==0 && (pacMan.tilePixel.x<midTile.x || ...
        %                 isFloorTile(pacMan.tile.x+1, pacMan.tile.y))
        %                 pacMan.dirEnum = pacMan.nextDirEnum;
        %                 pacMan.nextDirEnum = -1;
        %                 pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        %             end
    elseif keyCode(downKey)
%          close;
%          fig=figure(1);
%          set(fig,'Position',[1980,300,600,600])
%        delete(h);
%          h=annotation('textarrow',[0.5,0.5],[0.5,0.25]);
        up = 0;
        down = 1;
        left = 0;
        right = 0;
        
        pacMan.nextDirEnum = DIR_DOWN;
        if pacMan.dirEnum == DIR_UP && pacMan.tilePixel.y<midTile.y || ...
                pacMan.distToMid.x==0 && isFloorTile(pacMan.tile.x, pacMan.tile.y+1)
            pacMan.dirEnum = pacMan.nextDirEnum;
            pacMan.nextDirEnum = -1;
            pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        end
        %             if pacMan.dirEnum == pacMan.distToMid.x==0 && (pacMan.tilePixel.y<midTile.y || ...
        %                 isFloorTile(pacMan.tile.x, pacMan.tile.y+1))
        %                 pacMan.dirEnum = pacMan.nextDirEnum;
        %                 pacMan.nextDirEnum = -1;
        %                 pacMan.dir = setDirFromEnum(pacMan.dirEnum);
        %             end
    else
        %%pacMan.nextDirEnum = -1;%%%%%20170110 hy
        return;
    end
end

%fprintf('{%d,%d,%d}\n', pacMan.tile.x, pacMan.tile.y, dirEnum);



end