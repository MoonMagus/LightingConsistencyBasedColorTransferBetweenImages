function varargout = ColorGrading(varargin)
%COLORGRADING M-file for ColorGrading.fig
%      COLORGRADING, by itself, creates a new COLORGRADING or raises the existing
%      singleton*.
%
%      H = COLORGRADING returns the handle to a new COLORGRADING or the handle to
%      the existing singleton*.
%
%      COLORGRADING('Property','Value',...) creates a new COLORGRADING using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ColorGrading_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      COLORGRADING('CALLBACK') and COLORGRADING('CALLBACK',hObject,...) call the
%      local function named CALLBACK in COLORGRADING.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ColorGrading

% Last Modified by GUIDE v2.5 14-Jan-2015 22:16:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColorGrading_OpeningFcn, ...
                   'gui_OutputFcn',  @ColorGrading_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before ColorGrading is made visible.
function ColorGrading_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%%
set(hObject,'Name','辐照度直方图迁移');

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
handles.GaussFilterHandle = findobj('Tag','GaussFilter');
handles.SigmaTextHandle = findobj('Tag','SigmaText');
handles.WidthTextHandle = findobj('Tag','WidthText');
handles.HeightTextHandle = findobj('Tag','HeightText');
handles.HueSyncHandle = findobj('Tag','HueSync');
handles.TargetPanelHandle = findobj('Tag','TargetPanel');
handles.ColorTargetAxisHandle = findobj('Tag','ColorTargetAxis');
handles.HistTargetAxisHandle = findobj('Tag','HistTargetAxis');
handles.LuminanceTargetAxisHandle = findobj('Tag','LuminanceTargetAxis');
handles.SourcePanelHandle = findobj('Tag','SourcePanel');
handles.ColorSourceAxisHandle = findobj('Tag','ColorSourceAxis');
handles.HistSourceAxisHandle = findobj('Tag','HistSourceAxis');
handles.LuminanceSourceAxisHandle = findobj('Tag','LuminanceSourceAxis');
handles.ResultPanelHandle = findobj('Tag','ResultPanel');
handles.ColorMatchedAxisHandle = findobj('Tag','ColorMatchedAxis');
handles.HistMatchedAxisHandle = findobj('Tag','HistMatchedAxis');
handles.LuminanceMatchedAxisHandle = findobj('Tag','LuminanceMatchedAxis');


%% 载入源图像和目标图像.
s = imread('云南.jpg');
t = imread('马尔代夫.jpg');
handles.CurrentSource = '云南.jpg';
handles.CurrentTarget = '马尔代夫.jpg';
handles = PlotAxis(handles,s,t);

%% Choose default command line output for ColorGrading
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ColorGrading wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ColorGrading_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% 各坐标轴对象绘制函数.
function handle = PlotAxis(handles,s,t)
% 此函数用于根据源图像和目标图像绘制各坐标轴对象.
% 载入目标图像和源图像.
TargetPreprocessed = RGB2Lab(t);   
TargetChannelL = TargetPreprocessed(:,:,1);
TargetChannelA = TargetPreprocessed(:,:,2);
TargetChannelB = TargetPreprocessed(:,:,3);
SourcePreprocessed = RGB2Lab(s);   
SourceChannelL = SourcePreprocessed(:,:,1);
SourceChannelA = SourcePreprocessed(:,:,2);
SourceChannelB = SourcePreprocessed(:,:,3);


% 设置目标图像坐标轴.
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
handles.TargetImage = t;
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
axes(HistTargetHandle);
LuminanceData = mat2gray(TargetChannelL,[0 100]);
LuminanceData = im2uint8(LuminanceData);
imhist(LuminanceData);
histCount = imhist(LuminanceData);
handles.LuminanceData = LuminanceData;
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
handles.LuminanceData = LuminanceData;

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
handles.SourceImage = s;
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
LuminanceSource = mat2gray(SourceChannelL,[0 100]);
LuminanceSource = im2uint8(LuminanceSource);
axes(HistSourceHandle);
imhist(LuminanceSource);
handles.LuminanceSource = LuminanceSource;
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
handles.ResultImage = resultImage;
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

%检测是否执行色调同步.
HueSyncHandle = findobj(CurrentImage,'Tag','HueSync');
if size(HueSyncHandle) ~= 0
   handles.HueSyncHandle = HueSyncHandle; 
else 
   HueSyncHandle =  handles.HueSyncHandle;
