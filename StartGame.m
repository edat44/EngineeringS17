function StartGame(handles)

%% Set up Game axes
%configureAxes(handles);

%% Create both players with correct difficulty and strategy
paddles = {  Paddle(handles, handles.dif1popup.Value, handles.strat1popup.Value, handles.leftOffset, -handles.scoreTextX),...
                Paddle(handles, handles.dif2popup.Value, handles.strat2popup.Value, handles.rightOffset, handles.scoreTextX)};
            
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
    while handles.runSimulationCheckbox.Value && length(balls) > 0
        tic; %starts timer to check how long loop iteration takes
        %% Update Paddles
        for iPaddle=1:length(paddles)
            %Update paddle
            paddles{iPaddle}.Update(balls{1});
        end
        
        %% Update Balls
        for iBall=length(balls):-1:1
            ball = balls{iBall};
            %Update ball initially
            ball.UpdatePosition();
            
            ballBorders = ball.Borders();
            
            %Check for paddle and ball collisions
            leftPaddleBorders = paddles{leftPlayer}.Borders();
            if ballBorders.bottom <= leftPaddleBorders.top && ballBorders.top >= leftPaddleBorders.bottom &&...
                    ballBorders.left <= leftPaddleBorders.right && ball.LastBorders().left > leftPaddleBorders.right
        
                ball.SetXVelocityDirection(1);
                ball.SetX(leftPaddleBorders.right + ballBorders.width/2);
            end
           
            rightPaddleBorders = paddles{rightPlayer}.Borders();
            if ballBorders.bottom <= rightPaddleBorders.top && ballBorders.top >= rightPaddleBorders.bottom &&...
                    ballBorders.right >= rightPaddleBorders.left && ball.LastBorders().right < rightPaddleBorders.left
               
                ball.SetXVelocityDirection(-1);
                ball.SetX(rightPaddleBorders.left - ballBorders.width/2);
            end
            
            %Check if ball has been scored
            if ballBorders.left < -handles.quarterSize.width
                paddles{leftPlayer}.Score();
                delete(ball);
                balls(iBall) = [];
                continue;
            elseif ballBorders.right > handles.quarterSize.width
                paddles{rightPlayer}.Score();
                delete(ball);
                balls(iBall) = [];
                continue;
            end
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
    disp(ERR);
    disp(ERR.stack(1));
    terminated = true;
    disp('Simulation terminated abruptly');
end

%% Delete game objects
for iPaddle=length(paddles):-1:1
    delete(paddles{iPaddle});
    paddles(iPaddle) = [];
end

for iBall=length(balls):-1:1
    delete(balls{iBall});
    balls(iBall) = [];
end

if ~terminated
    handles.gameRunning = false;
    guidata(gcf, handles);
    disp('Simulation finished');
    
    
    %% Report game statistics

end



