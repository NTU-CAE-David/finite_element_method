function boundaryElements = findBoundaryElements(coor, conn, xRange, yRange)
    % 查找包含指定 x 和 y 範圍內的邊界元素
    % 將輸出的 Boundary Elements 手動覆蓋到輸入文件中

    %{ 
        ======使用形式======    
        % 定義要查找的 x 值和 y 值範圍
        xRange = [64, 65]; % 例如，查找 64 到 65 的邊界元素
        yRange = [-inf, inf]; % 例如，查找在 y 範圍內的元素
        
        % 呼叫函數查找包含匹配 x 和 y 值範圍的邊界元素
        boundaryElements = findBoundaryElements(coor, conn, xRange, yRange);
    %}
    
    % 檢查是否提供了 y 範圍，預設為無限制
    if nargin < 4
        yRange = [-inf, inf];
    end

    % 呼叫 findBoundary 函數來查找包含指定 x 和 y 值範圍的邊界節點
    boundaryNodes = findBoundary(coor, xRange, yRange);

    boundaryElements = [];
    
    % 遍歷每個邊界節點的索引
    for j = 1:length(boundaryNodes)
        nodeIndex = boundaryNodes(j, 1);

        % 遍歷每個元素
        for i = 1:size(conn, 2)
            elementNodes = conn(:, i);
    
            % 如果節點索引在元素節點列表中，將該元素添加到結果中
            if ismember(nodeIndex, elementNodes)
                boundaryElements = [boundaryElements; i];
            end
        end
    end

    % 移除重複的元素
    boundaryElements = unique(boundaryElements);
end
