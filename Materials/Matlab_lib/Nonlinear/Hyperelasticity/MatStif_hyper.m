function dsde = MatStif_hyper(ndime,mate,B,jhat)
    dsde = zeros(ndime,ndime,ndime,ndime);
    dlt = [[1,0,0]; 
           [0,1,0];
           [0,0,1]];
    mu1 = mate(15);
    K1 = mate(16);
    Bqq = trace(B);
    if (ndime == 2)
        Bqq = Bqq+1;
    end
    for i = 1:ndime
        for j = 1:ndime
            for k = 1:ndime
                for l = 1:ndime
                    dsde(i,j,k,l) = mu1/jhat^(2/3)*( dlt(i,k)*B(j,l)+B(i,l)*dlt(j,k)-...
                        (2/3)*(B(i,j)*dlt(k,l)+B(k,l)*dlt(i,j))+...
                        (2/3)*Bqq/3*dlt(i,j)*dlt(k,l) )+...
                        K1*(2*jhat-1)*jhat* dlt(i,j) * dlt(k,l);
                end 
            end
        end 
    end
end