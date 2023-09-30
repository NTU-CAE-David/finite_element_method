function WriteOutput(filename,ndime,nnode,u,nelem,strain_matrix,stress_matrix)
    % Generate the FEM calculate solution to save in "output.opt"
    
    % Open the output file for writing
    outputFile = fopen(filename, 'w');
    
    % Write nodal displacements to the output file
    fprintf(outputFile, '*NODE\n');
    fprintf(outputFile, 'node#-u1-u2:\n');
    for node = 1:nnode
        fprintf(outputFile, '%d %f %f\n', node, u((node-1)*ndime+1), u((node-1)*ndime+2));
    end
    

    % TODO
    % Write element results to the output file
    fprintf(outputFile, '*ELEMENT\n');
    fprintf(outputFile, 'elem#-e11-e22-e12-s11-s22-s12\n');
%     for elem = 1:nelem
%         fprintf(outputFile, '%d %f %f %f %f %f %f\n', elem, ...
%             strain_matrix(elem, 1, 1), strain_matrix(elem, 2, 2), strain_matrix(elem, 1, 2), ...
%             stress_matrix(elem, 1, 1), stress_matrix(elem, 2, 2), stress_matrix(elem, 1, 2));
%     end

    % Close the output file
    fclose(outputFile);

end

