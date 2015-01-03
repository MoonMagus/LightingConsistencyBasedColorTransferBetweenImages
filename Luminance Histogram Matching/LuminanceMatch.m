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

% Last Modified by GUIDE v2.5 03-Jan-2015 23:24:33

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

%% 设置下拉菜单属性.
dirs1 = dir('*.jpg');
dirs2 = dir('*.bmp');
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
[x,y] = size(filenames);
if x > 0 
    ListImage = char(filenames(1));
else
    ListImage = '';
end
for i = 2:x
    ListImage = strcat(ListImage,'|',char(filenames(i)));
end
SourceImagePopHandle = findobj('Tag','SourcePopMenu');
for i=1:x
    if strcmp(char(filenames(i)),'云南.jpg')==1
        break;
    end
end
set(SourceImagePopHandle,'String',ListImage);
set(SourceImagePopHandle,'UserData',filenames);
set(SourceImagePopHandle,'Value',i);
TargetImagePopHandle = findobj('Tag','TargetPopMenu');
for j=1:x
    if strcmp(char(filenames(j)),'马尔代夫.jpg') == 1
        break;
    end
end
set(TargetImagePopHandle,'String',ListImage);
set(TargetImagePopHandle,'UserData',filenames);
set(TargetImagePopHandle,'Value',j);

%% 设置图像框架属性.
handles.ImageHandle = hObject;
handles.SourcePopHandle = SourceImagePopHandle;
handles.TargetPopHandle = TargetImagePopHandle;

%% 载入源图像和目标图像.
s = imread('云南.jpg');
t = imread('马尔代夫.jpg');
handles.CurrentSource = '云南.jpg';
handles.CurrentTarget = '马尔代夫.jpg';
handles = PlotAxis(handles,s,t);
%% Choose default command line output for LuminanceMatch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LuminanceMatch wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% 各坐标轴对象绘制函数.
function handle = PlotAxis(handles,s,t)
% 此函数用于根据源图像和目标图像绘制各坐标轴对象.
%  设置目标图像坐标轴.
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
    ColorTargetHandle = handles.ColorTargetHandle;
end
set(ColorTargetHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorTargetHandle);
imshow(t);
% 设置目标图像直方图坐标轴.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
    HistTargetHandle = handles.HistTargetHandle;
end
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
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
set(LuminanceTargetHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceTargetHandle);
imshow(LuminanceData);
% 设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
set(ColorSourceHandle,'Units','Pixels',...
                      'XTick',[],...
                      'YTick',[]);
axes(ColorSourceHandle);
imshow(s);
% 设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
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
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
set(LuminanceSourceHandle, 'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
axes(LuminanceSourceHandle);
imshow(LuminanceSource);
% 设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
set(HistMatchedHandle,'Units','Pixels',...
                     'XTick',[],...
                     'YTick',[]);
histCount = mat2gray(histCount);
resultImage = histeq(LuminanceSource,histCount);
axes(HistMatchedHandle);
imhist(resultImage,256);
% 设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
set(LuminanceMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImage = im2uint8(resultImageDouble);
axes(LuminanceMatchedHandle);
imshow(resultImage);
% 设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
set(ColorMatchedHandle,'Units','Pixels',...
                           'XTick',[],...
                           'YTick',[]);
resultImageDouble = mat2gray(resultImage,[0 255]);
resultImageDouble = resultImageDouble*100;
Result_image = Lab2RGB(resultImageDouble,SourceChannelA,SourceChannelB);
axes(ColorMatchedHandle);
imshow(Result_image);
imwrite(Result_image,'色调迁移结果.jpg');
handle = handles;

%% --- Outputs from this function are returned to the command line.
function varargout = LuminanceMatch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% 源图像下拉菜单回调函数.
function SourcePopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SourceImagePopHandle = findobj(gcf,'Tag','SourcePopMenu');
ListName = get(SourceImagePopHandle,'UserData');
sname = char(ListName(get(SourceImagePopHandle,'Value')));
s = imread(sname);
TargetImagePopHandle = findobj(gcf,'Tag','TargetPopMenu');
ListName = get(TargetImagePopHandle,'UserData');
tname = char(ListName(get(TargetImagePopHandle,'Value')));
t = imread(tname);
% tname = handles.CurrentTarget;
% t = imread(tname);
handles.CurrentSource = sname;
PlotAxis(handles,s,t);
% Hints: contents = cellstr(get(hObject,'String')) returns SourcePopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourcePopMenu


%% 源图像下拉菜单初始化函数.
function SourcePopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in TargetPopMenu.
function TargetPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SourceImagePopHandle = findobj(gcf,'Tag','SourcePopMenu');
ListName = get(SourceImagePopHandle,'UserData');
sname = char(ListName(get(SourceImagePopHandle,'Value')));
s = imread(sname);
TargetImagePopHandle = findobj(gcf,'Tag','TargetPopMenu');
ListName = get(TargetImagePopHandle,'UserData');
tname = char(ListName(get(TargetImagePopHandle,'Value')));
t = imread(tname);
handles.CurrentTarget = tname;
PlotAxis(handles,s,t);
% Hints: contents = cellstr(get(hObject,'String')) returns TargetPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TargetPopMenu


%% --- Executes during object creation, after setting all properties.
function TargetPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
