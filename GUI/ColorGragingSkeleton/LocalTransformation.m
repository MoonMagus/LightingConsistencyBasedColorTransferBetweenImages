function [WholeLuminOnlyResult, WholeHueSynResult, LuminaOnlyResult, HueSynResult,rs ,rt, ls, lsh, lt, lth, lr, lrh, SynSL, SynRL] = LocalTransformation(Target, Source, OpenMatteT, OpenMatteS, MatteT, MatteS)
%%-----------------------------------------------------------------------
% 对图像对的蒙版区域进行局部变换:
%     Target : 目标图像.
%     MatteT : 目标图像蒙版.
%     OpenMatteT : 开启目标蒙版.
%     Source : 源图像.
%     MatteS : 源图像蒙版.
%     OpenMatteS : 开启原图像蒙版.
%%-----------------------------------------------------------------------  
%  Author: 冯亚男
%  CreateTime: 2015-01-25 
%%------------------------------------------------------------------------
if nargin == 0
    Target = imread('Images/transformers.jpg');
    MatteT = imread('Images/transformersMatte.jpg');
    Source = imread('Images/interview.jpg');
    MatteS = imread('Images/interviewMatte.jpg');
    OpenMatteT = 1;
    OpenMatteS = 1;
end

%% 将蒙版叠加到目标图像上.
t = Target;
if OpenMatteT == 1
    dt = im2double(t);
    mt = MatteT;
    dmt = mat2gray(mt,[0 255]);
    bmt = im2bw(dmt,0.5);
    rmt = double(repmat(bmt,[1 1 3]));
    rt = im2uint8(dt.*rmt);
    %figure,imshow(rt);
    %imwrite(rt,'C:\Users\devil\Desktop\前后景分割\1.目标图像.jpg');
else
    rt = t;
    %figure,imshow(t);
end

% 抽取目标蒙版有效区域.
if  OpenMatteT == 1
    LABTargetMatteImage = RGB2Lab(rt);
else
    LABTargetMatteImage = RGB2Lab(t);
end
LABTargetMatteChannelL = LABTargetMatteImage(:,:,1);
LABTargetMatteChannelA = LABTargetMatteImage(:,:,2);
LABTargetMatteChannelB = LABTargetMatteImage(:,:,3);
eps = 0.001;
if OpenMatteT == 1
    IndexTargetMatte = find(LABTargetMatteChannelL > eps);
else
    IndexTargetMatte = find(LABTargetMatteChannelL > -1);
end
ChannelLTargetLocalMatte = LABTargetMatteChannelL(IndexTargetMatte);
ChannelATargetLocalMatte = LABTargetMatteChannelA(IndexTargetMatte);
ChannelBTargetLocalMatte = LABTargetMatteChannelB(IndexTargetMatte);
[~, IndexTargetLocalMatte] = sort(ChannelLTargetLocalMatte);
SizeTargetLocalMatte = size(IndexTargetLocalMatte,1);
% TargetMatte图像的L通道图像.
lt = LABTargetMatteChannelL;
% TargetMatte图像的L通道统计直方图.
lth = ChannelLTargetLocalMatte;

% 计算目标图像特征矩阵.
% 计算目标阴影带平均值和协方差矩阵.
ShadowATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(1:floor(SizeTargetLocalMatte/3)));
ShadowBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(1:floor(SizeTargetLocalMatte/3)));
MeanShadowATargetLocalMatte = sum(ShadowATargetLocalMatte)/(SizeTargetLocalMatte/3);
MeanShadowBTargetLocalMatte = sum(ShadowBTargetLocalMatte)/(SizeTargetLocalMatte/3);
CovShadowTargetLocalMatte   = cov(ShadowATargetLocalMatte,ShadowBTargetLocalMatte);
% 计算目标中间带平均值和协方差矩阵.
MiddleATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(floor(SizeTargetLocalMatte/3)+1:floor(2*SizeTargetLocalMatte/3)));
MiddleBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(floor(SizeTargetLocalMatte/3)+1:floor(2*SizeTargetLocalMatte/3)));
MeanMiddleATargetLocalMatte = sum(MiddleATargetLocalMatte)/(SizeTargetLocalMatte/3);
MeanMiddleBTargetLocalMatte = sum(MiddleBTargetLocalMatte)/(SizeTargetLocalMatte/3);
CovMiddleTargetLocalMatte   = cov(MiddleATargetLocalMatte,MiddleBTargetLocalMatte);
% 计算目标高亮带平均值和协方差矩阵.
HighATargetLocalMatte = ChannelATargetLocalMatte(IndexTargetLocalMatte(floor(2*SizeTargetLocalMatte/3)+1:SizeTargetLocalMatte));
HighBTargetLocalMatte = ChannelBTargetLocalMatte(IndexTargetLocalMatte(floor(2*SizeTargetLocalMatte/3)+1:SizeTargetLocalMatte));
MeanHighATargetLocalMatte = sum(HighATargetLocalMatte)/(SizeTargetLocalMatte/3);
MeanHighBTargetLocalMatte = sum(HighBTargetLocalMatte)/(SizeTargetLocalMatte/3);
CovHighTargetLocalMatte = cov(HighATargetLocalMatte,HighBTargetLocalMatte);




