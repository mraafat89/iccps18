function goal = my_algorithm(t, state, env, policy)
% state is current state
% t is current time
%% Do Not Modify Here
    goal = [];

    % current state
    pos = state(1:3);
    vel = state(4:6);
    Rot = QuatToRot(state(7:10)');
    [phi, theta, yaw] = RotToRPY_ZXY(Rot);
    euler = [phi; theta; yaw];
    omega = state(11:13);

    % mapping measurement
    pos2cell2(pos, env,1,1,1);

    % if (pos(1)<=4 && pos(1)>=3) && (pos(2)<=3 && pos(2)>=2) && t < 25.05
    % %     att1=3;
    % %     att2=0;
    % %     att3=pos(3);
    % %     att=[att1 att2 att3];
    %     pos2cell2(pos, env,2,3,1); 
    % elseif (pos(1)<=4 && pos(1)>=3) && (pos(2)<=4 && pos(2)>=3) && t < 30.05
    %     pos2cell2(pos, env,2,3,2);
    % end
    %% Modify

    % if t < 5.05 && t > 4.95
    %if t < 35.05 && t > 34.95 
    %    goal = [0, 0, -0.9]
    %end
    if (rem(t,5) <=0.05)% 5.05 && t > 4.95 || t < 10.05 && t > 9.95 || t < 15.05 && t > 14.95 || t < 20.05 && t > 19.95 || t < 25.05 && t > 24.95 || t < 30.05 && t > 29.95)
    %         [a, p1, p2] = getP(5,5,19,14); %%%%%%%%%%%%%%%%%
    %          div=length(p1)/5;             %%%%%%%%%%%%%%%%%   
    %MR    if t < 20.05 && t > 19.95
    %MR        [a, p1, p2] = getP(5,5,14,9); %19,4 with starting 3,1    
    %MR        div=length(p2)/5;
    %MR    elseif t < 25.05 && t > 24.95
    %MR        [a, p1, p2] = getP(5,5,19,14); %19,4 with starting 3,1    
    %MR        div=length(p2)/5;
    %MR    else
    %MR        [a, p1, p2] = getP(5,5,19,14);

    %MR end
        %[Q, a, p1] = getP(5,5);

        div=length(policy)/5;  
        count=0;
        for i=1:div
            for j=1:div
                count=count+1;
                 c(i,j) = policy(count); %%%%%%%%%%%%%%%%%
        %        if t < 20.05 && t > 19.95
        %            c(i,j) = p2(count);
        %        elseif t < 25.05 && t > 24.95
        %            c(i,j) = p2(count);
        %        else
        %            c(i,j) = p1(count);
        %        end
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
        observed_states(observation_count) = (floor(pos(2)) * 5) +floor(pos(1))+1; % cell position represents a state. Range is 1-25 counting row by row.
        goals_normalized_posterior = update_goals_posterior(observed_states,observed_actions);

        %% Plot infered goals
        global goals_set;
        for i = 1: length(goals_set)
            q = floor(goals_set(i)/5) + 1; %quotient represents the column number (Y)
            r = rem(goals_set(i),5); % remainder represents the row number (X)
            if(r == 0)
                r = 5;
                q = goals_set(i)/5;
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

