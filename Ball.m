classdef Ball < Entity
    %Ball
    
    properties
        velocity %vector with x and y components
        acceleration %scalar
        points
        pointPlot
        pointPlotColor
        pointPlotLength
    end
    
    methods
        function obj = Ball(handles)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize);
            obj.velocity = struct('x', (rand()*50)+80, 'y', 0);
            angleRange = [pi/8, pi/3];
            angle = rand()*(angleRange(2)-angleRange(1)+angleRangle(1);
            horizontalSwitch = rand()*2;
            if switchDirection < 1
                angle = angle + pi;
            end
            obj.SetVelocityFromAngle(angle);
            obj.acceleration = 5;
            obj.points = zeros(2,1);
            obj.pointPlotColor = [(rand()/2)+0.5, (rand()/2)+0.5, (rand()/2)+0.5];
            obj.pointPlotLength = 100;
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
            startPoint = max(1, numPoints-obj.pointPlotLength);
            endPoint = numPoints+1;
            obj.pointPlot = plot(obj.points(1,startPoint:endPoint), obj.points(2, startPoint:endPoint));
            obj.pointPlot.Color = obj.pointPlotColor;
            obj.pointPlot.Marker = '.';
            obj.pointPlot.Parent = obj.handles.gameplot;
            hold('off');
        end
        
        function angle = GetAngle(obj)
            angle = abs(atan(obj.velocity.y/obj.velocity.x));
        end
        
        function Bounce(obj, paddle, angleAdjustment)
            posDif = obj.position.y - paddle.GetPosition().y;
            newAngle = angleAdjustment*(posDif/(obj.handles.paddleHeight/2))*0.5;
            %obj.SetVelocityFromAngle(newAngle + obj.GetAngle());
        end
        
        function mag = GetVelocityMagnitude(obj)
            mag = sqrt(obj.velocity.x^2 + obj.velocity.y^2);
        end
        
        function SetVelocityFromAngle(obj, angle)
            currentMagnitude = obj.GetVelocityMagnitude();
            obj.velocity.x = currentMagnitude*cos(angle);
            obj.velocity.y = currentMagnitude*sin(angle);
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

