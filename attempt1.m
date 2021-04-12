clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
% Check that user has the specified Toolbox installed and licensed.
hasLicenseForToolbox = license('test', 'image_toolbox');   % license('test','Statistics_toolbox'), license('test','Signal_toolbox')
if ~hasLicenseForToolbox
  % User does not have the toolbox installed, or if it is, there is no available license for it.
  % For example, there is a pool of 10 licenses and all 10 have been checked out by other people already.
  ver % List what toolboxes the user has licenses available for.
  message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
  reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
  if strcmpi(reply, 'No')
    % User said No, so exit.
    return;
  end
end
%===============================================================================
% Read in gray scale demo image.
folder = pwd; % Determine where demo folder is (works with all versions).
baseFileName = 'car3.jpg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
  % The file doesn't exist -- didn't find it there in that folder.  
  % Check the entire search path (other folders) for the file by stripping off the folder.
  fullFileNameOnSearchPath = baseFileName; % No path this time.
  if ~exist(fullFileNameOnSearchPath, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
rgbImage = imread(fullFileName);
% Display the image.
subplot(2, 3, 1);
imshow(rgbImage, []);
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis on;
hp = impixelinfo();
% Get the dimensions of the image.  
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(rgbImage);
if numberOfColorChannels > 1
  % It's not really gray scale like we expected - it's color.
  % Use weighted sum of ALL channels to create a gray scale image.
%   grayImage = rgb2gray(rgbImage); 
  % ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
  % which in a typical snapshot will be the least noisy channel.
  grayImage = rgbImage(:, :, 3); % Take blue channel.
else
  grayImage = rgbImage; % It's already gray scale.
end
% Now it's gray scale with range of 0 to 255.
% Display the image.
subplot(2, 3, 1);
imshow(grayImage, []);
title('Original Gray Scale Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis on;
%------------------------------------------------------------------------------
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% Get rid of tool bar and pulldown menus that are along top of figure.
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
drawnow;
subplot(2, 3, 2);
imhist(grayImage);
grid on;
title('Histogram', 'FontSize', fontSize, 'Interpreter', 'None');
% Convert to logical (binary) with range false and true.
binaryImage = grayImage < 128;
% % Get rid of white surround.
% binaryImage = imclearborder(binaryImage);
% Display the image.
subplot(2, 3, 3);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis on;
% Do a closing to connect blobs separated in a letter, like the first A.
binaryImage = imclose(binaryImage, true(3));
% Get bounding box sizes
labeledImage = bwlabel(binaryImage);
props = regionprops(binaryImage, 'BoundingBox');
allBB = [props.BoundingBox];
allWidths = allBB(3:4:end)
allHeights = allBB(4:4:end)
% Find blobs that have widths of 20-100, and heights of 50-125.
lettersIndexes = find(allWidths > 20 & allWidths < 100 & allHeights > 20 & allHeights < 125)
binaryImage = ismember(labeledImage, lettersIndexes);
% Display the image.
subplot(2, 3, 4);
imshow(binaryImage, []);
title('Letters Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis on;
% Take the 6 largest blobs, just in case there are more due to noise.
binaryImage = bwareafilt(binaryImage, 6);
% Display the image.
subplot(2, 3, 5);
imshow(binaryImage, []);
title('Final Letters Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis on;
% Get bounding box sizes
labeledImage = bwlabel(binaryImage);
props = regionprops(binaryImage, 'BoundingBox');
% Open a new figure window.
figure;
% Extract the bounding boxes with imcrop().
for k = 1 : length(props)
  thisBB = props(k).BoundingBox;
  subImage = imcrop(binaryImage, thisBB);
  subplot(2, 3, k);
  imshow(subImage);
end
%------------------------------------------------------------------------------
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% Get rid of tool bar and pulldown menus that are along top of figure.
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
drawnow;