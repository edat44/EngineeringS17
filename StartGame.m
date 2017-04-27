function wins = StartGame(handles, testStrategy, pointsPerSimulation, ballsInPlay, realTime, hwb, currentSimulation, totalSimulations)
% Inputs:
%   handles: reference to gui handle
%   testStrategy: struct containing hitting and tracking strategy types
%   pointsPerSimulation: Number of points to run before finishing simulation
%   ballsInPlay: Number of balls on the board at one time
%   realTime: boolean- whether or not to display the simulation live on the board
%   hwb: refernce to waitbar handle
%   currentSimulation: Current simulation number in the full simulation set
%   totalSimulations: Total number of simulations that will be run within the simulation set
%
% Outputs:
%   wins: the number of points won by the testStrategy


% Shuffle random number generator
rng('shuffle');

%% Create both players with correct difficulty and strategy
leftStrategy = handles.baselineCPU;
    
paddles = {...
    Paddle(handles, leftStrategy, handles.leftOffset, -handles.scoreTextX, realTime),...
    Paddle(handles, testStrategy, handles.rightOffset, handles.scoreTextX, realTime)};

leftPlayer = 1;
rightPlayer = 2;
%% Create ball cell array with one initial ball
balls = {Ball(handles, realTime)};

ballsScored = 0;

%% Set up simulation
fprintf('Simulation beginning: ''%s'' & ''%s''\n', handles.hittingNames{testStrategy.hitting}, handles.trackingNames{testStrategy.tracking});
terminated = false;
try 
    handles.gameRunning = true;
    guidata(gcbo, handles);
    % Initialize ball timer for multiball simulations
    ballStart = tic;
    
    %% Run simulation until enough points have been scored or an error occurs
    while ballsScored < pointsPerSimulation
        %% Check if new ball needs to be spawned (for multiball simulations)
        if length(balls) < ballsInPlay && toc(ballStart) >= handles.multiBallDelay
            balls{length(balls)+1} = Ball(handles, realTime);
            ballStart = tic;
        end
        % Starts loop timer to check how long loop iteration takes
        pointStart = tic;
        
        %% Update waitbar (or exit simulation if waitbar doesn't exist)
        if ishandle(hwb)
            endPoint = pointsPerSimulation*totalSimulations;
            progress = (pointsPerSimulation*(currentSimulation-1))+(ballsScored);
            percentDone = progress/endPoint;
            waitbar((percentDone), hwb, [num2str(progress), ' / ', num2str(endPoint), ' (', num2str(percentDone*100), '%)']);
        else
            terminated = true;
            break;
        end
        
        %% Update Paddles
        for iPaddle=1:length(paddles)
            paddles{iPaddle}.Update(balls);
        end
        
        %% Update Balls
        for iBall=length(balls):-1:1
            ball = balls{iBall};

            %% Update initial ball movement
            ball.UpdatePosition();
            
            ballBorders = ball.Borders();
            
            %% Check for paddle and ball collisions
            leftPaddleBorders = paddles{leftPlayer}.Borders();
            if ballBorders.bottom <= leftPaddleBorders.top && ballBorders.top >= leftPaddleBorders.bottom &&...
                    ballBorders.left <= leftPaddleBorders.right && ball.LastBorders().left > leftPaddleBorders.right
        
                ball.SetX(leftPaddleBorders.right + ball.width/2);
                ball.Bounce(paddles{leftPlayer}, 1);
            end
           
            rightPaddleBorders = paddles{rightPlayer}.Borders();
            if ballBorders.bottom <= rightPaddleBorders.top && ballBorders.top >= rightPaddleBorders.bottom &&...
                    ballBorders.right >= rightPaddleBorders.left && ball.LastBorders().right < rightPaddleBorders.left
               
                ball.SetX(rightPaddleBorders.left - ball.width/2);
                ball.Bounce(paddles{rightPlayer}, -1);
            end
            
            %% Check if ball has been scored
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
            elseif ballBorders.right > handles.quarterSize.width
                paddles{leftPlayer}.Score();
                delete(ball);
                ballsScored = ballsScored + 1;
                if ballsScored < pointsPerSimulation
                    balls{iBall} = Ball(handles, realTime);
                else
                    balls(iBall) = [];
                end
            end
        end
        
        
        %% Finish out loop
        % If playing in realTime, adjust pause value based on differences
        % in compuation time in order to eliminate as much 'lag' as possible
        if realTime
            timeElapsed = toc(pointStart);
            if timeElapsed > handles.frameLength && handles.debugging
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
%% Catch any error that occurs and smoothly end simulation
catch ERR
    fprintf('ERROR: %s\n\t%s\n', ERR.identifier, ERR.message);
    disp(ERR);
    disp(ERR.stack(1));
    terminated = true;
    disp('Simulation terminated abruptly');
    handles.gameRunning = false;
end

%% Wrap up Simulation
handles.gameRunning = false;
if ~isempty(gcbo)
    guidata(gcbo, handles);
end

% If game was abruptly terminated set wins = -1 so full simulation set
% knows to abort remaining simulations
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


