I = imread('covers/rock/zz top - cheap sunglasses.jpg');
%I = imread('covers/rock/yungblud - hope for the underrated youth.jpg');
%I = imread('covers/rock/walter egan - magnet and steel.jpg');
%I = imread('covers/rock/u2 - pride (in the name of love).jpg');
%I = imread('covers/edm_dance/zac brown band - someone i used to know - kue radio remix.jpg');
%I = imread('covers/hiphop/yung mal - war (feat. gunna).jpg');


patch = imcrop(I,[20, 20, 70 70]);
patchVar = std2(patch)^2;
DoS = 2*patchVar;

J = imbilatfilt(I,DoS,4);

% now using gradient
[Gmag, Gdir] = imgradient(rgb2gray(J),'central');

imshowpair(Gmag,Gdir,'montage')
figure;
% filtering the gradient direction and then seeing if it is still rough
%Gdir = imbilatfilt(Gdir,DoS,2);
%Gdir = imbilatfilt(Gdir,DoS,2);
%Gdir = imbilatfilt(Gdir,DoS,4);
%Gdir = imbilatfilt(Gdir,DoS,10);
%[Gmag, Gdir] = imgradient(Gdir,'central');

% next need to find the areas with large gradient of gradient direction

sobel_mat = [1 2 1; 0 0 0 ; -1 -2 -1];
Gradients = conv2(Gdir, sobel_mat);
Gradients = abs(Gradients); % just so that we have the magnitude of gradient
[rows, cols] = size(Gradients);

gradient_threshold = 1200;

num_above_threshold = 0;

for i = 1:rows
   for j = 1:cols
       if(Gradients(i,j)>gradient_threshold)
           num_above_threshold = num_above_threshold + 1;
       end
   end
end
num_above_threshold;

image_list = [rgb2gray(I), Gmag, Gdir];

% showing the firgure
%imshowpair(Gmag,Gdir,'montage')
montage(image_list)


