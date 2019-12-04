% histogram and then filter to prevent colors that are next to each other
% to not be considered

function [ red_hist, blue_hist, green_hist ] = color_histogram( I )
    division_num = 10;
    num_color_values = floor(256/division_num) + 2;
    red_hist = zeros(num_color_values,1);
    blue_hist = zeros(num_color_values,1);
    green_hist = zeros(num_color_values,1);
    
    [rows, cols, depth] = size(I);

    for i = 1:rows
        for j = 1:cols            
            red_in_pixel = floor((I(i,j,1))/division_num) + 1;
            red_hist(red_in_pixel) = red_hist(red_in_pixel) + 1;
            if(depth > 1)
                green_in_pixel = floor((I(i,j,2))/division_num) + 1;
                green_hist(green_in_pixel) = green_hist(green_in_pixel) + 1;
                blue_in_pixel = floor((I(i,j,3))/division_num) + 1;
                blue_hist(blue_in_pixel) = blue_hist(blue_in_pixel) + 1;
            end
        end
    end
end