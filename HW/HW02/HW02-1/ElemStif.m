%% ElemStif function
function kel = ElemStif(iel,mate,coor,conn)
    x1a = coor(1,conn(1,iel));
    x2a = coor(2,conn(1,iel));
    x1b = coor(1,conn(2,iel));
    x2b = coor(2,conn(2,iel));
    x1c = coor(1,conn(3,iel));
    x2c = coor(2,conn(3,iel));
    B = zeros(3,6);
    B(1,1) = -(x2c-x2b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
    B(1,2) = 0;
    B(1,3) = -(x2a-x2c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
    .
    .
    .
    ael = . . .;
    if(mate(1) == 1)
        D = [1-mate(3) mate(3) 0; mate(3) 1-mate(3) 0; 0 0 (1-2*mate(3)) / 2];
        D = D*mate(2)/(1+mate(3))/(1-2*mate(3));
    else
        D = [1 mate(3) 0; mate(3) 1 0; 0 0 (1-mate(3)) / 2];
        D = D*mate(2)/(1-mate(3)*mate(3));
    end
    kel = ael*B.'*D*B;
end