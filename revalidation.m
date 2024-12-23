function Result = revalidation(num_point, eye_used, el, current_round, used_trial)
global gameWindow;
if num_point == 6
    distance = 90;
    px = [350,350,350,45,655,350];
    py = [450,75,825,450,450,450];
    point = {'center', 'up', 'down', 'left', 'right', 'center'};
    point_order = randperm(4) + 1;
    px(2:5) = px(point_order);
    py(2:5) = py(point_order);
    point(2:5) = point(point_order);
    Eyelink('message','Recheck validation 6 points');
elseif num_point == 10
    distance = 50;
    px = [350,350,655,45,45,655,350,45,655,350];
    py = [450,75,75,75,825,825,825,450,450,450];
    point = {'center', 'up', 'upright', 'upleft', 'downleft', 'downright', 'down', 'left', 'right', 'center'};
    point_order = randperm(8) + 1;
    px(2:9) = px(point_order);
    py(2:9) = py(point_order);
    point(2:9) = point(point_order);
    Eyelink('message','Recheck validation 10 points');
elseif num_point == 1
    distance = 90;
    px = 350;
    py = 450;
    point = {'center'};
    Eyelink('message','Recheck validation 1 points');
end

success = 0;
j = [];
for i = 1:length(px)
    point_x = px(i);
    point_y = py(i);
    point_size = el.calibrationtargetsize*7;
    Screen('FillOval', gameWindow, el.calibrationtargetcolour, ...
        [point_x,point_y,point_x+point_size,point_y+point_size]);
    Screen('Flip', gameWindow, [], [], 1);
    if i == 1
        pause(1);
    end
    [result,Esc_] = check_eyepos(point_x, point_y, eye_used, el, distance);
    if Esc_
        Result = 2;
        return
    end
    if result == 1
        success = success + 1;
        Eyelink('message', sprintf('Pass point %s re-validation at %d-%d\n', ...
            char(point(i)), current_round, used_trial));
        fprintf('Pass at %d-%d %s\n', current_round, used_trial, char(point(i)))
        Screen('Flip', gameWindow, [], [], 1);
        setDO(4,1)
        pause(0.03)
        setDO(4,0)
    else
        j = [j,i]; %#ok<AGROW>
        Eyelink('message', sprintf('Fail point %s re-validation at %d-%d\n', ...
            char(point(i)), current_round, used_trial)');
        fprintf('Fail at %d-%d %s\n', current_round, used_trial, char(point(i)))
        Screen('Flip', gameWindow, [], [], 1);
    end
    pause(0.1)
    fprintf("-----\n")
end
if success == num_point
    Result = 1;
    return
end
pause(2)
%% Recheck
for i = j
    point_x = px(i);
    point_y = py(i);
    point_size = el.calibrationtargetsize*7;
    Screen('FillOval', gameWindow, el.calibrationtargetcolour, ...
        [point_x,point_y,point_x+point_size,point_y+point_size]);
    Screen('Flip', gameWindow, [], [], 1);
    [result,Esc_] = check_eyepos(point_x, point_y, eye_used, el, distance);
    if Esc_
        Result = 2;
        return
    end
    if result == 1
        success = success + 1;
        Eyelink('message', sprintf('Pass point %s re-check at %d-%d\n', ...
            char(point(i)), current_round, used_trial));
        fprintf('Pass at %d-%d %s re-check\n', current_round, used_trial, char(point(i)))
        Screen('Flip', gameWindow, [], [], 1);
        setDO(4,1)
        pause(0.03)
        setDO(4,0)
    else
        Eyelink('message', sprintf('Fail point %s re-check at %d-%d\n', ...
            char(point(i)), current_round, used_trial)');
        fprintf('Fail at %d-%d %s re-check\n', current_round, used_trial, char(point(i)))
        Screen('Flip', gameWindow, [], [], 1);
    end
    pause(0.1)
    fprintf("-----\n")
end

if success < num_point && num_point ~= 1
    Result = 0;
else
    Result = 1;
end
end

function [result,Esc_] = check_eyepos(point_x, point_y, eye_used, el, distance)
%% init parameters
fixateTime = GetSecs() + 3;
%
totalFixTime = 0;
escapeKey = KbName('ESCAPE');
x_all = [];
y_all = [];
Esc_ = 0;
while GetSecs < fixateTime
    [~, ~, keyCode] = KbCheck;
    if keyCode(escapeKey)
        result = 0;
        Esc_ = 1;
        Eyelink('message', sprintf('skip revalidation\n'))
        fprintf("***** skip revalidation *****\n")
        return
    end
    sth_wrong=Eyelink('CheckRecording');
    if(sth_wrong~=0)
        error('Error in Recording');
    end
    evtype = Eyelink('GetNextDataType');
    if evtype == el.FIXUPDATE
        if Eyelink('isconnected') == el.connected % if we're really measuring eye-movements
            Eyelink('message', sprintf('check point %d %d\n', point_x, point_y));
            evt = Eyelink('getfloatdata', evtype);% get data
            Eyelink('message', sprintf('eye position %.2f %.2f\n', evt.gavx, evt.gavy));
            % only process if its the desired eye
            if evt.eye == eye_used
                x = evt.gavx;
                y = evt.gavy;
                if isempty(x_all)
                    x_all = x;
                    y_all = y;
                else
                    if (x_all -x)^2 + (y_all-y)^2 > 100^2
                        x_all = x;
                        y_all = y;
                    else
                        x_all = (x_all + x)/2;
                        y_all = (y_all + y)/2;
                    end
                end
                if (x-point_x)^2 + (y-point_y)^2 <= distance^2
                    totalFixTime = totalFixTime + 50;
                    if totalFixTime >= 500
                        break;
                    end
                else % broke fixation reset time
                    totalFixTime = 0;
                end
            end
        else
            error('Eyelink disconnected!');
        end
    end
end

if totalFixTime >= 500
    result = 1;
    fprintf("eye dist is %.2f, Point is %d, %d\n", ...
        ((point_x-x_all)^2+(point_y-y_all)^2)^(1/2), point_x, point_y)
else
    result = 0;
    fprintf("eye dist is %.2f, Point is %d, %d\n", ...
        ((point_x-x_all)^2+(point_y-y_all)^2)^(1/2), point_x, point_y)
end
end