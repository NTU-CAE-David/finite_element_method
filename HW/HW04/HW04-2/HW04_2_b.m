%% HW04-1: Finite Element Analysis
% E (Pa)
% force (N)
% length unit (m)
% stress (Pa)
% strain
% Traction = 1 kN/mm

clc;clear;

%% 打開文件
filename = 'hw4-2_b';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);


%% 計算全局剛度矩陣
% 使用 "Basic" 
% kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn);

% 使用 "高斯積分法" 
kglob_Gauss = GlobStif_Gauss(ndime, nnode, nelem, nelnd, mate, coor, conn);

% 使用 "Euler-Bernoulli" 
kglob_Euler = GlobStif_Euler(ndime, nnode, nelem, nelnd, mate, coor, conn);

% kpres = kglob;
kpres = kglob_Euler;
% kpres = kglob_Gauss;

% 計算兩個矩陣的誤差值
% error_matrix = kglob - kglob_Gauss;
% abs_error = abs(error_matrix); % 計算誤差的絕對值
% max_error = max(abs_error(:)); % 計算誤差的最大值
% fprintf('兩個矩陣的最大誤差值為：%f\n', max_error); % 顯示誤差的最大值

%% 讀取 Traction
rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, mate, coor, conn, trac);

% 計算全局荷載向量(force unit N)
% 讀取 node force [node dof force]
force = [6 2 -80000];
nforce = size(force,1);
force = force';

% % Initialize rglob to zeros outside the loop
% rglob = zeros(ndime * nnode, 1);

for i = 1:nforce
    node = force(1, i);  % Node where force is prescribed
    dof = force(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
    f_value = force(3, i);  % Prescribed force value

    % Update rglob inside the loop
    rglob(node * ndime - (ndime - dof)) = f_value;
end


rpres = rglob;

%% 處理邊界條件  (Section 2.7 item 11)
% Prescribed displacements
if npres ~= 0 % 檢測是否有位移邊界條件
    for i = 1:npres
        % 計算全局自由度編號 (idof)
        idof = ndime * (pres(1, i) - 1) + pres(2, i);
    
        % 第一個迴圈：修改剛度矩陣和殘差力向量
        for ir = 1:ndime * nnode
            kpres(ir, idof) = 0;  % 清零剛度矩陣的相應行
            rpres(ir) = rpres(ir) - kpres(ir, idof) * pres(3, i);  % 更新殘差力向量
        end
    end
    
    for i = 1:npres
        % 再次計算全局自由度編號 (idof)
        idof = ndime * (pres(1, i) - 1) + pres(2, i);
    
        % 第二個迴圈：應用位移邊界條件到剛度矩陣和殘差力向量
        kpres(idof, :) = 0;  % 清零剛度矩陣的相應行
        kpres(idof, idof) = 1;  % 設置對角元素為1
        rpres(idof) = pres(3, i);  % 更新殘差力向量 Prescribed displacement value
    end
end


%% 解方程系統（求解位移）
% u = K^-1*r
uglob = pinv(kpres)*rpres;
uglob(isnan(uglob)) = 0;    % 將 uglob 中的 NaN 值替換為 0

% 循環遍歷位移向量 uglob_x 的部分
uglob_x_sum = 0;
for i = 1:2:numel(uglob)
    uglob_x_sum = uglob_x_sum + uglob(i);
end
fprintf('uglob 的 x 方向之和: %.3f mm \n\n', uglob_x_sum / 50); % uglob 的 x 方向之和

%% 解方程系統（求解外力r）





%% Output file
% Generate the output filename based on the input filename
[~, filename, ext] = fileparts(filename);
outputFilename = [filename, '_output.opt'];

% 包含求解 stress, strain
% 存入 strain_stress_matrix[elem#-e11-e22-e12-s11-s22-s12]
strain_stress_matrix = WriteOutput(outputFilename, ndime,nnode,uglob,nelem,mate,coor,conn); 

%% 輸出 vtk file
vtkShapeID = 9; % 設置VTK形狀 ID＝9
WriteVTKFile(filename, nnode, ndime, nelem, nelnd, coor, conn, uglob*1000, vtkShapeID, strain_stress_matrix)

% 畫出應力分佈圖
plotElemStress(coor, conn, strain_stress_matrix);


%% 計算應力或其他所需結果

% 定義要查找的 stress 的範圍
xRnage = [-10, 10]; % 查找 0 到 2.1 的所有邊界點之 stress
yRnage = [-10, 10];

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

