function draw_text(file_name)
global gameWindow
Screen('TextSize', gameWindow, 40);
DrawFormattedText(gameWindow, sprintf('%s',file_name), 70,...
    50, [1 1 1]);
end