%% 将蒙版叠加到源图像上.
s = Source;
if  OpenMatteS == 1
    ds = im2double(s);
    ms = MatteS;
    dms = mat2gray(ms,[0 255]);
    bms = im2bw(dms,0.5);
    rms = double(repmat(bms,[1 1 3]));
    rs = im2uint8(ds.*rms);
    %figure,imshow(rs);
else
    rs = s;
    %figure,imshow(s);
end

% 抽取源图像蒙版有效区域.
if  OpenMatteS == 1
    LABSourceMatteImage = RGB2Lab(rs);
    LABSourceImage = RGB2Lab(s);
else
    LABSourceMatteImage = RGB2Lab(s);
end
LABSourceMatteChannelL = LABSourceMatteImage(:,:,1);
LABSourceMatteChannelA = LABSourceMatteImage(:,:,2);
LABSourceMatteChannelB = LABSourceMatteImage(:,:,3);
LABSourceMatteLuminanceOnlyChannelA = LABSourceMatteChannelA;
LABSourceMatteLuminanceOnlyChannelB = LABSourceMatteChannelB;
if OpenMatteS == 1
    LABSourceChannelL = LABSourceImage(:,:,1);
    LABSourceChannelA = LABSourceImage(:,:,2);
    LABSourceChannelB = LABSourceImage(:,:,3);
    SynSL = LABSourceChannelL;
    LABSourceLuminanceOnlyChannelA = LABSourceChannelA;
    LABSourceLuminanceOnlyChannelB = LABSourceChannelB;
else 
    SynSL = 0;
end
eps = 0.001;
if  OpenMatteS == 1
    IndexSourceMatte = find(LABSourceMatteChannelL > eps);
else
    IndexSourceMatte = find(LABSourceMatteChannelL > -1);
end;
ChannelLSourceLocalMatte = LABSourceMatteChannelL(IndexSourceMatte);
ChannelASourceLocalMatte = LABSourceMatteChannelA(IndexSourceMatte);
ChannelBSourceLocalMatte = LABSourceMatteChannelB(IndexSourceMatte);
[~, IndexSourceLocalMatte] = sort(ChannelLSourceLocalMatte);
SizeSourceLocalMatte = size(IndexSourceLocalMatte,1);
% SourceMatte图像的L通道图像.
ls = LABSourceMatteChannelL;
% SourceMatte图像的L通道统计直方图.
lsh = ChannelLSourceLocalMatte;


%进行辐照度拉伸.
TargetMatteLuminanceData = im2uint8(mat2gray(ChannelLTargetLocalMatte,[0 100]));
TargetHistCount = imhist(TargetMatteLuminanceData);
SourceMatteLuminanceData = im2uint8(mat2gray(ChannelLSourceLocalMatte,[0 100]));
TargetHistCount = mat2gray(TargetHistCount);
SourceMatteLuminanceTranferResult = histeq(SourceMatteLuminanceData,TargetHistCount);
resultImageDouble = mat2gray(SourceMatteLuminanceTranferResult,[0 255]);
resultImageDouble = resultImageDouble*100;
LABSourceMatteChannelL(IndexSourceMatte) = resultImageDouble;
if  OpenMatteS == 1 
    LABSourceChannelL(IndexSourceMatte) = resultImageDouble;
    SynRL = LABSourceChannelL;
else 
    SynRL = 0;
end
% ResultMatte图像的L通道图像.
lr = LABSourceMatteChannelL;
% ResultMatte图像的L通道统计直方图.
lrh = resultImageDouble;


% 计算目标图像特征矩阵.
% 计算源图像阴影带平均值和协方差矩阵.
ShadowASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)));
ShadowBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)));
MeanShadowASourceLocalMatte = sum(ShadowASourceLocalMatte)/(SizeSourceLocalMatte/3);
MeanShadowBSourceLocalMatte = sum(ShadowBSourceLocalMatte)/(SizeSourceLocalMatte/3);
CovShadowSourceLocalMatte   = cov(ShadowASourceLocalMatte,ShadowBSourceLocalMatte);
% 计算源图像中间带平均值和协方差矩阵.
MiddleASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)));
MiddleBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)));
MeanMiddleASourceLocalMatte = sum(MiddleASourceLocalMatte)/(SizeSourceLocalMatte/3);
MeanMiddleBSourceLocalMatte = sum(MiddleBSourceLocalMatte)/(SizeSourceLocalMatte/3);
CovMiddleSourceLocalMatte   = cov(MiddleASourceLocalMatte,MiddleBSourceLocalMatte);
% 计算源图像高亮带平均值和协方差矩阵.
HighASourceLocalMatte = ChannelASourceLocalMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
HighBSourceLocalMatte = ChannelBSourceLocalMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte));
MeanHighASourceLocalMatte = sum(HighASourceLocalMatte)/(SizeSourceLocalMatte/3);
MeanHighBSourceLocalMatte = sum(HighBSourceLocalMatte)/(SizeSourceLocalMatte/3);
CovHighSourceLocalMatte = cov(HighASourceLocalMatte,HighBSourceLocalMatte);



