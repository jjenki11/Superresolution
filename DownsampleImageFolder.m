
%   Take a folder of high res images and output low res images into
%   another folder given the type and downsampling factor

function [out] = DownsampleImageFolder(in_folder, out_folder, type, factor)
    fn0 = strcat('/*.', type);
    allFiles = dir( [in_folder fn0] );
    {allFiles(~[allFiles.isdir]).name};    
    [sx,sy] = size(allFiles);
    nim = max([sx,sy]);    
    dsamps = [];
    for i=1:nim
        in_tmp0 = strcat(in_folder, '/');
        in_tmp1 = strcat(in_tmp0, allFiles(i).name);        
        x = imread(in_tmp1);
        xg = rgb2gray(x);
        [oy, ox] = size(xg);        
        dsamps(:,:,i) = xg(1:factor:oy, 1:factor:ox);
        out_tmp0 = strcat(out_folder, '/');
        out_tmp1 = strcat(out_tmp0, allFiles(i).name);
        imwrite(uint8(dsamps(:,:,i)), out_tmp1);
    end
    out=dsamps;
end
