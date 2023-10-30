function fcnd = FaceNd(ndime,nelnd,ifc)
    fcnd = zeros(numFaceNd(ndime,nelnd),1);
    ind3 = [2,3,1];
    ind4 = [2,3,4,1];
    if(ndime == 2)
        if(nelnd == 3)
            fcnd(1) = ifc;
            fcnd(2) = ind3(ifc);
        elseif(nelnd == 6)
            fcnd(1) = ifc;
            fcnd(2) = ind3(ifc);
            fcnd(3) = ifc+3;
        elseif(nelnd == 4)
            fcnd(1) = ifc;
            fcnd(2) = ind4(ifc);
        elseif(nelnd == 8)
            fcnd(1) = ifc;
            fcnd(2) = ind4(ifc);
            fcnd(3) = ifc+4;
        end
    elseif(ndime == 3)
        if(nelnd == 4)
            if(ifc == 1)
                fcnd = [1,2,3];
            elseif(ifc == 2)
                fcnd = [1,4,2];
            elseif(ifc == 3)
                fcnd = [2,4,3];
            elseif(ifc == 4)
                fcnd = [3,4,1];
            end
        elseif(nelnd == 10)
            if(ifc == 1)
                fcnd = [1,2,3,5,6,7];
            elseif(ifc == 2)
                fcnd = [1,4,2,8,9,5];
            elseif(ifc == 3)
                fcnd = [2,4,3,9,10,6];
            elseif(ifc == 4)
                fcnd = [3,4,1,10,8,7];
            end
        elseif(nelnd == 8)
            if(ifc == 1)
                fcnd = [1,2,3,4];
            elseif(ifc == 2)
                fcnd = [5,8,7,6];
            elseif(ifc == 3)
                fcnd = [1,5,6,2];
            elseif(ifc == 4)
                fcnd = [2,3,7,6];
            elseif(ifc == 5)
                fcnd = [3,7,8,4];
            elseif(ifc == 6)
                fcnd = [4,8,5,1];
            end
        elseif(nelnd == 20)
            if(ifc == 1)
                fcnd = [1,2,3,4,9,10,11,12];
            elseif(ifc == 2)
                fcnd = [5,8,7,6,16,15,14,13];
            elseif(ifc == 3)
                fcnd = [1,5,6,2,17,13,18,9];
            elseif(ifc == 4)
                fcnd = [2,6,7,3,18,14,19,10];
            elseif(ifc == 5)
                fcnd = [3,7,8,4,19,15,20,11];
            elseif(ifc == 6)
                fcnd = [4,8,5,1,20,16,17,12];
            end
        end
    end
end
