function [B_matrix, x_xi_glob] = computeBMatrix(iel, ndime, nelnd, coor, conn, count_S_T)
    % Input:
    % - coor: Nodal coordinates
    % - conn: Element connectivity
    % - iel: Element index
    % - ndime: Number of dimensions (2 or 3)
    % - nelnd: Number of nodes per element

    coorie = zeros(ndime, nelnd); % Coordinates of nodes in the element
    xii = zeros(ndime, 1);
    dxdxi = zeros(ndime, ndime);
    dNdx = zeros(nelnd, ndime);
    M = numIntegPt(ndime, nelnd); % Number of Gauss integration points
    xi = IntegPt(ndime, nelnd, M);

    x_xi_glob = zeros(ndime, M); % 元素上的各高斯點的高斯座標
    B_matrix = zeros(count_S_T, ndime * nelnd, M);


    % Get the coordinates of the nodes in the element
    for a = 1:nelnd
        coorie(:, a) = coor(:, conn(a, iel));
    end

    
    % Integration loop
    for im = 1:M

        for i = 1:ndime
            xii(i) = xi(i,im); % 高斯積分點
        end
        N = ShpFunc(nelnd,ndime,xii);
        dNdxi = ShpFuncDeri(nelnd,ndime,xii);

        % x_real to x_xi (Gauss coor)
        for a = 1:nelnd
            for i = 1:ndime
                x_xi_glob(i,im) = x_xi_glob(i,im) + N(a)*coorie(i,a); % 高斯點座標
            end
        end
        

        dxdxi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    dxdxi(i,j) = dxdxi(i,j)+coorie(i,a)*dNdxi(a,j); % Jacobian
                end
            end
        end

        
        dxidx = inv(dxdxi);
        jcb = det(dxdxi);
        
        
        dNdx(:) = 0;
        
        for a = 1:nelnd
            for i = 1:ndime
                for j = 1:ndime
                    dNdx(a,i) = dNdx(a,i)+dNdxi(a,j)*dxidx(j,i);
                end
            end
        end
        

        % Compute B matrix
        if ndime == 2

            % 2D 4nodes
            B_matrix(1,1:ndime:size(B_matrix, 2), im) = dNdx(:, 1);
            B_matrix(2,2:ndime:size(B_matrix, 2), im) = dNdx(:, 2);
            B_matrix(3,1:ndime:size(B_matrix, 2), im) = dNdx(:, 2);
            B_matrix(3,2:ndime:size(B_matrix, 2), im) = dNdx(:, 1);

        elseif ndime == 3
            
            % 3D 8nodes
            B_matrix(1,1:ndime:size(B_matrix, 2), im) = dNdx(:, 1);
            B_matrix(2,2:ndime:size(B_matrix, 2), im) = dNdx(:, 2);
            B_matrix(3,3:ndime:size(B_matrix, 2), im) = dNdx(:, 3);
            
            % sigma_23
            B_matrix(4,2:ndime:size(B_matrix, 2), im) = dNdx(:, 3);
            B_matrix(4,3:ndime:size(B_matrix, 2), im) = dNdx(:, 2);
            
            % sigma_13
            B_matrix(5,1:ndime:size(B_matrix, 2), im) = dNdx(:, 3);
            B_matrix(5,3:ndime:size(B_matrix, 2), im) = dNdx(:, 1);

            % sigma_12
            B_matrix(6,1:ndime:size(B_matrix, 2), im) = dNdx(:, 2);
            B_matrix(6,2:ndime:size(B_matrix, 2), im) = dNdx(:, 1);

        end
        
    end
end
