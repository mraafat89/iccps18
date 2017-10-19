function pos2cell2(pos, env,i,a,b, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


global ind

% current cell position
x = floor(pos(1));
y = floor(pos(2));

% current cell index
cur_index = sub2ind(env.boundary(2,:), x / 1 + 1, y / 1 + 1);

% current cell 
xx = [x, x+1, x+1, x, x];
yy = [y, y, y+1, y+1, y];
if i==1
hold on;
% change color
fill(xx, yy, [0.7, 0.7, 0.7]);
elseif i==2
%     att1=[3 4 4 3 3];
%     att2=[0 0 1 1 0];
    att1=[a a+1 a+1 a a];
    att2=[b b b+1 b+1 b];

hold on
fill(xx, yy, [0.7, 0.7, 0.7]);
fill(att1, att2, [0.7, 0.7, 0.7]);
end
% check if index of cell has changed
if ind ~= cur_index
    % change the color of previous occupied cell back to its origin color
    [x_old, y_old] = ind2sub(env.boundary(2,:), ind);
    x_old = x_old - 1;
    y_old = y_old - 1;
    cell_old_x = [x_old, x_old+1, x_old+1, x_old, x_old];
    cell_old_y = [y_old, y_old, y_old+1, y_old+1, y_old];
    hold on;
    % change color
    fill(cell_old_x, cell_old_y, [0.8, 0.9, 0.9]);
%     att1=[3 4 4 3 3];
%     att2=[1 1 2 2 1];
%     fill(att1, att2, [0.8, 0.9, 0.9]);
%     att3=[3 4 4 3 3];
%     att4=[2 2 3 3 2];
%     fill(att3, att4, [0.8, 0.9, 0.9]);
%     fill(cell_old_x, cell_old_y, env.color_map(env.ind, :));

%****************************** Temporary Code **************************
    if x < 6
        x_real = xx;
        y_real = [5, 5, 5+1, 5+1, 5];
        % change color
        hold on;
%         keyboard;
        fill(x_real, y_real, [0.7, 0.7, 0.7]);
        hold on;
        fill(x_real-1, y_real, [0.8, 0.9, 0.9]);
%         fprintf('%d\n', x);
    elseif x < 8
        x_real = xx;
        y_real = yy + 2;
        % change color
        hold on;
        fill(x_real, y_real, [0.7, 0.7, 0.7]);
        hold on;
        fill(x_real-1, y_real, [0.8, 0.9, 0.9]);
        hold on;
        fill(x_real, y_real-1, [0.8, 0.9, 0.9]);
    elseif x == 8
        x_real = xx;
        y_real = [7, 7, 7+1, 7+1, 7];
        hold on;
        if y == 5 && t < 55.00
            fill(x_real, y_real, [0.7, 0.7, 0.7]);
            hold on;
            fill(x_real-1, y_real, [0.8, 0.9, 0.9]);
        end
        if y == 6
            fill(x_real, y_real, [0.8, 0.9, 0.9]);
        end
    end
%************************************************************************


    ind = cur_index;
end

end

