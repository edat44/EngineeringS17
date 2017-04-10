classdef Ball < Entity
    %Ball
    
    properties
        velocity
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = struct('x', 50, 'y', 0);
            disp(obj.velocity.x);
        end
        
        function UpdatePosition(obj)
            obj.position.x = obj.position.x + (obj.velocity.x / obj.handles.fps);
            obj.position.y = obj.position.y + (obj.velocity.y / obj.handles.fps);
        end
    end
end

