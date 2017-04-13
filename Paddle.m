classdef Paddle < Entity
    %Paddle: contains all info necessary
    
    properties
        difficulty
        strategy
        score
        scoreText
        scoreTextPosition
        baseSpeed
    end
    
    methods
        function obj = Paddle(handles, difficulty, strategy, xPos, scoreTextX)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight);
            obj.scoreTextPosition = struct('x', scoreTextX, 'y', handles.scoreTextY);
            obj.difficulty = difficulty;
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
        
        function UpdatePosition(obj, ball)
            y = obj.position.y;
            switch obj.difficulty
                case obj.handles.easy
                    %disp('Easy');
                case obj.handles.medium
                    %disp('Medium');
                case obj.handles.hard
                    %disp('Hard');
                case obj.handles.insane
                    %disp('Insane');
            end
            ballPos = ball.GetPosition();
            if ballPos.y > obj.position.y
                y = min(y + obj.baseSpeed, ballPos.y);
            elseif ballPos.y < obj.position.y
                y = max(y - obj.baseSpeed, ballPos.y);
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

