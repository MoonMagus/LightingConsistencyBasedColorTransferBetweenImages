function [a ,b] = ChrominanceTransform(sl,sa,sb,tl,ta,tb)
% ��Դͼ���a,bͨ��ֵת����Ŀ��ͨ����a,bֵ

%% ��Դͼ��ֳɲ�ͬ�����ȴ����д���.
[x1,y1] = size(sl);
SlData = reshape(sl,1,x1*y1);
[SlData, IndexLuminance] = sort(SlData);

% ����Դͼ���ɫ����������.
% ������Ӱ����ƽ��ֵ��Э�������.
SaShadowBand = sa(IndexLuminance(1:x1*y1/3));
SbShadowBand = sb(IndexLuminance(1:x1*y1/3));
SaShadowBand = reshape(SaShadowBand,1,floor(x1*y1/3));
SbShadowBand = reshape(SbShadowBand,1,floor(x1*y1/3));
usas = sum(SaShadowBand)/(x1*y1/3);
usbs = sum(SbShadowBand)/(x1*y1/3);
covssab = cov(SaShadowBand,SbShadowBand);
% �����м����ƽ��ֵ��Э�������.
SaMiddleBand = sa(IndexLuminance(x1*y1/3+1:2*x1*y1/3));
SbMiddleBand = sb(IndexLuminance(x1*y1/3+1:2*x1*y1/3));
[x,y]=size(SaMiddleBand);
SaMiddleBand = reshape(SaMiddleBand,1,x*y);
SbMiddleBand = reshape(SbMiddleBand,1,x*y);
usam = sum(SaMiddleBand)/(x1*y1/3);
usbm = sum(SbMiddleBand)/(x1*y1/3);
covsmab = cov(SaMiddleBand,SbMiddleBand);
% �����������ƽ��ֵ��Э�������.
SaHighBand = sa(IndexLuminance(2*x1*y1/3+1:x1*y1));
SbHighBand = sb(IndexLuminance(2*x1*y1/3+1:x1*y1));
SaHighBand = reshape(SaHighBand,1,floor(x1*y1/3));
SbHighBand = reshape(SbHighBand,1,floor(x1*y1/3));
usah = sum(SaHighBand)/(x1*y1/3);
usbh = sum(SbHighBand)/(x1*y1/3);
covshab = cov(SaHighBand,SbHighBand);

%% ��Ŀ��ͼ��ֳɲ�ͬ�����ȴ����д���.
[x2,y2] = size(tl);
TlData = reshape(tl,1,x2*y2);
[TlData, IndexLuminanceT] = sort(TlData);

% ����Դͼ���ɫ����������.
% ������Ӱ����ƽ��ֵ��Э�������.
TaShadowBand = ta(IndexLuminanceT(1:x2*y2/3));
TbShadowBand = tb(IndexLuminanceT(1:x2*y2/3));
TaShadowBand = reshape(TaShadowBand,1,floor(x2*y2/3));
TbShadowBand = reshape(TbShadowBand,1,floor(x2*y2/3));
utas = sum(TaShadowBand)/(x2*y2/3);
utbs = sum(TbShadowBand)/(x2*y2/3);
covtsab = cov(TaShadowBand,TbShadowBand);
% �����м����ƽ��ֵ��Э�������.
TaMiddleBand = ta(IndexLuminanceT(x2*y2/3+1:2*x2*y2/3));
TbMiddleBand = tb(IndexLuminanceT(x2*y2/3+1:2*x2*y2/3));
TaMiddleBand = reshape(TaMiddleBand,1,floor(x2*y2/3));
TbMiddleBand = reshape(TbMiddleBand,1,floor(x2*y2/3));
utam = sum(TaMiddleBand)/(x2*y2/3);
utbm = sum(TbMiddleBand)/(x2*y2/3);
covtmab = cov(TaMiddleBand,TbMiddleBand);
% �����������ƽ��ֵ��Э�������.
TaHighBand = ta(IndexLuminanceT(2*x2*y2/3+1:x2*y2));
TbHighBand = tb(IndexLuminanceT(2*x2*y2/3+1:x2*y2));
TaHighBand = reshape(TaHighBand,1,floor(x2*y2/3));
TbHighBand = reshape(TbHighBand,1,floor(x2*y2/3));
utah = sum(TaHighBand)/(x2*y2/3);
utbh = sum(TbHighBand)/(x2*y2/3);
covthab = cov(TaHighBand,TbHighBand);

% ���㲻ͬ���ȴ��ı任����.
ShadowTransformMatrix = covssab^(-1/2)*(covssab^(1/2)*covtsab*covssab^(1/2))^(1/2)*covssab^(-1/2);
MiddleTransformMatrix = covsmab^(-1/2)*(covsmab^(1/2)*covtmab*covsmab^(1/2))^(1/2)*covsmab^(-1/2);
HighTransformMatrix = covshab^(-1/2)*(covshab^(1/2)*covthab*covshab^(1/2))^(1/2)*covshab^(-1/2);

% ����任��Ĳ�ͬ���ȴ�a,bֵ.
% ������Ӱ���任���a,bֵ.
TransformShadowData = [SaShadowBand - usas;SbShadowBand - usbs];
MatrixShadow = ShadowTransformMatrix*TransformShadowData;
sa(IndexLuminance(1:x1*y1/3)) = MatrixShadow(1,:) + utas;
sb(IndexLuminance(1:x1*y1/3)) = MatrixShadow(2,:) + utbs;
% �����м���任���a,bֵ.
TransformMiddleData = [SaMiddleBand - usam;SbMiddleBand - usbm];
MatrixMiddle = MiddleTransformMatrix*TransformMiddleData;
sa(IndexLuminance(x1*y1/3+1:2*x1*y1/3)) = MatrixMiddle(1,:) + utam;
sb(IndexLuminance(x1*y1/3+1:2*x1*y1/3)) = MatrixMiddle(2,:) + utbm;
% ����������任���a,bֵ.
TransformHighData = [SaHighBand - usah;SbHighBand - usbh];
MatrixHigh = HighTransformMatrix*TransformHighData;
sa(IndexLuminance(2*x1*y1/3+1:x1*y1)) = MatrixHigh(1,:) + utah;
sb(IndexLuminance(2*x1*y1/3+1:x1*y1)) = MatrixHigh(2,:) + utbh;
a = sa;
b = sb;











