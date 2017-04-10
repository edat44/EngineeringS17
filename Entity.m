classdef Entity < handle
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
            obj.img.XData = [obj.position.x - obj.width/2, obj.position.x + obj.width/2];
            obj.img.YData = [obj.position.y - obj.height/2, obj.position.y + obj.height/2];
        end
    end
    
end

