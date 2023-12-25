function vqrbf_matrix = RBFInterpolation(x_xi_glob, ndime, nelnd)
    % Extract x and y coordinates from x_xi_glob for RBF interpolation
    x = squeeze(x_xi_glob(:, 1, :))';
    y = squeeze(x_xi_glob(:, 2, :))';
    % Assuming v is obtained from some computation, you need to specify it

    % Perform RBF interpolation
    v = rand(size(x)); % Replace this with actual values obtained from computation
    xq = linspace(min(x(:)), max(x(:)), 100); % Adjust based on your requirements
    yq = linspace(min(y(:)), max(y(:)), 100); % Adjust based on your requirements
    [Xq, Yq] = meshgrid(xq, yq);
    vqrbf_matrix = performRBFInterpolation(x, y, v, Xq, Yq);
end