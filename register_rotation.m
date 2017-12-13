function [final_R,im2] = register_rotation( image1, image2, thresh, buff );
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

image1 =double(image1);
image2 =double(image2);


xkernel=(1/6)*[1 0 -1
               1 0 -1
               1 0 -1];

ykernel=(1/6)*[1  1  1
               0  0  0
              -1 -1 -1];

gx=conv2(image1,xkernel,'same');
gy=conv2(image1,ykernel,'same');


%-----------------------------------------------%
% Cut out center because of later shift effects %
%-----------------------------------------------%

[fully,fullx]=size(gx);   % old size
gx=gx(buff:fully-buff+1,buff:fullx-buff+1);
gy=gy(buff:fully-buff+1,buff:fullx-buff+1);
im1=image1(buff:fully-buff+1,buff:fullx-buff+1);

[ydim,xdim]=size(im1); % new smaller size 

%-----------------------%
% Generate the M matrix %
%-----------------------%
ssx=buff:fully-buff+1;
ssy=buff:fullx-buff+1;

% T1 = .0014; %um
% T2 = .0014; %um

T1=.01; T2=.01;

hb=floor(max(size(ssy(:)))/2);
ha=floor(max(size(ssx(:)))/2);


for b=1:max(size(ssy(:)))
    for a=1:max(size(ssx(:)))
        ghaty(a,b) = (b-hb)*T1*gy(a,b);
        ghatx(a,b) = (a-ha)*T2*gx(a,b);
    end
end

g_bar = ghaty - ghatx;

gbar_gx = sum(sum(g_bar.*gx));
gbar_gy = sum(sum(g_bar.*gy));

gx_2 = sum(sum(gx.^2));
gy_2 = sum(sum(gy.^2));
gbar_2  = sum(sum(g_bar.^2));

cross=sum(sum(gx.*gy));

M=[ gx_2,    cross,   gbar_gx;
    cross,   gy_2,    gbar_gy;
    gbar_gx, gbar_gy, gbar_2];

%---------------------------%
% Initialize loop constants %
%---------------------------%
count=0; % Number of times through loop
stop=0;  % Loop stop flag

im2=(image2);   % start with the ``warped'' image being the full second image
Rn=zeros(3,1); % set initial shift estimates to zero
Rold=Rn;
% X=[1:fully];  % samp grid of original data in x   
% Y=[1:fullx]'; % samp grid of original data in y

%---------------------------%
% Begin iterative estimates %
%---------------------------%
while stop~=1
  count=count+1;

  % calculate the difference image over the interior region 
    yk=double(im2(buff:fully-buff+1,buff:fullx-buff+1)-im1);

    figure(8),
    imagesc(yk), colormap 'gray'
    title('difference between update and reference')

  % Generate the V matrix
    V=[ sum(sum( yk.*gx ));
        sum(sum( yk.*gy ));
        sum(sum( yk.*g_bar ));];
 
    local = M\V;

    Rn = Rn + local;    

    [sy,sx]=size(im2);
    [W,Z]=meshgrid( [1:sx],[1:sy] );    
    nearest_x = round(Rn(1,1));
    nearest_y = round(Rn(2,1));  
    XI=[1-nearest_x:fullx-nearest_x];
    YI=[1-nearest_y:fully-nearest_y]';

%     if(Rold == zeros(3,1))
%         check_val=100000;
%     else      
      check_val = sqrt(sum((Rn-Rold).^2)) / sqrt(sum(Rold.^2));
%     end
      
  % See if its time to stop or warp and continue
  if count > 50 | ((check_val < thresh))%| (nnz(isnan(check_val)) >0)
    stop=1;      
    count   
    im2(find(isnan(im2))) = 0;    
    figure(9),imagesc(im2);
    figure(10),imagesc(image1);
    final_R = Rn;
  else   % sub-pixelly rotate and then shift image2 according to latest estimate        
    
      % TBD start fresh with image2 each time?
    x = RotateImage(image2, -Rn(3,1));        
    % Get the values at the new coordinates        
    im2 = interp2( W,Z,x, XI,YI, 'bic' );  
    im2(find(isnan(im2))) = 0;   
  end
end