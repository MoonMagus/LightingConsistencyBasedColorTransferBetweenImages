function VideoData = LoadVideoData()
%��ȡ��Ƶ�����ݽṹ.
VideoName = 'dark.mp4';
VideoMedia = VideoReader(VideoName);
nFrames = VideoMedia.NumberOfFrames;
videoHeight = VideoMedia.Height;
videoWidth = VideoMedia.Width;

% Ԥ���Video���ݽṹ.
mov(1:nFrames) = ...
struct('cdata', zeros(videoHeight, videoWidth, 3, 'uint8'),'colormap', []);

% ����֡����.
dirname = uigetdir('C:\Users\devil\Desktop\��Ƶ֡','����ļ���');

% ����֡����.
for k = 1 : nFrames
    mov(k).cdata = read(VideoMedia, k);
    TargetName = strcat(dirname,'\','��',num2str(k),'֡.jpg');
    imwrite(mov(k).cdata,TargetName);
end
VideoData = mov;
