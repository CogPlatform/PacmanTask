map1 = GenerateRandomMap(2,0.6,' ');
map2 = GenerateRandomMap(2,0.6,' ');
map3 = GenerateRandomMap(2,0.6,' ');
map4 = GenerateRandomMap(2,0.6,' ');

currentDate = datestr(now, 'yyyy-mm-dd');
filename = ['/home/yanglab-lin/Downloads/Documents/code20170121/RandomMap/RandomMap-' ...
    currentDate '.mat'];
save(filename, 'map1','map2','map3','map4');