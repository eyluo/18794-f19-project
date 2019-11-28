PICTURE_PATH = './covers';
DATA_PATH = './data/matlab';

NUM_DIM = 300;

genres = dir(PICTURE_PATH);
exclude = [".DS_Store" "." ".."];

% Loop through all genres
for i=1:size(genres, 1)
    genre = genres(i).name;
    
    % Only consider valid genre names. dir includes '.','..',etc.    
    if ~any(strcmp(exclude, genre))
        genreAllCovers = [];
        genrePath = strcat(PICTURE_PATH, '/', genre);
        pictures = dir(genrePath);
        disp("Constructing matrix for " + genre + "...");
        X = zeros(800, 90000);
        
        % Create covariance matrix for genre.
        idx = 1;
        for j=1:size(pictures, 1)
            picture = pictures(j).name;
            if ~any(strcmp(exclude, picture))
                picturePath = strcat(genrePath, '/', picture);
                A = double(imread(picturePath));
                
                % If picture is in RGB, convert down to grayscale.
                dims = size(A);
                if size(dims, 2) > 2
                    A = double(rgb2gray(uint8(A)));
                end
                
                rowA = reshape(A, 1, size(A,1)*size(A,2));
                resizedA = [rowA zeros(1, 300*300-size(A,1)*size(A,2))];
                
                X(idx,:) = resizedA;
                idx = idx + 1;
            end
        end
        
        X = X(1:idx,:);
        
        close all;
        disp("Performing PCA for "+genre+"...");
        tic;
        [coeffs,~,~,~,~,genreAvg] = pca(X);
        toc;
        imshow(uint8(reshape(genreAvg, 300, 300)));
        
        filename = strcat(DATA_PATH,'/',genre,'_avg.mat');
        save(filename, 'genreAvg');
        
        topDims = coeffs(:,1:NUM_DIM);
        filename = strcat(DATA_PATH,'/',genre,'_vectors.mat');
        save(filename, 'topDims');
    end
end