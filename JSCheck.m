function [JSMoved, JSCode, JSVoltage, bug] = JSCheck
global JSup JSdown JSleft JSright up down left right; % trans_data;
global bug; bug = 0;
% for joysticks with 4 channels, left hand version（fyh:?)
% [a,b,c,d]=mex_u3test;%fyh-%can't recognize mex_u3test

%fyh
[a,b,c,d]=deal(0);

JSVoltage = [a,b,c,d]; % left, down, right, up
%fyh-%
% down = c>2.45;   %FIO0 c
% up = a>2.45;  %FIO1 a
% left = b>2.45;     %FIO2 b
% right = d>2.45;   %FIO3 d

% fyh-----------------------------------
% test:keyboard control
ifdown = KbName('DownArrow');   
ifup = KbName('UpArrow');  
ifleft = KbName('LeftArrow');      
ifright = KbName('RightArrow'); 

[~, ~, keyCode] = KbCheck;

if keyCode(ifdown)
    down =1;
    up =0;
    left=0;
    right =0;
end
if keyCode(ifup)
    down =0;
    up =1;
    left =0;
    right =0;
end
if keyCode(ifleft)
    down =0;
    up =0;
    left =1;
    right =0;
end
if keyCode(ifright)
    down=0;
    up=0;
    left=0;
    right =1;
end
%fyh--------------------------------------

dirCode = sum([1,3,5,7].*[up,right,left,down]);
JSMoved = dirCode>0;
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

%fyh
% if left
%     Marker('Left')
% elseif up
%     Marker('Up')
% elseif right
%     Marker('Right')
% elseif down
%     Marker('Down')
% end

if dirCode == 4 || dirCode == 6 || dirCode > 7
    bug = 1;
end
end

% function Marker(dir)
% global lj_Alpha
% switch dir
%     case 'Up'
%         lj_Alpha.setFIO(0,0)
%         lj_Alpha.setFIO(0,1)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,0)
%         lj_Alpha.setFIO(1,1)
%     case 'Down'
%         lj_Alpha.setFIO(0,0)
%         lj_Alpha.setFIO(0,2)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,0)
%         lj_Alpha.setFIO(1,2)
%     case 'Left'
%         lj_Alpha.setFIO(0,0)
%         lj_Alpha.setFIO(0,3)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,0)
%         lj_Alpha.setFIO(1,3)
%     case 'Right'
%         lj_Alpha.setFIO(0,0)
%         lj_Alpha.setFIO(0,4)
%         lj_Alpha.setFIO(1,7)
%         lj_Alpha.setFIO(0,7)
%         lj_Alpha.setFIO(1,0)
%         lj_Alpha.setFIO(1,4)
% end
% end
