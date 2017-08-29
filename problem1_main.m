load('dino2.mat');
dino01gray = rgb2gray(dino01);
sigma1 = 1;
sigma2 = 2;
sigma3 = 3;

corner_detection(sigma1, dino01gray);