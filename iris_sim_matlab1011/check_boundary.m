function flag = check_boundary(env, pt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

flag = false;

boundary = env.boundary;
x_min = boundary(1,1);
x_max = boundary(2,1);
y_min = boundary(1,2);
y_max = boundary(2,2);

if pt(1) <= x_min || pt(1) >= x_max || pt(2) >= y_max || pt(2) <= y_min
    flag = true;
end

end

