classdef Ball < Entity
    %Ball
    
    properties
        velocity
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = struct('x', 0, 'y', 100);
            disp(obj.velocity.x);
        end
        
        function UpdatePosition(obj)
            obj.position.x = obj.position.x + (obj.velocity.x / obj.handles.fps);
            obj.position.y = obj.position.y + (obj.velocity.y / obj.handles.fps);
            yLimit = obj.handles.quarterSize.height - obj.height/2;
            if abs(obj.position.y) > yLimit
                obj.velocity.y = -obj.velocity.y;
                if obj.position.y > 0
                    obj.position.y = yLimit;
                else
                    obj.position.y = -yLimit;
                end
            end
        end
        
        function delete(obj)
            delete@Entity(obj);
        end
    end
end

