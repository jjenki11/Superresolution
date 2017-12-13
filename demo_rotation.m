% The notation here is column vectors instead of
%row vector used in the presentation.
clc
% clear all
% Rotation matrix
theta = 3*pi/180;
T = [ cos(theta) -sin(theta)  0
    0.5*sin(theta) cos(theta) 0
          0           0       1 ];
% I  = imread('im4.jpg');
I=test_img;
% I=imresize(I,0.5);
in=double((I));

[sy,sx]=size(in);
im(in)
% define input pixel coordinates
[W,Z]=meshgrid( [1:sx],[1:sy] );
IN = [ W(:)'; Z(:)'; ones(1,sx*sy) ];

x0=(sx+1)/2;
y0=(sy+1)/2;
S1 = [ 1 0 x0; 
      0 1 y0; 
      0 0 1 ];
S2 = [ 1 0 -x0;
       0 1 -y0;
       0 0 1 ];

% Perform coordinate transformation
OUT = (S1*T*S2)*IN;

% Extract the new X,Y coordinates
X = clip( OUT(1,:), 1, sx );
Y = clip( OUT(2,:), 1, sy );

% Clip to be in image range
X = reshape( X, sy,sx );
Y = reshape( Y, sy,sx );

% Get the values at the new coordinates
out2 = interp2( W,Z,in, X,Y, 'bil' );
im(out2)

%%
spac=16;
Dx=W-X;Dy=Z-Y;
figure
imagesc(in);colormap(gray(256));
hold on
[sy,sx]=size(in);
quiver([1:spac:sx],[1:spac:sy],...
    Dx(1:spac:end,1:spac:end),Dy(1:spac:end,1:spac:end),0.5)
figure
imagesc(out2); colormap(gray(256));