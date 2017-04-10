function StartGame(handles)

%% Set up Game axes
%configureAxes(handles);

%% Create both players with correct difficulty and strategy
paddleData = {  Paddle(handles, handles.easy, handles.balanced, handles.rightOffset),...
                Paddle(handles, handles.easy, handles.balanced, handles.leftOffset)};
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
            fprintf('WARNING! TIME ELAPSED WAS GREATED THAN FRAME DELAY RATE:\n\ttime elapsed = %d\n\tframe delay = %d\n', timeElapsed, handles.frameDelay);
        end
        disp(handles.frameDelay-timeElapsed);
        pause(max(handles.frameDelay-timeElapsed, 0));
    end
catch ERR
    fprintf('ERROR: %s\n\t%s\n', ERR.identifier, ERR.message);
    terminated = true;
    disp('Simulation terminated abruptly');
end

if ~terminated
    handles.gameRunning = false;
    guidata(gcf, handles);
    disp('Simulation finished');
    
    
    %% Report game statistics

end



