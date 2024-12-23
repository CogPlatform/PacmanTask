function draw_el(T)
global gameWindow
if any(contains(T.Properties.VariableNames,"elX"))
    eye_x = T.elX;
    eye_y = T.elY;
    if eye_x <= 700 && eye_y<=900
        Screen('DrawDots',gameWindow,[eye_x,eye_y],25,255,[],1);
    end
end
end