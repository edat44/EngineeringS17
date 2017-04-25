classdef Paddle < Entity
    %Paddle: contains all info necessary
    
    properties (Access = public)
        strategy
        score
        scoreText
        scoreTextPosition
        baseSpeed
    end
    
    methods
        function obj = Paddle(handles, strategy, xPos, scoreTextX, realTime)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight, realTime);
            obj.scoreTextPosition = struct('x', scoreTextX, 'y', handles.scoreTextY);
            obj.strategy = strategy;
            obj.baseSpeed = handles.paddleSpeed / handles.fps;
            obj.score = 0;
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
                ballY = balls{1}.position.y;
                yDistanceFromBall = ballY - obj.position.y;
                switch obj.strategy
                    case obj.handles.conservative
                        targetY = ballY - 5*sign(yDistanceFromBall);
                    case obj.handles.balanced
                        targetY = ballY - 20*sign(yDistanceFromBall);
                    case obj.handles.offensive
                        targetY = ballY - 10*sign(yDistanceFromBall);
                    case obj.handles.aggressive
                        targetY = ballY - 25*sign(yDistanceFromBall);
                    case obj.handles.berserk
                        targetY = ballY - 30*sign(yDistanceFromBall);
                    otherwise
                        targetY = ballY;
                end
            end
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

