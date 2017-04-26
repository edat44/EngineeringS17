function varargout = PongTool(varargin)
% PONGTOOL MATLAB code for PongTool.fig
%      PONGTOOL, by itself, creates a new PONGTOOL or raises the existing
%      singleton*.
%
%      H = PONGTOOL returns the handle to a new PONGTOOL or the handle to
%      the existing singleton*.
%
%      PONGTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PONGTOOL.M with the given input arguments.
%
%      PONGTOOL('Property','Value',...) creates a new PONGTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PongTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PongTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PongTool

% Last Modified by GUIDE v2.5 25-Apr-2017 20:50:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PongTool_OpeningFcn, ...
                   'gui_OutputFcn',  @PongTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PongTool is made visible.
function PongTool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

handles.hitting = struct('conservative', 1, 'balanced', 2', 'aggressive', 3);
handles.hittingNames = handles.hittingPopup.String;

handles.tracking = struct('focused', 1, 'proximity', 2, 'threat', 3);
handles.trackingNames = handles.trackingPopup.String;

handles.baselineCPU = struct(...
    'hitting', handles.hitting.conservative,...
    'tracking', handles.tracking.focused);

handles.singleBall = 1;
handles.multiBall3 = 2;
handles.multiBall5 = 3;
handles.numberofBalls = [1, 3, 5];

handles.multiBallDelay = 1;

handles.leftOffset = -180;
handles.rightOffset = -handles.leftOffset;

handles.scoreTextY = 100;
handles.scoreTextX = 110;

handles.paddleWidth = 10;
handles.paddleHeight = 60;
handles.ballSize = 8;

handles.paddleSpeed = 150;
handles.ballAccelerationDamping = 50;

handles.quarterSize = struct('width', 200, 'height', 125);

handles.gameRunning = false;

handles.fps = 30;
handles.frameLength = 1/handles.fps;

handles.pointsPerSimulation = 3;

configureAxes(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PongTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PongTool_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.gameRunning
    clc;
    disableControls(handles);
    cla(handles.analysisAxes,'reset')
    pointsPerSimulation = str2double(handles.pointsPerSimulationText.String);
    ballsInPlay = handles.numberofBalls(handles.ballsInPlayPopup.Value);
    realTime = handles.realTimeCheckbox.Value;
    hwb = waitbar(0, 'Waiting...');
    hwb.NumberTitle = 'off';
    hwb.Name = 'Simulation Progress';
    
    if handles.runAllStrategiesCheckbox.Value
        numTrackingStrategies = numel(fieldnames(handles.tracking));
        numHittingStrategies = numel(fieldnames(handles.hitting));
        totalSimulations = numTrackingStrategies*numHittingStrategies;
        wins = zeros(1, totalSimulations);
        for i=1:totalSimulations
            strategyNames{i} = '';
        end
        for iStrategyNumber=1:totalSimulations
            hittingStrat =  rem(iStrategyNumber-1, numHittingStrategies)+1;
            trackingStrat = fix((iStrategyNumber-1)/numHittingStrategies)+1;
            strategy = struct('hitting', hittingStrat, 'tracking', trackingStrat);
            strategyNames{iStrategyNumber} = sprintf('%s & %s',...
                handles.hittingNames{hittingStrat},...
                handles.trackingNames{trackingStrat});
            wins(iStrategyNumber) = StartGame(handles,...
                strategy,...
                pointsPerSimulation,...
                ballsInPlay,...
                realTime,...
                hwb,...
                iStrategyNumber,...
                totalSimulations);
            if wins(iStrategyNumber) == -1
                break;
            end
            
            
            % Make a bar chart to show data
            X = strategyNames;
            Y = wins;
            percentageY = Y/pointsPerSimulation*100;
            bar(handles.analysisAxes, percentageY);
            handles.analysisAxes.XTickLabelRotation	= 45;
            handles.analysisAxes.XTickLabel = X;
            handles.analysisAxes.YLim = [0, 110];
            handles.analysisAxes.YTick = 0:10:100;
            plotTitle = sprintf('Balls in Play: %.0f, Points per Simulation: %.0f', ballsInPlay, pointsPerSimulation);
            title(handles.analysisAxes, plotTitle,'FontSize',15);
            xlabel(handles.analysisAxes,'Strategy Type');
            ylabel(handles.analysisAxes,'Percentage Points Won');
            
            labels = num2cell(percentageY);
            text(handles.analysisAxes, 1:iStrategyNumber, percentageY(1:iStrategyNumber),...
                labels(1:iStrategyNumber),...
                'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'Black');
        end
        
        % Store data from the match
        %matchData.cpuStrategy = handles.baselineCPU;
        %matchData.ballsInPlay = ballsInPlay;
        %matchData.pointsPerSimulation = pointsPerSimulation;
        %matchData.wins = wins;
        %matchData.strategyNames = strategyNames;

    else
        strategy = struct('tracking', handles.trackingPopup.Value, 'hitting', handles.hittingPopup.Value);
        strategyName = sprintf('%s & %s',...
            handles.trackingNames{strategy.tracking},...
            handles.hittingNames{strategy.hitting});
        wins = StartGame(handles,...
            strategy,...
            pointsPerSimulation,...
            ballsInPlay,...
            realTime,...
            hwb,...
            1,...
            1);
        if wins ~= -1
            X = strategyName;
            Y = wins;
            bar(handles.analysisAxes, Y/pointsPerSimulation*100);
            handles.analysisAxes.XTickLabel = X;
            handles.analysisAxes.YLim = [0, 110];
            handles.analysisAxes.YTick = 0:10:100;
            plotTitle = sprintf('Balls in Play: %.0f, Points per Simulation: %.0f', ballsInPlay, pointsPerSimulation);
            title(handles.analysisAxes, plotTitle,'FontSize',15);
            xlabel(handles.analysisAxes,'Strategy Type');
            ylabel(handles.analysisAxes,'Number of Points Won');
        end
    end
    
    if ishandle(hwb)
        close(hwb);
    end
    enableControls(handles);
else
    disp('Sorry, game already running');
end


% --- Executes on button press in cancelSimulationButton.
function cancelSimulationButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelSimulationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cancelSimulation(handles);

function cancelSimulation(handles)
handles.gameRunning = false;
disp('Cancelling simulation');
guidata(gcbo, handles);
enableControls(handles);

% --- Executes on Callback of pointsPerSimulation
function pointsPerSimulationText_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
balls = str2double(hObject.String);
balls = max(min(balls, 10000), 1);
hObject.String = balls;
guidata(hObject, handles);

% --- Executes on button press in runAllStrategiesCheckbox.
function runAllStrategiesCheckbox_Callback(hObject, eventdata, handles)
if hObject.Value
    handles.trackingPopup.Enable = 'off';
    handles.hittingPopup.Enable = 'off';
else
    handles.trackingPopup.Enable = 'on';
    handles.hittingPopup.Enable = 'on';
end

function disableControls(handles)
handles.startButton.Enable = 'off';
handles.strat1popup.Enable = 'off';
handles.trackingPopup.Enable = 'off';
handles.hittingPopup.Enable = 'off';
handles.ballsInPlayPopup.Enable = 'off';
handles.pointsPerSimulationText.Enable = 'off';
handles.realTimeCheckbox.Enable = 'off';
handles.runAllStrategiesCheckbox.Enable = 'off';
guidata(gcbo, handles);

function enableControls(handles)
handles.startButton.Enable = 'on';
handles.strat1popup.Enable = 'on';
handles.ballsInPlayPopup.Enable = 'on';
handles.pointsPerSimulationText.Enable = 'on';
handles.runAllStrategiesCheckbox.Enable = 'on';
handles.realTimeCheckbox.Enable = 'on';
if handles.runAllStrategiesCheckbox.Value
    handles.trackingPopup.Enable = 'off';
    handles.hittingPopup.Enable = 'off';
else
    handles.trackingPopup.Enable = 'on';
    handles.hittingPopup.Enable = 'on';
end
guidata(gcbo, handles);
