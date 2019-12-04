%test histogram


Drock = '../covers/rock';
Drnb = '../covers/rnb';
Dpop = '../covers/pop';
red_data = zeros(600,81);
test_data = zeros(300,81);
%Drock = '../covers/indie_alt';
%Drock = '../covers/hiphop';
%Drock = '../covers/edm_dance';
%Drock = '../covers/country';
S = dir(fullfile(Drock,'*.jpg'));
for k = 1:200%numel(S)
    
    F = fullfile(Drock,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    red_data(k,:) = [a(:) ; b(:) ; c(:)];
end
for k = 200:300%numel(S)
    
    F = fullfile(Drock,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    test_data(k-199,:) = [a(:) ; b(:) ; c(:)];
end

S = dir(fullfile(Drnb,'*.jpg'));
for k = 1:200%numel(S)
    
    F = fullfile(Drnb,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    red_data(k+200,:) = [a(:) ; b(:) ; c(:)];
end
for k = 200:300%numel(S)
    
    F = fullfile(Drnb,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    test_data(k-99,:) = [a(:) ; b(:) ; c(:)];
end

S = dir(fullfile(Dpop,'*.jpg'));
for k = 1:200%numel(S)
    
    F = fullfile(Dpop,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    red_data(k+400,:) = [a(:) ; b(:) ; c(:)];
end
for k = 200:300%numel(S)
    
    F = fullfile(Dpop,S(k).name);
    I = imread(F);
    [a,b,c] = color_histogram(I);
    test_data(k,:) = [a(:) ; b(:) ; c(:)];
end


%X = [randn(10,2); randn(15,2) + 5.5];  Y = [zeros(10,1); ones(15,1)];
%
% % Calculate linear discriminant coefficients
%W = LDA(X,Y);
%
% % Calulcate linear scores for training data
%L = [ones(25,1) X] * W';
%
% % Calculate class probabilities
%P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

W = LDA(red_data, [zeros(200,1); ones(200,1) ; ones(200,1)*2]);

%[ones(256,1) red_data]

L = [ones(300,1) test_data] * W';

% L is 1000 bigger than probably should be, since it is dividing this
% shouldn't change result
P = exp(L/1000) ./ repmat(sum(exp(L/1000),2),[1 3])

[rows, cols] = size(P);

wrong_pop = 0;
wrong_rock = 0;
wrong_rnb = 0;

for i = 1:rows
   if(P(i,1)>P(i,2)) 
       if(P(i,1)>P(i,3))
           if(i>100)
               wrong = wrong + 1;
           end
       else
           if(i<201)
               wrong = wrong + 1;
           end
       end
   else
       if(P(i,2)>P(i,3))
           if(i>200 & i<101)
               wrong = wrong + 1;
           end
       else
           if(i<201)
               wrong = wrong + 1;
           end
       end
   end
    
end
wrong
