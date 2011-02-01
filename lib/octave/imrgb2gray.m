function i = imrgb2gray(img)
	[q, mapp] = rgb2ind(
	img(:,:,1),
	img(:,:,2),
	img(:,:,3));
	i = ind2gray(q, mapp);
	if (isa(i, 'uint8'))
		x = double(i)/intmax(class(i))
	endif
endfunction
