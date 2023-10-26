%% HW03-3: Finite Element Analysis
% E (GPa)
% force (kN)
% length unit (mm)
% stress (Pa)
% strain
% Traction = 1 N/m

%% 打開文件
filename = 'hw1-3_infinitas';
filename = 'hw3-3-b';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);


%% 計算全局剛度矩陣
% 使用 "Basic" 
kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn);

% 使用 "高斯積分法" 
kglob_Gauss = GlobStif_Gauss(ndime, nnode, nelem, nelnd, mate, coor, conn);

% kglob = kglob_Gauss;

% 計算兩個矩陣的誤差值
error_matrix = kglob - kglob_Gauss;
abs_error = abs(error_matrix); % 計算誤差的絕對值
max_error = max(abs_error(:)); % 計算誤差的最大值
fprintf('兩個矩陣的最大誤差值為：%f\n', max_error); % 顯示誤差的最大值

%% 計算全局荷載向量(force unit kN)
% 讀取 node force [node dof force]
% force = [1 1 -2500;
%          2 1 2500];
% nforce = size(force,1);
% force = force';
% 
% % Initialize rglob to zeros outside the loop
% rglob = zeros(ndime * nnode, 1);
% 
% for i = 1:nforce
%     node = force(1, i);  % Node where force is prescribed
%     dof = force(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
%     f_value = force(3, i);  % Prescribed force value
% 
%     % Update rglob inside the loop
%     rglob(node * ndime - (ndime - dof)) = f_value;
% end

%% 讀取 Traction
rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, mate, coor, conn, trac);

%% 處理邊界條件  (Section 2.7 item 11)
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
fprintf('u 的 x 方向之和: %.3f mm \n\n', u_x_sum / 50); % u 的 x 方向之和

%% 解方程系統（求解外力r）





%% Output file
% Generate the output filename based on the input filename
[~, filename, ext] = fileparts(filename);
outputFilename = [filename, '_output.opt'];

% 包含求解 stress, strain
% 存入 strain_stress_matrix[elem#-e11-e22-e12-s11-s22-s12]
strain_stress_matrix = WriteOutput(outputFilename, ndime,nnode,u,nelem,mate,coor,conn); 


%% 計算應力或其他所需結果

% 定義要查找的 stress 的範圍
xRnage = [-1, 1]; % 查找 0 到 2.1 的所有邊界點之 stress
yRnage = [-1, 1];

% 調用函數查找包含匹配 x 值的边界元素
boundaryElements = findBoundaryElements(coor, conn, xRnage, yRnage);

% 初始化一個變量來儲存應力總和
total_stress = 0.0;
max_stress = 0.0;

% 遍歷 strain_stress_matrix 中的每一行
for i = 1:size(strain_stress_matrix, 1)
    % 獲取當前行的元素編號
    current_elem = strain_stress_matrix(i, 1);

    % 檢查當前元素是否在邊界元素列表中
    if ismember(current_elem, boundaryElements)
        
        % 如果是邊界元素，將應力數據（第5列）加到總和中
        total_stress = total_stress + strain_stress_matrix(i, 5);
        
        % 找出應力最大值
        if strain_stress_matrix(i, 5) > max_stress
            max_stress = strain_stress_matrix(i, 5);
        end

    end
end

% 印出總和的應力值
fprintf('Max stress is %.3f MPa\n', max_stress);

%% 找出應力最大值

% i 是應力數據（第5列）
i = 5; 

% 使用 max 函數找出第 i 行的最大值和索引
[row_max_value, index_of_max] = max(strain_stress_matrix(:, i));

fprintf('第 %d 行的最大值是 %f，位於索引 %d。\n', i, row_max_value, index_of_max);

