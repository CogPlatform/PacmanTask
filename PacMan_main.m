% % compile c code with mex
% mex setDO.c u3.o -lm -llabjackusb
clearvars
clear -globalpp
clear PsychImaging
close all force
cleanup_sr
addpath("\PacMan\Incage\incage_code_Map\incage_code_Map\Maps")
addpath(genpath("\PacMan\Incage\incage_code_Map\incage_code_Map\diary"))
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

if do
    fprintf('SubjectName = %s\n', SubjectName);
    while exist(strcat(SubjectName, '-', date, '-', num2str(inum)),'dir')
        inum = inum+1;
    end

    current_path = [cd, '\diary\'];
    mapname = "GenerateRandomMap_1_T_random_dir";
    datapath = strcat(current_path,SubjectName, '-', date, '-', num2str(inum));
    mkdir(datapath)
    
    main_20181216xy;

else
    error('please choose pacman version');
end


