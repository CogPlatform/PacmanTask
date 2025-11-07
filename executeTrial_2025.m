function [result, reward_round, cal, opts] = executeTrial_2025(texture, endDots, opts)
% returns
%   0 if all dots are cleared
%   1 if pacmac is dead
% global pixel tile dirEnum nextDirEnum...
%         keybleft keybright keybup keybdown
cal = 0;
globalDefinitions;
global deadline;
global data;
global rewd;
global idx;
% global randomfig; % %% 0--UP  1--DOWN  2--UP&DOWN  %% only used in UpDownMap
global JSMoved JSCode;
global fruit_pos;
% global GHOST_ENTERING_HOME;
% global GHOST_GOING_HOME;
%% kb version
% global keyDown keyCode upKey downKey leftKey rightKey;
%%

global up; up = 0;
global down; down= 0;
global left; left = 0;
global right; right = 0;
global bug; bug = 0;
global ch_block;
bugall = 0;
idx = 0;

global passtrial;  % pass current trial or not ---hy 20170328
passtrial=0;
% global time_all time;
global lj_Alpha;

%%
%fyh-incage pump
% global water;


%%
initData;
rt = 0;
frame=1;
ghostReleaseUpdate(3); % new game
escapeKey = KbName('ESCAPE');
pauseKey = KbName('s');
key_pass = KbName('p');
calKey = KbName('c');
%fyh
change_block = KbName('b');
% change_block = KbName('RightArrow');
% goKey = KbName('g');
[~, ~, keyCode] = KbCheck;
JoyStickCheck = 'JSCheck';
reward_count = 0;
reward_round = 0;
End_all = 0;
dead = 0;
timestep = 1;
frame_d = 0;
fps = 0;
CodeCost = 0;
JSCost = 0;
DSCost = 0;
rewardCost = 0;
drawCost = 0;
flipCost = 0;
ghostUpCost = 0;
pacManUpCost = 0;
Screen('DrawTexture', gameWindow, texture, [], [], [], 0);
drawRewards(fruit_pos);
if ghostNumber>0
    for i=1:ghostNumber
        drawGhostSprite(gameWindow, ghosts(i).pixel.x, ghosts(i).pixel.y, ...
            mod(floor(ghosts(i).frames/8),2), ghosts(i).dirEnum, ...
            ghosts(i).scared, isEnergizerFlash, ...
            ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME, ...
            ghosts(i).color);
    end
