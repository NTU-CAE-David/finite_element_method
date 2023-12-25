function kglob = GlobStif_BBar(ndime,nnode,nelem,nelnd,mate,coor,conn,wglob)
    kglob = zeros(ndime*nnode,ndime*nnode);
    for j = 1:nelem
        kel = ElemStif_BBar(j,ndime,nelnd,coor,conn,mate,wglob);
        for a = 1:nelnd
            for i = 1:ndime
                for b = 1:nelnd
                    for k = 1:ndime
                        ir = ndime*(conn(a,j)-1)+i;
                        ic = ndime*(conn(b,j)-1)+k;
                        kglob(ir,ic) = kglob(ir,ic)+kel(ndime*(a-1)+i,ndime*(b-1)+k);
                    end
                end
            end
        end
    end
end
