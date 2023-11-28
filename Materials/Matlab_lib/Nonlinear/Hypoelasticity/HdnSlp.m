function dsedee = HdnSlp(mate,ee)
    s0 = mate(10);
    e0 = mate(11);
    nho = mate(12);
    if(ee <= e0)
        if (abs(nho-1) < 1e-12)
            dsedee = s0/e0;
        else
            dsedee = s0*(nho/(nho-1)-ee/e0)/e0/sqrt((1+nho^2)/(nho-1)^2-(nho/(nho-1)-ee/e0)^2);
        end
    else
        dsedee = s0/nho/ee*(ee/e0)^(1/nho);
    end
end