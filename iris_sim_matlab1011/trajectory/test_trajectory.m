function [xtraj, ttraj, terminate_cond] = test_trajectory(start, stop, map, path, controlhandle, vis, env)
% TEST_TRAJECTORY simulates the robot from START to STOP following a PATH
% that's been planned for MAP.
% start - a 3d vector or a cell contains multiple 3d vectors
% stop  - a 3d vector or a cell contains multiple 3d vectors
% map   - map generated by your load_map
% path  - n x 3 matrix path planned by your dijkstra algorithm
% vis   - true for displaying visualization

%Controller and trajectory generator handles
trajhandle    = @trajectory_generator;

% Make cell
if ~iscell(start), start = {start}; end
if ~iscell(stop),  stop  = {stop}; end
if ~iscell(path),  path  = {path} ;end

% Get nquad
nquad = length(start);

% Make column vector
for qn = 1:nquad
    start{qn} = start{qn}(:);
    stop{qn} = stop{qn}(:);
end

% Quadrotor model
params = nanoplus();
global K
K = getK(params);
%% **************************** FIGURES *****************************
% Environment figure
if nargin < 7
    vis = true;
end

fprintf('Initializing figures...\n')
if vis
    h_fig = figure('Name', 'Environment');
else
    h_fig = figure('Name', 'Environment', 'Visible', 'Off');
end

h_3d = gca;
% grid on;
drawnow;
%*************************************************************************
% plot environment
plot (-10,-10,'r-');
hold on
plot (-10,-10,'b-');
legend('actual trajectory','desired trajectory');
hold on

boundary_x = env.boundary(2, 1);
boundary_y = env.boundary(2, 2);
xe=[0 boundary_x boundary_x 0 0];
ye=[0 0 boundary_y boundary_y 0];
fill(xe,ye,[0.8, 0.9, 0.9])
hold on
% xg=[0 boundary_x-3 boundary_x-3 0 0]
% yg=[boundary_y-1 boundary_y-1 boundary_y boundary_y boundary_y-1]
xg=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
yg=[boundary_y-3 boundary_y-3 boundary_y boundary_y boundary_y-3];
fill(xg,yg,[0.4, 0.99, 0.8])
hold on
% xb=[boundary_x-3 boundary_x boundary_x boundary_x-3 boundary_x-3]
% yb=[boundary_y-1 boundary_y-1 boundary_y boundary_y boundary_y-1]
xb=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
yb=[0 0 boundary_y-3 boundary_y-3 0];
fill(xb,yb,[0.9, 0.5, 0.5])
hold on
 
% xo1=[3 4 4 3 3];
% yo2=[3 3 4 4 3];
% fill(xo1,yo2,[0.9, 0.9, 0.9])
% hold on
%  
% xo1=[3 4 4 3 3];
% yo2=[0 0 1 1 0];
% fill(xo1,yo2,[0.9, 0.9, 0.9])
% hold on
 
 
for ii=1:boundary_x-1
    plot ([ii,ii],[0, boundary_y],'k');
end
for jj=1:boundary_y-1
    plot ([0, boundary_x],[jj, jj],'k');
end


% boundary_x = env.boundary(2, 1);
% boundary_y = env.boundary(2, 2);
% [xx, yy] = meshgrid(0:boundary_x, 0:boundary_y);
% zz = ones(size(xx)) * 0.9;
% surf(xx, yy, zz);
% alpha 0.2;
% colormap(hsv);


hold on;
axis([-1, env.boundary(2, 1) + 1, -1, env.boundary(2,2) + 1]);
view(0,90);
% hold on;
%*************************************************************************
% view(3);
xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
axis equal;
quadcolors = lines(nquad);
set(gcf,'Renderer','OpenGL')
 set(gca,'Color',[0.8 0.8 0.8]);
set(h_fig, 'KeyPressFcn', @(h_fig, evt)MyKeyPress_Cb(evt.Key));
%% *********************** INITIAL CONDITIONS ***********************
fprintf('Setting initial conditions...\n')
% Maximum time that the quadrotor is allowed to fly
time_tol = 50;          % maximum simulation time
starttime = 0;          % start of simulation in seconds
tstep     = 0.01;       % this determines the time step at which the solution is given
cstep     = 0.05;       % image capture time interval
nstep     = cstep/tstep;
time      = starttime;  % current time
max_iter  = time_tol / cstep;      % max iteration
for qn = 1:nquad
    % Get start and stop position
    x0{qn}    = init_state( start{qn} );
    xtraj{qn} = zeros(max_iter*nstep, length(x0{qn}));
    ttraj{qn} = zeros(max_iter*nstep, 1);
end

% Maximum position error of the quadrotor at goal
pos_tol  = 0.05; % m
% Maximum speed of the quadrotor at goal
vel_tol  = 0.05; % m/s

x = x0;        % state

%% ************************* RUN SIMULATION *************************
global key;
key = -1;
rpy = zeros(3,1);
fprintf('Simulation Running....\n')
iter = 0;
sim_time = 0;
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
            desired_state = trajhandle(sim_time, qn);
            QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], sim_time);
            h_title = title(sprintf('iteration: %d, time: %4.2f  ( Press "q" to stop )', iter, sim_time));
        end
        % Run simulation
        [tsave, xsave] = ode45(@(t,s) quadEOM(t, s, qn, controlhandle, trajhandle, params), timeint, x{qn});
        x{qn}    = xsave(end, :)';
        
        % add noise
        x{qn} = add_noise(x{qn});
        %*****************************************************************%
        sim_time = sim_time + cstep; % Update simulation time
        goal_new = my_algorithm(sim_time, x{qn}, env);
        if ~isempty(goal_new)
            cmd_start = x{qn}(1:3)';
            cmd_stop = cmd_start + goal_new;
            if ~check_boundary(env, cmd_stop)
                cmd_path{qn} = [cmd_start;cmd_stop];
                trajectory_generator([], [], map, cmd_path);
                time = -cstep;
            end
            
        end
        %*****************************************************************%
        
        % Save to traj
        xtraj{qn}((iter-1)*nstep+1:iter*nstep,:) = xsave(1:end-1,:);
        ttraj{qn}((iter-1)*nstep+1:iter*nstep) = tsave(1:end-1);

        % Update quad plot
        desired_state = trajhandle(time + cstep, qn);
        QP{qn}.UpdateQuadPlot(x{qn}, [desired_state.pos; desired_state.vel], sim_time + cstep);
    end
    [phi, theta, psi] = RotToRPY_ZXY(QP{qn}.rot');
    rpy = [rpy,[phi;theta;psi]];
    set(h_title, 'String', sprintf('iteration: %d, time: %4.2f   ( Press "q" to stop )', iter, sim_time + cstep))
    time = time + cstep; % update trajectory time
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

end
