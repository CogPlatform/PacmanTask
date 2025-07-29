%% Main PacMan Run Script

% legacy code uses globals
global mapname datapath SubjectName Left mapPath diaryPath

%% Set up paths
rootPath = fileparts(mfilename("fullpath"));
mapPath = [rootPath filesep 'Maps'];
datapath = [getenv("HOME") filesep 'OptickaFiles' filesep 'SavedData'];
diaryPath = [datapth filesep 'log.text.log'];
if isempty(datapath) || ~exist(datapath,'dir')
	mkdir(datapath);
end

% % compile c code with mex
% mex setDO.c u3.o -lm -llabjackusb
clearvars
clear -globalpp
clear PsychImaging
close all force
cleanup_sr
addpath(mapPath)
sca;
% setDO(4,0)%Set the 4th digital output channel to low
% setDO(6,0)%Set the 6th digital output channel to low            

diary(diaryPath)

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

if do
    fprintf('SubjectName = %s\n', SubjectName);
    while exist(strcat(SubjectName, '-', date, '-', num2str(inum)),'dir')
        inum = inum+1;
    end

    current_path = "/home/cog5/OptickaFiles/diary";
    mapname = "GenerateRandomMap_V10";
    datapath = strcat(current_path,SubjectName, '-', date, '-', num2str(inum));
    mkdir(datapath)
    
    main_20181216xy;

else
    error('please choose pacman version');
end


