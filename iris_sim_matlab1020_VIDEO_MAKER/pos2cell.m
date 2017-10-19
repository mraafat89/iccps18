function pos2cell(pos, env)
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
hold on;
% change color
fill(xx, yy, [0.8, 0.8, 0.8]);

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
%     fill(cell_old_x, cell_old_y, env.color_map(env.ind, :));
    ind = cur_index;
end

end

