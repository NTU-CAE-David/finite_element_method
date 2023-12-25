function [strain_matrix, stress_matrix] = ElemStrain_Gauss(ndime,nnode,nelem,nelnd,coor,conn, mate, u, linear)
% [strain_matrix, stress_matrix] = ElemStrain_Gauss(iel,ndime,coor,conn,u)
% 計算在高斯座標系中的"高斯點座標"
% (ndime,nnode,nelem,nelnd,mate,coor,conn)

    
    M = numIntegPt(ndime,nelnd); % 高斯積分點個數
    coor_gauss = zeros(nelem, ndime, M); % 元素上的各高斯點的高斯座標
    
    if nargin < 8
        linear = true; % 預設為線性
    end

    if ndime == 2
        count_S_T = 3;
    elseif ndime == 3
        count_S_T = 6;
    end
    strain_matrix = zeros(nnode, count_S_T);
    stress_matrix = zeros(nnode, count_S_T);
    strain_gauss_matrix = zeros(nelem, count_S_T, M);
    stress_gauss_matrix = zeros(nelem, count_S_T, M);
%     strain_stress_matrix = zeros(nelem, count_S_T*2+1);
    
    % X^a_i -> 第 i 元素的各node座標值
    for iel = 1:nelem

        % Element of displacement u
        u_iel = zeros(ndime * nelnd, 1);
        for i = 1:nelnd
            for j = 1:ndime
                u_iel(ndime*(i-1)+j) = u((conn(i, iel) - 1) * ndime + j);
            end
        end

        % Compute B matrix
        [B_matrix, x_xi_glob] = computeBMatrix(iel, ndime, nelnd, coor, conn, count_S_T);
        coor_gauss(iel, :, :) = x_xi_glob;
        

        for im = 1:M

            % Calculate Strain and Stress
            % Strain
            strain_gauss_matrix(iel,:,im) = B_matrix(:,:,im) * u_iel;

            % Stress
            if linear == true
                % Linear Material Constitutive
                cmat = MatStif(ndime,mate);

                if ndime == 2
                    for i = 1:ndime
                        for j = 1:ndime
                            % 对刚度张量的索引进行匹配
                            % 使用 Voigt 符号的索引函数 switchInd2 或 switchInd3
                            ind_stress = switchInd2(i, j); % 或者 switchInd3(i, j) 
                            for k = 1:ndime
                                for l = 1:ndime
                                    % 对应 Voigt 符号的索引
                                    ind_strain = switchInd2(k, l); % 或者 switchInd3(k, l) 
                                    % 填充应力矩阵和应变矩阵
                                    stress_gauss_matrix(iel, ind_stress, im) = cmat(i, j, k, l) * strain_gauss_matrix(iel, ind_strain, im);
                                end
                            end
                        end
                    end
                    strain_gauss_matrix(iel, 3, im) = strain_gauss_matrix(iel, 3, im)/2;
                else
                    for i = 1:ndime
                        for j = 1:ndime
                            % 对刚度张量的索引进行匹配
                            % 使用 Voigt 符号的索引函数 switchInd2 或 switchInd3
                            ind_stress = switchInd3(i, j); 
                            for k = 1:ndime
                                for l = 1:ndime
                                    % 对应 Voigt 符号的索引
                                    ind_strain = switchInd3(k, l); 
                                    % 填充应力矩阵和应变矩阵
                                    stress_gauss_matrix(iel, ind_stress, im) = cmat(i, j, k, l) * strain_gauss_matrix(iel, ind_strain, im);

                                end
                            end
                        end
                    end
                    strain_gauss_matrix(iel, 4:6, im) = strain_gauss_matrix(iel, 4:6, im)/2;
                end
            else
                % Hypoelastic Material Constitutive
                cmat = mate(10)*mate(12)/mate(11);
                strain_gauss_matrix(iel, 3, im) = strain_gauss_matrix(iel, 3, im)/2;
                stress_gauss_matrix(iel,:,im) = cmat.*strain_gauss_matrix(iel,:,im);
            end

        end

    end



    

    %% Radial basis function (RBF) interpolation
    % TODO 擴充至3D

    % Initialize the total RBF model


    for i = 1:count_S_T

%         x = squeeze(coor_gauss(:, 1, :));
%         y = squeeze(coor_gauss(:, 2, :));
%         v_stress = squeeze(stress_gauss_matrix(:, i, :));
%         v_strain = squeeze(strain_gauss_matrix(:, i, :));
        x = reshape(coor_gauss(:, 1, :), [], 1);
        y = reshape(coor_gauss(:, 2, :), [], 1);
        v_stress = reshape(stress_gauss_matrix(:, i, :), [], 1);
        v_strain = reshape(strain_gauss_matrix(:, i, :), [], 1);

        xq = coor(1, :);
        yq = coor(2, :);
        
        % stress
        rbfop_stress = rbfcreate([x(:)'; y(:)'], v_stress','RBFFunction','multiquadric','Stats', 'on');
%         rbfcheck(rbfop_stress); % Check the combined RBF model
        stress_matrix(:,i) = rbfinterp([xq(:)'; yq(:)'],rbfop_stress); % Interpolate for the entire coordinate system using the combined RBF model
        
        % strain
        rbfop_strain = rbfcreate([x(:)'; y(:)'], v_strain','RBFFunction','multiquadric','Stats', 'on');
%         rbfcheck(rbfop_strain); % Check the combined RBF model
        strain_matrix(:,i) = rbfinterp([xq(:)'; yq(:)'],rbfop_strain); % Interpolate for the entire coordinate system using the combined RBF model

    
%         figure;
%         plot3(x,y,v_stress,'mo');
%         hold on;
%         % 生成用于 meshgrid 的网格数据
%         [Xq, Yq] = meshgrid(xq, yq);
%         
%         % 组合 x、y 作为 plot3 的坐标数据
%         plot3(x, y, v_stress, 'mo');
%         hold on;
%         
%         % 使用 mesh 绘制插值曲面
%         mesh(Xq, Yq, reshape(stress_matrix(:, i), size(Xq)));
%         title('Radial basis function (RBF) interpolation');
%         legend('Sample Points','Interpolated Surface','Location','NorthWest');
%         hold off;

    end

end

%% 2D Voigt natation
function ind = switchInd2(i,j)
    if(i == 1 && j == 1)
        ind = 1;
    elseif(i == 2 && j == 2)
        ind = 2;
    elseif((i == 1 && j == 2) || (i == 2 && j == 1))
        ind = 3; 
    else
        disp('Wrong i & j.');
    end
end

%% 3D Voigt natation
function ind = switchInd3(i,j) 
    if(i == 1 && j == 1)
        ind = 1;
    elseif(i == 2 && j == 2)
        ind = 2;
    elseif(i == 3 && j == 3)
        ind = 3;
    elseif((i == 2 && j == 3) || (i == 3 && j == 2))
        ind = 4; 
    elseif((i == 1 && j == 3) || (i == 3 && j == 1))
        ind = 5; 
    elseif((i == 1 && j == 2) || (i == 2 && j == 1))
        ind = 6; 
    else
        disp('Wrong i & j.');
    end
end


