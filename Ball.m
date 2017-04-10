classdef Ball < Entity
    %Ball
    
    properties
        velocity
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = 0;
        end
        
    end
end

