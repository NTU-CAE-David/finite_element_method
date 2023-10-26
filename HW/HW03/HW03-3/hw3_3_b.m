%% A hexagon with a hexagonal hole

iteration_max = 200;
h = 0.2;
fd = @hw3_3_fd;
fh = @hw3_3_fh;

filename = 'hw3-3-b';
[p,t] = hw3_3_demo(iteration_max,h,fd,fh);

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
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW03/HW03-3';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw3-3
function [p,t] = hw3_3_demo(iteration_max,h,fd,fh)

    rng('default');
    box = [-1.0,-1.0; 1.0,1.0];

    n = 6;
    phi = 2*pi*(0:2:2*(n-1))'/(2*n);
    outer = [cos(phi), sin(phi)];
    n = 3;
    phi = 2*pi*(1:2:2*(n-1)+1)'/(2*n);
    inner = 0.5*[cos(phi),sin(phi)];
    fixed = [inner; outer];

    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
end

%% hw3-3_fd Signed distance function
function d = hw3_3_fd(p)
    n = 6;
    phi = 2*pi*(0:2:2*n)'/(2*n);
    outer = [cos(phi), sin(phi)];
    n = 3;
    phi = 2*pi*(1:2:2*n+1)'/(2*n);
    inner = 0.5*[cos(phi), sin(phi)];
    d1 = dpoly(p,outer);
    d2 = dpoly(p,inner);
    d = ddiff(d1,d2);
end


%% hw3-3_fh Mesh density function
function h = hw3_3_fh(p)
    np = size(p,1);
    h = ones(np,1);
end