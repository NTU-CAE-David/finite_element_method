function kglob = GlobStif_Euler(ndime,nnode,nelem,nelnd,mate,coor,conn)
% GlobStif_Euler function
% 高斯積分點
% Shear locking
% Ref. 'ME7112-06.pdf': "3.1 Shear locking and incompatible mode elements"

    kglob = zeros(ndime*nnode,ndime*nnode);
    for j = 1:nelem
        kel = ElemStif_Euler(j,ndime,nelnd,coor,conn,mate);
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