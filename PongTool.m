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

% Last Modified by GUIDE v2.5 19-Apr-2017 00:00:17

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

handles.conservative = 1;
handles.balanced = 2;
handles.aggressive = 3;
handles.berserk = 4;
handles.strategies = handles.strat2popup.String;
%{'Conservative', 'Balanced', 'Aggressive', 'Berserk'};

handles.singleBall = 1;
handles.multiBall3 = 2;
handles.multiBall5 = 3;
handles.numberofBalls = [1, 3, 5];

handles.leftOffset = -180;
handles.rightOffset = -handles.leftOffset;

handles.scoreTextY = 100;
handles.scoreTextX = 110;

handles.paddleWidth = 10;
handles.paddleHeight = 60;
handles.ballSize = 8;

handles.paddleSpeed = 70;

handles.quarterSize = struct('width', 200, 'height', 125);

handles.gameRunning = false;

handles.fps = 30;
handles.frameLength = 1/handles.fps;

handles.ballsPerSimulation = 3;

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
    cla(handles.singleballAxes,'reset')
    ballsPerSimulation = str2double(handles.ballsPerSimulationText.String);
    if handles.runAllStrategiesCheckbox.Value
        totalSimulations = length(handles.strategies);
        wins = zeros(1, length(handles.strategies));
        hwb = waitbar(0, 'Waiting...');
        hwb.NumberTitle = 'off';
        hwb.Name = 'Multi-Simulation Progress';
        for iStrategyNumber=1:totalSimulations
            if ishandle(hwb)
                waitbar(iStrategyNumber/totalSimulations, hwb,...
                    ['Simulation ', num2str(iStrategyNumber), ' out of ', num2str(totalSimulations), ': ',...
                    handles.strategies{iStrategyNumber}]);
            else
                break;
            end
            wins(iStrategyNumber) = StartGame(handles,...
                handles.strat1popup.Value,...
                iStrategyNumber,...
                ballsPerSimulation,...
                handles.numberofBalls(handles.ballsInPlayPopup.Value),...
                handles.realTimeCheckbox.Value);
            if wins(iStrategyNumber) == -1
                break;
            end
            X = handles.strategies;
            Y = (wins / ballsPerSimulation) * 100;
            bar(handles.singleballAxes, Y);
            handles.singleballAxes.XTickLabel = X;
            handles.singleballAxes.YLim = [0, 100];
            xlabel('Strategy Type');
            ylabel('Percent of Points Won');
        end
        if ishandle(hwb)
            close(hwb);
        end
    else
        strategyNumber = handles.strat2popup.Value;
        wins = StartGame(handles,...
            handles.strat1popup.Value,...
            strategyNumber,...
            ballsPerSimulation,...
            handles.numberofBalls(handles.ballsInPlayPopup.Value),...
            handles.realTimeCheckbox.Value);
        if wins ~= -1
            X = handles.strategies{strategyNumber};
            Y = (wins / ballsPerSimulation) * 100;
            bar(handles.singleballAxes, Y);
            handles.singleballAxes.XTickLabel = X;
            handles.singleballAxes.YLim = [0, 100];
            xlabel('Strategy Type');
            ylabel('Percent of Points Won');
        end
    end
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

% --- Executes on Callback of ballsPerSimulation
function ballsPerSimulationText_Callback(hObject, eventdata, handles)
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
    handles.strat2popup.Enable = 'off';
else
    handles.strat2popup.Enable = 'on';
end