end
HueSyncSwitch = get(HueSyncHandle,'Value');
if HueSyncSwitch == 1
[SourceChannelA , SourceChannelB] = ...
ChrominanceTransform(SourceChannelL,...
                     SourceChannelA,...
                     SourceChannelB,...
                     TargetChannelL,...
                     TargetChannelA,...
                     TargetChannelB);
end
Result_image = Lab2RGB(resultImageDouble,SourceChannelA,SourceChannelB);

%获取过滤器的参数值.
GaussFilterHandle = findobj(CurrentImage,'Tag','GaussFilter');
if size(GaussFilterHandle) ~= 0
   handles.GaussFilterHandle = GaussFilterHandle; 
else 
   GaussFilterHandle =  handles.GaussFilterHandle;
end
FilterSwitch = get(GaussFilterHandle,'Value');
if FilterSwitch == 1 
    SigmaTextHandle = findobj(CurrentImage,'Tag','SigmaText');
    if size(SigmaTextHandle) ~= 0
       handles.SigmaTextHandle = SigmaTextHandle; 
    else 
       SigmaTextHandle = handles.SigmaTextHandle;
    end
    sigma = get(SigmaTextHandle,'String');
    WidthTextHandle = findobj(CurrentImage,'Tag','WidthText');
    if size(WidthTextHandle) ~= 0
       handles.WidthTextHandle = WidthTextHandle; 
    else 
       WidthTextHandle = handles.WidthTextHandle;
    end
    width = get(WidthTextHandle,'String');
    HeightTextHandle = findobj(CurrentImage,'Tag','HeightText');
    if size(HeightTextHandle) ~= 0
       handles.HeightTextHandle = HeightTextHandle; 
    else 
       HeightTextHandle = handles.HeightTextHandle;
    end
    height = get(HeightTextHandle,'String'); 
    sizef = [double(width) double(height)];
    sigma = str2double(sigma);
    gausFilter = fspecial('gaussian',sizef,sigma);
    Result_image = imfilter(Result_image,gausFilter,'replicate');
end
axes(ColorMatchedHandle);
imshow(Result_image);
handles.Result_image = Result_image;
imwrite(Result_image,'色调迁移结果.jpg');
handle = handles;
guidata(CurrentImage,handles);


% --- Executes on selection change in SourcePopMenu.
function SourcePopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SourcePopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourcePopMenu


% --- Executes during object creation, after setting all properties.
function SourcePopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcePopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TargetPopMenu.
function TargetPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TargetPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TargetPopMenu


% --- Executes during object creation, after setting all properties.
function TargetPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargetPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BeginButton.
function BeginButton_Callback(hObject, eventdata, handles)
% hObject    handle to BeginButton (see GCBO)
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
PlotAxis(handles,s,t);


