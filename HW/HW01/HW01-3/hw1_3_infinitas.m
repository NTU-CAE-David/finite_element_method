%% A square with a hole with finer mesh density near the hole
iteration_max = 300;
h = 0.8;
fd = @hw1_3_fd;
fh = @(p) min(4*sqrt(sum(p.^2,2))-15,30);
filename = 'hw1-3_infinitas';
[p,t] = hw1_3_demo(iteration_max,h,fd,fh);

figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Mesh density function');
p = p.';
t = t.';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW01/HW01-3';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw1_3_demo
function [p,t] = hw1_3_demo(iteration_max,h,fd,fh)
    rng('default');
    box = [-100.0,-30.0; 100.0,30.0];
    fixed = [-100.0, 0.0; 100.0, 0.0; -100.0,-30.0; -100.0,30.0; 100.0,-30.0; 100.0,30.0];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
end

%% hw1_3_fd
function d = hw1_3_fd(p)
    d1 = drectangle(p,-100.0,100.0,-30.0,30.0);
    d2 = dcircle(p,0.0,0.0,6);
    d = ddiff(d1,d2);
end
