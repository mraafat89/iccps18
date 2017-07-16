function pos2cell(pos, env)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = floor(pos(1));
y = floor(pos(2));

xx = [x, x+1, x+1, x, x];
yy = [y, y, y+1, y+1, y];

% hold on;
% boundary_x = env.boundary(2, 1);
% boundary_y = env.boundary(2, 2);
% xe=[0 boundary_x boundary_x 0 0];
% ye=[0 0 boundary_y boundary_y 0];
% fill(xe,ye,[0.8, 0.9, 0.9])
% hold on
% xg=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
% yg=[boundary_y-3 boundary_y-3 boundary_y boundary_y boundary_y-3];
% fill(xg,yg,[0.4, 0.99, 0.8])
% hold on
% xb=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
% yb=[0 0 boundary_y-3 boundary_y-3 0];
% fill(xb,yb,[0.9, 0.5, 0.5])
% hold on
%  
% % xo1=[3 4 4 3 3];
% % yo2=[3 3 4 4 3];
% % fill(xo1,yo2,[0.9, 0.9, 0.9])
% % hold on
% %  
% % xo1=[3 4 4 3 3];
% % yo2=[0 0 1 1 0];
% % fill(xo1,yo2,[0.9, 0.9, 0.9])
% % hold on
%  
%  
% for ii=1:boundary_x-1
%     plot ([ii,ii],[0, boundary_y],'k');
% end
% for jj=1:boundary_y-1
%     plot ([0, boundary_x],[jj, jj],'k');
% end
hold on
fill(xx, yy, [0.6, 0.6, 0.6]);

end

