function saveImage(imagePath, imageIndex)
global gameWindow
imageArray = Screen('GetImage', gameWindow);
imwrite(imageArray, sprintf('%s/%05d.jpg',imagePath, imageIndex))
end