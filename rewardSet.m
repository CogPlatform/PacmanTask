function rewardSet
global rewd current_round;


rewd.numdot = 0;
rewd.numgoast = 0;
rewd.numeneg = 0;
rewd.magdot = 3; % frames the reward would last for
rewd.mageneg = 4;
if current_round>32
rewd.magdot = 6; 
rewd.mageneg = 7; 
end

rewd.maggoast = 18;
 %ZWY original code: rewd.mageneg = 50;
%% ============ fruit ============
rewd.magcherry = 10;
rewd.magstrawberry = 10;
rewd.magorange = 16;
rewd.magapple = 24;
rewd.magmelon = 34;
end
