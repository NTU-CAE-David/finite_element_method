function strain_stress_matrix = WriteOutput(filename,ndime,nnode,u,nelem,mate,coor,conn)
    % Generate the FEM calculate solution to save in "output.opt"
    
    % Open the output file for writing
    outputFile = fopen(filename, 'w');
    
    %% Write nodal displacements to the output file
    fprintf(outputFile, '*NODE\n');
    fprintf(outputFile, 'node#-u1-u2:\n');
    for node = 1:nnode
        fprintf(outputFile, '%d %.3f %.3f\n', node, u((node-1)*ndime+1), u((node-1)*ndime+2));
    end
    

    %% Write element results(Strain and Stress) to the output file
    fprintf(outputFile, '*ELEMENT\n');
    fprintf(outputFile, 'elem#-e11-e22-e12-s11-s22-s12\n');

    % 初始化一个矩阵来存储应变和应力数据
    strain_stress_matrix = zeros(nelem, 7);
    
    for elem = 1:nelem
        [strain_matrix, stress_matrix] = ElemStrain(elem, ndime, mate, coor, conn, u);
    
        % 存储元素号和应变、应力数据到矩阵中
        strain_stress_matrix(elem, 1) = elem;
        strain_stress_matrix(elem, 2:4) = [strain_matrix(1), strain_matrix(2), strain_matrix(3)/2];
        strain_stress_matrix(elem, 5:7) = [stress_matrix(1), stress_matrix(2), stress_matrix(3)];
    
        % 打印数据到文件
        fprintf(outputFile, '%d %.3f %.3f %.3f %.3f %.3f %.3f\n', elem, ...
            strain_matrix(1), strain_matrix(2), strain_matrix(3)/2, ...
            stress_matrix(1), stress_matrix(2), stress_matrix(3));
    end

    % Close the output file
    fclose(outputFile);

end

