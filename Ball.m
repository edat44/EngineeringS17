classdef Ball < Entity
    %Ball
    
    properties
        velocity
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = struct('x', randi([90, 600]), 'y', randi([8, 12]));
        end
        
        function UpdatePosition(obj)
            x = obj.position.x + (obj.velocity.x / obj.handles.fps);
            y = obj.position.y + (obj.velocity.y / obj.handles.fps);
            yLimit = obj.handles.quarterSize.height - obj.height/2;
            if abs(y) > yLimit
                obj.velocity.y = -obj.velocity.y;
            end
            obj.SetPosition(x, y);
        end
        
        function SetX(obj, x)
            obj.SetPosition(x, obj.position.y);
        end
        
        function vel = GetVelocity(obj)
            vel = obj.velocity;
        end
               
        function SetXVelocityDirection(obj, direction)
            obj.velocity.x = abs(obj.velocity.x) * sign(direction);
        end
        
        function delete(obj)
            delete@Entity(obj);
        end
    end
end

