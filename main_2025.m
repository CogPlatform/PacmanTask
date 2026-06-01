function main_2025(opts)

globalDefinitions; % define global variables and constants
global data;
global passtrial; % press key 'p' to pass current trial
global block_num;block_num = 1;
global EndReward;%fyh-after trial give extra reward %modified again by HLK
if isempty(EndReward)
	EndReward=0;
end
cur_path = pwd;

fprintf("===>>> Running main_2025\n");

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  INIT SESSION
opts.status.updateStatusToRunning(); % tell cogmoteGO a task is started
opts = init_2025(opts);
allGamesData = struct();  % main task data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Priority(MaxPriority(gameWindow));
goKey = KbName('g');
[~, ~, keyCode] = KbCheck(-1);

if isfield(opts,'mapPath') && exist(opts.mapPath,'dir')
	fprintf("===>>> Adding map path: %s\n", opts.mapPath);
	addpath(opts.mapPath,'-begin');
	mapLocation = which(opts.mapName);
	fprintf("===>>> Map file found at: %s\n", mapLocation);
else
	error('Map path %s does not exist', opts.mapPath);
end

fprintf("\n===>>> Map version is %s\n", opts.mapName)

%% modified by zzw 20161015
result = 0;
reward_total = 0;
reward_trial = 0;
lazy = 0;
lazyTrial = 0;
used_trial = 1;%modified by ypz
total_trial = 1; %ypz
reward_round =0;

%% add code to initialize the current_round (by ypz)
%%current_round is a persistent value, can retain untill you enter "clear all"
% Use MATLAB's persistent variables (resets when MATLAB closes)
persistent stored_round;

if isempty(stored_round)
	stored_round = 1;
else
	stored_round = stored_round + 1;
end

current_round = stored_round;

%% print correct rate, ljs
% win=0; totalValid=0; totalAll=0;
% opts.beginDate = datestr(now,0);
% begin_time = opts.beginDate;
% opts.beginTime = GetSecs;
% opts.rewards = reward_total;

