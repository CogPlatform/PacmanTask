function createMP4(name, vedioName, vedioWidth, vedioHeight)
%% create mp4 file
if ~exist(vedioName,'file')
    [status,~] = unix(sprintf('ffmpeg -r 30 -f image2 -i %s/%%5d.jpg -vf pad=%d:%d:100:0:black %s\n', ...
        name, vedioWidth, vedioHeight, vedioName));
    if status
        fprintf('fail to create %s\n', vedioName)
        fprintf('********************\n')
    else
        fprintf('create %s successfully\n', vedioName)
        fprintf('====================\n')
    end
else
    fprintf('%s is already exist\n', vedioName)
    fprintf('********************\n')
end
end