function elem_face_with_normals = calculateNormals(elem_face, conn, coor)

% 找出受力面(Face)上的的法線向量
% 格式：elem_face_with_normals = [elem_id, node_face, x_normals, y_normals]
    
    % 初始化结果矩阵，包含两列法向量信息
    elem_face_with_normals = elem_face;
    elem_face_with_normals(:, 3:4) = 0;

    % 遍历 elem_face 中的每一行
    for i = 1:size(elem_face, 1)
        % 获取当前行的元素编号和节点编号
        element_num = elem_face(i, 1);
        node_num_face = elem_face(i, 2);
        
        % 在 conn 中找到对应的行
%         row_idx = find(conn(:, 1) == element_num);
        nodes_of_element = conn(:,element_num);

        % 根据 elem_face 中的节点编号，确定节点对应的顺序
%         [~, node_idx] = ismember(node_num_face, nodes_of_element);
        
        % 确定两个节点的编号
        if node_num_face == 1
            node1 = nodes_of_element(1);
            node2 = nodes_of_element(2);
        elseif node_num_face == 2
            node1 = nodes_of_element(2);
            node2 = nodes_of_element(3);
        elseif node_num_face == 3
            node1 = nodes_of_element(3);
            node2 = nodes_of_element(1);
        end

        % 根据节点编号找到对应的坐标
        node1_coords = coor(:, node1)';
        node2_coords = coor(:, node2)';
        
        % 计算法向量（假设这是二维空间中的向量）
        normal_vector = [node1_coords(2) - node2_coords(2), node2_coords(1) - node1_coords(1)];

        % 归一化法向量
%         normal_vector = normal_vector / norm(normal_vector);

        % 将法向量信息写入结果矩阵中
        elem_face_with_normals(i, 3:4) = normal_vector;
    end
end
