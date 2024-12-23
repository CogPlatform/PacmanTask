function drawMonkeyMove(JSCode)

global gameWindow;
global screenWidth gameScreenWidth gameScreenHeight gameScreenXOffset;

if isempty(JSCode)
    return
end

upKey = JSCode(1);
downKey = JSCode(2);
leftKey = JSCode(3);
rightKey = JSCode(4);

x = 75 + screenWidth - gameScreenXOffset;
y = gameScreenHeight /2;
size = 25 / 2;
uparrow = [0,0;0,-3*size;-size,-3*size;size,-5*size;3*size,-3*size;2*size,-3*size;2*size,0;0,0];
rightarrow = ([cos(pi/2), -sin(pi/2);sin(pi/2), cos(pi/2)] * uparrow')';
downarrow = ([cos(pi/2), -sin(pi/2);sin(pi/2), cos(pi/2)] * rightarrow')';
leftarrow = ([cos(pi/2), -sin(pi/2);sin(pi/2), cos(pi/2)] * downarrow')';
if upKey
    Screen('FillPoly', gameWindow, [1,1,1], uparrow(3:5,:) + [repmat(x,3,1),repmat(y,3,1)], 1);
    Screen('FillPoly', gameWindow, [1,1,1], uparrow([1,2,6,7],:) + [repmat(x,4,1),repmat(y,4,1)], 1);
end

if rightKey
    Screen('FillPoly', gameWindow, [1,1,1], rightarrow(3:5,:) + [repmat(x+2*size,3,1),repmat(y,3,1)], 1);
    Screen('FillPoly', gameWindow, [1,1,1], rightarrow([1,2,6,7],:) + [repmat(x+2*size,4,1),repmat(y,4,1)], 1);
end

if downKey
    Screen('FillPoly', gameWindow, [1,1,1], downarrow(3:5,:) + [repmat(x+2*size,3,1),repmat(y+2*size,3,1)], 1);
    Screen('FillPoly', gameWindow, [1,1,1], downarrow([1,2,6,7],:) + [repmat(x+2*size,4,1),repmat(y+2*size,4,1)], 1);
end

if leftKey
    Screen('FillPoly', gameWindow, [1,1,1], leftarrow(3:5,:) + [repmat(x,3,1),repmat(y+2*size,3,1)], 1);
    Screen('FillPoly', gameWindow, [1,1,1], leftarrow([1,2,6,7],:) + [repmat(x,4,1),repmat(y+2*size,4,1)], 1);
end

if ~upKey && ~downKey && ~leftKey && ~rightKey
    Screen('FramePoly', gameWindow, [1,1,1], uparrow + [repmat(x,8,1),repmat(y,8,1)], 2);
    Screen('FramePoly', gameWindow, [1,1,1], rightarrow + [repmat(x+2*size,8,1),repmat(y,8,1)], 2);
    Screen('FramePoly', gameWindow, [1,1,1], downarrow + [repmat(x+2*size,8,1),repmat(y+2*size,8,1)], 2);
    Screen('FramePoly', gameWindow, [1,1,1], leftarrow + [repmat(x,8,1),repmat(y+2*size,8,1)], 2);
end

end