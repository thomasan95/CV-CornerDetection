load('dino2.mat')
[row_col1, smoothed_img1] = corner_detection(3, dino01, 50);
[row_col2, smoothed_img2] = corner_detection(3, dino02, 50);
%%
F = estimateFundamental(cor1, cor2, dino01, dino02, row_col1);
dino01gray = rgb2gray(dino01);
dino02gray = rgb2gray(dino02);
dino02gray = padarray(dino02gray, [50, 25]);
% 
% first_image = dino01gray;
% second_image = dino02gray;
% second_image = padarray(second_image, [50, 25]);
% 
% imshow([first_image second_image])
% 
% for i = 1:length(cor1)
%     
%     pt1 = cor1(i,:);
%     drawPoint(pt1);
%     pt2 = cor2(i,:);
%     pt2(1) = pt2(1)+ 2000;
%     drawPoint(pt2);
%     
%     line([pt1(1), pt2(1)], [pt1(2), pt2(2)]);
% end

R = row_col1(:,1);
C = row_col1(:,2);
col_row1 = [C, R];

point1 = [C(1,1), R(1,1)];
point2 = [C(2,1), R(2,1)];
point3 = [C(3,1), R(3,1)];

points = [point1;point2;point3];
points = [points, ones(length(points),1)];
dino01gray = rgb2gray(dino01);

imshow(dino01gray)
for i = 1:length(cor1)
    drawPoint(cor1(i,:))
    homogP = [cor2(i,:), 1];
    line = homogP*F;
    drawLine(line, 'line', 'blue')
end

% imshow(dino02gray)
% for i = 1:length(cor2)
%     drawPoint(cor2(i,:))
%     homogP = [cor1(i,:), 1];
%     line = homogP*F;
%     drawLine(line, 'line', 'blue')
% end

% imshow(dino01gray);
% drawPoint(point1);
% drawPoint(point2);
% drawPoint(point3);
% 
% imshow(dino02gray)
% 
% line1 = points(1,:)*F;
% line2 = points(2,:)*F;
% line3 = points(3,:)*F;
% drawLine(line1, 'l1', 'blue');
% drawLine(line2, 'l2', 'blue');
% drawLine(line3, 'l3', 'blue');