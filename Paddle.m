classdef Paddle < Entity
    %Paddle: extends from entity class
    
    properties (Access = public)
        strategy            %structure of strategy combination contraining two fields:
                            %   hitting
                            %   tracking
        score               % points scored
        scoreText           % text object handle that displays the points scored
        scoreTextPosition   % position of the scoreText handle
        baseSpeed           % maximum speed paddle can move in one frame
        ballTrack           % The index of the ball currently being tracked
    end
    
    methods
        % Contructor: creates Paddle object using parameters and an
        % envocation of parent Entity contructor
        function obj = Paddle(handles, strategy, xPos, scoreTextX, realTime)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight, realTime);
            obj.scoreTextPosition = struct('x', scoreTextX, 'y', handles.scoreTextY);
            obj.strategy = strategy;
            obj.baseSpeed = handles.paddleSpeed / handles.fps;
            obj.score = 0;
            ballTrack=1;
            if realTime
                obj.scoreText = text('Parent', handles.gameplot, 'Color', 'w', 'FontSize', 36);
                obj.UpdateScoreDisplay();
        
            end
        end
        
        % Update the Paddle
        function Update(obj, ball)
            obj.UpdatePosition(ball);
        end
        
        % Update scoreText handle to display current score
        function UpdateScoreDisplay(obj)
            obj.scoreText.String = num2str(obj.score);
            % Note: Extent(3) returns the width of the text object
            obj.scoreText.Position = [obj.scoreTextPosition.x - obj.scoreText.Extent(3)/2, obj.scoreTextPosition.y];
        end
        
        % Update the position of the paddle
        %   balls: cell array of all the balls on the board. Is handled
        %   differently depending on strategy type
        function UpdatePosition(obj, balls)
            % If no balls on the board, go to the middle of the board
            if length(balls) == 0
                targetY = 0;
            else
                % If only one ball is present, target it
                if length(balls) == 1
                    targetB=1;
                else
                    % If multiple balls are present, envoke tracking
                    % strategy to alter tracking methods
                    targetB=obj.ballTrack;
                    switch obj.strategy.tracking
                        case obj.handles.tracking.focused
                            % Focuses on only one ball at a time until it
                            % hits it, then moves on to another ball
                            if ~obj.BallGettingCloser(balls{targetB})
                                for jball=1:length(balls)
                                    if obj.BallGettingCloser(balls{jball})
                                        targetB=jball;
                                        break;
                                    end
                                end
                            end
                        case obj.handles.tracking.proximity
                            % Targets the ball closest to paddle (in the x direction)
                            %that is also moving towards the paddle
                            xClosest=obj.handles.quarterSize.width*2;
                            for jball=1:length(balls)
                                [closer, xDist] = obj.BallGettingCloser(balls{jball});
                                if closer && xDist < xClosest
                                    targetB=jball;
                                    xClosest = xDist;
                                end
                            end
                        case obj.handles.tracking.threat
                            % Targets ball with highest x velocity moving
                            % toward the paddle
                            vHighest=0;
                            for jball=1:length(balls)
                                closer=obj.BallGettingCloser(balls{jball});
                                if closer && balls{jball}.velocity.x > vHighest
                                    vHighest=balls{jball}.velocity.x;
                                    targetB=jball;
                                end
                            end
                    end
                end
                ballY = balls{targetB}.position.y;
                yDistanceFromBall = ballY - obj.position.y;
                % Aim for the target ball to hit a different section of the
                % paddle, depending on hitting strategy
                switch obj.strategy.hitting
                    case obj.handles.hitting.conservative
                        % Aims for the center of the paddle
                        targetY = ballY;
                    case obj.handles.hitting.balanced
                        % Aims for 15 pixels away from the center of the paddle
                        targetY = ballY - 15*sign(yDistanceFromBall);
                    case obj.handles.hitting.aggressive
                        % Aims for 30 pixels away from the center of the paddle 
                        targetY = ballY - 30*sign(yDistanceFromBall);
                    otherwise
                        targetY = ballY;
                end
            end
            obj.ballTrack=targetB;
            diffY = targetY - obj.position.y;
            % Move paddle in necessary y direction
            if abs(diffY) < obj.baseSpeed
                y = targetY;
            else
                y = obj.position.y + obj.baseSpeed*sign(diffY);
            end
            
            obj.SetPosition(obj.position.x, y);
        end
        
        % Scores a point
        function Score(obj)
            obj.score = obj.score + 1;
            if obj.realTime
                obj.UpdateScoreDisplay();
            end
        end
        
        %Checks whether a given ball is moving toward the paddle
        function [closer, currentXDist] = BallGettingCloser(obj, ball)
            currentXDist = abs(ball.position.x-obj.position.x);
            closer = currentXDist < abs(ball.lastPosition.x-obj.position.x);
        
        end
        
        % deletes object
        function delete(obj)
            delete@Entity(obj);
            delete(obj.scoreText);
        end
    end
    
end

