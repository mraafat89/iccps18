function [F, M, trpy, drpy] = LQRcontroller(qd, t, qn, params)
% LQR CONTROLLER quadrotor controller
%
% INPUTS:
% qd     - 1 x n cell, qd structure, contains current and desired state
% t      - 1 x 1, time
% qn     - quad number (used for multi-robot simulations)
% params - struct, output from nanoplus() and whatever parameters you want to pass in
%
% OUTPUTS:
% F      - 1 x 1, thrust
% M      - 3 x 1, moments
% trpy   - 1 x 4, desired thrust, roll, pitch, yaw
% drpy   - 1 x 3, derivative of desired roll, pitch, yaw

%convert qd to state
[s] = qdToState(qd{qn});

%get desired state
pos_des = qd{qn}.pos_des;
vel_des = qd{qn}.vel_des;
acc_des = qd{qn}.acc_des;
psi_des = qd{qn}.yaw_des;
p_des = 0;
q_des = 0;
r_des = qd{qn}.yawdot_des;

% Assign current states
x    = s(1);
y    = s(2);
z    = s(3);
xdot = s(4);
ydot = s(5);
zdot = s(6);
qW   = s(7);
qX   = s(8);
qY   = s(9);
qZ   = s(10);
p    = s(11);
q    = s(12);
r    = s(13);
Rot  = QuatToRot([qW; qX; qY; qZ]);
[phi, theta, psi] = RotToRPY_ZXY(Rot);

% % Position controller
% ax_des = acc_des(1) + params.kp_xy * (pos_des(1) - x) + params.kd_xy * (vel_des(1) - xdot); % + params.ki_xy*(x_int);
% ay_des = acc_des(2) + params.kp_xy * (pos_des(2) - y) + params.kd_xy * (vel_des(2) - ydot); %+ params.ki_xy*(y_int);
% az_des = acc_des(3) + params.kp_z  * (pos_des(3) - z) + params.kd_z  * (vel_des(3) - zdot); % + params.ki_z*(z_int);

%az_des =  params.kp_z*(pos_des(3)-z) + params.kd_z*(-zdot) + params.ki_z*(z_int);

%compute desired roll and pitch angle based on desired acceleration and yaw angle
%here we assume that the net vertical force produced by the props in close to mg
%ades_body = [cos(psi), sin(psi); -sin(psi), cos(psi)] * [ax_des; ay_des];
%theta_des = atan2(ades_body(1),(params.grav))+thetadelta;
%phi_des = atan2(-ades_body(2),(params.grav))+phidelta;

ax_des = acc_des(1);
ay_des = acc_des(2);
az_des = acc_des(3);

theta_des = (1 / params.grav) * (ax_des * cos(psi_des) + ay_des * sin(psi_des));
phi_des   = (1 / params.grav) * (ax_des * sin(psi_des) - ay_des * cos(psi_des));

% LQR Controller
global K;
X_vec = [pos_des; phi_des; theta_des; psi_des; vel_des;  p_des; q_des; r_des];
X_0 = [x, y, z, phi, theta, psi, xdot, ydot, zdot, p, q, r]';
err = X_vec - X_0;
u = K * err; 

% output
F = u(1) + params.mass * params.grav;
M = u(2:end);
trpy = [F*1000/params.grav, phi_des, theta_des, psi_des];
drpy = [0, 0,       0,         0];


end
