function result = executeTrial
% returns
%   0 if all dots are cleared
%   1 if pacmac is dead
% global pixel tile dirEnum nextDirEnum...
%         keybleft keybright keybup keybdown

globalDefinitions;
global flipSecs rewd current_state
global idx runtime trans_data
global randomfig; % %% 0--UP  1--DOWN  2--UP&DOWN  %% only used in UpDownMap
global win lose NumOfUpDown;
global JSMoved JSCode JSup JSdown JSleft JSright;
JSMoved = 0;idx = 0;

global passtrial;  % pass current trial or not ---hy 20170328
passtrial=0;

global doesGhostEaten; doesGhostEaten = 0;

%% 
global NumOfError;

%%
%% figure zzw 20170105

% global up down left right
% plot_up = zeros(300,1);
% plot_down = zeros(300,1);
% plot_left = zeros(300,1);
% plot_right = zeros(300,1);
% F_dir = figure('units','normalized','position',[0.5 0.5 0.25 0.5],...
%     'name','Joystick direction');
% uistack(F_dir,'top');
% s_up = subplot(4,1,1);      hold on
% xlabel('up','FontSize',12,'FontWeight','bold');
% set(gca,'ytick',[0 1],'yticklabel',{'off','on'}, 'ylim',[-0.5 1.5]);
% s_down = subplot(4,1,2);    hold on
% xlabel('down','FontSize',12,'FontWeight','bold');
% set(gca,'ytick',[0 1],'yticklabel',{'off','on'}, 'ylim',[-0.5 1.5]);
% s_left = subplot(4,1,3);    hold on
% xlabel('left','FontSize',12,'FontWeight','bold');
% set(gca,'ytick',[0 1],'yticklabel',{'off','on'}, 'ylim',[-0.5 1.5]);
% s_right = subplot(4,1,4);   hold on
% xlabel('right','FontSize',12,'FontWeight','bold');
% set(gca,'ytick',[0 1],'yticklabel',{'off','on'}, 'ylim',[-0.5 1.5]);

%%
frame=0;
ghostReleaseUpdate(3); % new game  
escapeKey = KbName('ESCAPE');
key_pass = KbName('p');
[keyDown, secs, keyCode] = KbCheck;
iti=0;
itin=0;
reward_count = 0;

dead = 0;
timestep = 0;
while gameMap.totalDots>0 && (~keyDown || ~keyCode(escapeKey)) && (current_state~=3)
    % what is the '~keyDown' for? --lzq
    
    %%  give reward / modified by zzw 20161220
    
    reward_count = reward_count + rewd.numdot + rewd.numgoast + rewd.numeneg;
    reward_reset;
    if reward_count > 0
        setDO(4,1);
        reward_count = reward_count - 1;
    else
        setDO(4,0);
        reward_count = 0;
    end
    %%fprintf('reward_count=%f/s',reward_count);
    
    %%  save data / modified by zzw 20161018
    timestep = timestep + 1;
    datasaving(timestep);
    if timestep == 1;
        waitframes = round(flipSecs / flipInterval);
        StimulusOnsetTime = StimulusOnsetTime + (waitframes - 0.5) * flipInterval;
        OldStimulusOnsetTime = StimulusOnsetTime;
    end
    %%  plot direction/ modified by zzw 20170105
%     plot_up(1:end-1) = plot_up(2:end); plot_up(end) = up;
%     plot_down(1:end-1) = plot_down(2:end); plot_down(end) = down;
%     plot_left(1:end-1) = plot_left(2:end); plot_left(end) = left;
%     plot_right(1:end-1) = plot_right(2:end); plot_right(end) = right;
%     h_up = plot(s_up,plot_up);
%     h_down = plot(s_down,plot_down);
%     h_left = plot(s_left,plot_left);
%     h_right = plot(s_right,plot_right);
%     drawnow;
%         delete(h_up);
%         delete(h_down);
%         delete(h_left);
%         delete(h_right);
% % %     setDO(16,up);
% % %     setDO(10,down);
% % %     setDO(8,left);
% % %     setDO(12,right);
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
                    doesGhostEaten = 1;
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
                dead = 1;
                setDO(4,0);
                
                deadSound; 
                pause(9);
                break;
            end
            ghostReleaseUpdate(6);  % refresh
        end
        %% if pacman does not go directly to dots, lose+=1;
        %modified by hy 20170110
