function S = register_shift( image1, image2, thresh, buff );
% S = register_shift( image1, image2, thresh, buff );
%
% A. Schaum Registration Algorithm using Prewitt Operator. 
% Uses Peleg's iterative estimation technique to treat large shift values
% paper:Analytic Methods of Image Registration Displacement Estimation and Resampling
% See paper high resolution image reconstruction from a sequence 
% of rotated and translated frames and its application to an infrared
% imaging system by russell hardie

% image1	Reference image
% image2	Unknown shift image 
% thresh	The threshold for the largest shift to accept, suggested=.1
% buff		The border buffer to ignore due to border effects and
%		shift effects, suggested=max expected  shift
% 
% S=[sx,sy]	Output shift vector
% sx		horizontal shift
% sy 		vertical shift
%
% Author: Dr. Russell C. Hardie
% June 1996, modified 8/12/04

%---------------------------------%
% Estimate the discrete gradients %
%---------------------------------%

xkernel=(1/6)*[1 0 -1
               1 0 -1
               1 0 -1];

ykernel=(1/6)*[1  1  1
               0  0  0
              -1 -1 -1];

gx=conv2(image1,xkernel,'same');
gy=conv2(image1,ykernel,'same');
% im(gx)
% % 
% % figure;
% title('Vertical Gradient'); 
% 
% % figure;
% im(gy);
% title('Horizontal Gradient');

%-----------------------------------------------%
% Cut out center because of later shift effects %
%-----------------------------------------------%

[fully,fullx]=size(gx);   % old size
gx=gx(buff:fully-buff+1,buff:fullx-buff+1);
gy=gy(buff:fully-buff+1,buff:fullx-buff+1);
image1=image1(buff:fully-buff+1,buff:fullx-buff+1);
[ydim,xdim]=size(image1); % new smaller size 

%-----------------------%
% Generate the M matrix %
%-----------------------%
% since we assume no rotation theta =0 and M is a 2x2 matrix
cross=sum(sum(gx.*gy));
M=[ sum(sum(gx.^2)), cross, 
    cross, sum(sum(gy.^2))];

%---------------------------%
% Initialize loop constants %
%---------------------------%

count=0; % Number of times through loop
stop=0;  % Loop stop flag

im2=image2;   % start with the ``warped'' image being the full second image
S=zeros(2,1); % set initial shift estimates to zero

X=[1:fullx];  % samp grid of original data in x   
Y=[1:fully]'; % samp grid of original data in y

%---------------------------%
% Begin iterative estimates %
%---------------------------%

while stop~=1
  count=count+1;

  % calculate the difference image over the interior region 
  gt=im2(buff:fully-buff+1,buff:fullx-buff+1)-image1;

  % Generate the V matrix
  V=[sum(sum( gt.*gx ))
     sum(sum( gt.*gy ))];

  % Find local shift estimate (Schaum)
  local=inv(M)*V;

  % Update the global estimate
  S=S+local;

  % See if its time to stop or warp and continue

  if count > 10 | ( abs(local(1)) < thresh & abs(local(2)) < thresh )
        stop=1;  
  else   % sub-pixelly shift image2 according to latest estimate
        XI=[1-S(1):fullx-S(1)];
        YI=[1-S(2):fully-S(2)]';
        im2=interp2(X,Y,image2,XI,YI,'bilinear');
	% Note that this repositioning puts NaN outside of original
	% grid.  This is why I cut out using buff and only operate on
	% the interior portion (free of NaN).
  end

end