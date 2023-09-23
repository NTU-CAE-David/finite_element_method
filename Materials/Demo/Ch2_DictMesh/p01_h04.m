%% A circle region with nominal mesh spacings h = 0.4, 0.3, 0.2:

iteration_max = 200;
h = 0.1;
filename = 'p01_h04';
[p,t] = p01_demo(iteration_max,h);
plotmesh(p,t,filename);

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/Materials/Demo/Ch2_DictMesh/';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% p01_demo
function [p,t] = p01_demo(iteration_max,h)
    rng('default');
    fd = @p01_fd;
    fh = @p01_fh;
    box = [-1.0,-1.0; 1.0,1.0];
    fixed = [ ];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
    p = p.';
    t = t.';
end

%% p01_fd
function d = p01_fd(p)
    d = sqrt(sum(p.^2, 2))-1;
end

%% p01_fh
function h = p01_fh(p)
    np = size(p,1);
    h = ones(np,1);
end