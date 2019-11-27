%I = imread('../covers/rock/zz top - cheap sunglasses.jpg');
I = imread('../covers/rock/yungblud - hope for the underrated youth.jpg');
%I = imread('covers/rock/walter egan - magnet and steel.jpg');
%I = imread('covers/rock/u2 - pride (in the name of love).jpg');
%I = imread('covers/edm_dance/zac brown band - someone i used to know - kue radio remix.jpg');
%I = imread('covers/hiphop/yung mal - war (feat. gunna).jpg');

clear param
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Computing gist:
[gist, param] = LMgist(I, '', param);

figure
subplot(121)
imshow(I)
title('Input image')
subplot(122)
showGist(gist, param)
title('Descriptor')

