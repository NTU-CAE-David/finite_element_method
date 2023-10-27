function plotElemStress(coor, conn, strain_stress_matrix)
    % Plot stress distribution on triangular elements
    
    %{ 
    % 使用說明
    title_str = '應力分佈';
    
    % 調用函數來繪製散點圖
    plotElemStress(coor, conn, strain_stress_matrix);
    %}

    % Create a figure
    figure;

    % Determine the range of element stress values
    element_stresses = strain_stress_matrix(:, 5);
    min_stress = min(element_stresses);
    max_stress = max(element_stresses);

    % Create a colormap (jet colormap)
    colormap(jet);

    % Loop through each element
    for iel = 1:size(conn, 2)
        x1 = coor(1, conn(1, iel));
        y1 = coor(2, conn(1, iel));
        x2 = coor(1, conn(2, iel));
        y2 = coor(2, conn(2, iel));
        x3 = coor(1, conn(3, iel));
        y3 = coor(2, conn(3, iel));

        % Extract the stress value for the current element
        element_stress = element_stresses(iel);

        % Map the stress value to a color using the jet colormap
        color = jetColormap(element_stress, min_stress, max_stress);

        % Define vertices and faces for the patch (triangle)
        vertices = [x1, y1; x2, y2; x3, y3];
        faces = [1, 2, 3];

        % Create the patch and set its color
        patch('Vertices', vertices, 'Faces', faces, 'FaceColor', color, 'EdgeColor', 'k');

        hold on;
    end

    % Add labels and title
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    title('應力分佈');

    % Add a colorbar to indicate stress values
    colorbar;
end

function color = jetColormap(value, min_val, max_val)
    % Map a value to a color using the jet colormap
    if (max_val - min_val) == 0
        color = [0, 0, 0]; % Handle the case where min_val and max_val are the same
    else
        % Scale the value to be between 0 and 1
        scaled_value = (value - min_val) / (max_val - min_val);

        % Use the scaled value to index the jet colormap
        colormap_jet = jet(64); % Use the number of colors from the jet colormap
        color_index = round(1 + 63 * scaled_value); % Ensure it's an integer between 1 and 64
        color = colormap_jet(color_index, :);
    end
end




