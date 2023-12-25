function fglob = GlobResi_hypo(ndime,nnode,nelem,nelnd,mate,coor,conn,wglob)
    fglob = zeros(ndime*nnode,1);
    for iel = 1:nelem
        fel = ElemResi_hypo(iel,ndime,nelnd,coor,conn,mate,wglob);
        for a = 1:nelnd
            for i = 1:ndime
                ir = ndime*(conn(a,iel)-1)+i;
                fglob(ir) = fglob(ir) + fel(ndime*(a-1)+i);
            end 
        end
    end 
end