%         if JSMoved
%             switch randomfig
%                 case 0 % up condition
%                     if JSCode(JSdown)
%                         lose=lose+1;
%                         dead=1;
%                         idx=0;
%                         NumOfError=NumOfError+1;
%                         setDO(4,0);
%                         break;
%                     end;
%                 case 1 % down condition
%                     if JSCode(JSup)
%                         lose=lose+1;
%                         dead=1;
%                         idx=0;
%                         NumOfError=NumOfError+1;
%                         setDO(4,0);
%                         break;
%                     end;
%             end;
%         end;
        %%
        pacManUpdate;
        updateEnergizer;
        
        
        if idx>1800  % if pacman do not move over 1800 frames, pacman will die.
            dead=1;
            idx=0;
            setDO(4,0);
            runtime=runtime+1;
            break;
        end;
        
       if keyCode(key_pass)  %press key 'p' to pass current trial  ---hy 20170328
           passtrial=1;
           break;
       end;
       
            
    end
    
    %     if (pacMan.dir.x==0)&&(pacMan.dir.y==0)
    %         start_time = ((day(now)*24 + hour(now))*60+minute(now))*60+second(now);
    %     else
    %         end_time = ((day(now)*24 + hour(now))*60+minute(now))*60+second(now);
    %         start_time=end_time;
    %     end;
    
    
    if ~mod(frame,1)
        drawMap;
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
%         
%                 for i=CHERRY:MELON
%                     drawFruit(gameWindow, i, (i+1)*tileSize*2, 17*tileSize+5);
%                 end
        %% modified by zzw 20161018
        if timestep == 1;
            StimulusOnsetTime = Screen('Flip', gameWindow, StimulusOnsetTime);
        else
            StimulusOnsetTime = Screen('Flip', gameWindow);
        end
        %%% drawRefleshMarker;
        measureRefleshRate;
        
        % [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', gameWindow);
        %% calculate the reflash rate
        iti = iti +StimulusOnsetTime - OldStimulusOnsetTime;
        itin = itin +1;
        OldStimulusOnsetTime = StimulusOnsetTime;
        
    end
    
    %Screen('FrameRect',gameWindow,[1 1 1],windowRect);
    %Screen('FillRect', gameWindow, [1 1 1], [0 0 100 100]);
    %Screen('FillArc', gameWindow, [1 0 0], [0 0 100 100], -30, 90);
    
    
    %Screen('Flip', gameWindow);
    [keyDown, secs, keyCode] = KbCheck;
    [JSMoved, JSCode] = JSCheck;
    frame = frame+1;
    
end
%end_time = (((t(3)*24 + t(4))*60+t(5))*60+t(6))*60;
% close(F_dir);
% % fclose(trans_data);

if ~passtrial
    if dead==1
        % draw dying pacman
        for i = 1:30
            drawMap;
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
        %     if pacMan.dirEnum == 0
        %         pacMan.dirEnum = DIR_UP;
        %     end
        for angle = 330-mod(floor(pacMan.frames/4),2)*30:-10:0
            drawMap;
            drawPacmanSprite(gameWindow,pacMan.pixel.x,pacMan.pixel.y,pacMan.dirEnum, angle, pacMan.color);
            Screen('Flip', gameWindow);
        end
        for size = 1:tileSize*0.9
            drawMap;
            rect = [pacMan.pixel.x-size pacMan.pixel.y-size pacMan.pixel.x+size pacMan.pixel.y+size];
            if ~mod(size-1,3)
                Screen('FillOval', gameWindow, pacMan.color*0.5, rect);
            else
                Screen('FillOval', gameWindow, [0 0 0], rect);
            end
            Screen('Flip', gameWindow);
        end
        StimulusOnsetTime = Screen('Flip', gameWindow);
        result = 1;
    elseif gameMap.totalDots == 0
        
        result = 0; % success!
        StimulusOnsetTime = Screen('Flip', gameWindow);
        
    else
        result = -1; % ESC pressed, quit session
        Screen('Flip', gameWindow);
        wlmsg = msgbox(['          win = ',num2str(win),...
            '     lose = ',num2str(lose)]);
        set(wlmsg,'units','normalized','position',[0.7 0.45 0.08 0.05]);
    end
else
    result = 0; % success!
    StimulusOnsetTime = Screen('Flip', gameWindow);
end


    
fprintf('FPS=%f/s',itin/iti);





