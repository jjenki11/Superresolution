%% hw5 - affine_example
%   Jeff Jenkins
%
%% Consider rotation angle  theta = pi/4;

function [out2] = ApplyRotation(x, theta, fig_num)
% theta = pi/4;   
%% 1-Define Rotation matrix (column vector notation)
Rmat= [[cos(theta), -sin(theta), 0]',...
       [sin(theta), cos(theta), 0]',...
       [0, 0, 1]'];
%% 2-load pout.tif and display image of size (sy x sx)
% x = double(imread('pout.tif'));
% sy = 500;   sx = 500;
% xsz = imresize(x, [sx sy]);
[sy,sx] = size(x);
%% 3-define input pixel coordinates using meshgrid
[W,Z] = meshgrid([1:sx],[1:sy]);
%% 4- Form new matrix IN similar to scalingtransformation.m
IN = [ W(:)'; Z(:)'];

%% What went wrong???
% The center of rotation is specified to be the (0,0) pixel which is
% in the top left hand corner of the image.  This causes a rotation about
% this corner point instead of the center of the image.
%% 9-Define the center of rotation to be in the middle of the image
w0 = floor(sx/2); z0 = floor(sy/2);
%% 10- Define translation matrices as slide number 10 but (column notation)
Tmat1 = [ [1,0,-w0]',[0,1,-z0]',[0,0,1]' ];
Tmat2 = [ [1,0,w0]',[0,1,z0]',[0,0,1]' ];
xform = Tmat1 * Rmat * Tmat2;
%% 11- repeat steps 5 to 8.
tform2=maketform('affine',xform);
OUT2=tformfwd(IN',tform2)';
X2 = clip( OUT2(1,:), 1, sx );
Y2 = clip( OUT2(2,:), 1, sy );
X2 = reshape( X2, sy,sx );
Y2 = reshape( Y2, sy,sx );
out2 = interp2( W,Z,x, X2,Y2, 'bil' );
% display the (properly) transformed image
figure(fig_num),
imagesc(out2-x)
end