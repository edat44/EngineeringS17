classdef (Abstract) Entity < handle
    %Entity
    
    properties
        handles
        position
        width
        height
        img
    end
    
    methods
        function obj = Entity(handles, posX, posY, width, height)
            obj.handles = handles;
            obj.position = struct('x', posX, 'y', posY);
            obj.width = width;
            obj.height = height;
            for i=1:3
                cData(1, 1, i) = 1;
            end
            obj.img = image('CData', cData, 'Parent', handles.gameplot);
            obj.UpdateImage();
        end
        
        function UpdateImage(obj)
            borders = obj.Borders();
            obj.img.XData = [borders.left, borders.right];
            obj.img.YData = [borders.bottom, borders.top];
        end
        
        function data = Borders(obj)
            data.left = obj.position.x - obj.width/2;
            data.right = obj.position.x + obj.width/2;
            data.bottom = obj.position.y - obj.height/2;
            data.top = obj.position.y + obj.height/2;
        end
        
        function delete(obj)
            delete(obj.img);
        end
    end
    
end