%% 特征参数表示
TMSA = MeanShadowATargetLocalMatte;
TMSB = MeanShadowBTargetLocalMatte;
TES  = CovShadowTargetLocalMatte;
TMMA = MeanMiddleATargetLocalMatte;
TMMB = MeanMiddleBTargetLocalMatte;
TEM  = CovMiddleTargetLocalMatte;
TMHA = MeanHighATargetLocalMatte;
TMHB = MeanHighBTargetLocalMatte;
TEH  = CovHighTargetLocalMatte;
SMSA = MeanShadowASourceLocalMatte;
SMSB = MeanShadowBSourceLocalMatte;
SES  = CovShadowSourceLocalMatte;
SMMA = MeanMiddleASourceLocalMatte;
SMMB = MeanMiddleBSourceLocalMatte;
SEM  = CovMiddleSourceLocalMatte;
SMHA = MeanHighASourceLocalMatte;
SMHB = MeanHighBSourceLocalMatte;
SEH  = CovHighSourceLocalMatte;


%% 计算不同亮度带的变换矩阵.
ShadowTransformMatrix = SES^(-1/2)*(SES^(1/2)*TES*SES^(1/2))^(1/2)*SES^(-1/2);
MiddleTransformMatrix = SEM^(-1/2)*(SEM^(1/2)*TEM*SEM^(1/2))^(1/2)*SEM^(-1/2);
HighTransformMatrix   = SEH^(-1/2)*(SEH^(1/2)*TEH*SEH^(1/2))^(1/2)*SEH^(-1/2);


%% 计算变换后的不同亮度带a,b值.
% 计算阴影带变换后的a,b值.
SA = ShadowASourceLocalMatte;
SB = ShadowBSourceLocalMatte;
TransformShadowData = [SA' - SMSA;SB' - SMSB];
MatrixShadow = ShadowTransformMatrix*TransformShadowData;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3))))= MatrixShadow(1,:) + TMSA;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))) = MatrixShadow(2,:) + TMSB;
LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3))))= MatrixShadow(1,:) + TMSA;
LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(1:floor(SizeSourceLocalMatte/3)))) = MatrixShadow(2,:) + TMSB;
% 计算中间带变换后的a,b值.
MA = MiddleASourceLocalMatte;
MB = MiddleBSourceLocalMatte;
TransformMiddleData = [MA' - SMMA;MB' - SMMB];
MatrixMiddle = MiddleTransformMatrix*TransformMiddleData;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = MatrixMiddle(1,:) + TMMA;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = MatrixMiddle(2,:) + TMMB;
LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = MatrixMiddle(1,:) + TMMA;
LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(SizeSourceLocalMatte/3)+1:floor(2*SizeSourceLocalMatte/3)))) = MatrixMiddle(2,:) + TMMB;
% 计算高亮带变换后的a,b值.
HA = HighASourceLocalMatte;
HB = HighBSourceLocalMatte;
TransformHighData = [HA' - SMHA;HB' - SMHB];
MatrixHigh = HighTransformMatrix*TransformHighData;
LABSourceMatteChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = MatrixHigh(1,:) + TMHA;
LABSourceMatteChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = MatrixHigh(2,:) + TMHB;
LABSourceChannelA(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = MatrixHigh(1,:) + TMHA;
LABSourceChannelB(IndexSourceMatte(IndexSourceLocalMatte(floor(2*SizeSourceLocalMatte/3)+1:SizeSourceLocalMatte))) = MatrixHigh(2,:) + TMHB;


%% 合成最后结果.
if OpenMatteS == 1
    WholeLuminOnlyResult = Lab2RGB(LABSourceChannelL,LABSourceLuminanceOnlyChannelA,LABSourceLuminanceOnlyChannelB);
    WholeHueSynResult = Lab2RGB(LABSourceChannelL,LABSourceChannelA,LABSourceChannelB);
else 
    WholeLuminOnlyResult =0;
    WholeHueSynResult = 0;
end
LuminaOnlyResult = Lab2RGB(LABSourceMatteChannelL,LABSourceMatteLuminanceOnlyChannelA,LABSourceMatteLuminanceOnlyChannelB);
HueSynResult = Lab2RGB(LABSourceMatteChannelL, LABSourceMatteChannelA, LABSourceMatteChannelB);

