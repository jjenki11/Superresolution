function [rot_img] = RotateImage(imagepad, angle)

    [nrows, ncols] = size(imagepad);
    midx=ceil((ncols+1)/2);
    midy=ceil((nrows+1)/2);  
    
    degree = angle*(pi/180);
    
    Mr = [cos(degree) sin(degree); -sin(degree) cos(degree)]; 

    % rotate about center
    [X, Y] = meshgrid(1:ncols,1:nrows);
    XYt = [X(:)-midx Y(:)-midy]*Mr;
    XYt = bsxfun(@plus,XYt,[midx midy]);
    xout = round(XYt(:,1)); yout = round(XYt(:,2)); % nearest neighbor!
    outbound = yout<1 | yout>nrows | xout<1 | xout>ncols;
    xout(xout<1) = 1; xout(xout>ncols) = ncols;
    yout(yout<1) = 1; yout(yout>nrows) = nrows;
    xout = repmat(xout,[1 1]); yout = repmat(yout,[1 1]);
    imagerot = imagepad(sub2ind(size(imagepad),yout,xout)); %,zout(:))); % lookup
    imagerot = reshape(imagerot,size(imagepad));
    imagerot(repmat(outbound,[1 1 1])) =[mean(imagepad(:))]; % set background value to [0 0 0] (black)
    
    rotated=imagerot;

    [newRows, newCols] = size(rotated);
    Roffset = newRows - nrows;
    Coffset = newCols - ncols;
    rtest = rotated(1+Roffset:end-Roffset, 1+Coffset:end-Coffset);
    rtest(find(isnan(rtest))) = 255;
    rot_img=rtest;
end
