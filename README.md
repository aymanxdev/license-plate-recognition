# License Plate Recognition Application -MATLAB


This design mainly studies the design of vehicle number plate classification system based on MATLAB software. The system mainly includes five core parts: image acquisition, image preprocessing, license plate location, character segmentation and character recognition. The image preprocessing module of the system converts the image into a binary image which is easy to locate the license plate through the operation of image graying, image enhancement, edge extraction and binarization. It uses the edge and shape characteristics of the license plate, and combines Roberts operator edge detection, digital image, morphology and other technologies to locate the license plate. The method of character segmentation is to find the continuous block of characters in the binary license plate, and cut if the length is longer than the set threshold, so as to complete the character segmentation. Character recognition is accomplished by template matching algorithm. Each of the above function modules is realized by MATLAB software. Finally, the license plate is identified. At the same time, the problems in the design are analyzed and dealt with concretely, and better methods are sought.

### Implementation and Design:
License plate recognition system includes:   
- image acquisition
- image preprocessing 
- license plate location 
- character segmentation 
- character recognition   


The system is mainly composed of image processing and character recognition. Where the image processing portion includes a map
Like preprocessing, edge extraction modules, license plate positioning, and segmentation modules. Character recognition part can be divided into words
Image grayscale and image edge extraction.

License plate location and license plate segmentation are the key to the entire system, and its role is in grayscale after image pre-processing.
Determining the specific location of the license plate in the image and segmenting a sub-image containing the license plate character from the entire image
result. For the recognition of the character recognition subsystem, the accuracy of the segmentation is directly related to the entire license plate character
and the recognition rate of the system.

#### The ultimate goal of the license plate recognition system is to identify unclear license plate photos and output a clear picture plus outputs every number and character on the license plate

### Flowchart
![flowchart](https://github.com/aymanxdev/license-plate-recognition/blob/main/flowchart.png)

### Procedure Steps 

1.	Corrosion operation
2.	Image clustering, fill image
3.	Remove the portion of the cluster with a gray value less than 2000
4.	Returns the dimensions of each of the 15 dimensions, stored in x, y, z
5.	Tic timing starts, toc ends
6.	Generate a zero pin for y*1
7.	If the myI image coordinates are (i, j), the point value is 1, that is, the background color is blue, blue plus one
8.	Blue pixel count
9.	Y-direction license plate area determination
10.	Temp is the maximum value of the element of the vector yellow_y, MaxY is the index of the value
11.	X-direction license plate area determination
12.	Further confirm the license plate area in the x direction
13.	Correction of the license plate area
14.	Write colored license plates to the dw file
15.	Reading license plate
16.	Convert license plate image to grayscale image
17.	Write a grayscale image to a file
18.	T is the threshold of binarization
19.	Binary image
20.	Before mean filtering
21.	Filter
22.	Create a predefined filter operator, average is mean filtering, template size is 3*3
23.	D, ie, mean filtering, h for h using the specified filter h
24.	Some images operate
25.	Expansion or corrosion
26.	Unit matrix
27.	Return information matrix
28.	Calculate whether the ratio of the total area of the object in the binary image to the entire area is greater than 0.365
29.	Corrosion if greater than 0.365
30.	Calculate whether the ratio of the total area of the object in the binary image to the entire area is less than 0.235
31.	If it is smaller, the expansion operation is implemented.
32.	Find a block with continuous text. If the length is greater than a certain threshold, the block is considered to have two characters and needs to be split.
33.	Cut out 7 characters
34.	Split the second to seventh characters
35.	Normalized size in commercial system programs is 40*20
36.	Final output.

### Output Screenshots 

![](https://github.com/aymanxdev/license-plate-recognition/blob/main/output_screenshot_1.png)

![](https://github.com/aymanxdev/license-plate-recognition/blob/main/output_screenshot_2.png)
