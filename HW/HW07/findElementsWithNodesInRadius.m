function elements_with_nodes = findElementsWithNodesInRadius(coor, conn, R_range)

% 找出在此範圍（半徑R）內的的所有node，並將各node對應到的的element輸出，並記錄其在此element中的位置。
% 格式：elements_with_nodes = [elem_id, node_position]
    
%{
======使用形式======
elements_with_nodes = findElementsWithNodesInRadius(coor, conn, [0.5, 0.501]);
%}
    
    % 计算节点到原点的距离
    x_coords = coor(1,:)';
    y_coords = coor(2,:)';
    distances = sqrt(x_coords.^2 + y_coords.^2);

    % 找到半径在 0.5 到 0.501 之间的节点
    nodes_in_radius = find(distances >= R_range(1) & distances <= R_range(2));

    % 初始化用于存储元素信息的矩阵
    elements_with_nodes = [];

    % 遍历 nodes_in_radius 中的每个节点编号
    for i = 1:length(nodes_in_radius)
        % 在 conn 矩阵中查找包含当前节点的元素
        [rows, cols] = find(conn' == nodes_in_radius(i));
        
        % 将找到的元素信息记录下来
        for j = 1:length(rows)
            elements_with_nodes = [elements_with_nodes; rows(j), cols(j)];
        end
    end
end
