PICTURE_PATH = './edges';
EDGE_PATH = './edges';
DATA_PATH = './data/matlab';

genres = dir(PICTURE_PATH);
exclude = [".DS_Store" "." ".."];

for i=1:size(genres, 1)
    genre = genres(i).name;
    if ~any(strcmp(exclude, genre))
        genreAllCovers = [];
        genrePath = strcat(PICTURE_PATH, '/', genre);
        pictures = dir(genrePath);
        disp("Constructing matrix for " + genre + "...");
        X = [];
        for j=1:size(pictures, 1)
            picture = pictures(j).name;
            if ~any(strcmp(exclude, picture))
                picturePath = strcat(genrePath, '/', picture);
                A = double(imread(picturePath));
                columnA = reshape(A, size(A,1)*size(A,2),1);
                resizedA = [columnA ; zeros(300*300-size(A,1)*size(A,2),1)];
                
                X = [X resizedA];
            end
        end
        
        close all;
        disp("Performing PCA for "+genre+"...");
        tic;
        genreAvg = mean(X, 2);
        coeffs = pca(X);
        toc;
        imshow(reshape(genreAvg, 300, 300));
        pause;
    end
end