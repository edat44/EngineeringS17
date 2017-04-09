function StartGame(handles)

%% Create both players with correct difficulty and strategy
rPaddle = createPaddle(handles.easy, handles.balanced, handles.rightPlayerOffset, 0, .2, 1);
lPaddle = createPaddle(handles.easy, handles.balanced, handles.leftPlayerOffset, 0, .2, 1);
pixel = imread('whitePixel.png');

paddleData = {rPaddle, lPaddle};
rImage = image('Cdata', pixel);
rImage.Parent = handles.gameplot;
rImage.XData = [rPaddle.position.x - rPaddle.width/2, rPaddle.position.x + rPaddle.width/2];
rImage.YData = [rPaddle.position.y - rPaddle.height/2, rPaddle.position.y + rPaddle.height/2];
drawnow();
%% Create ball(s)

%% Start simulation
while false

end

%% Report game statistics
