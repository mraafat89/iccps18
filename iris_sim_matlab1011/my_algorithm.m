function goal = my_algorithm(t, state, env, policy)
% state is current state
% t is current time
%% Do Not Modify Here
    goal = [];
    dimension = env.boundary(2);
    % current state
    pos = state(1:3);
    vel = state(4:6);
    Rot = QuatToRot(state(7:10)');
    [phi, theta, yaw] = RotToRPY_ZXY(Rot);
    euler = [phi; theta; yaw];
    omega = state(11:13);

    % mapping measurement
    pos2cell2(pos, env,1,1,1);

 
    if (rem(t,5) <=0.05)
        div=length(policy)/dimension;  
        count=0;
        for i=1:div
            for j=1:div
                count=count+1;
                 c(i,j) = policy(count);
            end
        end
        direction=c(floor(pos(2))+1,floor(pos(1))+1);
        if direction == 1 %N
            mx=0;
            my=1;
        elseif direction == 2 %S
            mx=0;
            my=-1;
        elseif direction == 3 %W
            mx=-1;
            my=0;
        elseif direction == 4 %E
            mx=1;
            my=0;
        end
        if direction == 5 % don't move
            goal = []; % no new goal
        else
            goal = [mx, my, 0];
        end

        %% Goal Inference
        global goals_normalized_posterior;
        % Observation O is a set of state-action pairs
        global observation_count;
        observation_count = observation_count + 1;
        global observed_actions;
        observed_actions(observation_count) = direction;
        global observed_states;
        observed_states(observation_count) = (floor(pos(2)) * dimension) +floor(pos(1))+1; % cell position represents a state. Range is 1-36 counting row by row.
        goals_normalized_posterior = update_goals_posterior(observed_states,observed_actions);

        %% Plot infered goals
        global goals_set;
        for i = 1: length(goals_set)
            q = floor(goals_set(i)/dimension) + 1; %quotient represents the column number (Y)
            r = rem(goals_set(i),dimension); % remainder represents the row number (X)
            if(r == 0)
                r = dimension;
                q = goals_set(i)/dimension;
            end
            % calculate the coordinates of the 4 corners of the square to fill
            x_plot = [r-1 r-1 r r r-1]; 
            y_plot = [q-1 q q q-1 q-1];
            % fill the potential goal with its value from the color mapped
            % posterior
            fill(x_plot,y_plot,goals_normalized_posterior(i));
        end
    end
end

