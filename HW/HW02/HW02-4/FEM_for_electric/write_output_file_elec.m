function write_output_file_elec(filename, nodes, elements)
    % Generate the Mesh input file
    
    % Generate the output filename based on the input filename
%     inputFilename = [filename, '_input.ipt'];
    inputFilename = filename;
    fid = fopen(inputFilename, 'w');
    
    % Write PARAMETER section
    fprintf(fid, '*PARAMETER\n');
    fprintf(fid, 'num-dim: 2\n');
    
    % Write MATPROP section
    fprintf(fid, '*MATPROP\n');
    fprintf(fid, "b-plane-strain: 1\n");
    fprintf(fid, "young's-modulus: 200.0\n");
    fprintf(fid, "poisson's-ratio: 0.3\n");
    
    % Write NODE section
    fprintf(fid, '*NODE\n');
    fprintf(fid, "num-node: %d\n", size(nodes, 1));
    fprintf(fid, "nodal-coord:\n");
    for i = 1:size(nodes, 1)
        fprintf(fid, "%.6f %.6f\n", nodes(i, 1), nodes(i, 2));
    end
    
    % Write ELEMENT section
    fprintf(fid, '*ELEMENT\n');
    fprintf(fid, "num-elem: %d\n", size(elements, 1));
    fprintf(fid, "num-elem-node: 3\n");
    fprintf(fid, "elem-conn:\n");
    for i = 1:size(elements, 1)
        fprintf(fid, "%d %d %d\n", elements(i, 1), elements(i, 2), elements(i, 3));
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
