function goal = my_algorithm(t, state, env)
% change getP and time intervals
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
pos2cell2(pos, env,1,1,1, t);

% if (pos(1)<=4 && pos(1)>=3) && (pos(2)<=3 && pos(2)>=2) && t < 25.05
% %     att1=3;
% %     att2=0;
% %     att3=pos(3);
% %     att=[att1 att2 att3];
% pos2cell2(pos, env,2,3,1); 
% elseif (pos(1)<=4 && pos(1)>=3) && (pos(2)<=4 && pos(2)>=3) && t < 30.05
%     pos2cell2(pos, env,2,3,2);
% end
%% Modify

% send new command
%**************** do calculation here ********************************

%**************************** end ************************************

% Example Code to move NSEW
% move forward

% if t < 5.05 && t > 4.95
if t > 64.00 
    goal = [];
    return;
end
if (t < 5.05 && t > 4.95 || t < 10.05 && t > 9.95 || t < 15.05 && t > 14.95 || t < 20.05 && t > 19.95 || t < 25.05 && t > 24.95 || t < 30.05 && t > 29.95 || t < 35.05 && t > 34.95 || t < 40.05 && t > 39.95 || t < 45.05 && t > 44.95 || t < 50.05 && t > 49.95 || t < 55.05 && t > 54.95 || t < 60.05 && t > 59.95)% || t < 65.05 && t > 64.95 || t < 70.05 && t > 69.95)
            [a, p1, p2] = getP(10,10,1,1); %%%%%%%%%%%%%%%%%
             div=length(p1)/10;             %%%%%%%%%%%%%%%%%   
%     if t < 30.05 && t > 29.95
%         [a, p1, p2] = getP(10,10,46,56); %19,4 with starting 3,1    
%         div=length(p2)/10;
%     elseif t < 35.05 && t > 34.95
%         [a, p1, p2] = getP(4,4,47,67); %19,4 with starting 3,1    
%         div=length(p2)/10;
%     elseif t < 40.05 && t > 39.95
%         [a, p1, p2] = getP(10,10,48,78); %19,4 with starting 3,1    
%         div=length(p2)/10; 
%     elseif t < 45.05 && t > 44.95
%         [a, p1, p2] = getP(10,10,49,89); %19,4 with starting 3,1    
%         div=length(p2)/10;     
%     else
%         [a, p1, p2] = getP(4,4,1,1);
%          div=length(p1)/4;    
%     end
count=0;
for i=1:div
    for j=1:div
        count=count+1;
        c(i,j) = p1(count); %%%%%%%%%%%%%%%%%
%         if t < 15.05 && t > 14.95
%             c(i,j) = p2(count);
%         elseif t < 20.05 && t > 19.95
%             c(i,j) = p2(count);
%         else
%             c(i,j) = p1(count);
%         end
    end
end
c;
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
t
goal = [mx, my, 0]
end

% % move backward
% if t < 10.05 && t > 9.95
%    goal = [-1, 0, 0];
% end
% % move right
% if t < 15.05 && t > 14.95
%    goal = [0, -1, 0];
% end
% % move left
% if t < 20.05 && t > 19.95
%    goal = [0, 1, 0];
% end


end

