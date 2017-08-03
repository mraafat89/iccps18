function goals_normalized_posterior = update_goals_posterior(o_s, o_a)
    global goals_set;
    global goals_posterior;
    global goals_prior;
   % loop for each goal in the set
% %     Na = 4; %number of actions
% %     Nr = 5; %number of rows
% %     Nc = 5; %number of columns
% %     Ntot = Nr*Nc; %number of cells
% %     
% %     %% P-Calculations
% %     % initialize the transition matrix P
% %     P = zeros(Ntot,Ntot,Na);
% % 
% %     % checks to make sure we don't fall out of bounds
% %     % Move to north action a = 1
% %     for i = 1: Ntot
% %         pf = 0.8;
% %         if(rem(i,Nc) ~= 0) % i is not on the right edge
% %             P(i,i+1,1) = 0.1;
% %         else % i is on the right edge
% %             pf = 0.9;
% %         end
% %         if(rem(i,Nc) ~=1) % i is not on the left edge
% %            P(i,i-1,1) = 0.1;
% %         else % i is on the left edge
% %             pf = 0.9;
% %         end
% %         if((i+Nc) <= Ntot) % i is not on the top edge
% %             P(i,i+Nc,1) = pf;
% %         else
% %             P(i,i,1) = pf;
% %         end
% %     end
% %     % Move to south action a = 2
% %     for i = 1: Ntot
% %         pf = 0.8;
% %         if(rem(i,Nc) ~= 0) % i is not on the right edge
% %             P(i,i+1,2) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if(rem(i,Nc) ~=1) % i is not on the left edge
% %            P(i,i-1,2) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if((i-Nc) >= 1) % i is not on the bottom edge
% %             P(i,i-Nc,2) = pf;
% %         else
% %             P(i,i,2) = pf;
% %         end
% %     end
% %     % Move to west action a = 3
% %     for i = 1: Ntot
% %         pf = 0.8;
% %         if((i-Nc) >= 1) % i is not on the bottom edge
% %             P(i,i-Nc,3) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if((i+Nc) <= Ntot) % i is not on the top edge
% %            P(i,i+Nc,3) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if(rem(i,Nc) ~=1) % i is not on the left edge
% %             P(i,i-1,3) = pf;
% %         else
% %             P(i,i,3) = pf;
% %         end
% %     end
% %     % Move to east action a = 4
% %     for i = 1: Ntot
% %         pf = 0.8;
% %         if((i-Nc) >= 1) % i is not on the bottom edge
% %             P(i,i-Nc,4) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if((i+Nc) <= Ntot) % i is not on the top edge
% %            P(i,i+Nc,4) = 0.1;
% %         else
% %             pf = 0.9;
% %         end
% %         if(rem(i,Nc) ~= 0) % i is not on the right edge
% %             P(i,i+1,4) = pf;
% %         else
% %             P(i,i,4) = pf;
% %         end
% %     end
% %     % Stay in place action a = 5
% %     for i = 1: Ntot
% %         P(i,i,5) = 1;
% %     end
pf= 0.8;
pl= 0.1;
pr= 0.1;
pb= 0;
Na = 4; %number of actions
Nr = 5; %number of rows
Nc = 5; %number of columns
Ntot = Nr*Nc; %number of cells

    
v1=Nc:Nc:Ntot-1;    % 3, 6
v2=Nc+1:Nc:Ntot;    % 4, 7

a=1; %N
    for i=1:Ntot       
        for j=1:Ntot
            if j==i+Nc %i=6 j=9
                if ismember(j,v2)
                    P(i,j,a)=pf+pl;
                elseif ismember(j, v1) || j ==Ntot
                    P(i,j,a)=pf+pr;
                
                else
                    P(i,j,a)=pf;  
                end
                
            
            elseif j==i+Nc-1 %i=1, j=3
                if ismember(j,v1)
                    P(i,j+1,a)=pf+pl;
                elseif j==Ntot
                    P(i,j,a)=0;
                else
                    P(i,j,a)=pl;
                end
            elseif j==i+Nc+1 %i=3, j=7
                if ismember(j,v2)
                    P(i,j-1,a)=pf+pr;
                else
                    P(i,j,a)=pr;
                end
            else
                P(i,j,a)=0;
            end
        end
% P(Ntot-Nc+1:Ntot,:,a)=0;
        if (i>(Ntot-Nc)+1 && i<Ntot)
            P(i,i,a)=pf;
            P(i,i+1,a)=pr;
            P(i,i-1,a)=pl;
        elseif i==Ntot-Nc+1
            P(i,i,a)=pf+pl;
            P(i,i+1,a)=pr;
        elseif i==Ntot
            P(i,i,a)=pf+pr;
            P(i,i-1,a)=pl;
        end    
    end

a=2;%S
    for i=1:Ntot
        for j=1:Ntot
            P(i,j,2)=P(abs(Ntot-i)+1,abs(Ntot-j)+1,1);
        end
    end

a=3;%W
    count=0;
    for i=1:Nr
        for j=1:Nc
            count=count+1;
            A(i,j)=count-1+1;
        end
    end
     B=rot90(A);
     C=rot90(B);
     D=rot90(C);

    
    for i=1:Ntot
        for j=1:Ntot
       P(A(i),A(j),3)= P(D(i),D(j),1);

        end
    end

a=4;%E

    for i=1:Ntot
        for j=1:Ntot
       P(A(i),A(j),4)= P(B(i),B(j),1);

        end
    end
    %% Reward Function
    R(:,1) = -0.001*ones(1,Ntot);
    discount = 0.9; %0.0199999        
    alpha = 0.9;
    for i = 1: length(goals_set)
        R(goals_set(i))=1;
        R(:,2) = R(:,1);
        R(:,3) = R(:,1);
        R(:,4) = R(:,1);
       % R(:,5) = R(:,1);
        %% CHECK
        mdp_check(P, R)
        %% RUN MDP
        
        [Q, V, policy] = mdp_policy_iteration(P, R, discount)
        %[Q, V, policy] = mdp_Q_learning(P, R, discount);
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
        R(goals_set(i))=-0.001;
    end
    %goals_posterior = (goals_posterior-min(goals_posterior))/(max(goals_posterior)-min(goals_posterior)) ;
    %   goals_normalized_posterior = goals_posterior - min(goals_posterior(:));
 %   goals_normalized_posterior = goals_normalized_posterior ./ max(goals_normalized_posterior(:));
    maxv = max(goals_posterior(:));
    goals_normalized_posterior = uint8((double(goals_posterior) ./ maxv) .* 255);
end