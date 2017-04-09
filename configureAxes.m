function configureAxes(handles)

raxes = line(handles.gameplot,[4.8 4.8],[-5 5]);
raxes.Color = 'w';
laxes = line(handles.gameplot,[-4.8 -4.8],[-5 5]);
laxes.Color = 'w';
maxes = line(handles.gameplot,[0 0],[-5 5]);
maxes.Color = 'w';

axis(handles.gameplot,[-5 5 -5 5])


