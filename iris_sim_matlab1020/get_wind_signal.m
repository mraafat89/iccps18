function [force, moment] = get_wind_signal(qd, t, qn, F, M)
%UNTITLED Summary of this function goes here
% To define disturbance space area, uncomment Section II, comment Section I;
% to define disturbance time period, uncomment Section I, comment Section II;

% maximum value 
f_max = -5.5;
m_max = 1.0;

force = zeros(3,1);
moment = zeros(3,1);

%% Section I: wind disturbance time period

% if t < 10.0 && t > 4.0
%     force = [0; f_max; 0];
% end

%% Section II: wind disturbance area period

x_min = 1;
x_max = 10;
% y_min = 3;
% y_max = 6;
% 
% z_min = 3;
% z_max = 6;
% 
pos = qd{qn}.pos;

if pos(1) >= x_min && pos(1) < x_max
    force = [0;f_max; 0];
end

end

