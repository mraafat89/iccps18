function map = load_map(filename, xy_res, z_res, margin)
% LOAD_MAP Load a map from disk.
%  MAP = LOAD_MAP(filename, xy_res, z_res, margin).  Creates an occupancy grid
%  map where a node is considered fill if it lies within 'margin' distance of
%  on abstacle.

% load data
% boundary xmin ymin zmin xmax ymax zmax
% block    xmin ymin zmin xmax ymax zmax r g b

res = [xy_res, xy_res, z_res];

% Env = importdata(filename);

[str, data1, data2, data3, data4, ...
      data5, data6,data7, data8, data9] = ...
                                        textread(filename, '%s%f%f%f%f%f%f%f%f%f', ...
                                        'emptyvalue',NaN,'commentstyle','shell');

if ~isempty(data9)    
    idx = isnan(data9);
    boundary = [data1(idx),data2(idx),data3(idx),data4(idx),data5(idx),data6(idx) ];
    block = [data1(~idx),data2(~idx),data3(~idx),data4(~idx),...
             data5(~idx),data6(~idx),data7(~idx),data8(~idx),data9(~idx) ];
% full map
% if size(Env.data, 1) > 1
%     if size(Env.data, 2) < 7
%         % boundary at the front;
%         boundary = Env.data(1, :);
%         Env = importdata(filename, ' ', 1);
%         block = Env.data;
%     else
%         idx = isnan(Env.data(:, 9));
%         boundary = Env.data(idx, :);
%         block = Env.data(~idx, :); 
%     end

    % initialize map
    boundary_min = boundary(1 : 3);
    boundary_max = boundary(4 : 6);
    res = min(boundary_max, res);
    [x, y, z] = meshgrid(boundary_min(1):res(1):boundary_max(1),... 
                         boundary_min(2):res(2):boundary_max(2),... 
                         boundary_min(3):res(3):boundary_max(3));
    occupied = zeros(size(x));
    block_min = bsxfun(@max, boundary_min, block(:, 1:3) - margin);
    block_max = bsxfun(@min, boundary_max, block(:, 4:6) + margin);
    
    block_index_min = floor(bsxfun(@rdivide, bsxfun(@minus, block_min, boundary_min), res)) + 1;
    block_index_max = floor(bsxfun(@rdivide, bsxfun(@minus, block_max, boundary_min), res)) + 1;

    for i = 1 : size(block, 1)
        occupied(block_index_min(i, 2):block_index_max(i, 2),...
                 block_index_min(i, 1):block_index_max(i, 1),... 
                 block_index_min(i, 3):block_index_max(i, 3)) = 1;
    end    
% empty map
else
    boundary = [data1,data2,data3,data4,data5,data6];
    boundary_min = boundary(1 : 3);
    boundary_max = boundary(4 : 6);
    res = min(boundary_max, res);
    [x, y, z] = meshgrid(boundary_min(1):res(1):boundary_max(1),...
                         boundary_min(2):res(2):boundary_max(2),...
                         boundary_min(3):res(3):boundary_max(3));
    occupied = zeros(size(x));
    block = [];
end
map{1} = [boundary_min; boundary_max; res];
map{2} = block;
map{3} = occupied;
map{4} = [x(:), y(:), z(:)];
map{5} = {x(1,:,1),y(:,1,1),z(1,1,:)};

end
