function [best_genre, best_mse, img, best_img] = pca_classify(picture_path)
%RECONSTRUCT_IMG Summary of this function goes here
%   Detailed explanation goes here
    DATA_PATH = './data/matlab';
    GENRES = [ "country", "edm_dance", "hiphop", "pop", "rnb", "rock" ];

    img = double(imread(picture_path));

    % If picture is in RGB, convert down to grayscale.
    dims = size(img);
    if size(dims, 2) > 2
        img = double(rgb2gray(uint8(img)));
    end

    row_img = reshape(img, 1, size(img,1)*size(img,2));
    resized_img = [row_img zeros(1, 300*300-size(img,1)*size(img,2))];
    
    best_genre = "";
    best_mse = Inf;
    best_img = zeros(300,300);
    for i=1:length(GENRES)
        genre = GENRES(i);
        genre_avg_data = load(strcat(DATA_PATH,'/',genre,'_avg.mat'));
        genre_vector_data = load(strcat(DATA_PATH,'/',genre,'_vectors.mat'));
        
        genre_avg = genre_avg_data.genreAvg;
        genre_vectors = genre_vector_data.topDims;

        % Rebuild image.
        reconstructed_img = genre_avg;
        for k=1:size(genre_vectors,2)
            eigenv = genre_vectors(:, k);
            p_k = (resized_img - genre_avg) * eigenv;
            reconstructed_img = reconstructed_img + p_k * transpose(eigenv);
        end
        
        temp = uint8(reshape(reconstructed_img, 300, 300));
%         close all;
%         imshow(temp);
        genre_mse = mse(resized_img, reconstructed_img);
        if genre_mse < best_mse
            best_genre = genre;
            best_mse = genre_mse;
            best_img = temp;
        end
    end
end

