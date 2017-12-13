function [cols] = AverageBlocksInImage(in, b_size)
    [sy,sx] = size(in);       
    hbs = floor(b_size/2);
    cols=[]; row=[];
    for i=(hbs+1):b_size:(sy-(hbs+1))
        row=[];
        for j=(hbs+1):b_size:(sx-(hbs+1))
            row=[row, mean(mean(in((i-hbs):(i+hbs),(j-hbs):(j+hbs))))];
        end
        cols = [cols; row];
    end
end