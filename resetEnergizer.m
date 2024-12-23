function resetEnergizer()
    global ghosts ghostNumber energizer;
    energizer.count = 0;
    energizer.active = 0;
    energizer.points = 1;
    energizer.pointsFramesLeft = 0;
    for i=1:ghostNumber
        ghosts(i).scared = false;
    end
end
