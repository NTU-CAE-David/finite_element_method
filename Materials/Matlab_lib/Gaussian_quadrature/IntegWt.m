function w = IntegWt(ndime,nelnd,M) 
    w = zeros(M);
    if (ndime == 1)
        w(1) = 1.0;
        w(2) = 1.0;
    elseif (ndime == 2)
        if (nelnd == 3)
            w(1) = 1/2;
            w(2) = 1/2;
        end
        if (nelnd == 6)
            w(1) = -27/96;
            w(2) = 25/96;
            w(3) = 25/96;
            w(4) = 25/96;  
        end
        if (nelnd == 4)
            for i=1:4
                w(i) = 1.0;
            end
        end
        if (nelnd == 8)
            w(1) = 0.308641974;
            w(2) = 0.493827159;
            w(3) = 0.308641974;
            w(4) = 0.493827159;
            w(5) = 0.790123455;
            w(6) = 0.493827159;
            w(7) = 0.308641974;
            w(8) = 0.493827159;
            w(9) = 0.308641974;
        end
    elseif (ndime == 3)
        if (nelnd == 4) 
            w(1) = 1/6;
        end
        if (nelnd == 10)
            w(1) = 1/24;
            w(2) = 1/24;
            w(3) = 1/24;
            w(4) = 1/24;
        end
        if (nelnd == 8) 
            for i=1:8
                w(i) = 1.0;
            end
        end
        if (nelnd == 20)
            w(1) = 0.171467763;
            w(2) = 0.274348421;
            w(3) = 0.171467763;
            w(4) = 0.274348421;
            w(5) = 0.438957474;
            w(6) = 0.274348421;
            w(7) = 0.171467763;
            w(8) = 0.274348421;
            w(9) = 0.171467763;
            w(10) = 0.274348421;
            w(11) = 0.438957474;
            w(12) = 0.274348421;
            w(13) = 0.438957474;
            w(14) = 0.702331959;
            w(15) = 0.438957474;
            w(16) = 0.274348421;
            w(17) = 0.438957474;
            w(18) = 0.274348421;
            w(19) = 0.171467763;
            w(20) = 0.274348421;
            w(21) = 0.171467763;
            w(22) = 0.274348421;
            w(23) = 0.438957474;
            w(24) = 0.274348421;
            w(25) = 0.171467763;
            w(26) = 0.274348421;
            w(27) = 0.171467763;
        end
    end
end
