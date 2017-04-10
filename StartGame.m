function StartGame(handles)

%% Set up Game axes
%configureAxes(handles);

%% Create both players with correct difficulty and strategy
paddles = {  Paddle(handles, handles.easy, handles.balanced, handles.leftOffset, -handles.scoreTextX),...
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
        for iPaddle=1:length(paddles)
            %Update position
           
            %Update displays
            paddles{iPaddle}.UpdateScoreDisplay;
            paddles{iPaddle}.UpdateImage();
        end
        
        %% Update Balls
        for iBall=1:length(balls)
            balls{iBall}.UpdatePosition();
            %Check for collisions
            
            %Update physical image of the ball
            balls{iBall}.UpdateImage();
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

%% Delete game objects
for iPaddle=1:length(paddles)
    delete(paddles{iPaddle});
end
for iPaddle=1:length(balls)
    delete(balls{iPaddle});
end

if ~terminated
    handles.gameRunning = false;
    guidata(gcf, handles);
    disp('Simulation finished');
    
    
    %% Report game statistics

end



