function boundaryNodes = findBoundary(nodeCoords, xValues)
    % 查找指定 x 值的边界点及其节点编号
    % 將輸出的 Boundary 手動覆蓋到 input 檔中
    %{ 
        ======使用形式======    
        % 定義要查找的 x 值
        xValues = [0, 65]; % 例如，查找 0 和 65 的邊界點
        
        % 調用函數查找匹配 x 值的邊界點及其節點編號
        boundaryNodes = findBoundary(coor, xValues);
    %}

    % 初始化结果
    boundaryNodes = [];
    
    % 提取節點的 x 坐標
    nodeCoords = nodeCoords'; % 轉置
    xCoords = nodeCoords(:, 1);
    
    % 遍歷 xValue 矩陣中的每個值
    for i = 1:numel(xValues)
        xValue = xValues(i);
        
        % 查找等於指定 x 值的節點的索引
        boundaryIndices = find(xCoords == xValue);
        
        % 提取邊界點的坐標和它們的節點編號，並添加到結果中
        boundaryNodes = [boundaryNodes; boundaryIndices, nodeCoords(boundaryIndices, :)];

        

    end

%     fprintf(fid, "num-prescribed-disp: ", );
%     fprintf(fid, "node#-dof#-disp:\n");

    % 輸出 num-prescribed-disp 和節點編號的總數
    fprintf('num-prescribed-disp: %d\n', size(boundaryNodes, 1));
    fprintf('node#-dof#-disp:\n');

    % 遍歷邊界節點，並輸出節點編號、自由度和位移
    for i = 1:size(boundaryNodes, 1)
        fprintf('%d %d %.1f\n', boundaryNodes(i, 1), 1, 0.0);
    end

end

%{
% 定义节点坐标
nodeCoords = [
    0.000000 0.000000
    0.000000 -2.100000
    0.000000 2.100000
    20.000000 0.000000
    20.000000 -2.100000
    20.000000 2.100000
    20.000000 -3.150000
    20.000000 3.150000
    45.000000 0.000000
    45.000000 -2.100000
    45.000000 2.100000
    45.000000 -3.150000
    45.000000 3.150000
    65.000000 0.000000
    65.000000 -2.100000
    65.000000 2.100000
    0.701345 -2.100000
    % 其他节点坐标
];

% 定义要查找的 x 值矩阵
xValues = [0, 65]; % 例如，查找 2.7、3.0 和 4.0 的边界节点

% 调用函数查找匹配 x 值的边界点及其节点编号
boundaryNodes = findBoundary(nodeCoords, xValues);

%}