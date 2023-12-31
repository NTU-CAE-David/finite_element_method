%% A flat bar of rectangular cross section

iteration_max = 200;
h = 0.8;
filename = 'hw1-2';
[p,t] = hw1_2_demo(iteration_max,h);
plotmesh(p,t,filename);

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW01/HW01-2';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw1-2
function [p,t] = hw1_2_demo(iteration_max,h)
    rng('default');
    fd = @hw1_2_fd;
    fh = @hw1_2_fh;
    box = [0.0, -4.0; 65.0, 4.0];
    fixed = [0.0, 0.0;
             0.0,-2.1; 0.0,2.1;
             20.0, 0.0;
             20.0,-2.1; 20.0,2.1;
             20.0,-3.15; 20.0,3.15;
             45.0, 0.0;
             45.0,-2.1; 45.0,2.1;
             45.0,-3.15; 45.0,3.15;
             65.0,0.0;
             65.0,-2.1; 65.0,2.1];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
    p = p.';
    t = t.';
end

%% hw1-2_fd
function d = hw1_2_fd(p)
    g1 = drectangle(p,0.0,20.0,-2.1,2.1);
    g2 = drectangle(p,20,45,-3.15,3.15);
    g3 = drectangle(p,45,65,-2.1,2.1);
    d = min(min(g1,g2),g3);
end

%% hw1-2_fh
function h = hw1_2_fh(p)
    np = size(p,1);
    h = ones(np,1);
end