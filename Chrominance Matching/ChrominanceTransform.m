function [a ,b] = ChrominanceTransform(sl,sa,sb,tl,ta,tb)
% 将源图像的a,b通道值转换到目标通道的a,b值

%% 将源图像分成不同的亮度带进行处理.
[x1,y1] = size(sl);
SlData = reshape(sl,1,x1*y1);
[SlData, IndexLuminance] = sort(SlData);

% 计算源图像的色调特征矩阵.
% 计算阴影带的平均值和协方差矩阵.
SaShadowBand = sa(IndexLuminance(1:x1*y1/3));
SbShadowBand = sb(IndexLuminance(1:x1*y1/3));
SaShadowBand = reshape(SaShadowBand,1,floor(x1*y1/3));
SbShadowBand = reshape(SbShadowBand,1,floor(x1*y1/3));
usas = sum(SaShadowBand)/(x1*y1/3);
usbs = sum(SbShadowBand)/(x1*y1/3);
covssab = cov(SaShadowBand,SbShadowBand);
% 计算中间带的平均值和协方差矩阵.
SaMiddleBand = sa(IndexLuminance(x1*y1/3+1:2*x1*y1/3));
SbMiddleBand = sb(IndexLuminance(x1*y1/3+1:2*x1*y1/3));
[x,y]=size(SaMiddleBand);
SaMiddleBand = reshape(SaMiddleBand,1,x*y);
SbMiddleBand = reshape(SbMiddleBand,1,x*y);
usam = sum(SaMiddleBand)/(x1*y1/3);
usbm = sum(SbMiddleBand)/(x1*y1/3);
covsmab = cov(SaMiddleBand,SbMiddleBand);
% 计算高亮带的平均值和协方差矩阵.
SaHighBand = sa(IndexLuminance(2*x1*y1/3+1:x1*y1));
SbHighBand = sb(IndexLuminance(2*x1*y1/3+1:x1*y1));
SaHighBand = reshape(SaHighBand,1,floor(x1*y1/3));
SbHighBand = reshape(SbHighBand,1,floor(x1*y1/3));
usah = sum(SaHighBand)/(x1*y1/3);
usbh = sum(SbHighBand)/(x1*y1/3);
covshab = cov(SaHighBand,SbHighBand);

%% 将目标图像分成不同的亮度带进行处理.
[x2,y2] = size(tl);
TlData = reshape(tl,1,x2*y2);
[TlData, IndexLuminanceT] = sort(TlData);

% 计算源图像的色调特征矩阵.
% 计算阴影带的平均值和协方差矩阵.
TaShadowBand = ta(IndexLuminanceT(1:x2*y2/3));
TbShadowBand = tb(IndexLuminanceT(1:x2*y2/3));
TaShadowBand = reshape(TaShadowBand,1,floor(x2*y2/3));
TbShadowBand = reshape(TbShadowBand,1,floor(x2*y2/3));
utas = sum(TaShadowBand)/(x2*y2/3);
utbs = sum(TbShadowBand)/(x2*y2/3);
covtsab = cov(TaShadowBand,TbShadowBand);
% 计算中间带的平均值和协方差矩阵.
TaMiddleBand = ta(IndexLuminanceT(x2*y2/3+1:2*x2*y2/3));
TbMiddleBand = tb(IndexLuminanceT(x2*y2/3+1:2*x2*y2/3));
TaMiddleBand = reshape(TaMiddleBand,1,floor(x2*y2/3));
TbMiddleBand = reshape(TbMiddleBand,1,floor(x2*y2/3));
utam = sum(TaMiddleBand)/(x2*y2/3);
utbm = sum(TbMiddleBand)/(x2*y2/3);
covtmab = cov(TaMiddleBand,TbMiddleBand);
% 计算高亮带的平均值和协方差矩阵.
TaHighBand = ta(IndexLuminanceT(2*x2*y2/3+1:x2*y2));
TbHighBand = tb(IndexLuminanceT(2*x2*y2/3+1:x2*y2));
TaHighBand = reshape(TaHighBand,1,floor(x2*y2/3));
TbHighBand = reshape(TbHighBand,1,floor(x2*y2/3));
utah = sum(TaHighBand)/(x2*y2/3);
utbh = sum(TbHighBand)/(x2*y2/3);
covthab = cov(TaHighBand,TbHighBand);

% 计算不同亮度带的变换矩阵.
ShadowTransformMatrix = covssab^(-1/2)*(covssab^(1/2)*covtsab*covssab^(1/2))^(1/2)*covssab^(-1/2);
MiddleTransformMatrix = covsmab^(-1/2)*(covsmab^(1/2)*covtmab*covsmab^(1/2))^(1/2)*covsmab^(-1/2);
HighTransformMatrix = covshab^(-1/2)*(covshab^(1/2)*covthab*covshab^(1/2))^(1/2)*covshab^(-1/2);

% 计算变换后的不同亮度带a,b值.
% 计算阴影带变换后的a,b值.
TransformShadowData = [SaShadowBand - usas;SbShadowBand - usbs];
MatrixShadow = ShadowTransformMatrix*TransformShadowData;
sa(IndexLuminance(1:x1*y1/3)) = MatrixShadow(1,:) + utas;
sb(IndexLuminance(1:x1*y1/3)) = MatrixShadow(2,:) + utbs;
% 计算中间带变换后的a,b值.
TransformMiddleData = [SaMiddleBand - usam;SbMiddleBand - usbm];
MatrixMiddle = MiddleTransformMatrix*TransformMiddleData;
sa(IndexLuminance(x1*y1/3+1:2*x1*y1/3)) = MatrixMiddle(1,:) + utam;
sb(IndexLuminance(x1*y1/3+1:2*x1*y1/3)) = MatrixMiddle(2,:) + utbm;
% 计算高亮带变换后的a,b值.
TransformHighData = [SaHighBand - usah;SbHighBand - usbh];
MatrixHigh = HighTransformMatrix*TransformHighData;
sa(IndexLuminance(2*x1*y1/3+1:x1*y1)) = MatrixHigh(1,:) + utah;
sb(IndexLuminance(2*x1*y1/3+1:x1*y1)) = MatrixHigh(2,:) + utbh;
a = sa;
b = sb;











