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

%% Variables relating to gui input values
% Hitting strategy
handles.hitting = struct('conservative', 1, 'balanced', 2', 'aggressive', 3);
handles.hittingNames = handles.hittingPopup.String;

% Tracking strategy
handles.tracking = struct('focused', 1, 'proximity', 2, 'threat', 3);
handles.trackingNames = handles.trackingPopup.String;

% Multiball variables
handles.singleBall = 1;
handles.multiBall3 = 2;
handles.multiBall5 = 3;
handles.numberofBalls = [1, 3, 5];

%% Game constants
% Baseline CPU Strategies
handles.baselineCPU = struct(...
    'hitting', handles.hitting.conservative,...
    'tracking', handles.tracking.focused);

% Delay time between each ball spawn at the start of a multiball game
handles.multiBallDelay = 1.25; %(seconds)

% Horizontal pixel offset of each player from the center of the board
handles.leftOffset = -180;
handles.rightOffset = -handles.leftOffset;

% Pixel offset of the Score Text from the center of the board
handles.scoreTextY = 100;
handles.scoreTextX = 110;

% Pixel size of each quarter of the board
handles.quarterSize = struct('width', 200, 'height', 125);

% Paddle and Ball sizes
handles.paddleWidth = 10;
handles.paddleHeight = 60;
handles.ballSize = 8;

% Maximum paddle speed
handles.paddleSpeed = 150;

% Initial ball acceleration damping factor
handles.ballAccelerationDamping = 50;

% Frames per second to run all 'real-time' simulations
handles.fps = 30;
handles.frameLength = 1/handles.fps;

%% Set up game board and variables

% Prevent two games from running at once
handles.gameRunning = false;

% Debugging mode prints out extra stuff to console
handles.debugging = false;

% Adds vertical lines to board
configureAxes(handles);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PongTool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in startButton.
% Main function that is executed to start a simulation
function startButton_Callback(hObject, eventdata, handles)
%% Pre simulation setup
% Reset Console and GUI axes
clc;
cla(handles.analysisAxes,'reset');

% Disable controls all so they can't be altered by the user during the
% simulation
disableControls(handles);

% Read in simulation data from handles
pointsPerSimulation = str2double(handles.pointsPerSimulationText.String);
ballsInPlay = handles.numberofBalls(handles.ballsInPlayPopup.Value);
realTime = handles.realTimeCheckbox.Value;

% Create simulation waitbar
hwb = waitbar(0, 'Waiting...');
hwb.NumberTitle = 'off';
hwb.Name = 'Simulation Progress';

%% Check how many simulations to run (all or just 1)
if handles.runAllStrategiesCheckbox.Value % Run all strategy combination simulations
    %% Calculate strategy information
    numTrackingStrategies = numel(fieldnames(handles.tracking));
    numHittingStrategies = numel(fieldnames(handles.hitting));
    totalSimulations = numTrackingStrategies*numHittingStrategies;
    
    %Initialize wins array and strategyNames cell array
    wins = zeros(1, totalSimulations);
    for i=1:totalSimulations
        strategyNames{i} = '';
    end
    
    %% Loop through all strategy combinations
    for iStrategyNumber=1:totalSimulations
        % Calculate which hitting and tracking strategy to use
        hittingStrat =  rem(iStrategyNumber-1, numHittingStrategies)+1;
        trackingStrat = fix((iStrategyNumber-1)/numHittingStrategies)+1;
        strategy = struct('hitting', hittingStrat, 'tracking', trackingStrat);
        
        % concatenate strategies into a single strategy name
        strategyNames{iStrategyNumber} = sprintf('%s & %s',...
            handles.hittingNames{hittingStrat},...
            handles.trackingNames{trackingStrat});
        
        %% Run one simulation given the calculated parameters
        wins(iStrategyNumber) = StartGame(handles,...
            strategy,...
            pointsPerSimulation,...
            ballsInPlay,...
            realTime,...
            hwb,...
            iStrategyNumber,...
            totalSimulations);
        
        % If simulation ended unexceptedly terminate full simulation set
        if wins(iStrategyNumber) == -1
            break;
        end
        
        
        %% Make a bar chart to show win data for each strategy combination
        X = strategyNames;
        Y = wins;
        
        % Format data as a percent of points won
        yPercentage = Y/pointsPerSimulation*100;
        bar(handles.analysisAxes, yPercentage);
        
        % Format bar chart
        handles.analysisAxes.XTickLabelRotation	= 45;
        handles.analysisAxes.XTickLabel = X;
        handles.analysisAxes.YLim = [0, 110];
        handles.analysisAxes.YTick = 0:10:100;
        plotTitle = sprintf('Balls in Play: %.0f, Points per Simulation: %.0f', ballsInPlay, pointsPerSimulation);
        title(handles.analysisAxes, plotTitle,'FontSize',15);
        xlabel(handles.analysisAxes,'Strategy Type');
        ylabel(handles.analysisAxes,'Percentage Points Won');
        
        % Add data labels to each bar
        labels = num2cell(yPercentage);
        text(handles.analysisAxes, 1:iStrategyNumber, yPercentage(1:iStrategyNumber),...
            labels(1:iStrategyNumber),...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'Black');
    end
else %Run single strategy simulation (same process as above for all strategies)
    % Manually draw strategies from handles
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
        yPercentage = Y/pointsPerSimulation*100;
        bar(handles.analysisAxes, yPercentage);
        handles.analysisAxes.XTickLabel = X;
        handles.analysisAxes.YLim = [0, 110];
        handles.analysisAxes.YTick = 0:10:100;
        plotTitle = sprintf('Balls in Play: %.0f, Points per Simulation: %.0f', ballsInPlay, pointsPerSimulation);
        title(handles.analysisAxes, plotTitle,'FontSize',15);
        xlabel(handles.analysisAxes,'Strategy Type');
        ylabel(handles.analysisAxes,'Number of Points Won');
        
        labels = num2cell(yPercentage);
        text(handles.analysisAxes, 1, yPercentage, labels,...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'Black');
    end
end

%% Post game wrap up
% Close waitbar object
if ishandle(hwb)
    close(hwb);
end

% Reenable controls
enableControls(handles);


% --- Executes on button press in cancelSimulationButton.
function cancelSimulationButton_Callback(hObject, eventdata, handles)
cancelSimulation(handles);

function cancelSimulation(handles)
handles.gameRunning = false;
disp('Cancelling simulation');
enableControls(handles);

% --- Executes on Callback of pointsPerSimulation
% ensures a valid number is entered in the text ball for pointsPerSimulation
function pointsPerSimulationText_Callback(hObject, eventdata, handles)
balls = str2double(hObject.String);
balls = max(min(balls, 10000), 1);
hObject.String = balls;
guidata(hObject, handles);

% --- Executes on button press in runAllStrategiesCheckbox.
function runAllStrategiesCheckbox_Callback(hObject, eventdata, handles)
% If checked, disables the strategy popup controls
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
