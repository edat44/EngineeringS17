function configureAxes(handles)

size = handles.quarterSize;
% Create right vertical line
raxes = line(handles.gameplot,[handles.rightOffset, handles.rightOffset],[-size.height, size.height]);
raxes.Color = 'w';

% Create left vertical line
laxes = line(handles.gameplot,[handles.leftOffset, handles.leftOffset],[-size.height, size.height]);
laxes.Color = 'w';

% Create middle vertical line
maxes = line(handles.gameplot,[0, 0], [-size.height, size.height]);
maxes.Color = 'w';


