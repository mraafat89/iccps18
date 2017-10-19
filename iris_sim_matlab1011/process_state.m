function goal = process_state(t, state, env, policy)
% state is current state
% t is current time
global sensor_readings;
global attack_drift;
global active_learning;
global attack_enable;
global last_action;
global defend;
global active_learning_counter;
lambda = 0.5;

active_learning_directions = [4,1,1,1,4,4,4,4,4,4,4,2,2];


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
        %% Begin attack
         if(t > 5) 
             if(attack_enable == 1)
                 attack_drift = attack_drift + 1;
                 sensor_readings(:,1) = pos;
                 %sensor_readings(:,2) = pos;
                 %sensor_readings(2,2) = sensor_readings(2,2) + attack_drift;
                 if last_action == 1 %N
                      sensor_readings(2,2) = sensor_readings(2,2) +1;
                      sensor_readings(1,2) = sensor_readings(1,2) ;
                 elseif last_action == 2 %S
                      sensor_readings(2,2) = sensor_readings(2,2) -1;
                      sensor_readings(1,2) = sensor_readings(1,2);
                 elseif last_action == 3 %W
                      sensor_readings(2,2) = sensor_readings(2,2) +1;
                      sensor_readings(1,2) = sensor_readings(1,2) -1;
                 elseif last_action == 4 %E
                     sensor_readings(2,2) = sensor_readings(2,2) +1;
                     sensor_readings(1,2) = sensor_readings(1,2) + 1;
                 end
             else
                 sensor_readings(:,1) = pos;
                 sensor_readings(:,2) = pos;
             end
         else
             sensor_readings(:,1) = pos;
             sensor_readings(:,2) = pos;
         end
        %% TODO: KF now just the estimated state is just the average
        pos = mean(sensor_readings,2);
        if(pos(1) > 10)
            pos(1) =9.9;
        end
        if(pos(2) > 10)
            pos(2) =9.9;
        end
        
        if(defend == 1)
            if(active_learning == 1)
                if(t > 60)
                    pos = sensor_readings(:,1);
                end
            else
                if(t > 45)
                    pos = sensor_readings(:,1);
                end
            end
        end
        %% Draw the correct sensor data
    %    r = floor(sensor_readings(1,1))+1;
    %    q = floor(sensor_readings(2,1))+1;
    %    x_plot = [r-1 r-1 r r r-1]; 
    %    y_plot = [q-1 q q q-1 q-1];
    %    fill(x_plot,y_plot,[0, 1, 0])
       
        %% Draw the spoofed sensor data
%        r = floor(sensor_readings(1,2))+1;
%        q = floor(sensor_readings(2,2))+1;
%        x_plot = [r-1 r-1 r r r-1]; 
%        y_plot = [q-1 q q q-1 q-1];
%        fill(x_plot,y_plot,[1, 0, 0])
%        
%         %% Draw the estimated
%        r = floor(pos(1))+1;
%        q = floor(pos(2))+1;
%        x_plot = [r-1 r-1 r r r-1]; 
%        y_plot = [q-1 q q q-1 q-1];
%        fill(x_plot,y_plot,[0, 1, 1])
%        
        div=length(policy)/dimension;  
        count=0;
        for i=1:div
            for j=1:div
                count=count+1;
                 c(i,j) = policy(count);
            end
        end
        direction=c(floor(pos(2))+1,floor(pos(1))+1);
        applied_direction = direction;
        %% active learning
        if active_learning == 1
           if(t > 20 && t < 25)
            %  if rand(1) < lambda
                  % with probability = lambda, generate a random action
               applied_direction = 1;%ceil(rand(1) * 4);
             % end
           elseif(t > 25 && t < 30)
           % if rand(1) < lambda
                  % with probability = lambda, generate a random action
               applied_direction = 1; %ceil(rand(1) * 4);
           elseif(t > 30 && t < 35)
               applied_direction = 4;
           elseif(t > 35 && t < 40)
               applied_direction = 1;
           elseif(t > 40 && t < 45)
               applied_direction = 4;
            elseif(t > 45 && t < 50)
               applied_direction = 2;
            elseif(t > 50 && t < 55)
               applied_direction = 2;
            elseif(t > 55 && t < 60)
               applied_direction = 2;
            elseif(t > 60 && t < 65)
               applied_direction = 2;               
           end
        %end
          %$  applied_direction = active_learning_directions(active_learning_counter);
        %    active_learning_counter = active_learning_counter + 1;
        end
        %%
        if applied_direction == 1 %N
            mx=0;
            my=1;
        elseif applied_direction == 2 %S
            mx=0;
            my=-1;
        elseif applied_direction == 3 %W
            mx=-1;
            my=0;
        elseif applied_direction == 4 %E
            mx=1;
            my=0;
        end
        if applied_direction == 5 % don't move
            goal = []; % no new goal
        else
            goal = [mx, my, 0];
        end
        last_action = direction;
        %% Goal Inference
        global goals_normalized_posterior;
        % Observation O is a set of state-action pairs
        global observation_count;
        observation_count = observation_count + 1;
        global observed_actions;
        observed_actions(observation_count) = direction;
        global observed_states;
        observed_states(observation_count) = (floor(sensor_readings(2,1)) * dimension) +floor(sensor_readings(1,1))+1; % cell position represents a state. Range is 1-36 counting row by row.
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

