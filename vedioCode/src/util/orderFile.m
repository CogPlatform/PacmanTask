function [file_list, file_order] = orderFile(files, nStart, nEnd)
% order files by round and trial number in files name
% Arg:
%   files: files to sort
%   "1-1-omegaL-29-Jun-2020.mat"
%   nStart, nEnd: start and end index of number in files name
%   1,2
% Out:
%   file_list: sorted files
%   file_order: the order of sorted files

%% sort by round and trial
file_name = files;
char_i = split(file_name,{'-','.'},2);
char_num = str2double(char_i(:,nStart:nEnd));
char_trial = char_num(:,1) * 1000 + char_num(:,2);
[~, I] = sortrows(char_trial); % sort files by current_round and used_trial
file_list = file_name(I);
file_order = I;
end