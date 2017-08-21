% Nr x Nc probability matrix. How to read it:
% The probability that from cell 1 we move to cell 11 given action N is 0.9
    %
    % 7 8 9
    % 4 5 6
    % 1 2 3
    %
   %MR function    [P, policy1, policy2] = getP(Nr, Nc, c, d) 
 function    policy = getP(Nr, Nc) 
% % pf= 0.8;
% % pl= 0.1;
% % pr= 0.1;
% % pb= 0;
% % Na = 5; %number of actions
% % %Nr = 5; %number of rows
% % %Nc = 5; %number of columns
% % Ntot = Nr*Nc; %number of cells
% % 
% % % initialize the transition matrix P
% % P = zeros(Ntot,Ntot,Na);
% % 
% % % checks to make sure we don't fall out of bounds
% % % Move to north action a = 1
% % for i = 1: Ntot
% %     if(rem(i,Nc) == 0) % i is on the right edge
% %         if((i+Nc) > Ntot) % i is on the top edge
% %             P(i,i,1) = 0.9;
% %             P(i,i-1,1) = 0.1;
% %         else
% %             P(i,i+Nc,1) = 0.9;
% %             P(i,i+Nc-1,1) = 0.1;
% %         end
% %     elseif(rem(i,Nc) ==1) % i is on the left edge
% %         if((i+Nc) > Ntot) % i is on the top edge
% %             P(i,i,1) = 0.9;
% %             P(i,i+1,1) = 0.1;
% %         else
% %             P(i,i+Nc,1) = 0.9;
% %             P(i,i+Nc+1,1) = 0.1;
% %         end
% %     else % i is not on the left nor right edges
% %         if((i+Nc) > Ntot) % i is on the top edge
% %             P(i,i,1) = 0.8;
% %             P(i,i+1,1) = 0.1;
% %             P(i,i-1,1) = 0.1;
% %         else
% %             P(i,i+Nc,1) = 0.8;
% %             P(i,i+Nc+1,1) = 0.1;
% %             P(i,i+Nc-1,1) = 0.1;
% %         end
% %     end
% % end
% % % Move to south action a = 2
% % for i = 1: Ntot
% %     if(rem(i,Nc) == 0) % i is on the right edge
% %         if((i-Nc) < 1) % i is on the bottom edge
% %             P(i,i,1) = 0.9;
% %             P(i,i-1,1) = 0.1;
% %         else
% %             P(i,i-Nc,1) = 0.9;
% %             P(i,i-Nc-1,1) = 0.1;
% %         end
% %     elseif(rem(i,Nc) ==1) % i is on the left edge
% %         if((i-Nc) < 1) % i is on the bottom edge
% %             P(i,i,1) = 0.9;
% %             P(i,i-1,1) = 0.1;
% %         else
% %             P(i,i-Nc,1) = 0.9;
% %             P(i,i-Nc+1,1) = 0.1;
% %         end
% %     else % i is not on the left nor right edges
% %         if((i-Nc) < 1) % i is on the bottom edge
% %             P(i,i,1) = 0.8;
% %             P(i,i+1,1) = 0.1;
% %             P(i,i-1,1) = 0.1;
% %         else
% %             P(i,i-Nc,1) = 0.8;
% %             P(i,i-Nc+1,1) = 0.1;
% %             P(i,i-Nc-1,1) = 0.1;
% %         end
% %     end
% % end
% % % TO BE DONE
% % % Move to west action a = 3
% % for i = 1: Ntot
% %     pf = 0.8;
% %     if((i-Nc) >= 1) % i is not on the bottom edge
% %         P(i,i-Nc,3) = 0.1;
% %     else
% %         pf = 0.9;
% %     end
% %     if((i+Nc) <= Ntot) % i is not on the top edge
% %        P(i,i+Nc,3) = 0.1;
% %     else
% %         pf = 0.9;
% %     end
% %     if(rem(i,Nc) ~=1) % i is not on the left edge
% %         P(i,i-1,3) = pf;
% %     else
% %         P(i,i,3) = pf;
% %     end
% % end
% % % Move to east action a = 4
% % for i = 1: Ntot
% %     pf = 0.8;
% %     if((i-Nc) >= 1) % i is not on the bottom edge
% %         P(i,i-Nc,4) = 0.1;
% %     else
% %         pf = 0.9;
% %     end
% %     if((i+Nc) <= Ntot) % i is not on the top edge
% %        P(i,i+Nc,4) = 0.1;
% %     else
% %         pf = 0.9;
% %     end
% %     if(rem(i,Nc) ~= 0) % i is not on the right edge
% %         P(i,i+1,4) = pf;
% %     else
% %         P(i,i,4) = pf;
% %     end
% % end
% % % Stay in place action a = 5
% % for i = 1: Ntot
% %     P(i,i,5) = 1;
% % end
     


pf= 0.8;
pl= 0.1;
pr= 0.1;
pb= 0;
Na = 4; %number of actions
%Nr = 5; %number of rows
%Nc = 5; %number of columns
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

%% REWARDS

R(:,1) = -3*ones(1,Ntot);
R(50)= 100;
%R(10)=-1000000000000000000;
R(9)= -100;
R(84) = R(94);
%R(74) = R(94);
%R(31) = R(21);
%R(32) = R(21);
%R(16) = R(21);
%R(26) = R(21);

R(:,2) = R(:,1);
R(:,3) = R(:,1);
R(:,4) = R(:,1);
%R(:,5) = R(:,1);

%% CHECK
mdp_check(P, R)
%% RUN MDP

discount = 0.9; %0.01999999
%[V1, policy1] = mdp_policy_iteration(P, R, discount)
%N = 100000; 
[Q, V1, policy] = mdp_policy_iteration(P, R, discount)
end

