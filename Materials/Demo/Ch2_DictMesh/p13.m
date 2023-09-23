%% The Sandia Fork
filename = 'p13';
fd = @p13_fd;
fh = @p13_fh;
h = 0.025;
meshbox = [0.0,0.0; 1.0,1.0];
iteration_max = 200;
fixed = [ ...
0.10000, 0.00000; ...
0.20000, 0.00000; ...
0.80000, 0.00000; ...
0.90000, 0.00000; ...
0.55000, 0.39686; ...
0.55000, 0.90000; ...
0.45000, 0.90000; ...
0.45000, 0.39686 ];
[p,t] = distmesh_2d(fd,fh,h,meshbox,iteration_max,fixed);
figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Mesh density function');
p = p';
t = t';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/Materials/Demo/Ch2_DictMesh/';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% 1 Signed distance function 
function d = p13_fd(p)
    g1 = drectangle(p,0.450,0.550,0.390,0.900);
    g2 = dcircle(p,0.500,0.000,0.400);
    g3 = dcircle(p,0.500,0.000,0.300 );
    d = dunion(g1,dintersect(-p(:,2),ddiff(g2,g3)));
end

%% 2 Mesh density function 
function h = p13_fh(p)
    h = ones(size(p,1),1);
end