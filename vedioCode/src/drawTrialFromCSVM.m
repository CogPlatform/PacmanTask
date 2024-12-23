function [Stop,num_j] = drawTrialFromCSVM(T_trial, fname, num_j, spikeTrain)
global B
%% init var
Stop = 0;
file_name = unique(T_trial.DayTrial);
%% main loop
k = 0;
for index = 1:length(T_trial.Step)
    %% key input to stop
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('p'))
        break;
    end
    if keyCode(KbName('escape'))
        Stop = 1;
        break;
    end
    if keyCode(KbName('s'))
        answer = input('resume? ', 's');
        while answer ~= 's'
            answer = input('resume? ', 's');
        end
    end
    %% update data
    T_i = T_trial(index,:);
    [ghostNumber, up, down, left, right] = getFrameFromCSV(T_i);
%     if mod(index,25) == 1
    k = k + 1;
    if k > width(spikeTrain)
        continue
    end
    p_x = softmaxFun(spikeTrain(:,k), B);
    [~,I] = max(p_x);
    y = ["down", "left", "no go", "right", "up"];
    dir = y(I);
    switch(dir)
        case 'down'
            down_m = 1;
            left_m = 0;
            right_m = 0;
            up_m = 0;
        case 'left'
            down_m = 0;
            left_m = 1;
            right_m = 0;
            up_m = 0;
        case 'right'
            down_m = 0;
            left_m = 0;
            right_m = 1;
            up_m = 0;
        case 'up'
            down_m = 0;
            left_m = 0;
            right_m = 0;
            up_m = 1;
        case 'no go'
            down_m = 0;
            left_m = 0;
            right_m = 0;
            up_m = 0;
    end
%     end
    %% draw information
    draw_el(T_i); % draw eyelink point
    drawMonkeyMove(up,right,down,left); % draw monkey move
    drawModelMove(up_m,right_m,down_m,left_m); % draw model move
    draw_text(file_name); % draw trial name
    %% draw one frame image and flip
    draw_frame(ghostNumber);
    %% save image
    saveImage(fname, num_j);
    num_j = num_j + 1;
end
end