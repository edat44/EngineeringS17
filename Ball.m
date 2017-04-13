classdef Ball < Entity
    %Ball
    
    properties
        velocity %vector with x and y components
        acceleration %scalar
        points
        pointPlot
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = struct('x', 10, 'y', randi([3, 10]));
            obj.acceleration = 10;
            obj.points = zeros(2,1);
        end
        
        function UpdatePosition(obj)
            angle = obj.GetAngle();
            obj.velocity.x = obj.velocity.x + (obj.acceleration*cos(angle) / obj.handles.fps)*sign(obj.velocity.x);
            obj.velocity.y = obj.velocity.y + (obj.acceleration*sin(angle) / obj.handles.fps)*sign(obj.velocity.y);
            x = obj.position.x + (obj.velocity.x / obj.handles.fps);
            y = obj.position.y + (obj.velocity.y / obj.handles.fps);
            yLimit = obj.handles.quarterSize.height - obj.height/2;
            if abs(y) > yLimit
                obj.velocity.y = -obj.velocity.y;
            end
            obj.SetPosition(x, y);
            s = size(obj.points);
            numPoints = s(2);
            obj.points(1, numPoints+1) = obj.position.x;
            obj.points(2, numPoints+1) = obj.position.y;
            if ishandle(obj.pointPlot)
                delete(obj.pointPlot);
            end
            hold('on');
            startPoint = max(1, numPoints-500);
            endPoint = numPoints+1;
            obj.pointPlot = plot(obj.points(1,startPoint:endPoint), obj.points(2, startPoint:endPoint), 'r.');
            obj.pointPlot.Parent = obj.handles.gameplot;
            hold('off');
        end
        
        function angle = GetAngle(obj)
            angle = abs(atan(obj.velocity.y/obj.velocity.x));
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
            delete(obj.pointPlot);
            delete@Entity(obj);
        end
    end
end

