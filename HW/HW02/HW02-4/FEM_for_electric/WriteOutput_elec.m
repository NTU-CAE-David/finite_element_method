function strain_stress_matrix = WriteOutput_elec(filename,ndime,nnode,u,nelem,mate,coor,conn)
    % Generate the FEM calculate solution to save in "output.opt"
    
    % Open the output file for writing
    outputFile = fopen(filename, 'w');
    
    %% Write nodal displacements to the output file
    fprintf(outputFile, '*NODE\n');
    fprintf(outputFile, 'node#-V:\n');
    for node = 1:nnode
        fprintf(outputFile, '%d %f\n', node, u(node));
    end
    

    %% Write element results(Strain and Stress) to the output file
    fprintf(outputFile, '*ELEMENT\n');
    fprintf(outputFile, 'elem#-E1-E2-I1-I2\n');

    % 初始化一个矩阵来存储应变和应力数据
    strain_stress_matrix = zeros(nelem, 5);
    
    for elem = 1:nelem
        [strain_matrix, stress_matrix] = ElemStrain_elec(elem, ndime, mate, coor, conn, u);
    
        % 存储元素号和应变、应力数据到矩阵中
        strain_stress_matrix(elem, 1) = elem;
        strain_stress_matrix(elem, 2:3) = [strain_matrix(1), strain_matrix(2)];
        strain_stress_matrix(elem, 4:5) = [stress_matrix(1), stress_matrix(2)];
    
        % 打印数据到文件
        fprintf(outputFile, '%d %.3f %.3f %.3f %.3f\n', elem, ...
            strain_matrix(1), strain_matrix(2), ...
            stress_matrix(1), stress_matrix(2));
    end

    % Close the output file
    fclose(outputFile);

end

