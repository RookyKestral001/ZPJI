close all;
clear all;
clc;

% figure;
H = 900;
W = 1600;
Frames = 100;

% flock0 = Flock(10);
% flock0.drawUAVs();
% flock0.drawLinks();
    
mov = VideoWriter('Boids.avi');
mov.FrameRate = 30; %֡�ʣ�Ĭ��30
obj.Quality = 100; %��Ƶ������[0, 100]
open(mov);
tic

flock0 = Flock(10);
% flock0.drawUAVs();
% flock0.drawLinks();
    
for iRound = 1:Frames
%     fname=strcat('..\imgdata\',num2str(i),'.jpg');
%     frame = imread(fname);
%     writeVideo(myObj,frame);

    clf;
    set(gcf, 'color', [1 1 1]); %��ɫ����
    title('initial');
%     axis([1 200 1 200]);
    
    flock0.saveAll();
    flock0.drawUAVs();
    flock0.drawLinks();
    flock0.updateAll();
    
    frame1 = getframe(gcf); %���Ƶ�ǰͼ�Σ�gcfΪget current figure������legend��title��label����дgcfʱĬ��Ϊgca��axis��
%     frame1.cdata = imresize(frame1.cdata, [H W]); %��Ƶ�ֱ���
    writeVideo(mov, frame1);
%     pause(0.5);
end

flock0.drawTraj();
toc
mov.close();