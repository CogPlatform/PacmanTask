%% add path and init
addpath(genpath("src"))
init_var; % clear and init variables
init_create; % create vedio folder and diary
%% load csv data
load('data/model_data.mat');
global st B %#ok<NUSED>
st = spikeTrains;
T = data;
%% open window and init gameMap, ghosts, pacMan
init_csv;
vedioWidth = 800;
vedioHeight = 1170;
%% draw whole day
drawDayFromCSVM(T, vedioWidth, vedioHeight);
%% 
sca
rmpath(genpath("src"))
diary off