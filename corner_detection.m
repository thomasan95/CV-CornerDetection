%%                          Changing Arguments
% clear all;
% load('dino2.mat');
% in_img = rgb2gray(dino01);
% in_sigma = 5;
% n = 50;
% sigma1 = 1;
% sigma2 = 2;
% sigma3 = 3;

function [row_col, smoothed_img] = corner_detection(in_sigma, in_img, n)
%%                          Initialize Parameters
in_img = rgb2gray(in_img);
width = in_sigma*3;
win_size = width*2+1;
size1 = size(in_img, 1);
size2 = size(in_img, 2);

Filter = zeros(win_size, win_size);
total = 0;
%%                          Creating Gaussian Kernel
for i =-width:width
    for j = -width:width
        x = i+width+1;
        y = j+width+1;
        G = (1/(2*pi*(in_sigma^2)))*exp(-(i^2 + j^2)/((in_sigma^2)*2));
        Filter(x,y) = G;
        total = total+G;
    end
end
%%                        Computing Grads and C array
Filter = Filter/total;
kx = [-0.5, 0, 0.5];
ky = [-0.5; 0; 0.5];
smoothed_image = conv2(in_img, Filter);
smoothed_img = smoothed_image;

kx = rot90(kx, 2);
ky = rot90(ky, 2);

Gx = conv2(smoothed_image, kx);
Gy = conv2(smoothed_image, ky);

% figure(1)
% imagesc(Gx)
% colormap gray
% figure(2)
% imagesc(Gy)
% colormap gray
%%
Cxy = zeros(size(in_img));

for i = width+1:size1-width
    for j = width+1:size2-width
        x_sum = 0;
        y_sum = 0;
        xy_sum = 0;
        
        for x = i-width:i+width
            for y = j-width:j+width
                
                x_sum = x_sum + Gx(x,y)^2;
                y_sum = y_sum + Gy(x,y)^2;
                xy_sum = xy_sum + Gx(x,y)*Gy(x,y);
                
            end
        end
        
        C = [x_sum, xy_sum; xy_sum, y_sum];
        
        C_trace = trace(C);
        C_det = det(C);
        
        eig_min = 0.5*(C_trace - sqrt((C_trace^2) - 4*C_det));
        
        Cxy(i,j) = eig_min;
    end
end

Compare = zeros(size(in_img));
%%                                   NMS
for i = 2:size1-1
    for j = 2:size2-1
        if i < 50 || j < 50 || i > size1-50 || j > size2-50
            continue;
        end
        if Cxy(i,j) > Cxy(i-1,j-1) && Cxy(i,j) > Cxy(i-1,j) ...
                && Cxy(i,j) > Cxy(i-1,j+1) && Cxy(i,j) > Cxy(i,j-1) ...
                && Cxy(i,j) > Cxy(i,j+1) && Cxy(i,j) > Cxy(i+1,j-1) ...
                && Cxy(i,j) > Cxy(i+1,j) && Cxy(i,j) > Cxy(i+1, j+1)
            Compare(i,j) = Cxy(i,j);
        end
    end
end

[B, I] = sort(Compare(:), 'descend');
I = I(1:n);
B = B(1:n);
%%                              Plotting Points
[R, C] = ind2sub(size(in_img), I);
row_col = [R, C];

index = [C, R];

figure(1)
imshow(in_img)
for i = 1:n
    pt = index(i,:);
    drawPoint(pt);
end
