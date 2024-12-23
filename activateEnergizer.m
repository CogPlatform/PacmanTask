function activateEnergizer
    global energizer ghosts GHOST_GOING_HOME GHOST_ENTERING_HOME ghostNumber

    energizer.active = 1;
    energizer.count = 0;
    energizer.points = 1;
    for i=1: ghostNumber %% ZWY original code: for i = 1:4
        ghosts(i).sigReverse = true;
        if (ghosts(i).mode ~= GHOST_GOING_HOME && ghosts(i).mode ~= GHOST_ENTERING_HOME)
            ghosts(i).scared = true;
            ghosts(i).targeting = 0;
        end
    end
end