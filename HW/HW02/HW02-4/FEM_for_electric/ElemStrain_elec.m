%% ElemStrain function
function [strain_matrix, stress_matrix] = ElemStrain_elec(iel,ndime,mate,coor,conn,u)
    % 三角形三點座標
    x1a = coor(1,conn(1,iel));
    x2a = coor(2,conn(1,iel));
    x1b = coor(1,conn(2,iel));
    x2b = coor(2,conn(2,iel));
    x1c = coor(1,conn(3,iel));
    x2c = coor(2,conn(3,iel));

    % Shape function
    B = zeros(2,3);
    B(1,1) = -(x2c-x2b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    B(1,2) = -(x2a-x2c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    B(1,3) = -(x2b-x2a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));
    B(2,1) = (x1c-x1b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    B(2,2) = (x1a-x1c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    B(2,3) = (x1b-x1a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));

%     % Plane Strain or Stress
%     if(mate(1) == 1) 
%         % Plane Strain
%         D = [1-mate(3) mate(3) 0; mate(3) 1-mate(3) 0; 0 0 (1-2*mate(3)) / 2];
%         D = D*mate(2)/(1+mate(3))/(1-2*mate(3));
%     else 
%         % Plane Stress
%         D = [1 mate(3) 0; mate(3) 1 0; 0 0 (1-mate(3)) / 2];
%         D = D*mate(2)/(1-mate(3)*mate(3));
%     end
    
    D = mate(1); % material-conductiviry

    % Element of displacement u
    u_iel = zeros(3,1);
    u_iel(1) = u((conn(1,iel)-1)*ndime+1);
    u_iel(2) = u((conn(2,iel)-1)*ndime+1);
    u_iel(3) = u((conn(3,iel)-1)*ndime+1);

    % Calculate Strain and Stress
    strain_matrix = B*u_iel;
    stress_matrix = D*strain_matrix;
    
end