function kglob = GlobStif_hyper(ndime,nnode,nelem,nelnd,mate,coor,conn,wglob)
    kglob = zeros(ndim*nnode,ndim*nnode);
    for j = 1:nelem
        kel = ElemStif_hyper(j,ndime,nelnd,coor,conn,mate,wglob);
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