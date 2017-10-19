function [desired_state] = velCmd(t, qn)

% yaw and yawdot
yaw = 0;
yawdot = 0;

% output desired state
desired_state.pos = zeros(3,1);
desired_state.vel = zeros(3,1);
desired_state.acc = zeros(3,1);
% desired_state.vel = zeros(3,1);
% % desired_state.acc = zeros(3,1);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

if t > 18.0    
    desired_state.vel = [0;0;0];
elseif t > 10.0    
    desired_state.vel = [0.5;0;0];
elseif t > 5.0
    desired_state.vel = [0.1;0;0];
end
end
