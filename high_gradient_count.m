function [ count ] = high_gradient_count( I )
% Performs levinson-durbin recurrsion on the autocorrelation coefficients
patch = imcrop(I,[20, 20, 70 70]);
patchVar = std2(patch)^2;
DoS = 2*patchVar;

J = imbilatfilt(I,DoS,4);

% now using gradient
[~, Gdir] = imgradient(rgb2gray(J),'central');

% filtering the gradient direction and then seeing if it is still rough
Gdir = imbilatfilt(Gdir,DoS,2);
Gdir = imbilatfilt(Gdir,DoS,2);
Gdir = imbilatfilt(Gdir,DoS,4);
Gdir = imbilatfilt(Gdir,DoS,10);
[~, Gdir] = imgradient(Gdir,'central');

% next need to find the areas with large gradient of gradient direction

sobel_mat = [1 2 1; 0 0 0 ; -1 -2 -1];
Gradients = conv2(Gdir, sobel_mat);
Gradients = abs(Gradients); % just so that we have the magnitude of gradient
[rows, cols] = size(Gradients);

gradient_threshold = 1200;

count = 0;

for i = 1:rows
   for j = 1:cols
       if(Gradients(i,j)>gradient_threshold)
           count = count + 1;
       end
   end
end

end