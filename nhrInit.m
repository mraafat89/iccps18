function robot = nhrInit(x,y)
% robot initial configuraion
robot.x = x;
robot.y = y;
robot.v = 0;
robot.theta = -pi + 2 * pi * rand(1,1);
robot.L1 = 3;
robot.L2 = 1.5;
end