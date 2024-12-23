function fname = creatVF(file_name, datapath)
%% vedio folder name
round_now = split(file_name, {'-','.'});
fname1 = sprintf('%s%s', datapath, join(round_now(3:7)','-'));
% fname2 = strcat(join(round_now(1:7)','-'));
% fname = sprintf('%s/%s', fname1, fname2);
fname = sprintf('%s', fname1);
if exist(fname,'dir')
    fprintf('%s folder already exists\n', fname);
else
    fprintf('create %s folder\n', fname);
    mkdir(fname);
end
% %% create folder for pictures with vedio file name
% vname = strcat(join(round_now','-'));
% name = sprintf('%s%s', datapath, vname);
% if exist(sprintf('%s', name),'dir')
%     fprintf('%s folder already exists\n', name);
% else
%     fprintf('create %s folder\n', name);
%     mkdir(name);
% end
end