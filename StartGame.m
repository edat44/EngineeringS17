function StartGame(handles)

%% Set up Game axes
%configureAxes(handles);

%% Create both players with correct difficulty and strategy
paddleData = {  Paddle(handles, handles.easy, handles.balanced, handles.leftOffset, -handles.scoreTextX),...
                Paddle(handles, handles.easy, handles.balanced, handles.rightOffset, handles.scoreTextX)};
            
leftPlayer = 1;
rightPlayer = 2;
%% Create ball(s)
balls = {Ball(handles)};

%% Start simulation
disp('Simulation beginning...');
terminated = false;
try
    handles.gameRunning = true;
    guidata(gcf, handles);
    while handles.runSimulationCheckbox.Value
        tic; %starts timer to check how long loop iteration takes
        %% Update Paddles
        for i=1:length(paddleData)
            paddleData{i}.UpdateScoreDisplay;
            UpdateImage(paddleData{i});
        end
        
        %% Update Balls
        for i=1:length(balls)
            UpdatePosition(balls{i});
            UpdateImage(balls{i});
        end
        %% Finish out loop
        timeElapsed = toc;
        if timeElapsed > handles.frameDelay
            fprintf(['WARNING! TIME ELAPSED WAS GREATED THAN FRAME DELAY RATE:\n\t',...
                'time elapsed = %d\n\t',...
                'frame delay = %d\n\t',...
                'left over time = %d\n'],...
                timeElapsed, handles.frameDelay, handles.frameDelay-timeElapsed);
        end
        
        pause(max(handles.frameDelay-timeElapsed, 0));
    end
catch ERR
    fprintf('ERROR: %s\n\t%s\n', ERR.identifier, ERR.message);
    terminated = true;
    disp('Simulation terminated abruptly');
end

for i=1:length(paddleData)
    delete(paddleData{i});
end
for i=1:length(balls)
    delete(balls{i});
end

if ~terminated
    handles.gameRunning = false;
    guidata(gcf, handles);
    disp('Simulation finished');
    
    
    %% Report game statistics

end



