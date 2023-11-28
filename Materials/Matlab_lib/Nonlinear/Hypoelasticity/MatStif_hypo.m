function dsde = MatStif_hypo(ndime,mate,epsi)
    emod = mate(10)/mate(11)*mate(12);
    nu = mate(3);
    dsde = zeros(ndime,ndime,ndime,ndime);
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
    dsedee = HdnSlp(mate,ee);
    elascoef = emod/9/(1-2*nu);
    for i = 1:ndime
        for j = 1:ndime
            for k = 1:ndime
                for l = 1:ndime
                    if(ee > 0)
                        dsde(i,j,k,l) = 2/3*se/ee*(dlt(i,k)*dlt(j,l)-dlt(i,j)*dlt(k,l)/3)+...
                            4/9*(dsedee-se/ee)*eij(i,j)*eij(k,l)/ee/ee+...
                            elascoef*dlt(i,j)*dlt(k,l);
                    else
                        dsde(i,j,k,l) = 2/3*dsedee*(dlt(i,k)*dlt(j,l)-dlt(i,j)*dlt(k,l)/3)+...
                            elascoef*dlt(i,j)*dlt(k,l);
                    end
                end 
            end
        end 
    end
end
