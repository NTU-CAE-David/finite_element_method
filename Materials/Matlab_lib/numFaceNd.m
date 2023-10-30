function nfcnd = numFaceNd(ndime,nelnd)
    if(ndime == 2)
        if(nelnd == 3 || nelnd == 4)
            nfcnd = 2;
        elseif (nelnd == 6 || nelnd == 8)
            nfcnd = 3;
        end
    elseif(ndime == 3)
        if(nelnd == 4)
            nfcnd = 3;
        elseif (nelnd == 10)
            nfcnd = 6;
        elseif (nelnd == 8)
            nfcnd = 4;
        elseif (nelnd == 20)
            nfcnd = 8;
        end
    end
end
