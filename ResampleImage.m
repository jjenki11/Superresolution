
function [out, dx, dy] = ResampleImage(in, fx, fy, method)
    Z=double(in);
    [sy,sx]=size(Z);
    [X,Y]=meshgrid([1:sx],[1:sy]);
    [XI,YI] = meshgrid(1:fx:sx,1:fy:sy);
    dx = abs(XI(1,1) - XI(1,2));
    dy = abs(YI(1,1) - YI(2,1));
    out = interp2(X,Y,Z,XI,YI, method);
end


