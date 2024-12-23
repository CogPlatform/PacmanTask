map1 = GenerateRandomMap_V10(3,0.4,' ');
map2 = GenerateRandomMap_V10(3,0.4,' ');
map3 = GenerateRandomMap_V10(3,0.4,' ');
map4 = GenerateRandomMap_V10(3,0.4,' ');

currentDate = datestr(now, 'yyyy-mm-dd');
filename = ['/home/yanglab-lin/Downloads/Documents/code20170121/RandomMap/RandomMap-V10-' ...
    currentDate '.mat'];
save(filename, 'map1','map2','map3','map4');