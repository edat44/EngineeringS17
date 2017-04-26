classdef Paddle < Entity
    %Paddle: contains all info necessary
    
    properties (Access = public)
        strategy
        score
        scoreText
        scoreTextPosition
        baseSpeed
        ballTrack
    end
    
    methods
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
        
        function Update(obj, ball)
            obj.UpdatePosition(ball);
        end
        
        function UpdateScoreDisplay(obj)
            obj.scoreText.String = num2str(obj.score);
            %Extent(3) gives the width of the text object
            obj.scoreText.Position = [obj.scoreTextPosition.x - obj.scoreText.Extent(3)/2, obj.scoreTextPosition.y];
        end
        
        function UpdatePosition(obj, balls)
            if length(balls) == 0
                targetY = 0;
            else
                for iball=1:length(balls)
                    pos = balls{iball}.position;
                    positions(iball,:)=[abs(obj.position.x - pos.x); abs(obj.position.y - pos.y)];
                end
                if length(balls) == 1
                    targetB=1;
                else
                    targetB=obj.ballTrack;
                    switch obj.strategy.tracking
                        case obj.handles.tracking.focused
                            if abs(balls{targetB}.position.x-obj.position) > abs(balls{targetB}.lastPosition.x-obj.lastPosition)
                                for jball=1:length(balls)
                                  if abs(balls{jball}.position.x-obj.position) < abs(balls{jball}.lastPosition.x-obj.lastPosition)
                                      targetB=jball;
                                  end
                                end
                            end
                        case obj.handles.tracking.proximity
                                    targetB=1;
                        case obj.handles.tracking.threat
                                        targetB=1;
                            end
                    end
                    ballY = balls{targetB}.position.y;
                    yDistanceFromBall = ballY - obj.position.y;
                    switch obj.strategy.hitting
                        case obj.handles.hitting.conservative
                            targetY = ballY;
                        case obj.handles.hitting.balanced
                            targetY = ballY - 15*sign(yDistanceFromBall);
                        case obj.handles.hitting.aggressive
                            targetY = ballY - 30*sign(yDistanceFromBall);
                        otherwise
                            targetY = ballY;
                    end
                end
                obj.ballTrack=targetB;
            diffY = targetY - obj.position.y;
            %disp(diffY);
            if abs(diffY) < obj.baseSpeed
                y = targetY;
            else
                y = obj.position.y + obj.baseSpeed*sign(diffY);
            end
            
            obj.SetPosition(obj.position.x, y);
        end
        
        function Score(obj)
            obj.score = obj.score + 1;
            if obj.realTime
                obj.UpdateScoreDisplay();
            end
        end
        
        function delete(obj)
            delete@Entity(obj);
            delete(obj.scoreText);
        end
    end
    
end

