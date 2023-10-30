%% ReadInput_gmsh function
function [ndime, nnode, nelem, coor, conn] = ReadInput_gmsh_to_write_output_file(infile, elementShape)
    
% infile: gmsh filename
% elementShape: 使用的元素形狀有多少點。
% 例如：8-node quadrilateral elements -> elementShape=8

    fileID = fopen(infile, 'r');

    if fileID == -1
        error('無法打開文件或文件不存在');
    end
    
    %% Read the file line by line
    tline = fgetl(fileID);
    while ischar(tline)
        % Extracting NDIME, NELEM, and NPOIN
        if startsWith(tline, 'NDIME=')
            ndime = str2double(regexp(tline, '\d+', 'match'));

        elseif startsWith(tline, 'NELEM=')
            nelem = str2double(regexp(tline, '\d+', 'match'));
            
            % Reading ELEMENT CONNECTIVITY
            conn = zeros(elementShape, nelem);
            for i = 1:nelem
                line = fgetl(fileID);
                split_values = str2double(strsplit(line));
                conn(:, i) = split_values(2: end-1)+1;  % 提取中間的元素 從0開始，所以要+1
            end

        elseif startsWith(tline, 'NPOIN=')
            nnode = str2double(regexp(tline, '\d+', 'match'));
            
            % Reading COORDINATES
            coor = zeros(ndime, nnode);
            for i = 1:nnode
                line = fgetl(fileID);
                split_values = str2double(strsplit(line));
                coor(:, i) = split_values(1: end-1);  % 提取中間的元素
            end

        end

        tline = fgetl(fileID);
    end

    %% 輸出：Mesh檔
    [~, meshFile, ~] = fileparts(infile);
    write_output_file(meshFile, coor', conn', elementShape);

    fclose(fileID);
end

