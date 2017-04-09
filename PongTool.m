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

% Last Modified by GUIDE v2.5 08-Apr-2017 19:59:05

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PongTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);
configureAxes(handles)


% --- Outputs from this function are returned to the command line.
function varargout = PongTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
StartGame(handles);
