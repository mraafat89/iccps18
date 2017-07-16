function plot_path(map, path)
% PLOT_PATH Visualize a path through an environment
%   PLOT_PATH(map, path) creates a figure showing a path through the
%   environment.  path is an N-by-3 matrix where each row corresponds to the
%   (x, y, z) coordinates of one point along the path.


boundary_min = map{1}(1, :);
boundary_max = map{1}(2, :);
block = map{2};

figure;
axis(reshape([boundary_min; boundary_max], 1, 6));

if ~isempty(block)
    colorSet = block(:, 7:9) / 255;
    % learned patch function from website : 
    % http://nf.nci.org.au/facilities/software/Matlab/techdoc/ref/patch.html
    for i = 1 : size(block, 1)
        x = [block(i, 1), block(i, 4)];
        y = [block(i, 2), block(i, 5)];
        z = [block(i, 3), block(i, 6)];
        vert = [x([1 2 2 1 1 2 2 1]);
                y([1 1 1 1 2 2 2 2]);
                z([1 1 2 2 1 1 2 2])]';
        face = [1 2 3 4;
                3 4 8 7;
                7 6 5 8;
                1 2 6 5;
                2 3 7 6;
                1 5 8 4];
        patch('Faces',face,'Vertices',vert, 'FaceColor',colorSet(1,:));
        hold on;
    end
end

plot3(path(:, 1), path(:, 2), path(:, 3), 'color', 'b', 'LineWidth', 2);
xlabel('X');
ylabel('Y');
zlabel('Z');

end