
function [rots, x_shifts, y_shifts] = GenerateRandomTransformations(n_xforms)

    lower_limit = -10;
    upper_limit = 10;
    
    rots = (randi([-10, 10],1,n_xforms));
    x_shifts = (randi([-10, 10],1,n_xforms));
    y_shifts = (randi([-10, 10],1,n_xforms));
    
end