% --- Executes on slider movement.
function WidthSlider_Callback(hObject, eventdata, handles)
% hObject    handle to WidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WidthValue = get(hObject,'Value');
WidthTextHandle = findobj(gcf,'Tag','WidthText');
set(WidthTextHandle,'String',ceil(WidthValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function WidthSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WidthSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function HeightSlider_Callback(hObject, eventdata, handles)
% hObject    handle to HeightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HeightValue = get(hObject,'Value');
HeightTextHandle = findobj(gcf,'Tag','HeightText');
set(HeightTextHandle,'String',ceil(HeightValue));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function HeightSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HeightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function WidthText_Callback(hObject, eventdata, handles)
% hObject    handle to WidthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WidthValue = get(hObject,'String');
WidthSliderHandle = findobj(gcf,'Tag','WidthSlider');
set(WidthSliderHandle,'Value',ceil(str2double(WidthValue)));
% Hints: get(hObject,'String') returns contents of WidthText as text
%        str2double(get(hObject,'String')) returns contents of WidthText as a double


% --- Executes during object creation, after setting all properties.
function WidthText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WidthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HeightText_Callback(hObject, eventdata, handles)
% hObject    handle to HeightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HeightValue = get(hObject,'String');
HeightSliderHandle = findobj(gcf,'Tag','HeightSlider');
set(HeightSliderHandle,'Value',ceil(str2double(HeightValue)));
% Hints: get(hObject,'String') returns contents of HeightText as text
%        str2double(get(hObject,'String')) returns contents of HeightText as a double


% --- Executes during object creation, after setting all properties.
function HeightText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HeightText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GaussFilter.
function GaussFilter_Callback(hObject, eventdata, handles)
% hObject    handle to GaussFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GaussFilter



function SigmaText_Callback(hObject, eventdata, handles)
% hObject    handle to SigmaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SigmaText as text
%        str2double(get(hObject,'String')) returns contents of SigmaText as a double


% --- Executes during object creation, after setting all properties.
function SigmaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SigmaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HueSync.
function HueSync_Callback(hObject, eventdata, handles)
% hObject    handle to HueSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HueSync


%% --- Executes on button press in DetailButton.
function DetailButton_Callback(hObject, eventdata, handles)
% hObject    handle to DetailButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ContrastButtonHandle = findobj('Tag','ContrastButton');
ContrastButtonValue = get(ContrastButtonHandle,'Value');
if ContrastButtonValue ==1
   set(ContrastButtonHandle,'Value',0);
end
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
%设置目标源图像坐标轴.
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
   ColorTargetHandle = handles.ColorTargetHandle;
end
axes(ColorTargetHandle);
cla reset;
set(ColorTargetHandle,'Visible','on');
TargetImage = handles.TargetImage;
imshow(TargetImage);
%设置目标直方图.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
   HistTargetHandle = handles.HistTargetHandle;
end
axes(HistTargetHandle);
cla reset;
set(HistTargetHandle,'Visible','on');
LuminanceData = handles.LuminanceData;
imhist(LuminanceData);
%设置目标辐照图坐标轴.
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
axes(LuminanceTargetHandle);
cla reset;
set(LuminanceTargetHandle,'Visible','on');
imshow(LuminanceData);
%设置目标面板.
TargetPanelHandle = findobj('Tag','TargetPanel');
if size(TargetPanelHandle) ~= 0
   handles.TargetPanelHandle = TargetPanelHandle; 
else 
   TargetPanelHandle = handles.TargetPanelHandle;
end
set(TargetPanelHandle,'Visible','on');

%设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
axes(ColorSourceHandle);
cla reset;
set(ColorSourceHandle,'Visible','on');
SourceImage = handles.SourceImage;
imshow(SourceImage);
%设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
axes(HistSourceHandle);
cla reset;
set(HistSourceHandle,'Visible','on');
LuminanceSource = handles.LuminanceSource;
imhist(LuminanceSource);
%设置源图像辐照度坐标轴.
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
axes(LuminanceSourceHandle);
cla reset;
set(LuminanceSourceHandle,'Visible','on')
imshow(LuminanceSource);
% 设置源面板.
SourcePanelHandle = findobj('Tag','SourcePanel');
if size(SourcePanelHandle) ~= 0
   handles.SourcePanelHandle = SourcePanelHandle; 
else 
   SourcePanelHandle = handles.SourcePanelHandle;
end
set(SourcePanelHandle,'Visible','on');

%设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
axes(ColorMatchedHandle);
cla reset;
set(ColorMatchedHandle,'Visible','on');
ResultImage = handles.Result_image;
imshow(ResultImage);
%设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
axes(HistMatchedHandle);
cla reset;
set(HistMatchedHandle,'Visible','on');
TargetLuminance = handles.ResultImage;
imhist(TargetLuminance);
%设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
axes(LuminanceMatchedHandle);
cla reset;
set(LuminanceMatchedHandle,'Visible','on');
imshow(TargetLuminance);
% 设置匹配面板.
ResultPanelHandle = findobj('Tag','ResultPanel');
if size(ResultPanelHandle) ~= 0
   handles.ResultPanelHandle = ResultPanelHandle; 
else 
   ResultPanelHandle = handles.ResultPanelHandle;
end
set(ResultPanelHandle,'Visible','on');

% Hint: get(hObject,'Value') returns toggle state of DetailButton


%% --- Executes on button press in ContrastButton.
function ContrastButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContrastButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DetailButtonHandle = findobj('Tag','DetailButton');
DetailButtonValue = get(DetailButtonHandle,'Value');
if DetailButtonValue ==1
   set(DetailButtonHandle,'Value',0);
end
CurrentImage = handles.ImageHandle;
figure(CurrentImage);
%设置目标源图像坐标轴.
ColorTargetHandle = findobj(CurrentImage,'Tag','ColorTargetAxis');
if size(ColorTargetHandle) ~= 0
   handles.ColorTargetHandle = ColorTargetHandle; 
else 
    ColorTargetHandle = handles.ColorTargetHandle;
end
axes(ColorTargetHandle);
cla reset;
set(ColorTargetHandle,'Visible','off');
%设置目标直方图.
HistTargetHandle = findobj(CurrentImage,'Tag','HistTargetAxis');
if size(HistTargetHandle) ~= 0
   handles.HistTargetHandle = HistTargetHandle; 
else 
    HistTargetHandle = handles.HistTargetHandle;
end
axes(HistTargetHandle);
cla reset;
set(HistTargetHandle,'Visible','off');
%设置目标辐照图坐标轴.
LuminanceTargetHandle = findobj(CurrentImage,'Tag','LuminanceTargetAxis');
if size(LuminanceTargetHandle) ~= 0
   handles.LuminanceTargetHandle = LuminanceTargetHandle; 
else 
    LuminanceTargetHandle = handles.LuminanceTargetHandle;
end
axes(LuminanceTargetHandle);
cla reset;
set(LuminanceTargetHandle,'Visible','off');
%设置目标面板.
TargetPanelHandle = findobj('Tag','TargetPanel');
if size(TargetPanelHandle) ~= 0
   handles.TargetPanelHandle = TargetPanelHandle; 
else 
   TargetPanelHandle = handles.TargetPanelHandle;
end
set(TargetPanelHandle,'Visible','off');

%设置源图像坐标轴.
ColorSourceHandle = findobj(CurrentImage,'Tag','ColorSourceAxis');
if size(ColorSourceHandle) ~= 0
   handles.ColorSourceHandle = ColorSourceHandle; 
else 
    ColorSourceHandle = handles.ColorSourceHandle;
end
axes(ColorSourceHandle);
cla reset;
set(ColorSourceHandle,'Visible','off');
%设置源图像直方图坐标轴.
HistSourceHandle = findobj(CurrentImage,'Tag','HistSourceAxis');
if size(HistSourceHandle) ~= 0
   handles.HistSourceHandle = HistSourceHandle; 
else 
    HistSourceHandle = handles.HistSourceHandle;
end
axes(HistSourceHandle);
cla reset;
set(HistSourceHandle,'Visible','off');
%设置源图像辐照度坐标轴.
LuminanceSourceHandle = findobj(CurrentImage,'Tag','LuminanceSourceAxis');
if size(LuminanceSourceHandle) ~= 0
   handles.LuminanceSourceHandle = LuminanceSourceHandle; 
else 
    LuminanceSourceHandle = handles.LuminanceSourceHandle;
end
axes(LuminanceSourceHandle);
cla reset;
set(LuminanceSourceHandle,'Visible','off')
% 设置源面板.
SourcePanelHandle = findobj('Tag','SourcePanel');
if size(SourcePanelHandle) ~= 0
   handles.SourcePanelHandle = SourcePanelHandle; 
else 
   SourcePanelHandle = handles.SourcePanelHandle;
end
set(SourcePanelHandle,'Visible','off');
%设置匹配图像坐标轴.
ColorMatchedHandle = findobj(CurrentImage,'Tag','ColorMatchedAxis');
if size(ColorMatchedHandle) ~= 0
   handles.ColorMatchedHandle = ColorMatchedHandle; 
else 
    ColorMatchedHandle = handles.ColorMatchedHandle;
end
axes(ColorMatchedHandle);
cla reset;
set(ColorMatchedHandle,'Visible','off');
%设置匹配图像直方图坐标轴.
HistMatchedHandle = findobj(CurrentImage,'Tag','HistMatchedAxis');
if size(HistMatchedHandle) ~= 0
   handles.HistMatchedHandle = HistMatchedHandle; 
else 
    HistMatchedHandle = handles.HistMatchedHandle;
end
axes(HistMatchedHandle);
cla reset;
set(HistMatchedHandle,'Visible','off');
%设置匹配图像辐照度坐标轴.
LuminanceMatchedHandle = findobj(CurrentImage,'Tag','LuminanceMatchedAxis');
if size(LuminanceMatchedHandle) ~= 0
   handles.LuminanceMatchedHandle = LuminanceMatchedHandle; 
else 
    LuminanceMatchedHandle = handles.LuminanceMatchedHandle;
end
axes(LuminanceMatchedHandle);
cla reset;
set(LuminanceMatchedHandle,'Visible','off');
% 设置匹配面板.
ResultPanelHandle = findobj('Tag','ResultPanel');
if size(ResultPanelHandle) ~= 0
   handles.ResultPanelHandle = ResultPanelHandle; 
else 
   ResultPanelHandle = handles.ResultPanelHandle;
end
set(ResultPanelHandle,'Visible','off');















% Hint: get(hObject,'Value') returns toggle state of ContrastButton
