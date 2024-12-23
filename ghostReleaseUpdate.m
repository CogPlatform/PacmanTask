function ghostReleaseUpdate(action)
%//////////////////////////////////////////////////////////////////////////////////////
% Ghost Releaser
% Determines when to release ghosts from home
%   available actions
%       1: save
%       2: load
%       3: reset for new levels
%       4: restart a level
%       5: dot eaten
%       6: refresh

    MODE_PERSONAL = 0;
    MODE_GLOBAL = 1;
    GHOST_PACING_HOME = 4;
    CLYDE = 2;
    global ghostActive ghosts ghostCounts ghostNumber mode; 
    global framesSinceLastDot globalCount;
    
    % this is how many frames it will take to release a ghost after pacman stops eating
    timeoutLimit = 240;

    % dot limits used in personal mode to release ghost after # of dots have been eaten
    personalDotLimit = [0 0 30 60];
    
    % dot limits used in global mode to release ghost after # of dots have been eaten
%     globalDotLimit = [0 7 17 32];
    
    
%     var savedGlobalCount = {};
%     var savedFramesSinceLastDot = {};
%     var savedGhostCounts = {};

    switch action
        case 1     % save state at time t
%             savedFramesSinceLastDot(t) = framesSinceLastDot;
%             if (mode == MODE_GLOBAL) {
%                 savedGlobalCount[t] = globalCount;
%             elseif (mode == MODE_PERSONAL) {
%                 savedGhostCounts[t] = {};
%                 savedGhostCounts[t][PINKY] = ghostCounts[PINKY];
%                 savedGhostCounts[t][INKY] = ghostCounts[INKY];
%                 savedGhostCounts[t][CLYDE] = ghostCounts[CLYDE];
%             end
        case 2    % load state at time t
%             framesSinceLastDot = savedFramesSinceLastDot[t];
%             if (mode == MODE_GLOBAL) {
%                 globalCount = savedGlobalCount[t];
%             }
%             else if (mode == MODE_PERSONAL) {
%                 ghostCounts[PINKY] = savedGhostCounts[t][PINKY];
%                 ghostCounts[INKY] = savedGhostCounts[t][INKY];
%                 ghostCounts[CLYDE] = savedGhostCounts[t][CLYDE];
%             }
        case 3 % onNewLevel
            mode = MODE_PERSONAL;
            framesSinceLastDot = 0;
            ghostCounts = [0 0 0 0];
        case 4 % onRestartLevel
            mode = MODE_GLOBAL;
            framesSinceLastDot = 0;
            globalCount = 0;
        case 5 % onDotEat
            framesSinceLastDot = 0;

            if (mode == MODE_GLOBAL) 
                globalCount = globalCount+1;
            else 
                for i=1:ghostNumber
                    if (ghosts(i).mode == GHOST_PACING_HOME) 
                        ghostCounts(i) = ghostCounts(i)+1;
                        break;
                    end
                end
            end

        case 6 % refresh
            
            % use personal dot counter
            if (mode == MODE_PERSONAL&&ghostActive)
                for i=1:ghostNumber
                    if (ghosts(i).mode == GHOST_PACING_HOME)
                        if (ghostCounts(i) >= personalDotLimit(i))
                            ghosts(i).sigLeaveHome = 1;
                            return;
                        end
                        break;
                    end
                end
            % use global dot counter
            elseif (mode == MODE_GLOBAL) 
                for i=1:ghostNumber
                    if (ghosts(i).mode == GHOST_PACING_HOME)
                        if (ghostCounts(i) >= personalDotLimit(i))
                            ghosts(i).sigLeaveHome = 1;
                            if i== CLYDE
                                globalCount = 0;
                                mode = MODE_PERSONAL;
                            end
                            return;
                        end
                        break;
                    end
                end
            end

            % also use time since last dot was eaten
            if (framesSinceLastDot > timeoutLimit)
                framesSinceLastDot = 0;
                for i=2:ghostNumber
                    g = ghosts(i);
                    if (g.mode == GHOST_PACING_HOME)
                        ghosts(i).sigLeaveHome = 1;
                        break;
                    end
                end
            else
                framesSinceLastDot = framesSinceLastDot+1;
            end
    end
end
