function drawDayFromCSV(T, vedioWidth, vedioHeight)
Trials = unique(T.DayTrial);
[Trials, ~] = orderFile(Trials, 1, 2);
num_j = 1;
for file_name = Trials'
    if num_j == 1
        %% creat vedio folder
        fname = creatVF(file_name, "results/vedio/");
        vedioName = sprintf('%s.mp4', fname);
    end
    %% draw
    T_ = T(T.DayTrial == file_name,:);
    map = char(T_.Map(1)); %#ok<NASGU>
    init_gameVar;
    [Stop,num_j] = drawTrialFromCSV(T_, fname, num_j);
    if Stop
        break
    end
end
%% create MP4
createMP4(fname, vedioName, vedioWidth, vedioHeight);
end