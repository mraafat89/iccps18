function nhrPlotGoals( goals )
    r = 3;
    th = 0:pi/50:2*pi;
    for i = 1 : length(goals)
        xunit = r * cos(th) + goals(i,1).x;
        yunit = r * sin(th) + goals(i,1).y;
        plot(xunit, yunit);
    end
end

