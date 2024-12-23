t = pumpManager();  
waterkey = KbName('w'); 
lastOutputTime = GetSecs();
while true
    [~, ~, keyCode] = KbCheck;%KbCheck- check both press and release the button 

   
    if keyCode(waterkey) && ~keyPressed
        t.giveRewardDuration(5000);
        fprintf("waterOn\n"); 
        keyPressed = true;
    elseif ~keyCode(waterkey)
        keyPressed = false;
    end
   
    currentTime = GetSecs();
    if currentTime - lastOutputTime >= 1
        formattedTime = datetime('now', 'Format', 'HH:mm:ss');
        fprintf("hello at %s (Elapsed Time: %.2f seconds)\n", char(formattedTime), currentTime);   
        lastOutputTime = currentTime; 
    end

    pause(0.01); 
end
