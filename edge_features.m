PICTURE_PATH = './covers';
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
        disp("Edge detection for " + genre + "...");
        for j=1:size(pictures, 1)
            picture = pictures(j).name;
            if ~any(strcmp(exclude, picture))
                picturePath = strcat(genrePath, '/', picture);
                A = imread(picturePath);
                dims = size(A);
                if size(dims, 2) > 2
                    A = rgb2gray(A);
                end
                cannyA = edge(A, 'canny');
                
                imwrite(cannyA, strcat(EDGE_PATH, '/', genre, '/', picture));
            end
        end
    end
end