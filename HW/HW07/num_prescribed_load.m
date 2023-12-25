clc;

R_range = [0.25, 0.25001]; % 設定尋找範圍（半徑R）

% 找出在此範圍（半徑R）內的的所有node，並將各node對應到的的element輸出，並記錄其在此element中的位置。
% 格式：elements_with_nodes = [elem_id, node_position]
elements_with_nodes = findElementsWithNodesInRadius(coor, conn, R_range);

% 將重複兩次的 element 找出來，並記錄重複此兩點所對應到 node_position，找出面（face）。
% 格式：elem_face = [elem_id, node_face]
elem_face = mappedElements(elements_with_nodes);

% 最後找出此面(Face)上的的法線向量
% 格式：elem_face_with_normals = [elem_id, node_face, x_normals, y_normals]
elem_face_with_normals = calculateNormals(elem_face, conn, coor);

%% 依據題目調整面(Face)上的的法線向量大小
press = 1e6; % MPa

% 輸出 num-prescribed-disp 和節點編號的總數
fprintf('num-prescribed-load: %d\n', size(elem_face_with_normals, 1));
fprintf("elem#-face#-trac:\n");

    
% 遍歷邊界節點，並輸出節點編號、自由度和位移
for i = 1:size(elem_face_with_normals, 1)
    fprintf('%d %d %.6g %.6g\n', ...
        elem_face_with_normals(i,1), ...
        elem_face_with_normals(i,2), ...
        elem_face_with_normals(i,3)*press, ...
        elem_face_with_normals(i,4)*press);
end