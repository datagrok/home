function f = imfilter(a, b, c, d)
	if (nargin < 3)
		f = conv2(a, b); 
	elseif (nargin < 4)
		f = conv2(a, b, c); 
	else
		f = conv2(a, b, c, d); 
	endif
endfunction
