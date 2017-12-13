function out=interpalign(in,psfx,psfy,LX,LY,method,sx,sy);
%
% out=interpalign(in,psfx,psfy,LX,LY,method,sx,sy);
%
% interpolates assuming we want to fill around the known
% pixels and not between them as imresize( ) does.  It is subtle
% but important when trying to recover an image which has been
% filtered with an FIR PSF and subsampled.
%
% Upper left hand block of image (repeats throughout, X's spaced by LX,LY)
% where 'X' is what we know and 'o' is what we want
% to recover:
%
%            psfx=5
%      0   1   2   3   4
%    _____________________
% 0  | o | o | o | o | o |
% 1  | o | o | o | o | o |
% 2  | o | o | X | o | o |  psfy=5
% 3  | o | o | o | o | o |
% 4  | o | o | o | o | o |
%    _____________________
%
%
% out           interpolated image
% in            input image
% psfx,psfy     dimensions of FIR PSF before subsampling to for 'in'
% LX,LY         down sampling factor (spacing between the X's)
% method        interpolation method
%               'nea', 'bil', 'bic', 'spline'
% sx,sy         *optional* size to crop final image to.  The bottom and right
%               edge are cutoff.  sx <= LX*lrsx   sy <= LY*lrsy
%
% Author: Dr. Russell Hardie
% University of Dayton
% 6/14/01

% get size info
[lrsy,lrsx,temp]=size(in);

% compute the offset for the known values 'X' compared to the grid of 'o'
sty=(psfy-1)/2;
stx=(psfx-1)/2;

% compute the grid of known pixels (X's) plus a border of 1 all around
X=stx+LX*[-1:lrsx];
Y=sty+LY*[-1:lrsy]';

% compute the grid of pixels we want (o's)
XI=[0:lrsx*LX-1];
YI=[0:lrsy*LY-1]';

% perform desired interpolation
out=interp2(X,Y,softpad(in,1,1,1,1),XI,YI,method);

if nargin > 7
    out=out(1:sy,1:sx);
end
