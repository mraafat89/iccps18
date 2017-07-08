function robotPlot = nhrUpdateRobotPlot(robot, robotPlot, color)
    %delete previous robot plot
        delete(robotPlot.line1);
        delete(robotPlot.line2);
        delete(robotPlot.line3);
    robotPlot = nhrPlot(robot, color);
end

