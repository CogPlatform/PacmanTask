
function empty_map = GenerateRandomMap(n,dot_percentage,f)

%dot_percentage = 0.7;
no_dot_region =[];
empty_map =  [ ...
    '____________________________' ...
    '____________________________' ...
    '____________________________' ...
    '||||||||||||||||||||||||||||' ...
    '|            ||            |' ...
    '| |||| ||||| || ||||| |||| |' ...
    '| |||| ||||| || ||||| |||| |' ...
    '| |||| ||||| || ||||| |||| |' ...
    '|                          |' ...
    '| |||| || |||||||| || |||| |' ...
    '| |||| || |||||||| || |||| |' ...
    '|      ||    ||    ||      |' ...
    '|||||| ||||| || ||||| ||||||' ...
    '_____| ||||| || ||||| |_____' ...
    '_____| ||          || |_____' ...
    '_____| || |||--||| || |_____' ...
    '|||||| || |______| || ||||||' ...
    '          |______|          ' ...
    '|||||| || |______| || ||||||' ...
    '_____| || |||||||| || |_____' ...
    '_____| ||          || |_____' ...
    '_____| || |||||||| || |_____' ...
    '|||||| || |||||||| || ||||||' ...
    '|            ||            |' ...
    '| |||| ||||| || ||||| |||| |' ...
    '| |||| ||||| || ||||| |||| |' ...
    '| ||||                |||| |' ...
    '| |||| |||||||||||||| |||| |' ...
    '| |||| |||||||||||||| |||| |' ...
    '| |||| ||          || |||| |' ...
    '| |||| |||||||||||||| |||| |' ...
    '| |||| |||||||||||||| |||| |' ...
    '|                          |' ...
    '||||||||||||||||||||||||||||' ...
    '____________________________' ...
    '____________________________'];


load('map_v9_regions.mat');
% region2(53) = 511; %To avoid dot at pacman initial location
region2(region2 == 742) = 511;
number_of_dots_per_region = floor(dot_percentage * length(region1));


if n < 4

% Pick from region 1 and 3    
    x13 = rand(1,1);
    
    if x13 < 0.5
        dots13 = datasample(region1,number_of_dots_per_region);
        energizer13 = datasample(region1,1);
        no_dot_region13 = region3;
    else
        dots13 = datasample(region3,number_of_dots_per_region);
        energizer13 = datasample(region3,1);
        no_dot_region13 = region1;
    end
    
% Pick from region 2 and 4    
    x24 = rand(1,1);
    
    if x24 < 0.5
        dots24 = datasample(region2,number_of_dots_per_region);
        energizer24 = datasample(region2,1);
        no_dot_region = [no_dot_region13 region4];
    else
        dots24 = datasample(region4,number_of_dots_per_region);
        no_dot_region = [no_dot_region13 region2];
        energizer24 = datasample(region4,1);
    end
    
    dotsTunnel = datasample(tunnel,7);
    for i = 1:7
        empty_map(dotsTunnel(i)) = '.';
    end
    
    if  n ==2
        for i = 1:number_of_dots_per_region
            empty_map(dots13(i)) = '.';
            empty_map(dots24(i)) = '.';
        end
        
        empty_map(energizer13) = 'o';
        empty_map(energizer24) = 'o';
        fruit = datasample([dots13; dots24],1);
        empty_map(fruit) = f;
    elseif n == 3
        
 % add one more region
        more_region = rand(1,1);
        if more_region < 0.5
            dotsmore = datasample(no_dot_region(:,1),number_of_dots_per_region);
            energizermore = datasample(no_dot_region(:,1),1);
        else
            dotsmore = datasample(no_dot_region(:,2),number_of_dots_per_region);
            energizermore = datasample(no_dot_region(:,2),1);
        end
        
        for i = 1:number_of_dots_per_region
            empty_map(dots13(i)) = '.';
            empty_map(dots24(i)) = '.';
            empty_map(dotsmore(i)) = '.';
        end
        
        empty_map(energizermore) = 'o';
        empty_map(energizer13) = 'o';
        empty_map(energizer24) = 'o';
        fruit = datasample([dots13; dots24;dotsmore],1);
        empty_map(fruit) = f;
    end
    
    
    
    
    
    
else
    dots1 = datasample(region1,number_of_dots_per_region);
    dots2 = datasample(region2,number_of_dots_per_region);
    dots3 = datasample(region3,number_of_dots_per_region);
    dots4 = datasample(region4,number_of_dots_per_region);
    
    energizer1 = datasample(region1,1);
    energizer2 = datasample(region2,1);
    energizer3 = datasample(region3,1);
    energizer4 = datasample(region4,1);
    fruit = datasample([region1; region2; region3; region4],1);
    
    for i = 1:number_of_dots_per_region
        empty_map(dots1(i)) = '.';
        empty_map(dots2(i)) = '.';
        empty_map(dots3(i)) = '.';
        empty_map(dots4(i)) = '.';
    end
    empty_map(energizer1) = 'o';
    empty_map(energizer2) = 'o';
    empty_map(energizer3) = 'o';
    empty_map(energizer4) = 'o';
    empty_map(fruit) = f;
    
    dotsTunnel = datasample(tunnel,7);
    for i = 1:7
        empty_map(dotsTunnel(i)) = '.';
    end
    
end

end


 


    
    
    
    
    
    