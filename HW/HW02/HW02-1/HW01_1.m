%% 打開文件
filename = 'hw1-1';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);

%% 計算全局剛度矩陣
kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn);

%% 計算全局荷載向量
% 讀取 node force [node dof force]
force = [5 1 25e3;
         6 1 -25e3];
nforce = size(force,1);
force = force';

% Initialize rglob to zeros outside the loop
rglob = zeros(ndime * nnode, 1);

for i = 1:nforce
    node = force(1, i);  % Node where force is prescribed
    dof = force(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
    f_value = force(3, i);  % Prescribed force value

    % Update rglob inside the loop
    rglob(node * ndime - (ndime - dof)) = f_value;
end

% 讀取 Traction
% 未完成
% rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, mate, coor, conn, trac);
%% HW01-1: Finite Element Analysis

%% 處理邊界條件
% Prescribed displacements
if npres ~= 0 % 檢測是否有位移邊界條件
    for i = 1:npres
        node = pres(1, i);  % Node where displacement is prescribed
        dof = pres(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
        u_value = pres(3, i);  % Prescribed displacement value
        
        % Modify stiffness matrix
        kglob(node * ndime - (ndime - dof), :) = 0;  % Zero out the row
        kglob(node * ndime - (ndime - dof), node * ndime - (ndime - dof)) = 1;  % Set diagonal to 1
        
        % Modify residual force vector
        rglob(node * ndime - (ndime - dof)) = u_value;
    end
end

%% 解方程系統（求解位移）
% u = K^-1*r
u = kglob \ rglob;
u(isnan(u)) = 0;    % 將 u 中的 NaN 值替換為 0

% 循環遍歷位移向量 u_x 的部分
u_x_sum = 0;
for i = 1:2:numel(u)
    u_x_sum = u_x_sum + u(i);
end
disp(['u 的 x 方向之和：', num2str(u_x_sum)]);

%% 計算應力或其他所需結果
% stress, strain
% TODO
strain_matrix = [];
stress_matrix = [];

%% Output file
% Generate the output filename based on the input filename
[~, filename, ext] = fileparts(filename);
outputFilename = [filename, '_output.opt'];
WriteOutput(outputFilename, ndime,nnode,u,nelem,strain_matrix,stress_matrix);
