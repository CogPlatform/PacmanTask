function draw_frame(ghostNumber)
global gameWindow
%% draw everything
drawMap;
for i=1:ghostNumber
    drawGhostSprite(i);
end
drawPlayer;
% Fix Tunnel bug
gameScreenWidth = 700;
gameScreenHeight = 900;
Screen('FillRect', gameWindow, [0,0,0], ...
    [gameScreenWidth+1;gameScreenHeight/2-51; ...
    gameScreenWidth+52;gameScreenHeight/2+26]);
% flip
Screen('Flip', gameWindow, 0, 0, 1);
end