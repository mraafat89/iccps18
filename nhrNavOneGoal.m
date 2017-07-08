function [robot,vx,vy]= nhrNavOneGoal(goal, robot, error, integral, derivative)
    %Init Control Parameters
%    kThetaP = 2.5;
    kVP = 0.55;
    kVI = 0.6;
    kVD = 0.02;
    %calculate new robot angle
    thetaNew = atan2(goal.y - robot.y , goal.x - robot.x);
    % calculate new robot velocity
    v = (kVP*error + kVI*integral + kVD*derivative);
    %update robot 
    vx = v * cos(thetaNew);
    vy = v * sin(thetaNew);
end

