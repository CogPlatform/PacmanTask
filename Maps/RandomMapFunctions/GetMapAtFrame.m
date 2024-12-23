%% Regenerate and visualize the map
function all_row = GetMapAtFrame(map_frame)
% Input: current state
% Output: a visualization of the map 


all_row = '';
for j = 1:36
    row1 = '';
    for i = (j*28-27):(j*28)
        if map_frame(i) == ' '
            row1 = strcat(row1,{' '});
        else
            row1 = strcat(row1,map_frame(i));
        end
    end
    all_row= char(all_row,char(row1));
    
end
all_row = all_row((2:37),:);
end

