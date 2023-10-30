function plotElemStress(coor, conn, strain_stress_matrix, order)
    % Plot stress distribution on triangular elements
    
    %{ 
    % 使用說明
    title_str = '應力分佈';
    
    % 調用函數來繪製散點圖
    plotElemStress(coor, conn, strain_stress_matrix);
    %}

    % Create a figure
    figure;
    
    % 检查是否提供了 order，如果没有提供，则使用默认值 1 (一階)
    if nargin < 4
        order = 1;
    end

    % Determine the range of element stress values
    element_stresses = strain_stress_matrix(:, 5);
    min_stress = min(element_stresses);
    max_stress = max(element_stresses);

    % Create a colormap (jet colormap)
    colormap(jet);

    % Loop through each element
    for iel = 1:size(conn, 2)

        % Extract the stress value for the current element
        element_stress = element_stresses(iel);

        % Map the stress value to a color using the jet colormap
        color = jetColormap(element_stress, min_stress, max_stress);

        % Define vertices and faces for the patch (triangle)
        vertices = coor(:, conn(:, iel))';
        
        faces = 1:size(conn(:, iel), 1)/order;

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




