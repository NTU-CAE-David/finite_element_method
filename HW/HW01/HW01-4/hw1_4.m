%% A flat bar of rectangular cross section

iteration_max = 200;
h = 0.05;
filename = 'hw1-4';
[p,t] = hw1_4_demo(iteration_max,h);
plotmesh(p,t,filename);

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW01/HW01-4';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw1-4
function [p,t] = hw1_4_demo(iteration_max,h)
    rng('default');
    fd = @hw1_4_fd;
    fh = @hw1_4_fh;
    box = [0.0, -3.0; 12.0, 3.0];
    fixed = [0.0,0.0; 12.0, 0.0;
             0.0,-3.0; 0.0,3.0; 
             6.0,-3.0; 6.0,3.0;
             12.0,-2.0; 12.0,2.0];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
    p = p.';
    t = t.';
end

%% hw1-4_fd
function d = hw1_4_fd(p)
    d1 = drectangle(p, 0.0, 6.0, -3.0, 3.0);
    d2 = drectangle(p, 6.0, 12.0,-2.0, 2.0);
    d3 = drectangle(p, 6.0, 6.6, 2.0, 2.6);
    d4 = drectangle(p, 6.0, 6.6, -2.6, -2.0);
    c1 = dcircle(p, 6.6, 2.6, 0.6);
    c2 = dcircle(p, 6.6, -2.6, 0.6);
    d_t = min(min(min(d1,d2),d3),d4);
    c_t = min(c1,c2);
    d = ddiff(d_t, c_t);
end

%% hw1-4_fh
function h = hw1_4_fh(p)
%     np = size(p,1);
%     h = ones(np,1);
    h1 = 0.03+0.6*sqrt((p(:,1)-6.6).^2+(p(:,2)-2.6).^2);
    h2 = 0.03+0.6*sqrt((p(:,1)-6.6).^2+(p(:,2)+2.6).^2);
    h = min(h1,h2);
end