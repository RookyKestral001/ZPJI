close all;
clear all;
clc;

% figure;
H = 900;
W = 1600;
Frames = 20;

% flock0 = Flock(10);
% flock0.drawUAVs();
% flock0.drawLinks();
    
mov = VideoWriter('Boids.avi');
mov.FrameRate = 30;  %帧率，默认30
obj.Quality = 100; %视频质量，[0, 100]
open(mov);
tic

flock0 = Flock(7);
% flock0.drawUAVs();
% flock0.drawLinks();
    
for iRound = 1:Frames
%     fname=strcat('..\imgdata\',num2str(i),'.jpg');
%     frame = imread(fname);
%     writeVideo(myObj,frame);

    clf;
    set(gcf, 'color', [1 1 1]); %白色背景
    title('initial');
    axis([1 60 1 60]);
    
    flock0.saveAll();
    flock0.drawUAVs();
    flock0.drawLinks();
    if iRound ~= Frames
        flock0.updateAll();
    end
    frame1 = getframe(gcf); %复制当前图形，gcf为get current figure，包括legend、title和label。不写gcf时默认为gca（axis）
%     frame1.cdata = imresize(frame1.cdata, [H W]); %视频分辨率
    writeVideo(mov, frame1);
%     pause(0.5);
end

flock0.drawTraj();
toc
mov.close();

figure;
flock0.coherenceCal();