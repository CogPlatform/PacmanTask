function drawDayFromMAT(filePath, files, vedioWidth, vedioHeight)
for fileName = files'
    file_name = strcat(filePath, "/", fileName);
    load(file_name, "data");
    map = data.gameMap.currentTiles(:,1);
    %% draw
    init_gameVar;
    Stop = drawTrialFromMAT(fileName, data, vedioWidth, vedioHeight);
    if Stop
        break
    end
end
end