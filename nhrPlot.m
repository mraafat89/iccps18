function robotPlot = nhrPlot(robot, color)

tr1.x = robot.x + (robot.L1) * cos(robot.theta);
tr1.y = robot.y + (robot.L1) * sin(robot.theta);

x4 = robot.x - (robot.L1) * cos(robot.theta);
y4 = robot.y - (robot.L1) * sin(robot.theta);

tr2.x = x4 + (robot.L2 * cos((pi/2)-robot.theta));
tr2.y = y4 - (robot.L2 * sin((pi/2)-robot.theta));

tr3.x = x4 - (robot.L2 * cos((pi/2)-robot.theta));
tr3.y = y4 + (robot.L2 * sin((pi/2)-robot.theta));

robotPlot.line1 = line([tr1.x,tr2.x], [tr1.y, tr2.y], 'Color', color);
robotPlot.line2 = line([tr1.x,tr3.x], [tr1.y, tr3.y], 'Color', color);
robotPlot.line3 = line([tr2.x,tr3.x], [tr2.y, tr3.y], 'Color', color);

plot(robot.x,robot.y, '.', 'Color', color);
%line([tr1.x,(tr2.x+tr3.x)/2], [tr1.y, (tr2.y+tr3.y)/2], 'Color', 'g');
%text(1,1,num2str(robot.theta*180/pi));
end