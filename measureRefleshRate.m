function measureRefleshRate(start)

global n fps_all
t = toc;
iti = t - start;
fps = 1/iti;
if isempty(n)
    n = 0;
    fps_all = 0;
end
% if rand()>0.95 % ;P  --by lzq
%     display(['real-time fps equals to ',num2str(fps)]);
% end
n = n + 1;
fps_all = fps_all + fps;
if ~mod(n,10) && n ~= 0
    fps = fps_all / 10;
    if fps < 54
        fprintf('real-time fps equals to %f\n', fps);
    end
    n = 0;
    fps_all = 0;
end

end