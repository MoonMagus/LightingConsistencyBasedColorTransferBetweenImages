function varargout = LuminanceMatch(varargin)
% LUMINANCEMATCH MATLAB code for LuminanceMatch.fig
%      LUMINANCEMATCH, by itself, creates a new LUMINANCEMATCH or raises the existing
%      singleton*.
%
%      H = LUMINANCEMATCH returns the handle to a new LUMINANCEMATCH or the handle to
%      the existing singleton*.
%
%      LUMINANCEMATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUMINANCEMATCH.M with the given input arguments.
%
%      LUMINANCEMATCH('Property','Value',...) creates a new LUMINANCEMATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LuminanceMatch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LuminanceMatch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LuminanceMatch

% Last Modified by GUIDE v2.5 02-Jan-2015 19:40:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LuminanceMatch_OpeningFcn, ...
                   'gui_OutputFcn',  @LuminanceMatch_OutputFcn, ...
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


% --- Executes just before LuminanceMatch is made visible.
function LuminanceMatch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LuminanceMatch (see VARARGIN)

% 载入源图像和目标图像.
s = imread('西班牙大街.jpg');
t = imread('金湾寺.jpg');

% 设置图形框架对象属性.
set(hObject,'Name', '交互式辐照度迁移', ...
            'NumberTitle', 'Off', ...
            'Resize', 'Off', ...
            'Tag', 'HMfig', ...
            'Toolbar', 'None', ...
            'Units', 'Pixels', ...
            'Visible', 'Off');

% 设置各坐标轴对象的属性.
% 设置目标图像坐标轴.
ColorTargetHandle = findobj('Tag','ColorTargetAxis');
set(ColorTargetHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorTargetHandle);
imshow(t);
% 设置目标图像直方图坐标轴.
HistTargetHandle = findobj('Tag','HistTargetAxis');
set(HistTargetHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);
TargetPreprocessed = RGB2Lab(t);   
TargetChannelL = TargetPreprocessed(:,:,1);
axes(HistTargetHandle);
LuminanceData = mat2gray(TargetChannelL,[0 100]);
LuminanceData = im2uint8(LuminanceData);
imhist(LuminanceData);
histCount = imhist(LuminanceData);
% 设置目标图像辐照度坐标轴.                 
LuminanceTargetHandle = findobj('Tag','LuminanceTargetAxis');
set(LuminanceTargetHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceTargetHandle);
imshow(LuminanceData);
% 设置源图像坐标轴.
ColorSourceHandle = findobj('Tag','ColorSourceAxis');
set(ColorSourceHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorSourceHandle);
imshow(s);
% 设置源图像直方图坐标轴.
HistSourceHandle = findobj('Tag','HistSourceAxis');
set(HistSourceHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);  
SourcePreprocessed = RGB2Lab(s);   
SourceChannelL = SourcePreprocessed(:,:,1);
SourceChannelA = SourcePreprocessed(:,:,2);
SourceChannelB = SourcePreprocessed(:,:,3);
axes(HistSourceHandle);
LuminanceSource = mat2gray(SourceChannelL,[0 100]);
LuminanceSource = im2uint8(LuminanceSource);
axes(HistSourceHandle);
imhist(LuminanceSource);
% 设置源图像辐照度坐标轴.                  
LuminanceSourceHandle = findobj('Tag','LuminanceSourceAxis');
set(LuminanceSourceHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceSourceHandle);
imshow(LuminanceSource);
% 设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj('Tag','HistMatchedAxis');
set(HistMatchedHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);
histCount = mat2gray(histCount);
resultImage = histeq(LuminanceSource,histCount);
axes(HistMatchedHandle);
imhist(resultImage,256);
% 设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj('Tag','LuminanceMatchedAxis');
set(LuminanceMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImage = im2uint8(resultImageDouble);
axes(LuminanceMatchedHandle);
imshow(resultImage);
% 设置匹配图像坐标轴.
ColorMatchedHandle = findobj('Tag','ColorMatchedAxis');
set(ColorMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImageDouble = resultImageDouble*100;
Result_image = Lab2RGB(resultImageDouble,SourceChannelA,SourceChannelB);
axes(ColorMatchedHandle);
imshow(Result_image);
imwrite(Result_image,'色调迁移结果.jpg');
% Choose default command line output for LuminanceMatch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LuminanceMatch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LuminanceMatch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
