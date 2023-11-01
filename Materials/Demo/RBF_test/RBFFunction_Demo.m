n = 250;
x = -3 + 6*rand(n,1);
y = -3 + 6*rand(n,1);
v = sin(x).^4 .* cos(y);

%% MATLAB function: scatteredInterpolant
F = scatteredInterpolant(x,y,v); % 散點插值
[xq,yq] = meshgrid(-3:0.1:3);
F.Method = 'linear'; % 設置插值方法為線性插值
F.ExtrapolationMethod = 'linear'; % 設置外插方法為線性外插
vq = F(xq,yq); % 對應的插值結果

figure;
plot3(x,y,v,'mo');
hold on;
mesh(xq,yq,vq);
title('MATLAB function: scatteredInterpolant');
legend('Sample Points','Interpolated Surface','Location','NorthWest');
hold off;

%% Exact Solution
figure;
plot3(x,y,v,'mo');
hold on;
mesh(xq,yq,sin(xq).^4 .* cos(yq));
title('Exact Solution: f(x,y) = sin(x)^4 * cos(y)');
legend('Sample Points','Exact Surface','Location','NorthWest');

%% Radial basis function (RBF) interpolation
rbfop=rbfcreate([x(:)'; y(:)'], v(:)','RBFFunction','multiquadric','Stats', 'on');
rbfcheck(rbfop);
vqrbf = rbfinterp([xq(:)'; yq(:)'],rbfop);
figure;
plot3(x,y,v,'mo');
hold on;
mesh(xq,yq,reshape(vqrbf, size(xq)));
title('Radial basis function (RBF) interpolation');
legend('Sample Points','Interpolated Surface','Location','NorthWest');
hold off;