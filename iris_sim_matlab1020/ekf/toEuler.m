function eul = toEuler( R )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

phi = asin(R(3,2));
theta = atan2(-R(3, 1), R(3,3));
psi =  atan2(-R(1,2), R(2,2));
eul = [phi;theta;psi];
end

