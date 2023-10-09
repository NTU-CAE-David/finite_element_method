function plotNodeValuesFromMatrix(coor, node_values, title_str)
% 繪製電壓散布圖
% 輸入參數：
% coor - 包含節點座標的矩陣，每列代表一個節點，第一行是x坐標，第二行是y坐標
% node_values - 節點的值（V），應該是一個與節點數量相同的向量
% title_str - 圖的標題

%{ 
% 使用說明
title_str = '節點電壓';

% 調用函數來繪製散點圖
plotNodeValuesFromMatrix(coor, u, title_str);
%}

% 提取節點數量
num_nodes = size(coor, 2);

% 提取x坐標和y坐標
x_coordinates = coor(1, :);
y_coordinates = coor(2, :);

% 根據節點值（V）映射節點大小和顏色
min_node_size = 10; % 最小節點大小
max_node_size = 250; % 最大節點大小
min_node_color = min(node_values);
max_node_color = max(node_values);
scaled_node_sizes = min_node_size + (max_node_size - min_node_size) * (node_values - min_node_color) / (max_node_color - min_node_color);

% 創建散點圖，以x坐標和y坐標表示節點位置，節點大小和顏色都表示節點值（V）
scatter(x_coordinates, y_coordinates, scaled_node_sizes, node_values, 'filled');
colorbar; % 添加顏色條以表示節點值

xlabel('X 坐標');
ylabel('Y 坐標');
title(title_str);

% 設置圖形參數（可選）
grid on;
end
