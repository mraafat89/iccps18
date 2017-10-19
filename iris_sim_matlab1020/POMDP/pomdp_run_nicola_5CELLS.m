%% RUN MDP

discount = 0.9 %0.01999999
[V, policy] = mdp_policy_iteration(P, R, discount)

%% RUN POMDP
% Attacks makes me believe that I'm either in 5(2 sensors) or 6(1 sensor).
% The atatck can be either place. The robot doesn't know where it is. It
% has partial knowledge where it can be. What's the best strategy?

% P(7,:,:)=2/3*P(7,:,:)+1/3*P(8,:,:);
% P(8,:,:)=P(7,:,:);
P(20,:,:)=2/3*P(20,:,:)+1/3*P(17,:,:);
P(17,:,:)=P(20,:,:);

discount = 0.9 %0.01999999
[V, policy] = mdp_policy_iteration(P, R, discount)
