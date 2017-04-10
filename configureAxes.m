function configureAxes(handles)

size = handles.quarterSize;

raxes = line(handles.gameplot,[handles.rightOffset, handles.rightOffset],[-size.height, size.height]);
raxes.Color = 'w';
laxes = line(handles.gameplot,[handles.leftOffset, handles.leftOffset],[-size.height, size.height]);
laxes.Color = 'w';
maxes = line(handles.gameplot,[0, 0], [-size.height, size.height]);
maxes.Color = 'w';

%handles.gameplot.XLim = [-boardQuarter(1), boardQuarter(1)];
%handles.gameplot.YLim = [-boardQuarter(2), boardQuarter(2)];
%axis(handles.gameplot, 'off');
%handles.gameplot.Color = [0, 0, 0];


