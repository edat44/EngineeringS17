function StartGame(handles)

%% Set up Game axes

%% Create both players with correct difficulty and strategy
paddleData = {  createPaddle(handles.easy, handles.balanced, handles.rightPlayerOffset, 0, .2, 1),...
                createPaddle(handles.easy, handles.balanced, handles.leftPlayerOffset, 0, .2, 1)};
for i=1:length(paddleData)
    paddle = paddleData{i};
    paddle.image = image('CData', imread('whitePixel.png'));
    paddle.image.Parent = handles.gameplot;
    paddleData{i} = paddle;
end
%% Create ball(s)

%% Start simulation
disp('Simulation beginning...');

while handles.runSimulationCheckbox.Value
    for i=1:length(paddleData)
        paddle = paddleData{i};
        paddle.image.XData = [paddle.position.x - paddle.width/2, paddle.position.x + paddle.width/2];
        paddle.image.YData = [paddle.position.y - paddle.height/2, paddle.position.y + paddle.height/2];
        paddleData{i} = paddle;
    end
    pause(.001);
end
disp('Simulation terminated');

%% Report game statistics
