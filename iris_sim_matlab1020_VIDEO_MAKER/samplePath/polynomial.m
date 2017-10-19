function [desired_state] = polynomial(t, qn)
%polynomial traj for testing

coeffs = [0.00335409, -0.0374999, 0.111803, 0, 0, 0];

if(t > 4.472)
  t = 4.472;
end

r = coeffs*[t^5; t^4; t^3; t^2; t; 1];

pos = [r; r; r];
yaw = 0;

rd = coeffs*[5*t^4; 4*t^3; 3*t^2; 2*t; 1; 0];

vel = [rd; rd; rd];
yawdot = 0;

rdd = coeffs*[20*t^3; 12*t^2; 6*t; 2; 0; 0];
acc = [rdd; rdd; rdd];

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

end