end
drawPlayer;
ifi = Screen('GetFlipInterval', gameWindow);
%fyh
% setDO(4,0);
% Marker('Water Off')
%% Flip the first frame
[JSMoved, JSCode, JSVoltage] = JSCheck;
[vbl,~,flip,miss] = Screen('Flip', gameWindow);
%fyh
% Eyelink('message','Trial Start');
% Marker('Trial Start');
datasaving(timestep,JSVoltage,reward_round,ifi,vbl,flip,miss,fps,CodeCost, ...
    JSCost,DSCost,rewardCost,drawCost,flipCost,ghostUpCost,pacManUpCost);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while gameMap.totalDots>0
    %%  give reward -fyh change to incage type
    rewardStart = GetSecs();
    reward_count = reward_count + rewd.numdot + rewd.numgoast + rewd.numeneg;
    reward_round = reward_round + rewd.numdot + rewd.numgoast + rewd.numeneg;
    reward_reset;
    if reward_count > 0
        % setDO(4,1);
        % Marker('Water On')
		if opts.audio && opts.audioBeeps; opts.aM.beep(opts.correctBeep,0.1,0.1); end
        opts.water.giveReward(100,0);
        reward_count = reward_count - 1;
    else
        % water.stopReward;
        % setDO(4,0);
        % Marker('Water Off')
    end
    rewardEnd = GetSecs();
    rewardCost = GetSecs() - rewardStart;
    %%
    skip = 0;
    if ghostNumber>0
        if energizer.pointsFramesLeft>0
            for i=1:ghostNumber
                if (ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME)
                    ghostUpdate(i);
                end
            end
            energizer.pointsFramesLeft = energizer.pointsFramesLeft-1;
            skip = 1;
            %             show_online('dead2')
            
        elseif ghostActive % make ghosts go home immediately after points disappear
            for i=1:ghostNumber
                if (ghosts(i).mode == GHOST_EATEN)
                    ghosts(i).mode = GHOST_GOING_HOME;
                    ghosts(i).targeting = 2;% 'door';
                end
            end
        end
    end
    
    if (~skip)
        if ghostNumber>0
            for i=1:ghostNumber
                ghostUpdate(i);
            end
            if isPacmanCollide()
                Screen('DrawTexture', gameWindow, texture, [], [], [], 0);
                drawRewards(fruit_pos);
                if ghostNumber>0
                    for i=1:ghostNumber
                        drawGhostSprite(gameWindow, ghosts(i).pixel.x, ghosts(i).pixel.y, ...
                            mod(floor(ghosts(i).frames/8),2), ghosts(i).dirEnum, ...
                            ghosts(i).scared, isEnergizerFlash, ...
                            ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME, ...
                            ghosts(i).color);
                    end
                end
                drawPlayer;
                [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
                if pacMan.pixel.x == 337 && pacMan.pixel.y == 662
                    % Eyelink('message','Pacman no move');
                    % Marker('Pacman no move');
                    rt = 1;
                else
                    % Eyelink('message','Pacman Dead');
                    % Marker('Pacman Dead');
                end
                
                % setDO(4,0);
                % Marker('Water Off')
                if opts.audio; opts.aM.play; end
                dead = 1;
                pause(opts.timeOut);
                break;
            end
            ghostReleaseUpdate(6);  % refresh
        end
        
        %%
        ghostUpCost = GetSecs() - rewardEnd;
        ghostUpEnd = GetSecs();
        pacManUpdate;
        pacManUpCost = GetSecs() - ghostUpEnd;
        updateEnergizer;
        if gameMap.totalDots == endDots
%           if ghosts(i).mode == GHOST_GOING_HOME
            Screen('DrawTexture', gameWindow, texture, [], [], [], 0);
            drawRewards(fruit_pos);
            if ghostNumber>0
                for i=1:ghostNumber
                    drawGhostSprite(gameWindow, ghosts(i).pixel.x, ghosts(i).pixel.y, ...
                        mod(floor(ghosts(i).frames/8),2), ghosts(i).dirEnum, ...
                        ghosts(i).scared, isEnergizerFlash, ...
                        ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME, ...
                        ghosts(i).color);
                end
            end
            drawPlayer;
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Finish trial');
            % Marker('Finish trial');
            break
        end
        
        
        if idx>deadline  % if pacman do not move over 900 frames, pacman will die.
            Screen('DrawTexture', gameWindow, texture, [], [], [], 0);
            drawRewards(fruit_pos);
            if ghostNumber>0
                for i=1:ghostNumber
                    drawGhostSprite(gameWindow, ghosts(i).pixel.x, ghosts(i).pixel.y, ...
                        mod(floor(ghosts(i).frames/8),2), ghosts(i).dirEnum, ...
                        ghosts(i).scared, isEnergizerFlash, ...
                        ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME, ...
                        ghosts(i).color);
                end
            end
            drawPlayer;
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Pacman no move');
            % Marker('Pacman no move');
            rt = 1;
            % setDO(4,0);
            % Marker('Water Off')
            deadSound;
            dead=1;
            idx=0;
            pause(5);
            break;
        end
        %% key operation
        % stop & resume operation
        if keyCode(pauseKey)%press key's' to resume
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Key Pause');
            % Marker('Key Pause');
            % setDO(4,0);
            % Marker('Water Off')
            answer = input('resume? ', 's');
            while answer ~= 's'
                answer = input('resume? ', 's');
            end
            dead = 1;
            break
        elseif keyCode(escapeKey)%esc
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Key pass');
            % Marker('Key pass');
            % setDO(4,0);
            % Marker('Water Off')
            break
        elseif keyCode(key_pass)  %press key 'p' to pass current trial  ---hy 20170328
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Key pass');
            % Marker('Key pass');
            % setDO(4,0);
            % Marker('Water Off')
            passtrial=1;
            break
        elseif keyCode(calKey)
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % Eyelink('message','Key Pause');
            % Marker('Key Pause');
            % setDO(4,0);
            % Marker('Water Off')
            dead = 1;
            cal = 1;
            break
        elseif keyCode(change_block)
            [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
            % setDO(4,0);
            ch_block = 1;
            passtrial=1;
            break
        end
    end
    %% draw everything
    drawStart = GetSecs();
    Screen('DrawTexture', gameWindow, texture, [], [], [], 0);
    drawRewards(fruit_pos);
    if ghostNumber>0
        for i=1:ghostNumber
            drawGhostSprite(gameWindow, ghosts(i).pixel.x, ghosts(i).pixel.y, ...
                mod(floor(ghosts(i).frames/8),2), ghosts(i).dirEnum, ...
                ghosts(i).scared, isEnergizerFlash, ...
                ghosts(i).mode == GHOST_GOING_HOME || ghosts(i).mode == GHOST_ENTERING_HOME, ...
                ghosts(i).color);
        end
    end
    drawPlayer;
    Screen('DrawingFinished', gameWindow);
    drawEnd = GetSecs();
    drawCost = drawEnd - drawStart;
    frame = frame + 1;
    timestep = timestep + 1;
    %% Flip
    VBL = GetSecs();
    [vbl,~,flip,miss] = Screen('Flip', gameWindow, vbl+(1-0.5)*ifi);
%     tmp = Screen('GetImage',gameWindow);
%     imwrite(tmp,'/home/pacman/Desktop/screenshot/test5.png')

    % Eyelink('message',sprintf('Frame: %d', timestep));%fyh-%
   
    % eyelink message must just after Screen('Flip')
    %fyh
    % if mod(timestep,2)
    %     lj_Alpha.toggleFIO(5)
    %     lj_Alpha.setFIO(1,7)
    %     lj_Alpha.setFIO(0,7)
    % else
    %     lj_Alpha.toggleFIO(6)
    %     lj_Alpha.setFIO(1,7)
    %     lj_Alpha.setFIO(0,7)
    % end
    
    %% print time cost and fps
    Flip = GetSecs();
    if frame ~= 2
        End_all = End_all + Flip - start;
        fps = 1/(Flip - start);
        CodeCost = VBL - start;
        DSCost = DataSave - JSCheckTime;
        JSCost = JSCheckTime - start;
        flipCost = Flip - VBL;
        if fps < 56 || fps > 64
            frame_d = frame_d + 1;
        end
    end
    start = GetSecs();
    %%
    [~, ~, keyCode] = KbCheck;
    [JSMoved, JSCode, JSVoltage, bug] = eval(JoyStickCheck);
    JSCheckTime = GetSecs();
    bugall = bug + bugall;
    %%  save data / modified by ljs 2019.11.01
    datasaving(timestep,JSVoltage,reward_round,ifi,vbl,flip,miss,fps,CodeCost, ...
        JSCost,DSCost,rewardCost,drawCost,flipCost,ghostUpCost,pacManUpCost);
    DataSave = GetSecs();
end


timestep = timestep + 1;
datasaving(timestep,JSVoltage,reward_round,ifi,vbl,flip,miss,fps,CodeCost, ...
    JSCost,DSCost,rewardCost,drawCost,flipCost,ghostUpCost,pacManUpCost);
fprintf('%d frames in total have miss or fps larger than 64\n', frame_d)
% if timestep >= 20000
%     error('should change preallocation of data in initData')
% end
if bugall
    fprintf('%d frames in total have two directions at the same time\n', bugall)
end


%%
if ~passtrial
    if dead==1
        % draw dying pacman
        for i = 1:30
            Screen('DrawTexture', gameWindow, texture);
            drawRewards(fruit_pos);
            drawPlayer;
            for j=1:ghostNumber
                ghosts(j).frames = ghosts(j).frames + 1;
                drawGhostSprite(gameWindow, ghosts(j).pixel.x, ghosts(j).pixel.y, ...
                    mod(floor(ghosts(j).frames/8),2), ghosts(j).dirEnum, ...
                    ghosts(j).scared, isEnergizerFlash, ...
                    ghosts(j).mode == GHOST_GOING_HOME || ghosts(j).mode == GHOST_ENTERING_HOME, ...
                    ghosts(j).color);
            end
            Screen('Flip', gameWindow);
        end
        
        for angle = 330-mod(floor(pacMan.frames/4),2)*30:-10:0
            Screen('DrawTexture', gameWindow, texture);
            drawRewards(fruit_pos);
            drawPacmanSprite(gameWindow,pacMan.pixel.x,pacMan.pixel.y,pacMan.dirEnum, angle, pacMan.color);
            Screen('Flip', gameWindow);
        end
        
        for size = 1:tileSize*0.9
            Screen('DrawTexture', gameWindow, texture);
            drawRewards(fruit_pos);
            rect = [pacMan.pixel.x-size pacMan.pixel.y-size pacMan.pixel.x+size pacMan.pixel.y+size];
            if ~mod(size-1,3)
                Screen('FillOval', gameWindow, pacMan.color*0.5, rect);
            else
                Screen('FillOval', gameWindow, [0 0 0], rect);
            end
            Screen('Flip', gameWindow);
        end
        pause(0.3);
        Screen('Flip', gameWindow);
        % Eyelink('message','Trial End');
        % Marker('Trial End');
        if rt
            result = 2;
        else
            result = 1;
        end
        
    elseif gameMap.totalDots == endDots
%     elseif ghosts(i).mode == GHOST_GOING_HOME
        result = 0; % success!
        Screen('Flip', gameWindow);
        % Eyelink('message','Trial End');
        % Marker('Trial End');

    else
        result = -1; % ESC pressed, quit session
        Screen('Flip', gameWindow);
        pause(1)
        % Eyelink('message','Trial End');
        % Marker('Trial End');
    end
else
    result = 0; % success!
    Screen('Flip', gameWindow);
    pause(1)
    % Eyelink('message','Trial End');
    % Marker('Trial End');
end

fprintf('FPS=%f/s \n', (frame-3)/End_all)
end
