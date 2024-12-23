function T = loadcsv(dataName)
T = readtable(dataName,'Delimiter',',','ReadVariableNames',true);
T.DayTrial = string(T.DayTrial);
T.Map = string(T.Map);
T.JoyStick = string(T.JoyStick);
T.pDir = string(T.pDir);
T.g1Dir = string(T.g1Dir);
T.g2Dir = string(T.g2Dir);
T.pacMan = [T.pacMan_1,T.pacMan_2];
T.ghost1 = [T.ghost1_1,T.ghost1_2,T.ghost1_3];
T.ghost2 = [T.ghost2_1,T.ghost2_2,T.ghost2_3];
end