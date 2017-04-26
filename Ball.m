classdef Ball < Entity
    %Ball
    
    properties (Access = public)
        velocity %vector with x and y components
        accelerationDamping %scalar
        points
        pointPlot
        pointPlotColor
        pointPlotLength
    end
    
    methods
        function obj = Ball(handles, realTime)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize, realTime);
            
            %Calculate Initial Ball velocity
            obj.velocity = struct('x', (rand()*100)+100, 'y', 0);
            angleRange = [pi/20, pi/8];
            angle = (rand()*(angleRange(2)-angleRange(1)))+angleRange(1);
            horizontalSwitch = rand()*2;
            verticalSwitch = rand()*2;
            if verticalSwitch < 1
                angle = -angle;
            end
            if horizontalSwitch < 1
                angle = angle + pi;
            end
            obj.SetVelocityFromAngle(angle);
            
            obj.accelerationDamping = handles.ballAccelerationDamping;
            obj.points = zeros(2,1);
            obj.pointPlotColor = [(rand()/2)+0.5, (rand()/2)+0.5, (rand()/2)+0.5];
            obj.pointPlotLength = 50;
        end
        
        function UpdatePosition(obj)
            angle = obj.GetAngle();
            deltat = 1/obj.handles.fps;
            %Use Verlet method to calculate new position and velocity
            %vhalfx = obj.velocity.x + abs(obj.velocity.x)/(obj.accelerationDamping*cos(angle))*(deltat/2)*sign(obj.velocity.x);
            %vhalfy = obj.velocity.y + abs(obj.velocity.y)/(obj.accelerationDamping*sin(angle))*(deltat/2)*sign(obj.velocity.y);
            vhalfx = obj.velocity.x + obj.velocity.x/(obj.accelerationDamping*cos(angle))*(deltat/2);
            vhalfy = obj.velocity.y + obj.velocity.y/(obj.accelerationDamping*sin(angle))*(deltat/2);
            
            x = obj.position.x + (vhalfx*deltat);
            y = obj.position.y + (vhalfy*deltat);
            
            obj.velocity.x = vhalfx + vhalfx/(obj.accelerationDamping*cos(angle))*(deltat/2)*vhalfx;
            obj.velocity.y = vhalfy + vhalfy/(obj.accelerationDamping*sin(angle))*(deltat/2)*vhalfy;
            
            yLimit = obj.handles.quarterSize.height - obj.height/2;
            if abs(y) > yLimit
                obj.velocity.y = -obj.velocity.y;
            end
            obj.SetPosition(x, y);
            if obj.realTime
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
        end
        
        function angle = GetAngle(obj)
            angle = abs(atan(obj.velocity.y/obj.velocity.x));
        end
        
        function Bounce(obj, paddle, xDirection)
            obj.SetXVelocityDirection(xDirection)
            posDif = abs(obj.position.y - paddle.GetPosition().y);
            obj.accelerationDamping = obj.accelerationDamping * (1 - (posDif/(paddle.height*2)));
            %newAngle = angleAdjustment*(posDif/(obj.handles.paddleHeight/2))*0.5;
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

