function goals_normalized_posterior = update_goals_posterior(o_s, o_a)
    global goals_set;
    global goals_posterior;
    global goals_prior;
   % loop for each goal in the set
    Na = 5; %number of actions
    Nr = 6; %number of rows
    Nc = 6; %number of columns
    Ntot = Nr*Nc; %number of cells
    
    %% P-Calculations
    % initialize the transition matrix P
    P = zeros(Ntot,Ntot,Na);

    % checks to make sure we don't fall out of bounds
    % Move to north action a = 1
    for i = 1: Ntot
        pf = 0.8;
        if(rem(i,Nc) ~= 0) % i is not on the right edge
            P(i,i+1,1) = 0.1;
        else % i is on the right edge
            pf = 0.9;
        end
        if(rem(i,Nc) ~=1) % i is not on the left edge
           P(i,i-1,1) = 0.1;
        else % i is on the left edge
            pf = 0.9;
        end
        if((i+Nc) <= Ntot) % i is not on the top edge
            P(i,i+Nc,1) = pf;
        else
            P(i,i,1) = pf;
        end
    end
    % Move to south action a = 2
    for i = 1: Ntot
        pf = 0.8;
        if(rem(i,Nc) ~= 0) % i is not on the right edge
            P(i,i+1,2) = 0.1;
        else
            pf = 0.9;
        end
        if(rem(i,Nc) ~=1) % i is not on the left edge
           P(i,i-1,2) = 0.1;
        else
            pf = 0.9;
        end
        if((i-Nc) >= 1) % i is not on the bottom edge
            P(i,i-Nc,2) = pf;
        else
            P(i,i,2) = pf;
        end
    end
    % Move to west action a = 3
    for i = 1: Ntot
        pf = 0.8;
        if((i-Nc) >= 1) % i is not on the bottom edge
            P(i,i-Nc,3) = 0.1;
        else
            pf = 0.9;
        end
        if((i+Nc) <= Ntot) % i is not on the top edge
           P(i,i+Nc,3) = 0.1;
        else
            pf = 0.9;
        end
        if(rem(i,Nc) ~=1) % i is not on the left edge
            P(i,i-1,3) = pf;
        else
            P(i,i,3) = pf;
        end
    end
    % Move to east action a = 4
    for i = 1: Ntot
        pf = 0.8;
        if((i-Nc) >= 1) % i is not on the bottom edge
            P(i,i-Nc,4) = 0.1;
        else
            pf = 0.9;
        end
        if((i+Nc) <= Ntot) % i is not on the top edge
           P(i,i+Nc,4) = 0.1;
        else
            pf = 0.9;
        end
        if(rem(i,Nc) ~= 0) % i is not on the right edge
            P(i,i+1,4) = pf;
        else
            P(i,i,4) = pf;
        end
    end
    % Stay in place action a = 5
    for i = 1: Ntot
        P(i,i,5) = 1;
    end
    %% Reward Function
    R(:,1) = -0.01*ones(1,Ntot);
    discount = 0.9; %0.0199999        
    alpha = 0.9;
    for i = 1: length(goals_set)
        R(goals_set(i))=10;
        R(:,2) = R(:,1);
        R(:,3) = R(:,1);
        R(:,4) = R(:,1);
        R(:,5) = R(:,1);
        %% CHECK
        mdp_check(P, R)
        %% RUN MDP
        [Q, V, policy] = mdp_Q_learning(P, R, discount);
        % calculate likelihood numerator and denomenator
        Q_sum = zeros(Na,1); %summation of Q for each action over the observations
        A_sum = 0; % summation of Q of observed actions over the observations
        for j = 1: Na
            for k = 1: length(o_s)
                Q_sum(j) = Q_sum(j) + Q(o_s(k),j);
                if(j == o_a(k)) % this is the observed action
                    A_sum = A_sum + Q(o_s(k),o_a(k));
                end
            end
        end
        goal_likelihood = exp(alpha * A_sum)/(sum(exp(alpha * Q_sum)));
        % update goals posterior using Bayes's rule
        goals_posterior(i) =  goal_likelihood * goals_prior(i);
        %reset goal
        R(goals_set(i))=-3;
    end
    %goals_posterior = (goals_posterior-min(goals_posterior))/(max(goals_posterior)-min(goals_posterior)) ;
    %   goals_normalized_posterior = goals_posterior - min(goals_posterior(:));
 %   goals_normalized_posterior = goals_normalized_posterior ./ max(goals_normalized_posterior(:));
    maxv = max(goals_posterior(:));
    goals_normalized_posterior = uint8((double(goals_posterior) ./ maxv) .* 255)
end