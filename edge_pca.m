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
        X = [];
        
        % Create covariance matrix for genre.
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
                
                X = [X ; resizedA];
            end
        end
        
        close all;
        disp("Performing PCA for "+genre+"...");
        tic;
        [coeffs,~,~,~,~,genreAvg] = pca(X);
        toc;
        imshow(uint8(reshape(genreAvg, 300, 300)));
        pause;
             
        % Demonstrate reconstruction of each image.
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
                                
                % Rebuild image.
                reconstructedImg = genreAvg;
                for k=1:NUM_DIM
                    eigenv = coeffs(:, k);
                    p_k = (resizedA - genreAvg) * eigenv;
                    reconstructedImg = reconstructedImg + p_k * transpose(eigenv);
                    
                    if mod(k, 50) == 0
                        close all;
                        imshow(uint8(reshape(reconstructedImg, 300, 300)));
                        pause;
                    end
                end
            end
        end        
    end
end