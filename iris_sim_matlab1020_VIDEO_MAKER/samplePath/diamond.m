function [desired_state] = diamond(t, qn)
% DIAMOND generates a  "diamond helix" with corners at (0; 0; 0),
% (0; 2 sin 45; 2 cos 45), (0; 0; 4 cos 45), and (0;-2 sin 45; 2 cos 45)
% when projected into the yz plane, and an x coordinate starting at 0 and
% ending at 1. The quadrotor should start at (0; 0; 0) and end at (1; 0; 0).

% Reference: I use quintic polynomial trajectories method mentioned in
% <Robot modeling and Control> by Spong, Hutchinson and Vidyasagar 1st
% edition. I utilize some of the code on page 178 "Matlab code to generate
% coefficients for quintic trajectory segment".

T       = 20;                   % finishing time
t       = min(max(t, 0), T);    % validating time
verts   = [0    0               0;
           1/4  2*sin(pi/4)     1*cos(pi/4);
           2/4  0               2*cos(pi/4);
           3/4  -2*sin(pi/4)    1*cos(pi/4);
           1    0               0];
% verts   = [0    0      0;
%            1    0      1;
%            1    1      2;
%            0    0      0];
if t >= T
    % hover controller input
    x       = 1;
    y       = 0;
    z       = 0;
    pos     = [x; y; z];
    vel     = zeros(3,1);
    acc     = zeros(3,1);
else
    % 3-d position controller input
    seg     = floor(t*4/T);     % segment number
    t0      = T/4*(seg);        % segment starting time
    tf      = t0 + T/4;         % segment ending time
    M       = [1    t0  t0^2    t0^3    t0^4    t0^5;
               0    1   2*t0    3*t0^2  4*t0^3  5*t0^4;
               0    0   2       6*t0    12*t0^2 20*t0^3;
               1    tf  tf^2    tf^3    tf^4    tf^5;
               0    1   2*tf    3*tf^2  4*tf^3  5*tf^4;
               0    0   2       6*tf    12*tf^2 20*tf^3];

    q0      = verts(seg+1,:);
    q1      = verts(seg+2,:);
    b       = [q0;
               0    0   0;
               0    0   0;
               q1;
               0    0   0;
               0    0   0];
    a       = M\b;
    pos     = a(1,:) + a(2,:)*t + a(3,:)*t^2 + a(4,:)*t^3 + a(5,:)*t^4 + a(6,:)*t^5;
    vel     = a(2,:) + 2*a(3,:)*t + 3*a(4,:)*t^2 + 4*a(5,:)*t^3 + 5*a(6,:)*t^4;
    acc     = 2*a(3,:) + 6*a(4,:)*t + 12*a(5,:)*t^2 + 20*a(6,:)*t^3;
end

% yaw and yawdot
yaw = 0;
yawdot = 0;

% output desired state
desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
% if t > 0.05
%     desired_state.pos = [20;0;0];
% else
%     desired_state.pos = zeros(3,1);
% end
% desired_state.vel = zeros(3,1);
% desired_state.acc = zeros(3,1);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;
end
