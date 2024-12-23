function Stop = drawTrialFromMAT(fileName, data, vedioWidth, vedioHeight)
%% init var
Stop = 0;
num_j = 1;
file_name = fileName;
%% creat vedio folder
fname = creatVF(file_name, "results/vedio/");
vedioName = sprintf('%s.mp4', fname);
%% main loop
for index = 1:length(data.time.vbl)
    %% key input to stop
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('p'))
        break;
    end
    if keyCode(KbName('escape'))
        Stop = 1;
        break;
    end
    %% update data
    [ghostNumber, up, down, left, right] = getFrameFromMAT(data, index);
    %% draw information
    drawMonkeyMove(up,right,down,left); % draw monkey move
    draw_text(file_name); % draw trial name
    %% draw one frame image and flip
    draw_frame(ghostNumber);
    %% save image
    saveImage(fname, num_j);
    num_j = num_j + 1;
end
%% create MP4
createMP4(fname, vedioName, vedioWidth, vedioHeight);
end