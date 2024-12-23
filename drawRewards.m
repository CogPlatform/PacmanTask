function drawRewards(fruit_pos)

global gameWindow gameMap midTile tileSize scale;

if ~isempty(fruit_pos)
    x = fruit_pos(1);
    y = fruit_pos(2);
    index = x+(y-1)*gameMap.numCols;
    tile = gameMap.currentTiles(index);
    if (tile == 'C' || tile  == 'S' || tile == 'O' || tile == 'A' || tile == 'M')
        drawFruit(gameWindow, tile, (x-1)*tileSize+midTile.x, (y-1)*tileSize+midTile.y);
    end
end
[dots,sizes,colors,n]=dotsProfiling(gameMap.numRows,gameMap.numCols,gameMap.currentTiles,...
    tileSize, midTile.x, midTile.y,gameMap.pelletSize,gameMap.energizerSize,scale);
if n>0
    Screen('DrawDots', gameWindow, dots(:,1:n), sizes(1:n), colors(:,1:n), [0 0], 1);
end

%     drawgrid
end