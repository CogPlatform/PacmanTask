%% add path and init
addpath(genpath("src"))
init_var; % clear and init variables
init_create; % create vedio folder and diary
%% open window and init gameMap, ghosts, pacMan
init_csv;
vedioWidth = 800;
vedioHeight = 1170;
%% load data and draw map
load("/home/muscle/pacman/Code/vedioCode/data/Patamon-01-Jul-2021-1/1-1-Patamon-01-Jul-2021.mat","data");
map = data.gameMap.currentTiles(:,1);
init_gameVar;
drawMap;
Screen('Flip', gameWindow, 0, 0, 1);
rmpath(genpath("src"))