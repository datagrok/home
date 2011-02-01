## Copyright (C) 1996, 1997 John W. Eaton
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, write to the Free
## Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
## 02110-1301, USA.

## -*- texinfo -*-
## @deftypefn {Function File} {} image (@var{x}, @var{zoom})
## @deftypefnx {Function File} {} image (@var{x}, @var{y}, @var{A}, @var{zoom})
## Display a matrix as a color image.  The elements of @var{x} are indices
## into the current colormap and should have values between 1 and the
## length of the colormap.  If @var{zoom} is omitted, the image will be
## scaled to fit within 600x350 (to a max of 4).
##
## The axis values corresponding to the matrix elements are specified in
## @var{x} and @var{y}. At present they are ignored.
## @end deftypefn
##
## @seealso{imshow, imagesc, and colormap}

## Author: Tony Richardson <arichard@stark.cc.oh.us>
## Created: July 1994
## Adapted-By: jwe

## Author: Michael Lamb http://datagrok.org
## image.m from the octave distribution blows.

function image (x, y, A, zoom)
  ppm_name = "octave-image.ppm";

  if (nargin == 0)
    ## Load Bobbie Jo Richardson (Born 3/16/94)
    A = loadimage ("default.img");
    zoom = 2;
  elseif (nargin == 1)
    A = x;
    zoom = [];
    x = y = [];
  elseif (nargin == 2)
    A = x;
    zoom = y;
    x = y = [];
  elseif (nargin == 3)
	warning("x and y values are currently ignored.");
    zoom = [];
  elseif (nargin > 4)
    usage ("image (matrix, zoom) or image (x, y, matrix, zoom)");
  endif

  saveimage (ppm_name, A, "ppm");

  % if no zoom was specified, determine if there should be
  % one. If we do zoom in, make it an integer value so
  % pixels are evenly scaled up.
  if isempty(zoom)
	if min(size(A)) < 200
		zoom = floor(max(200./size(A)));
	else
		zoom = 1;
	endif
  endif

  hw = floor(size(A) .* zoom);

  system (sprintf ("pnmtoxwd \"%s\" | xwud  -geometry %dx%d &", ppm_name, hw(2), hw(1)));

  %system (sprintf ("convert -scale %dx%d \"%s\" xwd:- | xwud > /dev/null 2>&1 &", hw(2), hw(1), ppm_name));
endfunction
