function updateEnergizer
    global energizer 
    if (energizer.active)
        if (energizer.count == energizer.duration)
            resetEnergizer();
        else
            energizer.count = energizer.count+1;
        end
    end
end