Drock = '../covers/rock';
%Drock = '../covers/rnb';
%Drock = '../covers/pop';
%Drock = '../covers/indie_alt';
%Drock = '../covers/hiphop';
%Drock = '../covers/edm_dance';
%Drock = '../covers/country';
S = dir(fullfile(Drock,'*.jpg'))
for k = 1:numel(S)
    F = fullfile(Drock,S(k).name);
    I = imread(F);
    high_gradient_count(I)
end