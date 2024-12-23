function drawgrid
    global gameWindow  midTile tileSize ;
%     [xc,yc] = RectCenter(gameWindow);
    baseRect = [0 0 tileSize tileSize];
    Xpos = linspace(1,28,28)*tileSize-midTile.x+1;
    Ypos = linspace(1,36,36)*tileSize-midTile.y+1;

    num = 28*36;

    alre = nan(4,28*36);
    for i = 1:28
        for j = 1:36
        alre(:,i) = CenterRectOnPointd(baseRect,Xpos(i),Ypos(j));
        end
    end
    
    penWid = 2;
    Screen('FrameRect',gameWindow,[0.5,0.2,0.2],alre,penWid);
%     Screen('Flip',gameWindow); 
    


end
    
