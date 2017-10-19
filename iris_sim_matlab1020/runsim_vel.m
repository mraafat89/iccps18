% NOTE: This srcipt will not run as expected unless you fill in proper
% code in trajhandle and controlhandle
% You should not modify any part of this script except for the
% visualization part
%
%% ***************** MEAM 620 QUADROTOR SIMULATION *****************
close all
clear all
addpath('utils')
addpath('trajectories')

% You need to implement trajhandle and controlhandle

% trajectory generator
trajhandle = @velCmd;

% controller
% controlhandle = @controller;
% controlhandle = @LQRcontroller;
controlhandle = @vel_controller1;

%% *********** YOU SHOULDN'T NEED TO CHANGE ANYTHING BELOW **********
% number of quadrotors
nquad = 1;

% max time
time_tol = 30;

% parameters for simulation
params = nanoplus();
global K;
K = getK(params);
%% **************************** FIGURES *****************************
fprintf('Initializing figures...\n')
h_fig = figure;
h_3d = gca;
axis equal
grid on
view(3);
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]')
quadcolors = lines(nquad);

set(gcf,'Renderer','OpenGL')
set(h_fig, 'KeyPressFcn', @(h_fig, evt)MyKeyPress_Cb(evt.Key));
%% *********************** INITIAL CONDITIONS ***********************
fprintf('Setting initial conditions...\n')
starttime = 0;          % start of simulation in seconds
tstep     = 0.01;       % this determines the time step at which the solution is given
cstep     = 0.05;       % image capture time interval
nstep     = cstep/tstep;
time      = starttime;  % current time
max_iter  = time_tol / cstep;      % max iteration
for qn = 1:nquad
    % Get start and stop position
    des_start = trajhandle(0, qn);
    des_stop  = trajhandle(inf, qn);
    stop{qn}  = des_stop.pos;
    x0{qn}    = init_state( des_start.pos );
    xtraj{qn} = zeros(max_iter*nstep, length(x0{qn}));
    ttraj{qn} = zeros(max_iter*nstep, 1);
end

x         = x0;        % state

% Maximum position error of the quadrotor at goal
pos_tol  = 0.02; % m
% Maximum speed of the quadrotor at goal
vel_tol  = 0.02; % m/s

%% ************************* RUN SIMULATION *************************
global key;
key = -1;
rpy = zeros(3,1);
fprintf('Simulation Running....')
iter = 0;
% Main loop
while key ~= 'q'
    iter = iter + 1;
    timeint = time:tstep:time+cstep;

    tic;
    % Iterate over each quad
    for qn = 1:nquad
        % Initialize quad plot
        if iter == 1
%             QP{qn} = QuadPlot(qn, x0{qn}, 0.1, 0.04, quadcolors(qn,:), max_iter, h_3d);
            QP{qn} = QuadPlot(qn, x0{qn}, params.arm_mat, 0.04, quadcolors(qn,:), max_iter, h_3d);
            desired_state = trajhandle(time, qn);
            QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time);
            h_title = title(sprintf('iteration: %d, time: %4.2f', iter, time));
        end

        % Run simulation
        [tsave, xsave] = ode45(@(t,s) quadEOM(t, s, qn, controlhandle, trajhandle, params), timeint, x{qn});
        x{qn}    = xsave(end, :)';

        % Save to traj
        xtraj{qn}((iter-1)*nstep+1:iter*nstep,:) = xsave(1:end-1,:);
        ttraj{qn}((iter-1)*nstep+1:iter*nstep) = tsave(1:end-1);

        % Update quad plot
        desired_state = trajhandle(time + cstep, qn);
        QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], time + cstep);
    end
    [phi, theta, psi] = RotToRPY_ZXY(QP{qn}.rot');
    rpy = [rpy,[phi;theta;psi]];
    set(h_title, 'String', sprintf('iteration: %d, time: %4.2f', iter, time + cstep))
    time = time + cstep; % Update simulation time
    t = toc;

    % Pause to make real-time
    if (t < cstep)
        pause(cstep - t);
    end

    % Check termination criteria
%     if terminate_check(x, time, stop, pos_tol, vel_tol, time_tol)
%         break
%     end
end
key = -1;
%% ************************* POST PROCESSING *************************
% Truncate xtraj and ttraj
for qn = 1:nquad
    xtraj{qn} = xtraj{qn}(1:iter*nstep,:);
    ttraj{qn} = ttraj{qn}(1:iter*nstep);
end

% Plot the saved position and velocity of each robot
for qn = 1:nquad
    % Truncate saved variables
    QP{qn}.TruncateHist();
    % Plot position for each quad
    h_pos{qn} = figure('Name', ['Quad ' num2str(qn) ' : position']);
    plot_state(h_pos{qn}, QP{qn}.state_hist(1:3,:), QP{qn}.time_hist, 'pos', 'vic');
    plot_state(h_pos{qn}, QP{qn}.state_des_hist(1:3,:), QP{qn}.time_hist, 'pos', 'des');
    % Plot orientation for each quad
    h_ori{qn} = figure('Name', ['Quad ' num2str(qn) ' : euler']);
    plot_state(h_ori{qn}, rpy, QP{qn}.time_hist, 'euler', 'vic');
    % Plot velocity for each quad
    h_vel{qn} = figure('Name', ['Quad ' num2str(qn) ' : velocity']);
    plot_state(h_vel{qn}, QP{qn}.state_hist(4:6,:), QP{qn}.time_hist, 'vel', 'vic');
    plot_state(h_vel{qn}, QP{qn}.state_des_hist(4:6,:), QP{qn}.time_hist, 'vel', 'des');
end

fprintf('finished.\n')
