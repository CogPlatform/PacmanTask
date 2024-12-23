function image = drawMap

global gameWindow gameMap tileSize scale;

% ghost house door
%rectColor = [1 0.7216 0.8706]; %[255 184 222] / 255.0;
if gameMap.ghostHouseTile.x>=0
    Screen('FillRect', gameWindow, [1 0.7216 0.8706], [(gameMap.ghostHouseTile.x-1)*tileSize ...
        gameMap.ghostHouseTile.y*tileSize-2*scale (gameMap.ghostHouseTile.x+1)*tileSize ...
        gameMap.ghostHouseTile.y*tileSize]);
end


fillStyle = gameMap.wallFillColor;
strokeStyle = gameMap.wallStrokeColor;

for i=1:length(gameMap.walls)
    Screen('FillPoly', gameWindow, fillStyle, gameMap.walls{i}, 0);
    Screen('FramePoly', gameWindow, strokeStyle, gameMap.walls{i});
end
Screen('Flip', gameWindow);
image = Screen('GetImage', gameWindow);

end