function cmat = MatStif(ndime,mate)

    emod = mate(2);
    nu = mate(3);
    cmat = zeros(ndime,ndime,ndime,ndime);
    
    % 2D
    if(ndime == 2)
        if(mate(1) == 1)
            C = [1-nu, nu, 0; nu, 1-nu, 0; 0 0 0.5*(1-2*nu)]*emod/(1+nu)/(1-2*nu);
        else
            C = [1, nu, 0; nu, 1, 0; 0 0 0.5*(1-nu)]*emod/(1-nu*nu);
        end
        
        
        for i = 1:2
            for j = 1:2
                ind1 = switchInd2(i,j);
                for k = 1:2
                    for l = 1:2
                        ind2 = switchInd2(k,l);
                        cmat(i,j,k,l) = C(ind1,ind2); % 3*3
                    end
                end 
            end
        end 

    % 3D
    else
        % Isotropic Linear elastic
        lambda = emod*nu/(1+nu)/(1-2*nu);
        mu = 0.5*emod/(1+nu);
        C = [(lambda+2*mu), lambda, lambda, 0, 0, 0;
            lambda, (lambda+2*mu), lambda, 0, 0, 0;
            lambda, lambda, (lambda+2*mu), 0, 0, 0;
            0, 0, 0, mu, 0, 0;
            0, 0, 0, 0, mu, 0;
            0, 0, 0, 0, 0, mu]; % 6*6 

        for i = 1:3
            for j = 1:3
                ind1 = switchInd3(i,j);
                for k = 1:3
                    for l = 1:3
                        ind2 = switchInd3(k,l);
                        cmat(i,j,k,l) = C(ind1,ind2); % 6*6
                    end
                end 
            end
        end 
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