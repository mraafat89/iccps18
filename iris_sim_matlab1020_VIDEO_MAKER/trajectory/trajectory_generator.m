function [ desired_state ] = trajectory_generator(t, qn, map, path)
% TRAJECTORY_GENERATOR: Turn a Dijkstra or A* path into a trajectory
%
% NOTE: This function would be called with variable number of input
% arguments. In init_script, it will be called with arguments
% trajectory_generator([], [], map, path) and later, in test_trajectory,
% it will be called with only t and qn as arguments, so your code should
% be able to handle that. This can be done by checking the number of
% arguments to the function using the "nargin" variable, check the
% MATLAB documentation for more information.
%
% map: The map structure returned by your load_map function
% path: This is the path returned by your planner (dijkstra function)
%
% desired_state: Contains all the information that is passed to the
% controller, as in phase 2
%
% It is suggested to use "persistent" variables to store map and path
% during the initialization call of trajectory_generator, e.g.

persistent map0 path0 coeff_x coeff_y coeff_z num time
persistent start stop t_total
global v_max

v = v_max; % v < 5.5

if nargin > 2
    map0 = map;
    path0 = path{1};
    res = map0{1}(3, :);
    numOfPoint = size(path0, 1);
       
    %***************************************************************
    validPointIDX = ones(numOfPoint, 1);
% %     validPointIDX(2:end-1) = 0;
%     i = 1;
%     j = i + 1;
%     while j < numOfPoint
%         num_res = max((path0(j, :) - path0(i, :))./res);
%         a = linspace(path0(i, 1), path0(j,1), num_res+1);
%         b = linspace(path0(i, 2), path0(j,2), num_res+1);
%         c = linspace(path0(i, 3), path0(j,3), num_res+1);
%         
%         
%         if all(collide(map, [a', b', c'])==0)
%             validPointIDX(j) = 0;
%             j = j + 1;
%         else 
%             i = j - 1;
%             validPointIDX(i) = 1;
%         end
%     end
% %     point = path0(1, :);
% %     for i = 2 : numOfPoint - 1
% %         num_res = max((point - path0(i, :))./res);
% %         a = linspace(point(1), path0(i,1), num_res+1);
% %         b = linspace(point(2), path0(i,2), num_res+1);
% %         c = linspace(point(3), path0(i,3), num_res+1);
% %         
% %         
% %         if all(collide(map0, [a', b', c'])==0)
% %             validPointIDX(i) = 0;
% %         else 
% %             validPointIDX(i-1) = 1;
% %             point = path0(i-1, :);
% %         end
% %     end

    validPoint = path0(logical(validPointIDX), :);
    start = validPoint(1:end-1, :);
    stop = validPoint(2:end, :);
    
    %***************************************************************
    
    
    % calculate distance
    dis = sqrt(sum((stop - start).^2, 2));
    num = size(start, 1);
    dis_total = sum(dis);
    t_total = dis_total/v;
    t_sum = 0;
    % calculate coefficient
    coeff_x = zeros(6, num);
    coeff_y = coeff_x;
    coeff_z = coeff_x;
      
    for i = 1 : num
        
        p0 = start(i, :);
        pt = stop(i, :);
        v0 = 0;
        vt = 0;
        a0 = 0;
        at = 0;
        
        t = ceil(sqrt(dis(i)/dis_total)*t_total);
        time(i) = t_sum;
        t_sum = t_sum + t;
        X = [0,      0,      0,     0,   0   1;
             t^5,    t^4,    t^3,   t^2, t,  1;
             0,      0,      0,     0,   1,  0;
             5*t^4,  4*t^3,  3*t^2, 2*t, 1,  0;
             0,      0,      0,     2,   0,  0;
             20*t^3, 12*t^2, 6*t,   2,   0,  0];

        coeff_x(:, i) = X \ [p0(1), pt(1), v0, vt, a0, at]';
        coeff_y(:, i) = X \ [p0(2), pt(2), v0, vt, a0, at]';
        coeff_z(:, i) = X \ [p0(3), pt(3), v0, vt, a0, at]';
    end
    time(i + 1) = ceil(t_sum);
    return;   
end  

if t >= time(end) 
    desired_state.pos = stop(end,:)';
    desired_state.vel = zeros(3,1);
    desired_state.acc = zeros(3,1);
    desired_state.yaw = 0;
    desired_state.yawdot = 0;
    return;
end

idx = find(time<=t);
idx = idx(end);
t = t - time(idx);
if idx > size(coeff_x, 2)
    idx = size(coeff_x, 2);
end

s = [t^5, t^4, t^3, t^2, t, 1];
sd = [5*t^4, 4*t^3, 3*t^2, 2*t, 1, 0];
sdd = [20*t^3, 12*t^2, 6*t, 2, 0, 0];


px = s * coeff_x(:, idx);
vx = sd * coeff_x(:, idx);
ax = sdd * coeff_x(:, idx);

py = s * coeff_y(:, idx);
vy = sd * coeff_y(:, idx);
ay = sdd * coeff_y(:, idx);

pz = s * coeff_z(:, idx);
vz = sd * coeff_z(:, idx);
az = sdd * coeff_z(:, idx);

pos = [px; py; pz];
vel = [vx; vy; vz];
acc = [ax; ay; az];

yaw = 0;
yawdot = 0;

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;
    
end

