function Keeppull( obj, events)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   global action,t;
   [a,b,c,d]=mex_u3test;
   switch action
       case 1
           if b<=1.5
               action=0;
                stop(t);
           end;
       case 2
           if d<=1.5
               action=0;
                stop(t);
           end;
       case 3
           if c<=1.5
               action=0;
                stop(t);
           end;
       case 4
           if a<=1.5
               action=0;
               stop(t);
           end;
   end
end

