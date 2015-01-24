function  CaculateFrameFeature()
% 计算指定视频流中的帧特征矩阵.

dirs1 = dir('C:\Users\devil\Desktop\pics1\*.jpg');
dirs2 = dir('C:\Users\devil\Desktop\pics1\*.bmp');
dirs = [dirs1;dirs2];
dircell = struct2cell(dirs)';
filenames = dircell(:,1);
n = size(filenames,1);
Frames(1,n) = struct('MS',[],'ES',[],'MM',[],'EM',[],'MH',[],'EH',[]);
E = zeros(1,n);
M = zeros(1,n);
for i = 1 : n
    Frames(i) = ExtractLABBandFeature(strcat('C:\Users\devil\Desktop\pics1\',char(filenames(i))))';
    E(i) = trace(Frames(i).ES + Frames(i).EM + Frames(i).EH);
    M(i) = sum(Frames(i).MS + Frames(i).MM + Frames(i).MH);
end
MetricMatrix = zeros(n,n);
for i = 1:n
    for j = 1:n
        MetricMatrix(i,j) = MetricDistance(Frames(i),Frames(j));
        if  MetricMatrix(i,j) < 0.000001
            MetricMatrix(i,j) = 0;
        end
    end
end
disp('Metric计算结束，开始中心点聚类 ');

% MetricMatrix
Data(1,:) = E;
Data(2,:) = M;	
[~, BestMedoids, MedoidsSize] = KMedoids(MetricMatrix, Data, floor(n/30));
KeyFrames = size(BestMedoids,2);
for i = 1:KeyFrames
    if  MedoidsSize(i) >= 30
        f = imread(strcat('C:\Users\devil\Desktop\pics1\',char(filenames(BestMedoids(i)))));
        imwrite(f,strcat('C:\Users\devil\Desktop\提取的关键帧\',char(filenames(BestMedoids(i)))));
    end
end