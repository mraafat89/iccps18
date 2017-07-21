function goals_normalized_posterior = update_goals_posterior(o)
    global goals_set;
    global goals_posterior;
    global goals_prior;
   % loop for each goal in the set
    pf= 0.8;
    pl= 0.1;
    pr= 0.1;
    pb= 0;
    Na = 4; %number of actions
    Nr = 6; %number of rows
    Nc = 6; %number of columns
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

       P(:,:,1)


    a=2;%S
        for i=1:Ntot
            for j=1:Ntot
                P(i,j,2)=P(abs(Ntot-i)+1,abs(Ntot-j)+1,1);
            end
        end
            P(:,:,2)

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
            P(:,:,3)

    a=4;%E

    for i=1:Ntot
        for j=1:Ntot
            P(A(i),A(j),4)= P(B(i),B(j),1);
        end
    end
    P(:,:,4)
    R(:,1) = -3*ones(1,Ntot);
    discount = 0.9; %0.01999999
    for i = 1: length(goals_set)
        R(goals_set(i))=100;
        R(:,2) = R(:,1);
        R(:,3) = R(:,1);
        R(:,4) = R(:,1);
        %% CHECK
        mdp_check(P, R)
        %% RUN MDP
        [Q, V1, policy1] = mdp_Q_learning(P, R, discount);
        alpha = 0.3;
        goal_likelihood = exp(alpha * Q(o.state,o.action))/sum(exp(alpha * Q(o.state,:)));
        % update goals posterior using Bayes's rule
        goals_posterior(i) = 0.3 * goal_likelihood * goals_posterior(i);
        %reset goal
        R(goals_set(i))=-3;
    end
 %   goals_normalized_posterior = goals_posterior - min(goals_posterior(:));
 %   goals_normalized_posterior = goals_normalized_posterior ./ max(goals_normalized_posterior(:));
    maxv = max(goals_posterior(:));
    goals_normalized_posterior = uint8((double(goals_posterior) ./ maxv) .* 255);
end