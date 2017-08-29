load('dino2.mat')
[row_col1, smoothed_img1] = corner_detection(3, dino01, 50);
[row_col2, smoothed_img2] = corner_detection(3, dino02, 50);
%%
thresh = 0.0005;
ratio = 0.6;
in_img = dino01;

for i = 1:50
    
    row1 = row_col1(i,1); col1 = row_col1(i,2);
    
    for j = 1:50
        
        row2 = row_col2(j,1); col2 = row_col2(j,2);
        if row1 < 6 || row1 > size(in_img,1)-6 || col1 < 6 || col1 > ...
                size(in_img,2)-6 || row2 < 6 || col2 < 6 || ...
                col2 > size(in_img,2)-6 || row2 > size(in_img,1)-6
            continue;
        else
            window1 = smoothed_img1(row1-4:row1+4, col1-4:col1+4);
            window2 = smoothed_img2(row2-4:row2+4, col2-4:col2+4);
        end
        u1 = (1/9)*sum(sum(window1));
        u2 = (1/9)*sum(sum(window2));
        o1 = sqrt((1/9))*sqrt(sum(sum((window1-u1).^2)));
        o2 = sqrt((1/9))*sqrt(sum(sum((window2-u2).^2)));
        
        NSSD(i,j) = sum(sum(((window1-u1)/o1 - (window2-u2)/o2).^2));
    end
end

NSSD_copy1 = NSSD;

storedval1 = [];
storedchord1 = [];

NSSD_copy1 = NSSD;
chords1 = [];
chords2 = [];
for i = 1:size(NSSD_copy1, 1)
    sorted_vals = sort(NSSD_copy1(i,:));
    min1_1 = sorted_vals(1,1);
    min1_2 = sorted_vals(1,2);
    
    if (min1_1/min1_2 < ratio) && (min1_1 < thresh)
         for j = 1:size(NSSD_copy1,2)
            minj = min(NSSD_copy1(:,j));
            if minj == min1_1
                storedchord1 = [storedchord1; i, j];
            end
         end
    end
    
end
dino1_rows = storedchord1(:,1);
dino2_rows = storedchord1(:,2);
dino1_row_col = [];
dino2_row_col = [];
dino01gray = rgb2gray(dino01);
dino02gray = rgb2gray(dino02);
dino02gray(1450:1500,:) = 255;
dino02gray(:,1900:2000) = 255;

figure(1)

for i = 1:length(dino1_rows)
    dino1_index = dino1_rows(i,1);
    dino2_index = dino2_rows(i,1);
    
    dino1_row_col = [dino1_row_col; row_col1(dino1_index,:)];
    dino2_row_col = [dino2_row_col; row_col2(dino2_index,:)];
        
end

dino1_col_row = dino1_row_col;
dino2_col_row = dino2_row_col;

temp1 = dino1_row_col(:,1); 
dino1_col_row(:,1) = dino1_col_row(:,2);
dino1_col_row(:,2) = temp1;

temp2 = dino2_row_col(:,1);
dino2_col_row(:,1) = dino2_col_row(:,2);
dino2_col_row(:,2) = temp2;

for i = 1:size(dino2_col_row,1)
    dino2_col_row(i,1) = dino2_col_row(i,1) + size(dino01,2);
end

imshow([dino01gray dino02gray]);
for i = 1:size(dino2_col_row)
    
    pt1 = dino1_col_row(i,:);
    drawPoint(pt1);
    pt2 = dino2_col_row(i,:);
    drawPoint(pt2);
    
    line([pt1(1), pt2(1)], [pt1(2), pt2(2)]);
end