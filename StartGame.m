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
        tic;
        for i=1:length(paddleData)
            updateImage(paddleData{i});
        end
        timeElapsed = toc;
        if timeElapsed > handles.frameDelay
            fprintf('WARNING! TIME ELAPSED WAS GREATED THAN FRAME DELAY RATE:\n\ttime elapsed = %d\n\tframe delay = %d\n', timeElapsed, handles.frameDelay);
        end
        disp(handles.frameDelay-timeElapsed);
        pause(max(handles.frameDelay-timeElapsed, 0));
    end
catch
    terminated = true;
    disp('Simulation terminated abruptly');
end

if ~terminated
    handles.gameRunning = false;
    guidata(gcf, handles);
    disp('Simulation finished');
    
    
    %% Report game statistics

end



