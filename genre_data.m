PICTURE_PATH = './covers';
DATA_PATH = './data/matlab';

genres = dir(PICTURE_PATH);
exclude = [".DS_Store" "." ".."];

for i=1:size(genres, 1)
    genre = genres(i).name;
    if ~any(strcmp(exclude, genre))
        genreAllCovers = [];
        genrePath = strcat(PICTURE_PATH, '/', genre);
        pictures = dir(genrePath);
        for j=1:size(pictures, 1)
            picture = pictures(j).name;
            if ~any(strcmp(exclude, picture))
                picturePath = strcat(genrePath, '/', picture);
                A = imread(picturePath);
                vectorA = A(:);
                paddedA = [vectorA ; zeros(size(genreAllCovers, 1)-length(vectorA), 1)];
                genreAllCovers = [genreAllCovers paddedA];
            end
        end
        
        % write genre data to some .dat file to process for later
        fid = fopen(strcat(DATA_PATH, '/', genre, '.dat'), 'w');
        fprintf(fid, '%d ', genreAllCovers);
        fclose(fid);
    end
end