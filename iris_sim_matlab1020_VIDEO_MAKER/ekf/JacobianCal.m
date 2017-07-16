clc;
clear;
close all;


%% Calculate Jacobian symbolic representation
syms x y z phi theta psi % x1 x2
syms vx vy vz 
syms wx wy wz ax ay az          
syms bgx bgy bgz ngx ngy ngz
syms bax bay baz nax nay naz
syms dt
syms nbgx nbgy nbgz
syms nbax nbay nbaz
g = 9.81;


% 
p = [x;y;z];
q = [phi;theta;psi];
p_dot = [vx;vy;vz];
bg = [bgx;bgy;bgz];
ba = [bax;bay;baz];
X_vec = [p;q;p_dot];

% body frame
omega = [wx;wy;wz];
acc = [ax;ay;az];
ng = [ngx;ngy;ngz];
na = [nax;nay;naz];
nbg = [nbgx;nbgy;nbgz];
nba = [nbax;nbay;nbaz];

G = [cos(theta), 0, -cos(phi)*sin(theta);
     0,          1,  sin(phi);
     sin(theta), 0,  cos(phi)*cos(theta)];
 
R_rot = toRot(phi, theta, psi);
p_ddot = R_rot*(acc - ba - na) - [0;0;-g];

f = X_vec + dt*[p_dot;
               G^(-1)*(omega-bg-ng);
               [0;0;-g] + R_rot*(acc - ba - na);
               nbg;
               nba];

h = [p;q];

% Jacobian
J = jacobian(f, X_vec);
A = simplify(J);
A_fun = matlabFunction(A);

J = jacobian(f, [ng;na;bg;ba]);
B = simplify(J);
B_fun = matlabFunction(B);

J = jacobian(h, X_vec);
C = simplify(J);
C_fun = matlabFunction(C);