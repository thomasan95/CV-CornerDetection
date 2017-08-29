function F_denorm = estimateFundamental(x, x_p, dino01, dino02, row_col1)

% x = cor1;
% x_p = cor2;

% Normalize Matrix
x_mean_1 = mean(x(:,1)); x_var_1 = var(x(:,1));
y_mean_1 = mean(x(:,2)); y_var_1 = var(x(:,2));

x_mean_2 = mean(x_p(:,1));  x_var_2 = var(x_p(:,1));
y_mean_2 = mean(x_p(:,2));  y_var_2 = var(x_p(:,2));

% Turn into homogenous coordinates
x = [x(:,1), x(:,2), ones(length(x), 1)];
x_p = [x_p(:,1), x_p(:,2), ones(length(x_p), 1)];

s1 = sqrt(2/(x_var_1 + y_var_1));
s2 = sqrt(2/(x_var_2 + y_var_2));

Norm_Mat1 = [s1, 0, -x_mean_1*s1; 0, s1, -y_mean_1*s1; 0, 0, 1];
Norm_Mat2 = [s2, 0, -x_mean_2*s2; 0, s2, -y_mean_2*s2; 0, 0, 1];

x_bar = Norm_Mat1*x';
x_p_bar = Norm_Mat2*x_p';

x_bar = [x_bar(1,:)', x_bar(2,:)'];
x_p_bar = [x_p_bar(1,:)', x_p_bar(2,:)'];


% Af = 0
% A=[x_bar(:,1).*x_p_bar(:,1), x_bar(:,2).*x_p_bar(:,1), x_p_bar(:,1), ...
%     x_bar(:,1).*x_p_bar(:,2), x_bar(:,2).*x_p_bar(:,2), ...
%     x_p_bar(:,2), x_bar(:,1), x_bar(:,2), ones(length(x),1)];

A=[x_bar(:,1).*x_p_bar(:,1), x_bar(:,1).*x_p_bar(:,2), x_bar(:,1), ...
  x_bar(:,2).*x_p_bar(:,1), x_bar(:,2).*x_p_bar(:,2), ...
  x_bar(:,2), x_p_bar(:,1), x_p_bar(:,2), ones(length(x),1)];

[U, S, V] = svd(A);

F = reshape(V(:,9), 3, 3)';

[U2, S2, V2] = svd(F);
S2(3,3) = 0;

F = U2*S2*V2';

F_denorm = Norm_Mat2'*F*Norm_Mat1;

dino01gray = rgb2gray(dino01);
dino02gray = rgb2gray(dino02);

first_image = dino01gray;
second_image = dino02gray;
second_image(1450:1500,:) = 255;
second_image(:,1900:2000) = 255;
% 
% imshow([first_image second_image])
% 
% for i = 1:length(cor1)
%     
%     pt1 = cor1(i,:);
%     drawPoint(pt1);
%     pt2 = cor2(i,:);
%     pt2(1) = pt2(1)+ 2000;
%     drawPoint(pt2);
%     
%     line([pt1(1), pt2(1)], [pt1(2), pt2(2)]);
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

% imshow(dino01gray)
% for i = 1:length(cor1)
%     drawPoint(cor1(i,:))
%     homogP = [cor2(i,:), 1];
%     line = homogP*F_denorm;
%     drawLine(line, 'line', 'blue')
% end

% imshow(dino02gray)
% for i = 1:length(cor2)
%     drawPoint(cor2(i,:))
%     homogP = [cor1(i,:), 1];
%     line = homogP*F_denorm;
%     drawLine(line, 'line', 'blue')
% end

% imshow(dino01gray);
% drawPoint(point1);
% drawPoint(point2);
% drawPoint(point3);

imshow(dino02gray)

line1 = points(1,:)*F_denorm;
line2 = points(2,:)*F_denorm;
line3 = points(3,:)*F_denorm;
drawLine(line1, 'l1', 'blue');
drawLine(line2, 'l2', 'blue');
drawLine(line3, 'l3', 'blue');
