corner_detection.m
	Param: in_sigma, in_img, n
		in_sigma: input sigma
		in_img: input image
		n: number of corners to detect
	Output: row_col, smoothed_img
		row_col: rows and columns (stored as column matrix)
			of the corresponding corners
		smoothed_img: Gaussian filtered image
	This function takes in an image and creates a Gaussian filter, which size is
	specified by the input sigma. After the Gaussian filter is computed, the original
	image is smoothed by convolving the Gaussian filter with the original image.
	I compute the gradients by convolving those with the rotated gradient kernels
	(-0.5, 0, 0.5) for X gradient and (-0.5; 0; 0.5) for the Y gradient.
	After the gradients were computed, I established the C matrix based off of window
	size, and then used the equation 
	eig_min = 0.5*(C_trace - sqrt((C_trace^2) - 4*C_det));
	The code then performs Non Maximal Suppression, grabbing only eigen values
	that were the greatest of their neighbors.
	After that, it’s just a matter of plotting the coordinates.

stereo_correspondence.m
	This file calculates the NSSD values of the given images. My code calculates
	based off of a 9x9 window, calculating the mean and variance of dino01, dino02.
	These values are then stored in a 50x50 NSSD matrix with row i and column j
	corresponding with the i’th corner in image 1 with the j’th corner in 
	image 2. After that, I then grab the lowest of the each row and match it with the
	column it corresponds to and make sure that that specific value is the lowest
	in both row and column. I perform thresholding after that to make sure it meets
	the specified thresh (i used 0.0005) and matching ratio (i used 0.6). 
	For each “match” I find, I store the index (i and j) that the “match” corresponds 	to and find the coordinates based off of the corresponding row in row_col1 and
	row_col2 which are returned from corner_detection.m.
	After that, I then pad the image to have the images match in size and then plot
	the coordinates together, drawing lines in between. I had to offset the corners
	detected in image 2 by 2000 though, to correspond with the combined image of
	dino01 and dino02.

estimateFundamental.m
	This function calculates the fundamental coordinates based off of the coordinates 	x (cor1) and x’(cor2), as well as the dino images and coordinates for the 3 
	points. The function first performs normalization of the homogenous coordinates. 
	The normalization matrix is constructed using the mean and variances of both
	cor1 and cor2. After that, the homogenous coordinates for the corresponding
	points in cor1 and cor2 are normalized. 
	The A matrix is then constructed, with the form of 
	[x*x’, x*y’, x, y*x’, y*y’, y*x’, x’, y’, 1]
	I grab the V column of the lowest scalar value (which would be the last
	vector column of the V matrix after running svd) and reshape that into a 3x3
	after. To ensure that the fundamental matrix is of rank 2, I run svd on the 
	previously obtained matrix. I then denormalize it by multiplying the normal
	matrices from before in reverse order. After that, it’s just plotting points and
	corresponding lines.