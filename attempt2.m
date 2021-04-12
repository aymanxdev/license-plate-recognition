global picture;
    picture = imread('car2.jpg');
    picture2Gray = rgb2gray(picture);                %??????
    figure,
    subplot(1, 3, 1),imshow(picture);title('????');          
    subplot(1, 3, 2),imshow(picture2Gray);title('????????');
    subplot(1, 3, 3),imhist(picture2Gray);title('??????????');colorbar;
%     grayEn = imadjust(picture2Gray, [], [0.25, 0.75], 2);       %?????
    grayEn = histeq(picture2Gray);              %??????
    figure, 
    subplot(1, 2, 1), imshow(grayEn);title('?????????');
    subplot(1, 2, 2), imhist(grayEn);title('??????????');
    %????
    grayEn = imfilter(grayEn, fspecial('average', 3));      %?????????????
    pictureOut = edge(grayEn, 'sobel');     
    figure,
    imshow(pictureOut), title('sobel?????????');
    close all;
%?????????
    se1 = [1 ; 1 ; 1];
  %  pictureErode = imerode(pictureIn, se1);
    figure, imshow(pictureErode), title('????+?????'); 
%     ?????????????????????
    se2 = strel('rectangle', [48, 48]);
    pictureClose = imclose(pictureErode, se2);
    figure, imshow(pictureClose), title('????+???????'); 
    pictureCut = bwareaopen(pictureClose, 10000);                    %??????
    pictureCut = removeLargeArea(pictureCut, 50000);             %??????
    figure, imshow(pictureCut), title('??????????');
    % ???????
    pictureRe = regionprops(pictureCut, 'area', 'boundingbox');
%     areas = [pictureRe.Area];    %????????areas?
    rects = cat(1, pictureRe.BoundingBox);      
   %????????????????rects????[???x??, ???y??, ??????(x), ?? 
   %????(y)]      
    figure, imshow(pictureCut), title('???????????');  
    rectangle('position', rects(1, :), 'EdgeColor', 'r');   %???????????????
    pictureOut = imcrop(picture, rects(1, :));                      %???????????
    figure, imshow(pictureOut), title('????????');
    close all;
    pictureGray1 = rgb2gray(pictureIn);
    %??????
    T=affine2d([0 1 0;1 0 0;0 0 1]);
    pictureTr=imwarp(pictureGray1,T);              % ??????????90°??????
    theta = -20 : 20;                                       %?????????
    r1 = radon(pictureTr, theta);                      %radon???????
    result1 = sum(abs(diff(r1)), 1);          %?????????????????????
    rot1 = find(result1==max(result1))-21;
    pictureRo = imrotate(pictureIn, rot1);
    figure, imshow(pictureIn), title('????');
    figure, imshow(pictureRo), title('???????????');
%??????
    pictureGray2 = rgb2gray(pictureRo);
    r2 = radon(pictureGray2, theta);
    result2 = sum(abs(diff(r2)), 1);
    rot2 = (find(result2==max(result2))-21)/57.3;           %???????
    if rot2>0
        T1 = affine2d([1 0 0 ; -tan(rot2) 1 0 ; size(pictureGray2, 1) * tan(rot2) 0 1]);
    else
        T1 = affine2d([1 0 0 ; tan(-rot2) 1 0 ; size(pictureGray2, 1) * tan(-rot2) 0 1]);
    end
    pictureOut = imwarp(pictureRo, T1);
    figure, imshow(pictureOut), title('??+?????????');
    close all;
% ???????????
    pictureGray1 = rgb2gray(pictureIn);
    [mY1, nY1] = size(pictureGray1);
    yresult = sum(abs(diff(pictureGray1)), 2);%1??? 2??
    yresult = imfilter(yresult, fspecial('average', 6));
    %??????
    yTemp1 = yresult(10 : ceil(mY1/4), 1);
    [~, ymin] = max(yTemp1);
    %??????
    yTemp2 = yresult(ceil(mY1/4) : (mY1 - 1), 1);
    [~, ymax] = max(yTemp2);
    ymax = ymax + ceil(mY1/4);
    pictureCutY =  imcrop(pictureIn, [1, ymin+5, nY1 , (ymax - ymin)-8]);
    
    % ???????
    pictureGray2 = rgb2gray(pictureCutY);
    [mX, nX] = size(pictureGray2);
    xdiff = zeros(mX, nX-1);
    for i = 1:mX
        xdiff(i, :) = abs(diff(pictureGray2(i, :)));            %????????????
        xresult = sum(xdiff, 1);
    end
    xresult = imfilter(xresult, fspecial('average', 6));
    %??????
    xTemp1 = xresult( 1, 1 : ceil(nX/5));
    [~, xmin] = max(xTemp1);
    %??????
    xTemp2 = xresult( 1, ceil(4*nX/5):(nX - 1));
    [~, xmax] = max(xTemp2);
    xmax = xmax + ceil(4*nX/5);
    pictureOut =  imcrop(pictureCutY, [xmin, 1,  (xmax - xmin) , mX]);
    figure, imshow(pictureOut), title('?????????');
    figure, imshow(pictureIn), title('????');
    close all;
    result = zeros(1, 5);    
    for i =35:39
        filename = strcat(int2str(i), 'car2.jpg');
        shuzi = imread(filename);
        level = graythresh(shuzi);          %ostu???????
        shuzi = imbinarize(shuzi, level);
        shuzi = imfilter(shuzi, fspecial('average', 3));
        Num =0;
        for j =1:48
            for k = 1:24
                if ( picture(j, k) == shuzi(j, k))
                    Num = Num+1;
                end
            end
        end
        result(1, i-34) = Num;
    end
    num = find(result == max(result));
    switch num
        case 1
            out = '?';
        case 2
            out = '?';
        case 3
            out = '?';    
        case 4
            out = '?';    
        case 5
            out = '?';  
        case 6
            out = '?'; 
        case 7
            out = '?'; 
    end
