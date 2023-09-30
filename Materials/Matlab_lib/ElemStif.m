%% ElemStif function
function kel = ElemStif(iel,mate,coor,conn)
    % 三角形三點座標
    x1a = coor(1,conn(1,iel));
    x2a = coor(2,conn(1,iel));
    x1b = coor(1,conn(2,iel));
    x2b = coor(2,conn(2,iel));
    x1c = coor(1,conn(3,iel));
    x2c = coor(2,conn(3,iel));

    % Shape function
    B = zeros(3,6);
    B(1,1) = -(x2c-x2b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    B(1,2) = 0;
    B(1,3) = -(x2a-x2c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    B(1,4) = 0;
    B(1,5) = -(x2b-x2a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));
    B(1,6) = 0;
    B(2,1) = 0;
    B(2,2) = (x1c-x1b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    B(2,3) = 0;
    B(2,4) = (x1a-x1c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    B(2,5) = 0;
    B(2,6) = (x1b-x1a)/((x2c-x2a)*(x1b-x1a)-(x1c-x1a)*(x2b-x2a));
    B(3,1) = B(2,2);
    B(3,2) = B(1,1);
    B(3,3) = B(2,4);
    B(3,4) = B(1,3);
    B(3,5) = B(2,6);
    B(3,6) = B(1,5);

    % Aelem
    ael = abs((x1b-x1a)*(x2c-x2a)-(x1c-x1a)*(x2b-x2a))/2;

    % Plane Strain or Stress
    if(mate(1) == 1) 
        % Plane Strain
        D = [1-mate(3) mate(3) 0; mate(3) 1-mate(3) 0; 0 0 (1-2*mate(3)) / 2];
        D = D*mate(2)/(1+mate(3))/(1-2*mate(3));
    else 
        % Plane Stress
        D = [1 mate(3) 0; mate(3) 1 0; 0 0 (1-mate(3)) / 2];
        D = D*mate(2)/(1-mate(3)*mate(3));
    end


    kel = ael*B.'*D*B;
end