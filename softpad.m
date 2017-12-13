function [frame] = softpad(frame,t,r,b,l);
%
% [frame] = softpad(frame,t,r,b,l);
% 
% Pads the borders of an image by mirroring the outer pixels
%
% frame			Input image and expanded output image
%
% t			Border size to add to image on top
% r			Border size to add to image on right
% b			Border size to add to image on bottom
% l			Border size to add to image on left
%
% Author: Dr. Russell C. Hardie  


% Get input frame size
[ydim,xdim]=size(frame);

top=frame(1:t,:);
bot=frame(ydim-b+1:ydim,:);
frame=[flipud(top); frame; flipud(bot)];

lef=frame(:,1:l);
rig=frame(:,xdim-r+1:xdim);
frame=[fliplr(lef),frame, fliplr(rig)];
