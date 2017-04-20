classdef (Abstract) Entity < handle
    %Entity
    
    properties (Access = public)
        handles
        position
        lastPosition
        width
        height
        rect
        realTime
    end
    
    methods (Access = public)
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
        
        function data = Borders(obj)
            data.left = obj.position.x - obj.width/2;
            data.right = obj.position.x + obj.width/2;
            data.bottom = obj.position.y - obj.height/2;
            data.top = obj.position.y + obj.height/2;
            data.width = obj.width;
            data.height = obj.height;
        end
        
        function data = LastBorders(obj)
            data.left = obj.lastPosition.x - obj.width/2;
            data.right = obj.lastPosition.x + obj.width/2;
            data.bottom = obj.lastPosition.y - obj.height/2;
            data.top = obj.lastPosition.y + obj.height/2;
            data.width = obj.width;
            data.height = obj.height;
        end
        
        function collision = HasCollided(obj, test) %not currently in use
            objB = obj.Borders();
            testB = test.Borders();
            collision = (testB.left < objB.right) && (testB.right > objB.left) &&...
                       (testB.bottom < objB.top) && (testB.top > objB.bottom);
        end
        
        function pos = GetPosition(obj)
            pos = obj.position;
        end
    
        function delete(obj)
            delete(obj.rect);
            delete@handle(obj);
        end
    end
    
    methods (Access = protected)
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
        function UpdateImage(obj)
            borders = obj.Borders();
            if ishandle(obj.rect)
                obj.rect.Position = [borders.left, borders.bottom, obj.width, obj.height];
            end
        end
    end
    
end

