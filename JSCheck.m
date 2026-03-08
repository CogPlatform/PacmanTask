function [JSMoved, JSCode, JSVoltage, bug, keyCode] = JSCheck
global JSup JSdown JSleft JSright up down left right; % trans_data;
global bug;
persistent JS_last_direction JS_start_time JS_duration_threshold;
persistent ifdown ifup ifleft ifright;

bug = 0;

% Initialize duration tracking variables
if isempty(JS_last_direction)
	JS_last_direction = 0; % 0 means no direction
	JS_start_time = GetSecs; % record start time
	JS_duration_threshold = 0.15; % threshold in seconds, adjustable
end

[a,b,c,d]=deal(0);
JSVoltage = [a,b,c,d]; % left, down, right, up

if isempty(ifdown) || isempty(ifup) || isempty(ifleft) || isempty(ifright)
	ifdown = KbName('DownArrow');
	ifup = KbName('UpArrow');
	ifleft = KbName('LeftArrow');
	ifright = KbName('RightArrow');
end

% check keyboard state
[~, tNow, keyCode] = KbCheck(-1);

% Reset direction states
[left,down,right,up]=deal(0);

% Detect current key state
current_time = tNow;
current_direction = 0;

if keyCode(ifdown)
	current_direction = 1; % down
elseif keyCode(ifup)
	current_direction = 2; % up
elseif keyCode(ifleft)
	current_direction = 3; % left
elseif keyCode(ifright)
	current_direction = 4; % right
end

% Check direction and duration
if current_direction == 0
	% No direction detected, reset timer
	JS_last_direction = 0;
	JS_start_time = current_time;
elseif current_direction == JS_last_direction
	% Same direction, check duration
	if (current_time - JS_start_time) >= JS_duration_threshold
		% Duration reached threshold, set direction
		switch current_direction
			case 1 % down
				down = 1;
			case 2 % up
				up = 1;
			case 3 % left
				left = 1;
			case 4 % right
				right = 1;
		end
	end
	% Duration not reached threshold, do nothing
else
	% New direction detected, reset timer
	JS_last_direction = current_direction;
	JS_start_time = current_time;
end
%fyh--------------------------------------

dirCode = sum([1,3,5,7] .* [up,right,left,down]);
JSMoved = dirCode > 0;
JSCode = zeros(1,4);

if up
	JSCode(JSup) = 1;
end
if right
	JSCode(JSright) = 1;
end
if left
	JSCode(JSleft) = 1;
end
if down
	JSCode(JSdown) = 1;
end

% Bug detection
if dirCode == 4 || dirCode == 6 || dirCode > 7
	bug = 1;
end
end
