function se = EffcStrs(mate,ee)
    s0 = mate(10);
    e0 = mate(11);
    nho = mate(12);
    if(ee <= e0)
        if (abs(nho-1) < 1e-12)
            se = s0*ee/e0;
        else
            se = s0*(sqrt( (1+nho^2)/(nho-1)^2 - (nho/(nho-1)-ee/e0)^2 )-1/(nho-1));
        end 
    else
        se = s0*( (ee/e0)^(1/nho) );
    end
end