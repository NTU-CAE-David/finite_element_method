%% A square with a hole with finer mesh density near the hole
iteration_max = 300;
h = 0.02;
fh = @(p) min(4*sqrt(sum(p.^2,2))-1,2);
filename = 'p03_2';
[p,t] = p03_demo(iteration_max,h,fh);
plotmesh(p,t,filename);

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/Materials/Demo/Ch2_DictMesh/';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');


%% p03_demo
function [p,t] = p03_demo(iteration_max,h,fh)
    rng('default');
    fd = @p03_fd;
    box = [-1.0,-1.0; 1.0,1.0];
    fixed = [-1.0,-1.0; -1.0,1.0; 1.0,-1.0; 1.0,1.0];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
    p = p.';
    t = t.';
end

%% p03_fd
function d = p03_fd(p)
    d1 = drectangle(p,-1.0,1.0,-1.0,1.0);
    d2 = dcircle(p,0.0,0.0,0.4);
    d = ddiff(d1,d2);
end
