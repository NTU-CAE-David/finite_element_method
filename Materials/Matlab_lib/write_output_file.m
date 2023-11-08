function write_output_file(filename, nodes, elements, elementShape)
    
    % Generate the Mesh input file

    % 检查是否提供了 elementShape，如果没有提供，则使用默认值 3
    if nargin < 4
        elementShape = 3;
    end
    
    % Generate the output filename based on the input filename
%     inputFilename = [filename, '_input.ipt'];
    inputFilename = filename;
    fid = fopen(inputFilename, 'w');

    ndime = size(nodes, 2); % 獲取 nodes 數組的列數（每個節點的維度數）
    
    % Write PARAMETER section
    fprintf(fid, '*PARAMETER\n');
    fprintf(fid, 'num-dim: %d\n', ndime);
    
    % Write MATPROP section
    fprintf(fid, '*MATPROP\n');
    fprintf(fid, "b-plane-strain: 1\n");
    fprintf(fid, "young's-modulus: 200.0\n");
    fprintf(fid, "poisson's-ratio: 0.3\n");
    
    % Write NODE section
    fprintf(fid, '*NODE\n');
    fprintf(fid, "num-node: %d\n", size(nodes, 1));
    fprintf(fid, "nodal-coord:\n");
    formatString = repmat('%.6f ', 1, ndime); % 根據 ndime 生成格式字符串
    formatString = [formatString, '\n'];
    
    for i = 1:size(nodes, 1)
        fprintf(fid, formatString, nodes(i, 1:ndime)); % 根據 ndime 調整輸出的數量
    end
    
    % Write ELEMENT section
    fprintf(fid, '*ELEMENT\n');
    fprintf(fid, "num-elem: %d\n", size(elements, 1));
    fprintf(fid, "num-elem-node: %d\n", elementShape);
    fprintf(fid, "elem-conn:\n");

    formatString = repmat('%d ', 1, elementShape);  % 根據 elementShape 動態生成格式字串
    formatString = [formatString(1:end-1) '\n'];  % 添加換行符
    
    for i = 1:size(elements, 1)
        fprintf(fid, formatString, elements(i, 1:elementShape));  % 使用動態格式字串輸出數據
    end


    % Write BOUNDARY section
    fprintf(fid, '*BOUNDARY\n');
    fprintf(fid, "num-prescribed-disp: 0\n");
    fprintf(fid, "node#-dof#-disp:\n");
    fprintf(fid, "num-prescribed-load: 0\n");
    fprintf(fid, "elem#-face#-trac:\n");
%     fprintf(fid, "num-prescribed-force: 0\n");
%     fprintf(fid, "node#-dof#-force:\n");
    
    
    fclose(fid);
end
