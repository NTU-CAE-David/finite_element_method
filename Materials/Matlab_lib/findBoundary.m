function boundaryNodes = findBoundary(coor, xRange, yRange, zRange)
    % 尋找指定 x、y 和 z 範圍內的邊界點及其節點編號
    % 將輸出的 Boundary 手動覆蓋到 input 檔中
    % 包含於 findBoundaryElements.m 中執行，無需獨立執行！！

    %{ 
        ======使用形式======    
        % 定義要查找的 x、y 和 z 值
        xRange = [64, 65]; % 例如，查找 64 到 65 的所有邊界點
        yRange = [-inf, inf]; % 例如，查找在 y 範圍內的元素
        zRange = [-inf, inf]; % 例如，查找在 z 範圍內的元素
        
        % 調用函數查找匹配 x、y 和 z 值的邊界點及其節點編號
        boundaryNodes = findBoundary(coor, xRange, yRange, zRange);
    %}
    
    % 檢查是否提供了 y 和 z 範圍，預設為無限制
    if nargin < 4
        zRange = [-inf, inf];
    end
    if nargin < 3
        yRange = [-inf, inf];
    end

    % 初始化结果
    boundaryNodes = [];
    
    coor = coor'; % 轉置
    ndime = size(coor, 2); % 獲取 coor 數組的列數（每個節點的維度數）
    xCoords = coor(:, 1); % 提取節點的 x 坐標
    yCoords = coor(:, 2); % 提取節點的 y 坐標
    if ndime == 3
        zCoords = coor(:, 3); % 提取節點的 z 坐標
    else
        zCoords = zeros(size(xCoords)); % 提取節點的 z 坐標
    end
    
    % 遍歷 xCoords、yCoords 和 zCoords 陣列
    for i = 1:numel(xCoords)
        xValue = xCoords(i);
        yValue = yCoords(i);
        zValue = zCoords(i);
    
        % 檢查 xValue、yValue 和 zValue 是否在指定的範圍內
        if xValue >= xRange(1) && xValue <= xRange(2) && ...
           yValue >= yRange(1) && yValue <= yRange(2) && ...
           zValue >= zRange(1) && zValue <= zRange(2)
            % 如果在範圍內，將節點索引和座標添加到結果中
            boundaryNodes = [boundaryNodes; i, coor(i, :)];
        end
    end

%     fprintf(fid, "num-prescribed-disp: ", );
%     fprintf(fid, "node#-dof#-disp:\n");

    
    % 輸出 num-prescribed-disp 和節點編號的總數
    fprintf('num-prescribed-disp: %d\n', size(boundaryNodes, 1) * ndime);
    fprintf('node#-dof#-disp:\n');
    
    % 遍歷邊界節點，並輸出節點編號、自由度和位移
    formatString = repmat('%d %d %.1f\n', 1, ndime); % 根据 ndime 动态生成格式字符串
    for i = 1:size(boundaryNodes, 1)
        for j = 1:ndime
            fprintf(formatString, boundaryNodes(i, 1), j, 0.0);
        end
    end

end

%{
% 定义节点坐标
coor = [
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
boundaryNodes = findBoundary(coor, xValues);

%}