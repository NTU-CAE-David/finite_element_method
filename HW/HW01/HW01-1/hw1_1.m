%% A flat bar of rectangular cross section

iteration_max = 200;
h = 0.9;
filename = 'hw1-1';
[p,t] = hw11_demo(iteration_max,h);
plotmesh(p,t,filename);

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW01/HW01-1';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw1-1
function [p,t] = hw11_demo(iteration_max,h)
    rng('default');
    fd = @hw11_fd;
    fh = @hw11_fh;
    box = [0.0, -5.0; 60.0, 5.0];
    fixed = [0.0,-2.0; 0.0, 0.0; 0.0,2.0; 60.0,3.0; 60.0, 0.0; 60.0, -3.0];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
    p = p.';
    t = t.';
end

%% hw1-1_fd
% function d = hw11_fd(p)
% %     d = sqrt(sum(p.^2, 2))-1;
%     g1 = drectangle(p,0.0,60.0,-3.0,3.0);
%     g2 = drectangle(protate(p, tan(1/60)),-70,70,2.0,6);
%     g3 = drectangle(protate(p,-tan(1/60)),-70,70,-6,-2.0);
%     d = ddiff(ddiff(g1,g2),g3);
% end

function d = hw11_fd(p)
    v = [0.0, 0.0; 0.0, 2.0; 30.0, 2.5; 60.0,3.0; 60.0, 0.0; 60.0, -3.0; 30.0, -2.5; 0.0,-2.0; 0.0, 0.0];
    d = dpoly(p,v);
end


%% hw1-1_fh
function h = hw11_fh(p)
    np = size(p,1);
    h = ones(np,1);
end