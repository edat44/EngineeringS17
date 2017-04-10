classdef Paddle < Entity
    %Paddle: contains all info necessary
    
    properties
        difficulty
        strategy
        score
        scoreText
        scoreTextPosition
    end
    
    methods
        function obj = Paddle(handles, difficulty, strategy, xPos, scoreTextX)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight);
            obj.scoreTextPosition = struct('x', scoreTextX, 'y', handles.scoreTextY);
            obj.difficulty = difficulty;
            obj.strategy = strategy;
            obj.score = randi([0, 150]);
            obj.scoreText = text('Parent', handles.gameplot, 'Color', 'w', 'FontSize', 36);
            obj.UpdateScoreDisplay();
        end
        
        function UpdateScoreDisplay(obj)
            obj.scoreText.String = num2str(obj.score);
            %Extent(3) gives the width of the text object
            obj.scoreText.Position = [obj.scoreTextPosition.x - obj.scoreText.Extent(3)/2, obj.scoreTextPosition.y];
        end
        
        function Score(obj)
            obj.score = obj.score + 1;
        end
        
        function delete(obj)
            delete@Entity(obj);
            delete(obj.scoreText);
        end
    end
    
end

