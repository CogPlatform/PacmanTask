%% add path and init
addpath(genpath("src"))
init_var; % clear and init variables
init_create; % create vedio folder and diary
%% load mat data
dataName = ""; % draw vedio from dataName in data folder
files = orderFile(dirFiles(strcat('data/',dataName),"mat"),1,2);
filePath = strcat('data/',dataName);
%% open window and init gameMap, ghosts, pacMan
init_csv;
vedioWidth = 800;
vedioHeight = 1170;
%% draw whole day
drawDayFromMAT(filePath, files, vedioWidth, vedioHeight);
%% 
sca
rmpath(genpath("src"))
diary off