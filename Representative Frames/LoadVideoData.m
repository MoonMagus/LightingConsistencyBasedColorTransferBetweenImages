function VideoData = LoadVideoData()
%获取视频的数据结构.
VideoName = 'dark.mp4';
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% 预填充Video数据结构.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% 保存帧数据.
dirname = uigetdir('C:\Users\devil\Desktop\视频帧','浏览文件夹');

% 载入帧数据.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
    TargetName = strcat(dirname,'\','第',num2str(k),'帧.jpg');
    imwrite(mov(k).cdata,TargetName);
end
VideoData = mov;
