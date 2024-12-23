function  drawCenterTileSq(window, color, tx, ty, w, rightGrout, downGrout, downRightGrout)
%draw square centered at the given tile with optional "floating point grout" filling
    global midTile tileSize;
    
    drawCenterPixelSq(window, color, (tx-1)*tileSize+midTile.x, (ty-1)*tileSize+midTile.y, w, ...
            rightGrout, downGrout, downRightGrout);
end