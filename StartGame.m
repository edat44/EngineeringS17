function StartGame(handles)

%% Set up Game axes
%configureAxes(handles);

%% Create both players with correct difficulty and strategy
paddleData = {  Paddle(handles, handles.easy, handles.balanced, handles.rightOffset),...
                Paddle(handles, handles.easy, handles.balanced, handles.leftOffset)};
%% Create ball(s)
%balls = {(0, 0, 5)};

%% Start simulation
disp('Simulation beginning...');
terminated = false;
try
    handles.gameRunning = true;
    guidata(gcf, handles);
    while handles.runSimulationCheckbox.Value
        for i=1:length(paddleData)
            updateImage(paddleData{i});
        end
        drawnow();
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



