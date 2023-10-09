%% HW02-4_3: Finite Element Analysis
% E -> strain
% V -> u
% I -> stress
% I*L -> traction
% conductiviry -> D（S/m）

%% 打開文件
filename = 'hw2-4_3';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput_elec(inputFile);

ndime_elec = 1; % 無方向性

%% 計算全局剛度矩陣
kglob = GlobStif_elec(ndime_elec, nnode, nelem, nelnd, mate, coor, conn);

%% 計算全局荷載向量(force unit N)
% 讀取 node force [node dof current]
force = [];
nforce = size(force,1);
force = force';

% Initialize rglob to zeros outside the loop
rglob = zeros(ndime_elec * nnode, 1);

for i = 1:nforce
    node = force(1, i);  % Node where force is prescribed
    dof = force(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
    f_value = force(3, i);  % Prescribed force value

    % Update rglob inside the loop
    rglob(node * ndime_elec - (ndime_elec - dof)) = f_value;
end

% 讀取 Traction
% 未完成
% rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, mate, coor, conn, trac);

%% 處理邊界條件  (Section 2.7 item 11)
% Prescribed displacements
if npres ~= 0 % 檢測是否有位移邊界條件
    for i = 1:npres
        node = pres(1, i);  % Node where displacement is prescribed
        dof = pres(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
        u_value = pres(3, i);  % Prescribed displacement value
        
        % Modify stiffness matrix
        kglob(node * ndime_elec - (ndime_elec - dof), :) = 0;  % Zero out the row
        kglob(node * ndime_elec - (ndime_elec - dof), node * ndime_elec - (ndime_elec - dof)) = 1;  % Set diagonal to 1
        
        % Modify residual force vector
        rglob(node * ndime_elec - (ndime_elec - dof)) = u_value;
    end
end

%% 解方程系統（求解位移）
% u = K^-1*r
u = kglob \ rglob;
u(isnan(u)) = 0;    % 將 u 中的 NaN 值替換為 0

% 循環遍歷位移向量 u_x 的部分



%% Output file
% Generate the output filename based on the input filename
[~, filename, ext] = fileparts(filename);
outputFilename = [filename, '_output.opt'];

% 包含求解 stress, strain
% 存入 strain_stress_matrix[elem#-E1-E2-I1-I2]
strain_stress_matrix = WriteOutput_elec(outputFilename, ndime_elec,nnode,u,nelem,mate,coor,conn); 


%% 計算應力或其他所需結果

% 定義要查找的 stress 的範圍
xRnage = [0, 3.5]; % R_A，查找 0 到 3.5 的所有邊界點之 stress
xRnage = [62, 65]; % R_D，查找 62 到 65 的所有邊界點之 stress
xRnage = [30, 33]; % F_BC，查找 30 到 33 的所有邊界點之 stress

% 調用函數查找包含匹配 x 值的邊界元素
boundaryElements = findBoundaryElements(coor, conn, xRnage);

% 初始化一個變量來儲存應力總和
total_stress = 0.0;

% 遍歷 strain_stress_matrix 中的每一行
for i = 1:size(strain_stress_matrix, 1)
    % 獲取當前行的元素編號
    current_elem = strain_stress_matrix(i, 1);

    % 檢查當前元素是否在邊界元素列表中
    if ismember(current_elem, boundaryElements)
        % 如果是邊界元素，將current數據（第4列）加到總和中
        total_stress = total_stress + strain_stress_matrix(i, 4);
    end
end

% 印出總和的應力值
Area_1 = 840/10e6; % m^2
Area_2 = 1260/10e6; % m^2
fprintf('Total force on the boundary: %.3f kN\n', total_stress*Area_1);

