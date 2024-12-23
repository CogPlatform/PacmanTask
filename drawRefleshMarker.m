function drawRefleshMarker
global markerState gameWindow0 screenWidth screenHeight;
if isempty(markerState)
    markerState = 1;
else 
    markerState = ~markerState*1;
end
markColor = [markerState,markerState,markerState];
xmark = screenWidth-30;
ymark = screenHeight-30;
marksize = [0,0,60,60];
centeredRect = CenterRectOnPointd(marksize,xmark,ymark);

Screen('FillRect',gameWindow0,markColor,centeredRect);
Screen('Flip',gameWindow0);