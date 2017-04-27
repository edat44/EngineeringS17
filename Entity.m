classdef (Abstract) Entity < handle
    % Entity class is the parent class of:
    %   Ball
    %   Paddle
    
    properties (Access = public)
        handles     % referance to gui handle
        position    % structure with fiels 'x' and 'y'. Position of the center of the object in the current frame
        lastPosition% same as position varible, but refers to object's position in the previous frame
        width       % Width of object
        height      % Height of object
        rect        % handle to rectangle object that gets drawn on the board
        realTime    % boolean- is simulation played out in realTime?
    end
    
    methods (Access = public)
        % Constuctor: creates Entity object given the parameters
        function obj = Entity(handles, posX, posY, width, height, realTime)
            obj.handles = handles;
            obj.position = struct('x', posX, 'y', posY);
            obj.lastPosition = struct('x', posX, 'y', posY);
            obj.width = width;
            obj.height = height;
            obj.realTime = realTime;
            if obj.realTime
                obj.rect = rectangle('Parent', handles.gameplot, 'FaceColor', 'white', 'LineStyle', 'none');
                obj.UpdateImage();
            end
        end
        
        % Returns a structure containing information about the 'borders' of
        % the object:
        %   left:   pixel value of the LEFT edge of the object
        %   right:  pixel value of the RIGHT edge of the object
        %   top:    pixel value of the TOP edge of the object
        %   bottom: pixel value of the BOTTOM edge of the object
        function data = Borders(obj)
            data.left = obj.position.x - obj.width/2;
            data.right = obj.position.x + obj.width/2;
            data.bottom = obj.position.y - obj.height/2;
            data.top = obj.position.y + obj.height/2;
        end
        
        % Same as Borders() function, but returns values based on the
        % postion of the object in the previous frame
        function data = LastBorders(obj)
            data.left = obj.lastPosition.x - obj.width/2;
            data.right = obj.lastPosition.x + obj.width/2;
            data.bottom = obj.lastPosition.y - obj.height/2;
            data.top = obj.lastPosition.y + obj.height/2;
        end
        
        % Deletes object and rectangle handle of object
        function delete(obj)
            delete(obj.rect);
            delete@handle(obj);
        end
    end
    
    methods (Access = protected)
        % Set the position to a given (x, y) position
        % Automatically constains the y position to remain within the board
        function SetPosition(obj, x, y)
            obj.lastPosition.x = obj.position.x;
            obj.lastPosition.y = obj.position.y;
            obj.position.x = x;
            obj.position.y = y;
            if obj.Borders().top > obj.handles.quarterSize.height
                obj.position.y = obj.handles.quarterSize.height - obj.height/2;
            elseif obj.Borders().bottom < -obj.handles.quarterSize.height
                obj.position.y = -(obj.handles.quarterSize.height - obj.height/2);
            else
                obj.position.y = y;
            end
            if obj.realTime
                obj.UpdateImage();
            end
        end
    end
    
    methods (Access = private)
        % Updates the rectangle object that gets physically displayed on the board
        function UpdateImage(obj)
            borders = obj.Borders();
            if ishandle(obj.rect)
                obj.rect.Position = [borders.left, borders.bottom, obj.width, obj.height];
            end
        end
    end
    
end

