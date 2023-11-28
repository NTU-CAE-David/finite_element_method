function tau = KchStrs(ndime,mate,B,jhat)
    tau = zeros(ndime,ndime);
    dlt = [ [1,0,0]; [0,1,0]; [0,0,1] ];
    mu1 = mate(15);
    K1 = mate(16);
    Bkk = trace(B);
    if (ndime == 2)
        Bkk = Bkk+1;
    end
    for i = 1:ndime
        for j = 1 : ndime
            tau(i,j) = mu1/jhat^(2/3)*(B(i,j)-Bkk/3*dlt(i,j))+K1*jhat*(jhat-1)*dlt(i,j);
        end 
    end
end