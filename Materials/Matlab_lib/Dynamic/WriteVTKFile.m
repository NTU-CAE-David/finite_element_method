function WriteVTKFile(filename, nnode, ndime, nelem, nelnd, coor, conn, uc, vtkShapeID)
    % Write VTK file with the given data
    
    % Open the file for writing
    fid = fopen(filename, 'w');
    if fid == -1
        error('Cannot open the file for writing');
    end

    fprintf(fid, "# vtk DataFile Version 2.0\n");
    fprintf(fid, "Generated volume Mesh\n");
    fprintf(fid, "ASCII\n");
    fprintf(fid, "DATASET UNSTRUCTURED_GRID\n");
    fprintf(fid, "POINTS %d float\n", nnode);

    %% Coordinates
    if ndime == 2
        for k = 1:nnode
            fprintf(fid, '%f %f %f\n', coor(1, k), coor(2, k), 0.0); % 2D z=0.0
        end
    elseif ndime == 3
        for k = 1:nnode
            fprintf(fid, '%f %f %f\n', coor(1, k), coor(2, k), coor(3, k));
        end
    end

    %% Element connectivity
    fprintf(fid, "CELLS %d %d\n", nelem, nelem * (1 + nelnd));
    for k = 1:nelem
        formatString = '%d';
        for n = 1:nelnd
            formatString = [formatString, ' %d'];
        end
        formatString = [formatString, '\n'];
        fprintf(fid, formatString, nelnd, conn(1:nelnd, k) - 1);
    end

    %% VTK shape IDs
    fprintf(fid, "CELL_TYPES %d\n", nelem);
    for k = 1:nelem
        fprintf(fid, "%d\n", vtkShapeID); % VTK shape IDs
    end

    %% Output node values (e.g., u, stress, strain...)
    fprintf(fid, "POINT_DATA %d\n", nnode);

    % Write "displacement": u_1, u_2, ...
    for j = 1:ndime
        fprintf(fid, "SCALARS u%d float\n", j);
        fprintf(fid, "LOOKUP_TABLE default\n");
        for k = 1:nnode
            fprintf(fid, "%f\n", uc(ndime * (k - 1) + j, 1));
        end
    end

    % Close the file
    fclose(fid);
end
