classdef Paddle < Entity
    %Paddle: contains all info necessary
    
    properties
        difficulty
        strategy
    end
    
    methods
        function obj = Paddle(handles, difficulty, strategy, xPos, yPos, width, height)
            obj = obj@Entity(handles, xPos, 0, handles.paddleWidth, handles.paddleHeight);
            obj.difficulty = difficulty;
            obj.strategy = strategy;
        end
        
    end
    
end

