% Nr x Nc probability matrix. How to read it:
% The probability that from cell 1 we move to cell 11 given action N is 0.9
    %
    % 7 8 9
    % 4 5 6
    % 1 2 3
    %
   %MR function    [P, policy1, policy2] = getP(Nr, Nc, c, d) 
 function    policy = getP(Nr, Nc) 
pf= 0.8;
pl= 0.1;
pr= 0.1;
pb= 0;
Na = 5; %number of actions
%Nr = 5; %number of rows
%Nc = 5; %number of columns
Ntot = Nr*Nc; %number of cells

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
        
%% REWARDS

R(:,1) = -3*ones(1,Ntot);
R(20)=1000000000;

R(:,2) = R(:,1);
R(:,3) = R(:,1);
R(:,4) = R(:,1);
R(:,5) = R(:,1);

%% CHECK
mdp_check(P, R)

%% RUN MDP

discount = 0.9; %0.01999999
%[V1, policy1] = mdp_policy_iteration(P, R, discount)
N = 100000;
[Q, V1, policy] = mdp_Q_learning(P, R, discount,N)

    end

