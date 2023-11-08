function mglob = GlobMass(ndime,nnode,nelem,nelnd,mate,coor,conn)
    mglob = zeros(ndime*nnode,ndime*nnode);
    for j = 1:nelem
        mel = ElemMass(j,ndime,nelnd,coor,conn,mate);
        for a = 1:nelnd
            for i = 1:ndime
                for b = 1:nelnd
                    for k = 1:ndime
                        ir = ndime*(conn(a,j)-1)+i;
                        ic = ndime*(conn(b,j)-1)+k;
                        mglob(ir,ic) = mglob(ir,ic) + mel(ndime*(a-1)+i,ndime*(b-1)+k);
                    end
                end
            end
        end
    end
end