function [F_est, M_est, state, disturbance] = ADRC(s, qd, t, qn, params, F, M)
% CONTROLLER quadrotor controller
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

persistent x_old t_old

% Initialize
if t == 0.0
    x_old = zeros(18, 1);
    t_old = 0;
end
mass = params.mass;
grav = params.grav;

tild_A = params.tild_A;
tild_B = params.tild_B;
tild_C = params.tild_C;
tild_L = params.tild_L;

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
y_arg = [x, y, z, phi, theta, psi, xdot, ydot, zdot, p, q, r]';
u0 = [mass * grav;0;0;0];
xdot = tild_A * x_old + tild_B * ([F;M] - u0) + tild_L * (y_arg - tild_C * x_old);

x_est = x_old + xdot * (t - t_old);
% keyboard
x_old = x_est;
t_old = t;

state = x_est(1:12);
disturbance = x_est(13:end);

F_est = F;
M_est = M;

end

