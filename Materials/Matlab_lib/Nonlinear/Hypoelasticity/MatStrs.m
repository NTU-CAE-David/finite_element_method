function sigm = MatStrs(ndime,mate,epsi)
    sigm = zeros(ndime,ndime);
    emod = mate(10)/mate(11)*mate(12);
    nu = mate(3);
    dlt = [ [1,0,0]; [0,1,0]; [0,0,1] ];
    if (ndime == 2)
        evol = epsi(1,1)+epsi(2,2);
    else
        evol = epsi(1,1)+epsi(2,2)+epsi(3,3);
    end
    ee = 0;
    eij = zeros(ndime,ndime);
    for i = 1:ndime
        for j = 1:ndime
            eij(i,j) = epsi(i,j)-dlt(i,j)*evol/3;
            ee = ee + eij(i,j)*eij(i,j);
        end 
    end
    ee = sqrt(2.*ee/3.);
    se = EffcStrs(mate,ee);
    elascoef = emod/9/(1-2*nu);
    for i = 1:ndime
        for j = 1:ndime
            if(ee > 0)
                sigm(i,j) = elascoef*dlt(i,j)*evol+2/3*se*eij(i,j)/ee;
            else
                sigm(i,j) = 0;
            end
        end 
    end
end