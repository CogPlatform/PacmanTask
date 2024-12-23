function drawCenterPixelSq(window, color, px,py,w,rightGrout,downGrout,downRightGrout)
% draw square centered at the given pixel
    global scale;
    Screen('FillRect', window, color, [px-w/2 py-w/2 px+w/2 py+w/2]);

    % fill "floating point grout" gaps between tiles
    gap = scale;
    if (rightGrout) 
        Screen('FillRect', window, color, [px-w/2 py-w/2 px+w/2+gap py+w/2]);
    end
    if (downGrout) 
        Screen('FillRect', window, color, [px-w/2 py-w/2 px+w/2 py+w/2+gap]);
    end
    %%if (rightGrout && downGrout && downRightGrout) ctx.fillRect(px-w/2, py-w/2,w+gap,w+gap);
end