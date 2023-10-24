%% HW03-1: Finite Element Analysis
% E (MPa)
% length unit (mm)


%% 打開文件
filename = 'input.ipt';
inputFile = fopen(filename, 'r');
% 讀取輸入數據
[ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);

%% 計算全局剛度矩陣
kglob = GlobStif_Gauss(ndime, nnode, nelem, nelnd, mate, coor, conn);








%% 計算全局荷載向量(force unit kN)
% 讀取 node force [node dof force]
force = [5 1 25e3;
         2 1 -25e3];
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

%% 處理邊界條件 (Section 2.7 item 11)
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