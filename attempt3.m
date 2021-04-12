clc;clear;close all;
I = imread('car2.jpg');
figure('name','Original Image','NumberTitle','off');imshow(I);
if(size(I,3)==3)
    I = rgb2gray(I);
    figure('name','Gray Scale Image','NumberTitle','off');imshow(I);
end
BW = imbinarize(I,'adaptive','ForegroundPolarity','bright','Sensitivity',0.4);
I = BW;
figure('name','Binary Image','NumberTitle','off');imshow(BW);
BW = bwareaopen(BW, 2000);
figure('name','Binary Image after opening','NumberTitle','off');imshow(BW);
SE = strel('disk',12);
BW = imclose(BW,SE);
figure('name','Binary Image after closing','NumberTitle','off');imshow(BW);
[m,n] = size(BW);
for r = 1:m
    for c =1:n
        if BW(r,c)==1
            BW(r,c)=0;
        elseif BW(r,c)==0
            BW(r,c)=1;
        end
    end
end
figure('name','Binary Image after switch pixel','NumberTitle','off');imshow(BW);
[B,L] = bwboundaries(BW,4);

stats = regionprops(L,'Area','Centroid');

for j = 1:length(B)
    boundary = B{j};
    [m,n] = size(BW);
    notvalid = 0;
    for r = 1:size(boundary,1)
        if(boundary(r,1) == 1 || boundary(r,1) == m)
            notvalid = 1;
        elseif(boundary(r,2) == 1 || boundary(r,2) == n)
            notvalid = 1;
        end
    end
    if(notvalid == 1)
        continue;
    end
    delta_sq = diff(boundary).^2; 
    perimeter = sum(sum(delta_sq,2));
    area = stats(j).Area;
    metric = 27*area/perimeter^2;
    if metric >= 0.9 && metric <= 1.1
        s = min(boundary, [], 1);
        e = max(boundary, [], 1);
        theplate = imcrop(I,[s(2) s(1) e(2)-s(2) e(1)-s(1)]); 
    end
end
figure('name','the plate','NumberTitle','off');imshow(theplate);

[L,N] = bwlabel(theplate,8);
stats=regionprops(L,'BoundingBox');
for i=1:N
    box=stats(i).BoundingBox;
    x=box(1);%left
    y=box(2);%top
    w=box(3);%width
    h=box(4);%height
    if(w > 35 && h > 70)
    numbers = imcrop(theplate,[x,y,w,h]);
    figure('name','number');imshow(numbers);
    end
end
