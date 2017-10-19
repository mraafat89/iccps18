close all;
clear all;
clc;
addpath(genpath('./'));

%% Loading Waypts
disp('Loading WayPoints ...');

% modify function "define_waypts" to define your own path
% waypts = define_waypts();

% [env, waypts] = define_env(5, 5, [3, 1]);
[env, waypts] = define_env(5, 5, [1, 3]);

%% Loading Map (Do NOT change anything here currently)
map = load_map('maps/emptyMap.txt', 1.0, 2.0, 0.35);
start = {waypts(1,:)};
stop  = {waypts(end,:)};
nquad = length(start);
for qn = 1:nquad
    path{qn} = waypts;
end

%% Initialize trajectory

% set maximum velocity
global v_max
v_max = 0.5; % v < 5.5 (SImulation Experimental Value)

disp('Generating Trajectory ...');
trajectory_generator([], [], map, path);

%% Run trajectory
controlhandle = @Linearcontroller;
trajectory = test_trajectory(start, stop, map, path, controlhandle, true, env); % with visualization
disp('Finished!');
