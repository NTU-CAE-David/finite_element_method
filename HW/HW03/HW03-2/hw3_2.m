%% A hexagon with a hexagonal hole

iteration_max = 200;
h = 5;
fd = @hw3_2_fd;
fh = @hw3_2_fh;

filename = 'hw3-2';
[p,t] = hw3_2_demo(iteration_max,h,fd,fh);

%% 畫圖
figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Mesh density function');
p = p.';
t = t.';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

% 輸出節點編號
% 顯示 elements number
figure('color','w');
triangulation_display(filename, 1, 3, 1); title('Element number');

% 顯示 nodes & elements number
figure('color','w');
triangulation_display(filename, 2, 3, 1); title('Node & Element number');


%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW03/HW03-2';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw3-2
function [p,t] = hw3_2_demo(iteration_max,h,fd,fh)

    rng('default');
    box = [0.0, -10.0; 60.0, 10.0];
    fixed = [0.0, 0.0; 0.0, 10.0; 0.0, -10.0;
             60.0, 0.0; 60.0, 10.0; 60.0, -10.0];

    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
end

%% hw3-2_fd Signed distance function
function d = hw3_2_fd(p)
    d = drectangle(p,0.0,60.0,-10.0,10.0);
end


%% hw3-2_fh Mesh density function
function h = hw3_2_fh(p)
    np = size(p,1);
    h = ones(np,1);
end