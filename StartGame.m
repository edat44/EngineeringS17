function wins = StartGame(handles, leftStrategy, rightStrategy, ballsPerSimulation, ballsInPlay, realTime)


rng('shuffle');

%% Create both players with correct difficulty and strategy
handles.paddles = {Paddle(handles, leftStrategy, handles.leftOffset, -handles.scoreTextX),...
                Paddle(handles, rightStrategy, handles.rightOffset, handles.scoreTextX)};
paddles = handles.paddles;

leftPlayer = 1;
rightPlayer = 2;
%% Create ball(s)
balls = {Ball(handles)};

ballsScored = 0;

%% Start simulation
fprintf('Simulation beginning: ''%s'' Strategy\n', handles.strategies{rightStrategy});
terminated = false;
hwb = waitbar(0, 'Waiting...');
hwb.NumberTitle = 'off';
hwb.Name = [handles.strategies{rightStrategy}, ' Game Progress'];
%hwb.Position(2) = hwb.Position(2) - (hwb.Position(3)*1.5);
try 
    handles.gameRunning = true;
    guidata(gcbo, handles);
    while ballsScored < ballsPerSimulation
        if ishandle(hwb)
            waitbar((ballsScored+1)/ballsPerSimulation, hwb,...
                ['Playing Ball ', num2str(ballsScored+1), ' out of ', num2str(ballsPerSimulation)]);
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
        
                ball.SetXVelocityDirection(1);
                ball.SetX(leftPaddleBorders.right + ballBorders.width/2);
                ball.Bounce(paddles{leftPlayer}, 1);
            end
           
            rightPaddleBorders = paddles{rightPlayer}.Borders();
            if ballBorders.bottom <= rightPaddleBorders.top && ballBorders.top >= rightPaddleBorders.bottom &&...
                    ballBorders.right >= rightPaddleBorders.left && ball.LastBorders().right < rightPaddleBorders.left
               
                ball.SetXVelocityDirection(-1);
                ball.SetX(rightPaddleBorders.left - ballBorders.width/2);
                ball.Bounce(paddles{rightPlayer}, -1);
            end
            
            %Check if ball has been scored
            ballBorders = ball.Borders();
            if ballBorders.left < -handles.quarterSize.width
                paddles{rightPlayer}.Score();
                delete(ball);
                ballsScored = ballsScored + 1;
                if ballsScored < ballsPerSimulation
                    balls{iBall} = Ball(handles);
                else
                    balls(iBall) = [];
                end
                continue;
            elseif ballBorders.right > handles.quarterSize.width
                paddles{leftPlayer}.Score();
                delete(ball);
                ballsScored = ballsScored + 1;
                if ballsScored < ballsPerSimulation
                    balls{iBall} = Ball(handles);
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

if ishandle(hwb)
    close(hwb);
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


