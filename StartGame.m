function wins = StartGame(handles, leftStrategy, rightStrategy, pointsPerSimulation, ballsInPlay, realTime, hwb, currentSimulation, totalSimulations)


rng('shuffle');

%% Create both players with correct difficulty and strategy
handles.paddles = {Paddle(handles, leftStrategy, handles.leftOffset, -handles.scoreTextX, realTime),...
                Paddle(handles, rightStrategy, handles.rightOffset, handles.scoreTextX, realTime)};
paddles = handles.paddles;

leftPlayer = 1;
rightPlayer = 2;
%% Create ball(s)
balls = {Ball(handles, realTime)};

ballsScored = 0;

%% Start simulation
fprintf('Simulation beginning: ''%s'' Strategy\n', handles.strategies{rightStrategy});
terminated = false;
try 
    handles.gameRunning = true;
    guidata(gcbo, handles);
    while ballsScored < pointsPerSimulation
        if ishandle(hwb)
            endPoint = pointsPerSimulation*totalSimulations;
            progress = (pointsPerSimulation*(currentSimulation-1))+(ballsScored);
            percentDone = progress/endPoint;
            waitbar((percentDone), hwb, [num2str(progress), ' / ', num2str(endPoint), ' (', num2str(percentDone*100), '%)']);
        else
            terminated = true;
            break;
        end
        tic; %starts timer to check how long loop iteration takes
        %% Update Paddles
        for iPaddle=1:length(paddles)
            %Update paddle
            paddles{iPaddle}.Update(balls);
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
        
                ball.SetX(leftPaddleBorders.right + ballBorders.width/2);
                ball.Bounce(paddles{leftPlayer}, 1);
            end
           
            rightPaddleBorders = paddles{rightPlayer}.Borders();
            if ballBorders.bottom <= rightPaddleBorders.top && ballBorders.top >= rightPaddleBorders.bottom &&...
                    ballBorders.right >= rightPaddleBorders.left && ball.LastBorders().right < rightPaddleBorders.left
               
                ball.SetX(rightPaddleBorders.left - ballBorders.width/2);
                ball.Bounce(paddles{rightPlayer}, -1);
            end
            
            %Check if ball has been scored
            ballBorders = ball.Borders();
            if ballBorders.left < -handles.quarterSize.width
                paddles{rightPlayer}.Score();
                delete(ball);
                ballsScored = ballsScored + 1;
                if ballsScored < pointsPerSimulation
                    balls{iBall} = Ball(handles, realTime);
                else
                    balls(iBall) = [];
                end
                continue;
            elseif ballBorders.right > handles.quarterSize.width
                paddles{leftPlayer}.Score();
                delete(ball);
                ballsScored = ballsScored + 1;
                if ballsScored < pointsPerSimulation
                    balls{iBall} = Ball(handles, realTime);
                else
                    balls(iBall) = [];
                end
                continue;
            end
        end
        
        
        %% Finish out loop
        if realTime
            timeElapsed = toc;
            if timeElapsed > handles.frameLength
                fprintf(['WARNING! TIME ELAPSED WAS GREATED THAN FRAME DELAY RATE:\n\t',...
                    'time elapsed = %d\n\t',...
                    'frame delay = %d\n\t',...
                    'left over time = %d\n'],...
                    timeElapsed, handles.frameLength, handles.frameLength-timeElapsed);
            end
            
            pause(max(handles.frameLength-timeElapsed, 0));
        end
        handles = guidata(gcbo);
        if ~handles.gameRunning
            terminated = true;
            break;
        end
    end
catch ERR
    fprintf('ERROR: %s\n\t%s\n', ERR.identifier, ERR.message);
    disp(ERR);
    disp(ERR.stack(1));
    terminated = true;
    disp('Simulation terminated abruptly');
    handles.gameRunning = false;
end

handles.gameRunning = false;
if ~isempty(gcbo)
    guidata(gcbo, handles);
end
if ~terminated
    disp('Simulation finished');
    wins = paddles{rightPlayer}.score;
else
    wins = -1;
end

%% Delete game objects
for iBall=length(balls):-1:1
    delete(balls{iBall});
    balls(iBall) = [];
end

for iPaddle=length(paddles):-1:1
    delete(paddles{iPaddle});
    paddles(iPaddle) = [];
end


