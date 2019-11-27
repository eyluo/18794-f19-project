PICTURE_PATH = './covers';
DATA_PATH = './data/matlab';

NUM_DIM = 300;

NUM_GENRES = 7;

genres = dir(PICTURE_PATH);
exclude = [".DS_Store" "." ".."];

% Loop through all genres
X = zeros(4200, 90000);
labels = zeros(4200, 1);
priorIdx = 1;
total = 0;
priors = zeros(1, NUM_GENRES);
for i=1:size(genres, 1)
    genre = genres(i).name;
    
    % Only consider valid genre names. dir includes '.','..',etc.    
    if ~any(strcmp(exclude, genre))
        genreAllCovers = [];
        genrePath = strcat(PICTURE_PATH, '/', genre);
        pictures = dir(genrePath);
        disp("Appending to X for " + genre + "...");
        
        genreSum = 0;
        for j=1:size(pictures, 1)
            picture = pictures(j).name;
            if ~any(strcmp(exclude, picture))
                picturePath = strcat(genrePath, '/', picture);
                A = double(imread(picturePath));
                
                genreSum = genreSum + 1;
                total = total + 1;
                
                % If picture is in RGB, convert down to grayscale.
                dims = size(A);
                if size(dims, 2) > 2
                    A = double(rgb2gray(uint8(A)));
                end
                
                rowA = reshape(A, 1, size(A,1)*size(A,2));
                resizedA = [rowA zeros(1, 300*300-size(A,1)*size(A,2))];
                
                X(total, :) = resizedA;
                labels(total, :) = convertCharsToStrings(genre);
            end
        end
        
        priors(priorIdx) = genreSum;
        priorIdx = priorIdx + 1;
    end
end

X = X(1:total,:);
labels = labels(1:total,:);

genreSum = genreSum ./ total;
mu = mean(X);
        
disp("Performing LDA...");
tic;
coeffs = LDA(X, labels, priors);
toc;
imshow(uint8(reshape(mu, 300, 300)));
pause;

% % Demonstrate reconstruction of each image.
% for j=1:size(pictures, 1)
%     picture = pictures(j).name;
%     if ~any(strcmp(exclude, picture))
%         picturePath = strcat(genrePath, '/', picture);
%         A = double(imread(picturePath));
% 
%         % If picture is in RGB, convert down to grayscale.
%         dims = size(A);
%         if size(dims, 2) > 2
%             A = double(rgb2gray(uint8(A)));
%         end
% 
%         rowA = reshape(A, 1, size(A,1)*size(A,2));
%         resizedA = [rowA zeros(1, 300*300-size(A,1)*size(A,2))];
% 
%         % Rebuild image.
%         reconstructedImg = mu;
%         for k=1:NUM_DIM
%             eigenv = coeffs(:, k);
%             p_k = (resizedA - mu) * eigenv;
%             reconstructedImg = reconstructedImg + p_k * transpose(eigenv);
% 
%             if mod(k, 50) == 0
%                 close all;
%                 imshow(uint8(reshape(reconstructedImg, 300, 300)));
%                 pause;
%             end
%         end
%     end
% end        