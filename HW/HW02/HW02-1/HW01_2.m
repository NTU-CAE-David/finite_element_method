%% HW01-2: Finite Element Analysis

%% 打開文件
filename = 'hw1-2';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);

%% 計算全局剛度矩陣
kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn);

%% 計算全局荷載向量
% 讀取 node force [node dof force]
force = [4 1 25.5e3;
         9 1 -17.0e3];
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

%% 解方程系統（求解外力r）





%% Output file
% Generate the output filename based on the input filename
[~, filename, ext] = fileparts(filename);
outputFilename = [filename, '_output.opt'];

% 包含求解 stress, strain
% 存入 strain_stress_matrix[elem#-e11-e22-e12-s11-s22-s12]
strain_stress_matrix = WriteOutput(outputFilename, ndime,nnode,u,nelem,mate,coor,conn); 


%% 計算應力或其他所需結果

% 定义要查找的 x 值
xRnage = [0, 0]; % 例如，查找 64 到 65 的所有邊界點

% 调用函数查找包含匹配 x 值的边界元素
boundaryElements = findBoundaryElements(coor, conn, xRnage);

% 初始化一个变量来存储应力总和
total_stress = 0.0;

% 遍历 strain_stress_matrix 中的每一行
for i = 1:size(strain_stress_matrix, 1)
    % 获取当前行的元素号
    current_elem = strain_stress_matrix(i, 1);

    % 检查当前元素是否在边界元素列表中
    if ismember(current_elem, boundaryElements)
        % 如果是边界元素，将应力数据（第5列）加到总和中
        total_stress = total_stress + strain_stress_matrix(i, 5);
    end
end

% 打印总和的应力值
Area_1 = 840/10e6; % m^2
Area_2 = 1260/10e6; % m^2
fprintf('Total stress on the boundary: %.3f\n', total_stress*Area_1);

