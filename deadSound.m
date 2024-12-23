function deadSound
clear
% fs=4000;
% t=5;
% sound(wgn(fs*t,1,0),fs);


filepath = 'explode.mp3';
[y Fs] = audioread(filepath);
t = 3; %s and 0<t<=9;

% another way to play sound commetted by ljs
% a = audioplayer(y(1:t*round(length(y)/3),:), Fs, 16, 13);
% play(a);

sound(y(1:t*round(length(y)/3),:),Fs);