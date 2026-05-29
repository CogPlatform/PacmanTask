function image = drawMap(opts)

	global gameMap tileSize scale;
	
	%[windowPtr,rect]=Screen('OpenOffscreenWindow',windowPtrOrScreenNumber 
	% [,color] [,rect] [,pixelSize] [,specialFlags] [,multiSample]);
	% we draw to an offscreen window
	mapWin = Screen('OpenOffscreenWindow', opts.screen, 0, [ 0 0 opts.mapWidth opts.mapHeight]);
	
	% ghost house door
	%rectColor = [1 0.7216 0.8706]; %[255 184 222] / 255.0;
	if gameMap.ghostHouseTile.x>=0
    	Screen('FillRect', mapWin, [1 0.7216 0.8706], [(gameMap.ghostHouseTile.x-1)*tileSize ...
        	gameMap.ghostHouseTile.y*tileSize-2*scale (gameMap.ghostHouseTile.x+1)*tileSize ...
        	gameMap.ghostHouseTile.y*tileSize]);
	end
	
	fillStyle = gameMap.wallFillColor;
	strokeStyle = gameMap.wallStrokeColor;
	
	for i=1:length(gameMap.walls)
    	Screen('FillPoly', mapWin, fillStyle, gameMap.walls{i}, 0);
    	Screen('FramePoly', mapWin, strokeStyle, gameMap.walls{i});
	end
	
	image = mapWin;

end