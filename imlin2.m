%   Optical Signal and Image Processing
%   hw2
%   Jeff Jenkins
%   54jenkins@cua.edu
%
%   imlin2
%       - Takes an input image, a, and b and returns a contrast
%         stretched image
%       in          input image
%       a           a parameter
%       b           b parameter
%       out         output image

function [ out ] = imlin2( in, a, b )   
    in = double(in);
    out = in-min(in(:));
    c = min(in(:));
    d = max(in(:));
    out = out *(b-a);
    out = out / (d - c);
    out = out + a;   
end