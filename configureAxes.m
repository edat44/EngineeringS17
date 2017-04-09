function configureAxes(handles)

line(handles.gameplot,[5 5],[-5 5])
line(handles.gameplot,[-5 -5],[-5 5])
line(handles.gameplot,[0 0],[-5 5])
axis(handles.gameplot,[-5 5 -5 5])


