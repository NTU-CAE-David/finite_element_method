function plot_triangular_mesh(coor, node_values)
    % 創建三角形網格圖
    figure;
    
    % 獲取三角形網格的拓撲信息
    tri = delaunay(coor(:, 1), coor(:, 2));
    
    % 使用 trisurf 繪製填充顏色的三角形
    trisurf(tri, coor(:, 1), coor(:, 2), zeros(size(coor, 1), 1), node_values, 'FaceColor', 'interp');
    
    % 添加顏色條
    colorbar;

    % 添加標籤和標題
    xlabel('X坐標');
    ylabel('Y坐標');
    title('屬性分佈圖');
end
