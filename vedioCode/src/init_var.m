%% initial variables and clearvars
% sca
clear -global
clear PsychImaging
close all force
clc
warning on
KbName('UnifyKeyNames')
% initial variables
globalDefinitions;
suc_num = 0;
Endreward = 0.16;
num_j = 1; % the number of images
time_cp = datetime('01-Mar-2019','InputFormat','dd-MMM-yyyy','Locale','en_US');
rewd.count = 0;
num = 1;
%% init keyboard
[keyDown, secs, keyCode] = KbCheck;