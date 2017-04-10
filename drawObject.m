function obj = drawObject(obj)
    %Changes the XData and YData properties of the objects 'image' field,
    %and then returns the object so that these object properties can be updated
    obj.image.XData = [obj.position.x - obj.width/2, obj.position.x + obj.width/2];
    obj.image.YData = [obj.position.y - obj.height/2, obj.position.y + obj.height/2];
    