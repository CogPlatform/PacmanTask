%%
clearvars
% global action,ti;

KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
[keyDown, secs, keyCode] = KbCheck;
%%
%%17/1/3  by hy
time_pull=0.5;
time_deliverwater=0.2;
time_loose=0.5;

up=1;down=2;left=3;right=4;% b d c a

action=0;
lastaction=0;
%%
while ~keyDown
    [keyDown, secs, keyCode] = KbCheck;
    [a,b,c,d]=mex_u3test;
    
    if b>1.5
        action=up;
    elseif d>1.5
        action=down;
    elseif c>1.5
        action=left;
    elseif a>1.5
        action=right;
    else
        action=0;
        continue;
    end;
    if action>0&&(action~=2)&&(action~=1)
        setDO(4,1);
        pause(time_deliverwater);
        setDO(4,0);
        pause(0.5);
    end
%     t = clock;
%     t_start = (((t(3)*24 + t(4))*60+t(5))*60+t(6))*60;
%     %     ti=timer('Period',0.01,'TasksToExecute',50,'ExecutionMode','fixedRate','TimerFcn',{@Keeppull});
%     %     start(ti);
%     pause(0.01);
%     idx=1;
%     if idx
%         [a,b,c,d]=mex_u3test;
%         switch action
%             case 1
%                 if b<=1.5
%                     action=0;
%                     
%                 end;
%             case 2
%                 if d<=1.5
%                     action=0;
%                     
%                 end;
%             case 3
%                 if c<=1.5
%                     action=0;
%                     
%                 end;
%             case 4
%                 if a<=1.5
%                     action=0;
%                     
%                 end;
%         end
%         t = clock;
%         t_end = (((t(3)*24 + t(4))*60+t(5))*60+t(6))*60;
%         if (t_end-t_start>time_pull)||action==0
%             idx=0;
%         end
%         pause(0.01);
%     end
    
    %     if (a>=1.5||b>=1.5||c>=1.5||d>=1.5)
    %         setDO(4,1);
    %         pause(0.2);
    %         setDO(4,0);
    %         pause(0.5)
    %     end;
    
    
    %%%
    %%
end;
