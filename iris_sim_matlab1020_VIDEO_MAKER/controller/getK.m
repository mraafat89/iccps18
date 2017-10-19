function K = getK(params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% parameters Q and R
Q = params.Q; R = params.R;

% Inertia Matrix
Ixx = params.I(1,1);
Iyy = params.I(2,2);
Izz = params.I(3,3);
Ixy = params.I(1,2);
Iyx = params.I(2,1);

psi_des = 0;

% Matrix A
A = zeros(12, 12);
A(1:6, 7:12) = eye(6);
A(7:8,4:5) = params.grav * [sin(psi_des), cos(psi_des);-cos(psi_des), sin(psi_des)];

% Matrix B
B = zeros(12,4);
den = Ixy^2 - Ixx * Iyy;
B(9:12,:) = diag([1/params.mass, -Iyy/den, -Ixx/den, 1/Izz]);
B(10,3) = Ixy/den;
B(11,2) = Ixy/den;

% LQR
[K, ~] = lqr(A, B, Q, R);

end

