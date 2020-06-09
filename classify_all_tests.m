DATA_PATH = './data/test';
IGNORE = [".DS_Store", ".", ".."];

tests = dir(DATA_PATH);

for i=1:length(tests)
    test = tests(i);
    filename = test.name;
    path = strcat(DATA_PATH,'/',filename);
    
    if ~any(strcmp(IGNORE, filename))
       disp(path);
       [best_genre, best_mse, img, best_img] = pca_classify(path);
       
       if best_genre == "indie_alt"
           best_genre = "indie/alt";
       end
       
       close all;
       imshow([img, best_img]);
       title(sprintf("Genre = %s, mse = %f", best_genre, best_mse));
       pause;
    end
end