%modified by HLK
win=0; totalValid=0; totalAll=0;
begin_time = datetime("now");
opts.beginDate = begin_time;
opts.beginTime = begin_time;
opts.rewards = reward_round;
texture = NaN;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN LOOP
while result >=0  % quit session when result<0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%% main part
	t = sprintf('===>>>==============current_round-used_trial\n%d-%d', current_round, used_trial);
	addMessage(opts.tL, 0, [], [], t); disp(t); % log message and print to console
	
	%fyh-change another marker
	% Marker_reset % 20240107 lyw
	% Marker(current_round);
	% Marker(used_trial);
	% Marker_reset
	
	rewardSet;
	rewd.rewardWin = 0.1;
	rewd.rewardX = 1;
	
	endDots = 0;%trial end when no dots on the map
	initTrialDG(opts, result);
	
	if any(~isnan(texture)) && ~isempty(texture) && Screen(texture, 'WindowKind') == -1
		try Screen('Close',texture); end
	end
	texture = drawMap(opts);

	opts.startTime = datetime("now"); %HLK

	%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN TRIAL
	[result, reward_round, cal, opts] = executeTrial_2025(texture, endDots, opts);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	totalAll = totalAll + 1; 
	totalValid = totalValid + 1;
	
	reward_total = reward_total + reward_round;
	reward_trial = reward_trial + reward_round;
		
	switch result
		case 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% success
			block_num = block_num + 1;
			if ~passtrial
				reward_win = rewd.rewardWin * rewd.rewardX;
				t = sprintf('reward win is %.2f now -- EndReward win is %.2f now', reward_win, EndReward);
				addMessage(opts.tL, 0, [], [], t); disp(t);
				
				reward_total = reward_total + EndReward * (60 * reward_win);
				reward_trial = reward_trial + EndReward * (60 * reward_win);
				t= sprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total \nMonkey started at %s', ...
					reward_trial/60, reward_total/60, begin_time);
				addMessage(opts.tL, 0, [], [], t); disp(t);
				reward_trial = 0
				if EndReward>0 %modified by HLK
					%fyh-change to new water code
					for i=1:EndReward
						WaitSecs(reward_win);% wait for this drop of water end
						if opts.audio && opts.audioBeeps; opts.aM.beep(opts.correctBeep,0.1,opts.audioVolume); end
						opts.water.giveReward(opts.rewardTime);%hlk give reward after each success
						WaitSecs(0.37);
					end
				else
					WaitSecs(2);
				end
			else
				fprintf('Kep Pass\n')
				t= sprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total \nMonkey started at %s', ...
					reward_trial/60, reward_total/60, begin_time);
				addMessage(opts.tL, 0, [], [], t); disp(t);
				totalValid = totalValid - used_trial;
				reward_trial = 0;
			end
	
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
			t = sprintf('win = %d, lazy = %d, corr_rate = %f, all_valid = %d, all = %d, gameID = %s', ...
				win, lazy, win/(totalAll-lazy), totalValid, totalAll, gameID);
			addMessage(opts.tL, 0, [], [], t); disp(t);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz(store the data in every trial in struct)
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'lazyTrial', lazyTrial, ...
				'lazy', lazy, ...
				'reward_trial', reward_trial, ...
				'reward_total', reward_total, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			current_round = current_round + 1;
			used_trial = 1;
			total_trial = total_trial + 1;%ypz
			lazyTrial = 0;
		case 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dead
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'lazyTrial', lazyTrial, ...
				'lazy', lazy, ...
				'reward_trial', reward_trial, ...
				'reward_total', reward_total, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			used_trial = used_trial + 1;
			total_trial = total_trial + 1;%ypz
			
		case 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% lazy_dead
			lazy = lazy + 1;
			lazyTrial = lazyTrial + 1;
			fprintf('lazy = %d \n', lazyTrial);
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modifed by ypz
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'lazyTrial', lazyTrial, ...
				'lazy', lazy, ...
				'reward_trial', reward_trial, ...
				'reward_total', reward_total, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			used_trial = used_trial + 1;
			total_trial = total_trial + 1;%ypz
			if lazyTrial > 10 && ~mod(lazyTrial,10)
				fprintf('pause 2 minutes, pree G to continue %s\n', datestr(now));
				kb_time = 120 * 100;
				while kb_time ~= 0 && ~keyCode(goKey)
					WaitSecs(0.01)
					kb_time = kb_time - 1;
					[~, ~, keyCode] = KbCheck(-1);
				end
			end
			
		case -1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'lazyTrial', lazyTrial, ...
				'lazy', lazy, ...
				'reward_trial', reward_trial, ...
				'reward_total', reward_total, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			fprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total\n', ...
				reward_trial/60, reward_total/60)
	end

	
	%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAVE DATA ON EACH TRIAL
	save(opts.dataName, 'allGamesData', '-v7.3');
	fprintf('--->>> Trial %i Data saved to %s\n',used_trial,opts.dataName);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SEND TRIAL INFO to COGMOTEGO
	opts.trialN = used_trial;
	opts.loopN = current_round;
	opts.rewards = reward_total;
	opts.result = result;
	opts.phase = 1;
	opts.reactionTime = NaN;
	opts.correctRate = (current_round-1)/(total_trial-1); %ypz
	opts.correctRateRecent = NaN;
	% opts.endTime = GetSecs;
	opts.endTime = datetime("now"); %HLK
	opts.pertrialtime = seconds(opts.endTime - opts.startTime);
	broadcastTrial(opts, true);

	%% ================================== check if a command was sent from control system
	[opts, keepRunning] = clutil.checkMessages(opts);

	if ~keepRunning || used_trial > opts.totalRewards
		result = -1; % set result to -2 to end session
	end

	% %modified by HLK
	% opts.trialN = used_trial;
	% opts.loopN = current_round;
	% opts.rewards = reward_total;
	% opts.result = result;
	% opts.endTime= datestr(now,'HH:MM:SS');
	% opts.pertrialtime = datetime(opts.endTime, 'InputFormat', 'HH:mm:ss') - datetime(opts.startTime, 'InputFormat', 'HH:mm:ss');
	% broadcastTrial(opts, true);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FINAL BROADCAST
% opts.endTime = GetSecs;
opts.endTime = datestr(now,'HH:MM:SS');%modified by HLK
broadcastTrial(opts, false);
try opts.status.updateStatusToStopped(); end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FINAL DATA SAVE, include opts
save(opts.dataName, 'allGamesData', 'opts', '-v7.3');
fprintf('#####################\n≣≣≣≣ <strong>SAVED RAW DATA to: %s</strong>\n#####################\n', opts.dataName)

alyx = opts.alyx; zmq = opts.zmq; opts.alyx = []; opts.zmq = [];
tL = opts.tL; opts.tL = []; % remove tL from opts to avoid saving large data
opts.broadcast = [];
opts.status = [];
j = "[]"; % default empty json
try
	j = jsonencode(opts);
	writelines(j, opts.jsonName, WriteMode="overwrite");
	fprintf('#####################\n≣≣≣≣ <strong>SAVED JSON DATA to: %s</strong>\n#####################\n', opts.jsonName)
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% USE ALYX TO SAVE DATA
%  Send data to Alyx if enabled
if opts.useAlyx
	[opts.session, success] = clutil.initAlyxSession(alyx, opts.session);
	if success
		opts.session = clutil.endAlyxSession(alyx, opts.session, "PASS", opts.trialN, current_round, j);
	end
end

%
sca;
Priority(0); ShowCursor;

%% last print
fprintf('Monkey started at %s\n', opts.beginTime)
fprintf('win = %d, lazy = %d, corr_rate = %f, all_valid = %d, all = %d\n', ...
	win, lazy, win/totalValid, totalValid, totalAll);

cd(cur_path);
clear -global lj
clear -global lj_Alpha
diary off

end
