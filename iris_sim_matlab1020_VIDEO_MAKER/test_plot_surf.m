close all

% figure(1)
% hold on
% [xx, yy] = meshgrid(0:5, 0:5);
% zz = ones(size(xx)) * 0.9;
% surf(xx, yy, zz);
% alpha 0.2;
% colormap(hsv);%hsv
% [xxx, yyy] = meshgrid(4:5, 0:5);
% zzz = ones(size(xxx)) * 0.9;
% surf(xxx, yyy, zzz);
% alpha 0.2;
% colormap(spring);%hsv

figure(2)
% xb=[1 2 2 1 1];
% yb=[1 1 2 2 1];
% fill(xb,yb,[0.8, 0.9, 0.9])

% %  boundary_x = env.boundary(2, 1);
% %  boundary_y = env.boundary(2, 2);
% % xb=[0 boundary_x boundary_x 0 0];
% % yb=[0 0 boundary_y boundary_y 0];
% % fill(xb,yb,[0.9, 0.9, 0.9])
% % hold on
% % for ii=1:boundary_x-1
% %     plot ([ii,ii],[0, boundary_y],'k-');
% % end


boundary_x = env.boundary(2, 1);
boundary_y = env.boundary(2, 2);
xe=[0 boundary_x boundary_x 0 0];
ye=[0 0 boundary_y boundary_y 0];
fill(xe,ye,[0.8, 0.9, 0.9])
hold on
% xg=[0 boundary_x-3 boundary_x-3 0 0]
% yg=[boundary_y-1 boundary_y-1 boundary_y boundary_y boundary_y-1]
xg=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
yg=[boundary_y-3 boundary_y-3 boundary_y boundary_y boundary_y-3];
fill(xg,yg,[0.4, 0.99, 0.8])
hold on
% xb=[boundary_x-3 boundary_x boundary_x boundary_x-3 boundary_x-3]
% yb=[boundary_y-1 boundary_y-1 boundary_y boundary_y boundary_y-1]
xb=[boundary_x-1 boundary_x boundary_x boundary_x-1 boundary_x-1];
yb=[0 0 boundary_y-3 boundary_y-3 0];
fill(xb,yb,[0.9, 0.5, 0.5])
