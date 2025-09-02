% % compile c code with mex
% mex setDO.c u3.o -lm -llabjackusb
clearvars
clear -globalpp
clear PsychImaging
close all force
cleanup_sr
addpath("/home/cog5/Code/PacmanTask/Maps")
addpath(genpath("/home/cog5/diary"))%改成了我的电脑命名路径，需要改回来，ypz
addpath(genpath("/home/cog5/Code/PacmanTask/vedioCode/src/rawDrawCode/draw"))
sca;
% setDO(4,0)%Set the 4th digital output channel to low
% setDO(6,0)%Set the 6th digital output channel to low            


diary myDiaryFile %



global mapname datapath SubjectName Left;


audioread('explode.mp3');
inum = 1;

answer = input('the version is c(incage) or t(test)? ', 's');
switch answer
    case 'c'
        do = 1;
        SubjectName = 'incage';
        Left = 0;
    case 't'
        do = 1;
        SubjectName = 't';
        Left = input('Left hand? 0 or 1: ');
    otherwise
        do = 0;
end

answer = input('Monkey weight: ', 's');
if isempty(answer)
    answer = '0';
end
fprintf('Monkey weight: %skg\n', answer);

% leftversion = "GenerateRandomMap_V10(3,0.4)";
% rightversion = "GenerateRandomMap_V10(3,0.4)";

%modified by ypz (store the data in one .mat file)
if do
    fprintf('SubjectName = %s\n', SubjectName);
    
    % 确保 diary 目录存在
    current_path = fullfile(cd, 'diary');
    if ~exist(current_path, 'dir')
        mkdir(current_path);
    end
    
    % 查找下一个可用的文件名
    dataFileName = '';
    while true
        dataFileName = sprintf('%s-%s-%d.mat', SubjectName, date, inum);
        filePath = fullfile(current_path, dataFileName);
        
        if ~exist(filePath, 'file')
            break;
        end
        inum = inum + 1;
    end

    mapname = "GenerateRandomMap_1_oneWay_random";
    
    % 设置全局变量
    global allGamesData dailyDataFile
    dailyDataFile = filePath;  % 完整的文件路径
    allGamesData = struct();   % 初始化空结构体
    
    % 保存初始空文件
    save(dailyDataFile, 'allGamesData', '-v7.3');
    fprintf('Created new data file: %s\n', dailyDataFile);
    datapath = '/home/cog5/test.mat';
    main_20181216xy;
else
    error('please choose pacman version');
end




