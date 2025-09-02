function main_2025(opts)

global datapath rewd double_line current_round SubjectName;
global allGamesData % 声明全局变量存储所有游戏数据
allGamesData = struct();  % 初始化为空结构体

cur_path = cd;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INIT TRIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opts = init_2025(opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

goKey = KbName('g');
[~, ~, keyCode] = KbCheck;

global gameWindow
global OldPriority data SubjectName mapname;
global passtrial; % press key 'p' to pass current trial
global lj_Alpha; 
global block_num;block_num = 1;

fprintf("\n===>>> Map version is %s\n", opts.mapName)

%% modified by zzw 20161015
result = 0;
reward_total = 0;
reward_trial = 0;
EndReward = 0;
lazy = 0;
lazyTrial = 0;
used_trial = 0;


%% print correct rate, ljs
win=0; totalValid=0; totalAll=0;
begin_time = datestr(now,0);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while result >=0  % quit session when result<0  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%% main part
	fprintf('====================\n')
	fprintf('%d-%d\n', current_round, used_trial)
	
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
	
	image = drawMap;
	texture = Screen('MakeTexture', gameWindow, image);
	clear image
	

	%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN TRIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[result, reward_round, cal, opts] = executeTrial_2025(texture, endDots, opts);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	

	totalAll = totalAll + 1; 
	totalValid = totalValid + 1;
	
	reward_total = reward_total + reward_round;
	reward_trial = reward_trial + reward_round;
	
	switch result
		case 0 % success
			block_num = block_num + 1;
			if ~passtrial
				reward_win = rewd.rewardWin * rewd.rewardX;
				EndReward = 5;%fyh-after trial give extra reward
				fprintf('reward win is %.2f now\n', reward_win)
				fprintf('EndReward win is %.2f now\n', EndReward)
				
				reward_total = reward_total + EndReward * (60 * reward_win);
				reward_trial = reward_trial + EndReward * (60 * reward_win);
				fprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total\n', ...
					reward_trial/60, reward_total/60)
				fprintf('Monkey started at %s\n', begin_time)
				reward_trial = 0;
				
				%fyh-change to new water code
				for i=1:EndReward
					% MarkerWater('Water On')
					% setDO(4,1);
					pause(reward_win);% wait for this drop of water end
					% setDO(4,0);
					% MarkerWater('Water Off')
					pause(0.37);
				end
	
				
			else
				fprintf('Kep Pass\n')
				fprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total\n', ...
					reward_trial/60, reward_total/60)
				fprintf('Monkey started at %s\n', begin_time)
				totalValid = totalValid - used_trial;
				reward_trial = 0;
			end
	
			fprintf('win = %d, lazy = %d, corr_rate = %f, all_valid = %d, all = %d\n', ...
				win, lazy, win/(totalAll-lazy), totalValid, totalAll);
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz(store the data in every trial in struct)
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			save(opts.dataFile, 'allGamesData', '-v7.3');
			current_round = current_round + 1;
			used_trial = 1;
			lazyTrial = 0;
		case 1 % dead
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			save(opts.dataFile, 'allGamesData', '-v7.3');
			used_trial = used_trial + 1;
			
		case 2 % lazy_dead
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
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			save(opts.dataFile, 'allGamesData', '-v7.3');
			used_trial = used_trial + 1;
			if lazyTrial > 10 && ~mod(lazyTrial,10)
				fprintf('pause 2 minutes, pree G to continue %s\n', datestr(now));
				kb_time = 120 * 100;
				while kb_time ~= 0 && ~keyCode(goKey)
					pause(0.01)
					kb_time = kb_time - 1;
					[~, ~, keyCode] = KbCheck;
				end
			end
			
		case -1
			clearData;
			gameID = sprintf('game_%d_%d', current_round, used_trial);
		
			% 将当前游戏数据存储为结构体字段
			allGamesData.(gameID) = data;
			
			% 添加元数据（可选）modified by ypz
			allGamesData.([gameID '_info']) = struct(...
				'round', current_round, ...
				'trial', used_trial, ...
				'result', result, ...
				'timestamp', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
			save(opts.dataFile, 'allGamesData', '-v7.3');
			fprintf('Monkey drank %.2f seconds water this trial and %.2f seconds in total\n', ...
				reward_trial/60, reward_total/60)
	end
	
	
	%% handle used_trial > 99
	if used_trial == 100
		result = -2;
	end
save(opts.dataFile, 'allGamesData', '-v7.3');
end
 
%%
%fyh-delete eyelink file

%% how much water and fruit
if result == -2
	fprintf("monkey was lazy too many trials, end the experiment or restart the game.\n")
	fprintf("%s\n", datestr(now))
end
answer = input('How much water received: ', 's');
if isempty(answer)
	answer = '200';
end
fprintf('Monkey drinks %sml water in total\n', answer);
fprintf('%.2fml water per second\n', str2double(answer)/reward_total*60);
answer = input('How much fruit received: ', 's');
if isempty(answer)
	answer = '100';
end
fprintf('Monkey eats %sg fruit\n', answer);

%% fyh-delete:translate edf file to asc file

%%
cd(cur_path);
sca;
Priority(OldPriority);

%% last print
fprintf('Monkey started at %s\n', begin_time)
fprintf('win = %d, lazy = %d, corr_rate = %f, all_valid = %d, all = %d\n', ...
	win, lazy, win/totalValid, totalValid, totalAll);

cd(cur_path);
clear -global lj
clear -global lj_Alpha
diary off


% function Marker(number)
% global lj_Alpha
% lj_Alpha.setFIO(0,4)
% lj_Alpha.setFIO(0,5)
% lj_Alpha.setFIO(0,6)
% %% tens
% tens =  floor(number/10);
% bin2 = dec2bin(tens,4);
% low = 4 - find(bin2 == '0');
% high = 4 - find(bin2 == '1');
% for i = 1:length(low)
%     lj_Alpha.setFIO(0,low(i))
% end
% for j = 1:length(high)
%     lj_Alpha.setFIO(1,high(j))
% end
% lj_Alpha.setFIO(1,7)
% lj_Alpha.setFIO(0,7)
% %% unit
% num = mod(number,10);
% bin2 = dec2bin(num,4);
% low = 4 - find(bin2 == '0');
% high = 4 - find(bin2 == '1');
% for i = 1:length(low)
%     lj_Alpha.setFIO(0,low(i))
% end
% for j = 1:length(high)
%     lj_Alpha.setFIO(1,high(j))
% end
% lj_Alpha.setFIO(1,7)
% lj_Alpha.setFIO(0,7)
% 
% end

% function MarkerWater(type)
% global lj_Alpha
% switch type
%     case 'Water On'
%         lj_Alpha.setFIO(0,1)
%         lj_Alpha.setFIO(0,2)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,1)
%         lj_Alpha.setFIO(1,2)
%     case 'Water Off'
%         lj_Alpha.setFIO(0,1)
%         lj_Alpha.setFIO(0,3)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,1)
%         lj_Alpha.setFIO(1,3)
% end
% end
% 
% function Marker_reset
% global lj_Alpha
% lj_Alpha.setFIO(1,0)
% lj_Alpha.setFIO(1,1)
% lj_Alpha.setFIO(1,2)
% lj_Alpha.setFIO(1,3)
% lj_Alpha.setFIO(1,4)
% lj_Alpha.setFIO(1,5)
% lj_Alpha.setFIO(1,6)
% lj_Alpha.setFIO(0,7)
% end


% function ITI_Marker(type)
% global lj_Alpha
% switch type
% 
%     % for ITI -20231024 lyw
%        case 'ITI start'
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,6)
%         lj_Alpha.setFIO(0,5)
%         lj_Alpha.setFIO(0,4)
%         lj_Alpha.setFIO(0,3)
%         lj_Alpha.setFIO(0,2)
%         lj_Alpha.setFIO(1,1)
%         lj_Alpha.setFIO(0,0)
%         case 'ITI end'
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,6)
%         lj_Alpha.setFIO(0,5)
%         lj_Alpha.setFIO(0,4)
%         lj_Alpha.setFIO(0,3)
%         lj_Alpha.setFIO(0,2)
%         lj_Alpha.setFIO(1,1)
%         lj_Alpha.setFIO(1,0)
% 
% end
% end

end
