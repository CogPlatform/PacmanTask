function tilePixel = getTilePixel(pixel, tileSize)
    % returns the relative pixel inside a tile given a map pixel
    
    tilePixel.x = mod(pixel.x, tileSize);
    tilePixel.y = mod(pixel.y, tileSize);
    if (tilePixel.x < 0)
        tilePixel.x = tilePixel.x+tileSize;
    end
    if (tilePixel.y < 0)
        tilePixel.y = tilePixel.y+tileSize;
    end
end
