% change rewards line 112
% Nr x Nc probability matrix. How to read it:
% The probability that from cell 1 we move to cell 11 given action N is 0.9
    %
    % 7 8 9
    % 4 5 6
    % 1 2 3
    %
    function    [P, policy1, policy2] = getP(Nr, Nc, c, d) 

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

   P(:,:,1);


a=2;%S
    for i=1:Ntot
        for j=1:Ntot
            P(i,j,2)=P(abs(Ntot-i)+1,abs(Ntot-j)+1,1);
        end
    end
        P(:,:,2);

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
        P(:,:,3);
    
a=4;%E

    for i=1:Ntot
        for j=1:Ntot
       P(A(i),A(j),4)= P(B(i),B(j),1);

        end
    end
        P(:,:,4);
        
%% REWARDS

R(:,1) = -3*ones(1,Ntot);
% R(Ntot-Nr+1:Ntot,1)=-100000000000000; % 2 bad areas
%R(Ntot-Nr+1,1)=-100000000; % 1 bad areas
% R(21)=100;
% R(22)=100;
% R(23)=100;

% R(5)=-1000000000000000000;
% R(10)=-1000000000000000000;
% R(15)=100;
% R(20)=100;
% R(25)=100;

% R(4)=-1000000000000000000000000;
% R(8)=-1000000000000000000000000;
% R(12)=100;
% R(16)=100;

R(10)=-1000000000000000;
R(20)=R(10);
R(30)=R(10);
R(40)=R(10);
R(50)=R(10);

R(60)=100;
R(70)=R(60);
R(80)=R(60);
R(90)=R(60);
R(100)=R(60);

R(:,2) = R(:,1);
R(:,3) = R(:,1);
R(:,4) = R(:,1);
R(:,1);

%% CHECK
mdp_check(P, R);

%% RUN MDP

discount = 0.9; %0.01999999
[V1, policy1] = mdp_policy_iteration(P, R, discount);

%% RUN ARMDP
% Attacks makes me believe that I'm either in 5(2 sensors) or 6(1 sensor).
% The atatck can be either place. The robot doesn't know where it is. It
% has partial knowledge where it can be. What's the best strategy?

% P(7,:,:)=2/3*P(7,:,:)+1/3*P(8,:,:);
% P(8,:,:)=P(7,:,:);
P(c,:,:)=2/3*P(c,:,:)+1/3*P(d,:,:); %17 20
P(d,:,:)=P(c,:,:);

discount = 0.9 %0.01999999
[V2, policy2] = mdp_policy_iteration(P, R, discount);
    end

