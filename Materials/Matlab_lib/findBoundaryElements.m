function boundaryElements = findBoundaryElements(coor, conn, xRange)
    % 查找包含指定 x 值的边界元素
    % 将输出的 Boundary Elements 手动覆盖到输入文件中
    %{ 
        ======使用形式======    
        % 定义要查找的 x 值
        xRange = [64, 65]; % 例如，查找 64 到 65 的所有邊界點
        
        % 调用函数查找包含匹配 x 值的边界元素
        boundaryElements = findBoundaryElements(coor, conn, xRange);
    %}

    boundaryNodes = findBoundary(coor, xRange);

    boundaryElements = [];
    
    % 遍历每个边界节点的索引
    for j = 1:length(boundaryNodes)
        nodeIndex = boundaryNodes(j,1);

        % 遍历每个元素
        for i = 1:size(conn, 2)
            elementNodes = conn(:, i);
    
            % 如果节点索引在元素节点列表中，将该元素添加到结果中
            if ismember(nodeIndex, elementNodes)
                boundaryElements = [boundaryElements; i];
            end
        end
    end

    % 移除重复的元素
    boundaryElements = unique(boundaryElements, 'rows');

end