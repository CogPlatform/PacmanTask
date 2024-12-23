%% create vedio folder
% the path of vedio folder
datapath = "results/vedio/";
if ~exist(datapath,"dir")
    fprintf('create %s folder\n', datapath);
    mkdir(sprintf('%s', datapath));
end
%% create diary
cur_path = cd;
cd(datapath)
createDiary("myDiaryFile");
cd(cur_path);