function  rewardSetDouble
global rewd 

rewd.numdot = 0;
rewd.numgoast = 0;
rewd.numeneg = 0;
rewd.magdot = 4; % frames the reward would last for
rewd.maggoast = 8;
rewd.mageneg = 4; %ZWY original code: rewd.mageneg = 50;
%% ============ fruit ============
rewd.magcherry = 3;
rewd.magstrawberry = 5;
rewd.magorange = 8;
rewd.magapple = 12;
rewd.magmelon = 17;
end