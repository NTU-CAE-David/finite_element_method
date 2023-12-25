function elem_face = mappedElements(elements_with_nodes)

% 將重複兩次的 element 找出來，並記錄重複此兩點所對應到 node_position，找出面（face）。
% 格式：elem_face = [elem_id, node_face]

    % 获取第一列元素
    first_column = elements_with_nodes(:, 1);
    
    % 找出重复的元素
    [unique_elems, ~, idx] = unique(first_column, 'stable');
    counts = accumarray(idx, 1);
    duplicate_elems = unique_elems(counts > 1);
    
    % 初始化结果
    elem_face = zeros(size(duplicate_elems, 1), 2);
    elem_face(:, 1) = duplicate_elems(:, 1);
    
    % 根据第二列的值确定输出
    for i = 1:length(duplicate_elems)
        % 找出重复元素对应的行索引
        rows = find(first_column == duplicate_elems(i));
        
        % 获取对应行的第二列元素
        second_column = elements_with_nodes(rows, 2);
        
        % 根据第二列的值进行条件判断
        if ismember(1, second_column) && ismember(2, second_column)
            elem_face(i,2) = 1;
        elseif ismember(2, second_column) && ismember(3, second_column)
            elem_face(i,2) = 2;
        elseif ismember(1, second_column) && ismember(3, second_column)
            elem_face(i,2) = 3;
        end
    end
end



