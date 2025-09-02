%dbstop if error
% % % close all force
% % % clearvars
% % % clearvars -global
KbName('UnifyKeyNames')
%mountLJFuse;
% % % cd /home/yanglab-lin/Downloads/pacman
init;  % initialize
global OldPriority data flipSecs flipInterval datapath SubjectName mapname;
global win runtime lose;
global NumOfTrials NumOfError NumOfSuccess randomfig;
global JSMoved
global EndReward;
global NumOfNormal NumOfScared NumOfNormalSuccess NumOfScaredSuccess;
global doesGhostWeek;
global doesGhostEaten;

win=0;runtime=0;lose=0;
NumOfTrials=0;NumOfError=0;NumOfSuccess=0;randomfig=0; 

NumOfNormal = 0; NumOfScared = 0; NumOfNormalSuccess = 0; NumOfScaredSuccess = 0;

global passtrial; % press key 'p' to pass current trial

flipSecs = flipInterval;
% pixel tile dirEnum nextDirEnum...
% keybleft keybright keybup keybdown
%% modified by zzw 20161015

result = 0;
current_round = 1;
used_trial = 1;

interval=0;
Interval=[]; % save interval between trails 
%%%%
while result >=0% quit session when result<0  azxa
    %% main part
    reward_reset;
    nMap =1;
    nMap = initTrial(mapname, result, nMap); % result: 0 re-initialize the map after all dots are cleared
    result = executeTrial;
    
    %% Exponential Distribution modified by hy
    IntervalOfTrails=0;
    while IntervalOfTrails<1||IntervalOfTrails>7
        IntervalOfTrails=exprnd(3);
    end
    
    %% modified by zzw 20161015
    %%%% modified by zzw 20161017. save the data for each trial
    %%%% modified by hy  20161129 add inter-trial interval in a expontial
    %%%% distribution
    
    if doesGhostEaten == 1
       NumOfScaredSuccess = NumOfScaredSuccess + 1;
    end

    switch result
        case 0 % success
            if ~passtrial
                win=win+1; 
                NumOfSuccess=NumOfSuccess+1;
                if doesGhostWeek == 0
                    NumOfNormalSuccess = NumOfNormalSuccess + 1;
                end

                for i=1:EndReward
                    setDO(4,1);            pause(0.08);% unit: second previous value 0.15, modified by SRX 20180723
                    setDO(4,0);            pause(0.37);
                end
            end
            %% Interval between trails modified by hy 2017/01/15
            Interval(current_round)=IntervalOfTrails;
            num=0;
            while num<20 % check JSMoved every (wait/20) second and pause (wait/20) 
                [JSMoved,JSCode] = JSCheck;
                if JSMoved
                    num=0;
                    Interval(current_round)=Interval(current_round)+IntervalOfTrails;
                end;
                pause(IntervalOfTrails/20);
                num=num+1;
            end
            
            %%
            flipSecs = 1; % the interval between rounds
            save(strcat(datapath,'/',num2str(current_round),'-', num2str(used_trial),'-',...
				SubjectName, '-', date,'.mat'),'data' ,'-v7.3');
			data = [];
            current_round = current_round + 1;
            used_trial = 1;% the interval between trials
        case 1 % dead
%             display('Loser!');
            lose = lose+1;
            NumOfError = NumOfError+1;
            %% Interval between trails modified by hy 2017/01/15
            Interval(current_round)=IntervalOfTrails;
            num=0;
            while num<20 % check JSMoved every (wait/20) second and pause (wait/20) 
                [JSMoved,JSCode] = JSCheck;
                if JSMoved
                    num=0;
                    %Interval(current_round)=Interval(current_round)+IntervalOfTrails;
                end;
                pause(IntervalOfTrails/20);
                num=num+1;
            end
            flipSecs = 5;
			save(strcat(datapath,'/',num2str(current_round),'-', num2str(used_trial),'-',...
				SubjectName, '-', date,'.mat'),'data' ,'-v7.3');

			data = [];
            used_trial = used_trial + 1;
        case -1
        save(strcat(datapath,'/',num2str(current_round),'-', num2str(used_trial),'-',...
             SubjectName, '-', date,'.mat'),'data' ,'-v7.3');

    end
    
end
show_online('Ending task')
% Clear the screen. "sca" is short hand for "Screen CloseAll". This clears
% all features related to PTB. Note: we leave the variables in the
% workspace so you can have a look at them if you want.
% For help see: help sca
sca;
Priority(OldPriority);