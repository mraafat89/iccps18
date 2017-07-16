function [env, waypts] = define_env(M, N, start)
% M is cell number in x direction, 
% N is cell number in y direction
% start is a vector: (initial position of quadrotor)
%           --- (1, 1) means the bottom-left corner
%           --- (M, N) means the upper-right corner

start_pt = [0,0,0];
start_pt(1:2) = start - [0.5, 0.5];
stop_pt = start_pt + [0, 0, 1];

waypts = [start_pt;stop_pt];

env.boundary = [0, 0; M, N];

end

