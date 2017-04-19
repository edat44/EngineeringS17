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
        function obj = Paddle(handles, strategy, xPos, scoreTextX)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight);
            obj.scoreTextPosition = struct('x', scoreTextX, 'y', handles.scoreTextY);
            obj.strategy = strategy;
            obj.baseSpeed = handles.paddleSpeed / handles.fps;
            obj.score = 0;
            obj.scoreText = text('Parent', handles.gameplot, 'Color', 'w', 'FontSize', 36);
            obj.UpdateScoreDisplay();
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
            y = obj.position.y;
            targetY = obj.position.y;
            switch obj.strategy
                otherwise
                    if length(balls) == 0
                        targetY = 0;
                    else
                        ballPos = balls{1}.GetPosition();
                        targetY = ballPos.y;
                    end
            end
            if targetY < obj.position.y
                y = max(targetY, obj.position.y - obj.baseSpeed);
            elseif targetY > obj.position.y
                y = min(targetY, obj.position.y + obj.baseSpeed);
            else
                y = obj.position.y;
            end    
            
            obj.SetPosition(obj.position.x, y);
        end
        
        function Score(obj)
            obj.score = obj.score + 1;
            obj.UpdateScoreDisplay();
        end
        
        function delete(obj)
            delete@Entity(obj);
            delete(obj.scoreText);
        end
    end
    
end

