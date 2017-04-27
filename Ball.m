classdef Ball < Entity
    %Ball
    
    properties (Access = public)
        velocity            % Velocity structure with x and y components
        accelerationDamping % Scalar number which affects acceleration of the ball
        points              % Number of points to draw in the ball trail
        pointPlot           % Handle to a plot which draws out the 'trail' of the ball
        pointPlotColor      % Color of the trail
        pointPlotLength     % Number of previous trail points to draw
    end
    
    methods
        % Contructor: creates Ball object using parameters and an
        % envocation of parent Entity contructor
        function obj = Ball(handles, realTime)
            obj = obj@Entity(handles, 0, 0, handles.ballSize, handles.ballSize, realTime);
            
            % Calculate Initial Ball velocity
            obj.velocity = struct('x', (rand()*100)+100, 'y', 0);
            
            % Generates a random angle in the first quadrant
            angleRange = [pi/20, pi/8];
            angle = (rand()*(angleRange(2)-angleRange(1)))+angleRange(1);
            
            % Adjust angle to land in each quadrant an equal percentage of
            % the time
            horizontalSwitch = rand()*2;
            verticalSwitch = rand()*2;
            if verticalSwitch < 1
                angle = -angle;
            end
            if horizontalSwitch < 1
                angle = angle + pi;
            end
            % Set ball velocity based on new angle
            obj.SetVelocityFromAngle(angle);
            
            obj.accelerationDamping = handles.ballAccelerationDamping;
            obj.points = zeros(2,1);
            obj.pointPlotColor = [(rand()/2)+0.5, (rand()/2)+0.5, (rand()/2)+0.5];
            obj.pointPlotLength = 50;
        end
        
        % Update position of ball
        function UpdatePosition(obj)
            angle = obj.GetAngle();
            deltat = 1/obj.handles.fps;
            
            %Use Verlet method to calculate new position and velocity
            vhalfx = obj.velocity.x + abs(obj.velocity.x)/(obj.accelerationDamping*cos(angle))*(deltat/2)*sign(obj.velocity.x);
            vhalfy = obj.velocity.y + abs(obj.velocity.y)/(obj.accelerationDamping*sin(angle))*(deltat/2)*sign(obj.velocity.y);
            
            x = obj.position.x + (vhalfx*deltat);
            y = obj.position.y + (vhalfy*deltat);
            
            obj.velocity.x = vhalfx + abs(vhalfx)/(obj.accelerationDamping*cos(angle))*(deltat/2)*sign(vhalfx);
            obj.velocity.y = vhalfy + abs(vhalfy)/(obj.accelerationDamping*sin(angle))*(deltat/2)*sign(vhalfy);
            
            % If ball has hit the top of the screen, flip y component of
            % the velocity
            yLimit = obj.handles.quarterSize.height - obj.height/2;
            if abs(y) > yLimit
                obj.velocity.y = -obj.velocity.y;
            end
            
            obj.SetPosition(x, y);
            
            % Update the physical ball and ball trail on board
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
        
        % Returns the angle (in radians) of the velocity of the ball
        function angle = GetAngle(obj)
            angle = abs(atan(obj.velocity.y/obj.velocity.x));
        end
        
        % Handles collisions with a paddle
        %   paddle: handle to paddle with which ball is colliding
        %   xDirection: X direction in which the ball should travel (-1 for
        %       left, 1 for right)
        function Bounce(obj, paddle, xDirection)
            obj.SetXVelocityDirection(xDirection)
            posDif = abs(obj.position.y - paddle.position.y);
            
            % Update acceleartion damping factor based on ball position
            % relative to the center of the paddle
            obj.accelerationDamping = obj.accelerationDamping * (1 - (posDif/(paddle.height*2)));
        end
        
        % returns the magnitude of the ball's velocity, in pixels/s
        function mag = GetVelocityMagnitude(obj)
            mag = sqrt(obj.velocity.x^2 + obj.velocity.y^2);
        end
        
        % Adjusts the x and y components of the velocity such that the ball
        % now travels at the given angle as measured from the positive x axis (in radians)
        function SetVelocityFromAngle(obj, angle)
            currentMagnitude = obj.GetVelocityMagnitude();
            obj.velocity.x = currentMagnitude*cos(angle);
            obj.velocity.y = currentMagnitude*sin(angle);
        end
        
        % Set just the x position of the ball
        function SetX(obj, x)
            obj.SetPosition(x, obj.position.y);
        end
        
        % Sets the x direction of the ball
        %   direction: -1 = left, 1 = right
        function SetXVelocityDirection(obj, direction)
            obj.velocity.x = abs(obj.velocity.x) * sign(direction);
        end
        
        % Deletes object
        function delete(obj)
            delete(obj.pointPlot);
            delete@Entity(obj);
        end
    end
end

