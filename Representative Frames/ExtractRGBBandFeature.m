function [MS,ES,MM,EM,MH,EH] = ExtractRGBBandFeature(RGBImage)
% 将输入的RGB图像依据亮度分离成不同的数据带.

RGBImage = imread('一棵树.jpg');
LABImage = RGB2Lab(RGBImage);
ChannelL = LABImage(:,:,1);
ChannelRed = RGBImage(:,:,1);
ChannelGreen = RGBImage(:,:,2);
ChannelBlue = RGBImage(:,:,3);

%% 将源图像分成不同的亮度带.
[x,y] = size(ChannelL);
LuminanceData = reshape(ChannelL,1,x*y);
[LuminanceData, IndexLuminance] = sort(LuminanceData);

%% 计算LAB颜色空间不同通道各亮度带的特征值.
RGBShadowBandR = ChannelRed(IndexLuminance(1:floor(x*y/3)));
RGBShadowBandG = ChannelGreen(IndexLuminance(1:floor(x*y/3)));
RGBShadowBandB = ChannelBlue(IndexLuminance(1:floor(x*y/3)));
RGBShadowBandR = reshape(RGBShadowBandR,floor(x*y/3),1);
RGBShadowBandG = reshape(RGBShadowBandG,floor(x*y/3),1);
RGBShadowBandB = reshape(RGBShadowBandB,floor(x*y/3),1);
MeanOfRGBSR = sum(RGBShadowBandR)/(x*y/3);
MeanOfRGBSG = sum(RGBShadowBandG)/(x*y/3);
MeanOfRGBSB = sum(RGBShadowBandB)/(x*y/3);
% 计算中间带.
RGBMiddleBandR = ChannelRed(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
RGBMiddleBandG = ChannelGreen(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
RGBMiddleBandB = ChannelBlue(IndexLuminance(floor(x*y/3)+1:floor(2*x*y/3)));
RGBMiddleBandR = reshape(RGBMiddleBandR,floor(2*x*y/3)-floor(x*y/3),1);
RGBMiddleBandG = reshape(RGBMiddleBandG,floor(2*x*y/3)-floor(x*y/3),1);
RGBMiddleBandB = reshape(RGBMiddleBandB,floor(2*x*y/3)-floor(x*y/3),1);
MeanOfRGBMR = sum(RGBMiddleBandR)/(x*y/3);
MeanOfRGBMG = sum(RGBMiddleBandG)/(x*y/3);
MeanOfRGBMB = sum(RGBMiddleBandB)/(x*y/3);
% 计算高亮带.
RGBHighBandR = ChannelRed(IndexLuminance(floor(2*x*y/3)+1:x*y));
RGBHighBandG = ChannelGreen(IndexLuminance(floor(2*x*y/3)+1:x*y));
RGBHighBandB = ChannelBlue(IndexLuminance(floor(2*x*y/3)+1:x*y));
RGBHighBandR = reshape(RGBHighBandR,x*y-floor(2*x*y/3),1);
RGBHighBandG = reshape(RGBHighBandG,x*y-floor(2*x*y/3),1);
RGBHighBandB = reshape(RGBHighBandB,x*y-floor(2*x*y/3),1);
MeanOfRGBHR = sum(RGBHighBandR)/(x*y/3);
MeanOfRGBHG = sum(RGBHighBandG)/(x*y/3);
MeanOfRGBHB = sum(RGBHighBandB)/(x*y/3);

%% 计算LAB颜色空间的特征值矩阵.
%阴影带.
MeanShadow = [MeanOfRGBSR;MeanOfRGBSG;MeanOfRGBSB];
CovShadow(:,1) = double(RGBShadowBandR);
CovShadow(:,2) = double(RGBShadowBandG);
CovShadow(:,3) = double(RGBShadowBandB);
CovShadowMatrix = cov(CovShadow);
MS = MeanShadow;
ES = CovShadowMatrix;
%中间带.
MeanMiddle = [MeanOfRGBMR;MeanOfRGBMG;MeanOfRGBMB];
CovMiddle(:,1) = double(RGBMiddleBandR);
CovMiddle(:,2) = double(RGBMiddleBandG);
CovMiddle(:,3) = double(RGBMiddleBandB);
CovMiddleMatrix = cov(CovMiddle);
MM = MeanMiddle;
EM = CovMiddleMatrix;
%高亮带.
MeanHigh = [MeanOfRGBHR;MeanOfRGBHG;MeanOfRGBHB];
CovHigh(:,1) = double(RGBHighBandR);
CovHigh(:,2) = double(RGBHighBandG);
CovHigh(:,3) = double(RGBHighBandB);
CovHighMatrix = cov(CovHigh);
MH = MeanHigh;
EH = CovHighMatrix;

%返回参数.
C.MS = MS;
C.ES = ES;
C.MM = MM;
C.EM = EM;
C.MH = MH;
C.EH = EH;

MS,ES,MM,EM,MH,EH








