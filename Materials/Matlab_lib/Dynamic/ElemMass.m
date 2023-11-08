function mel = ElemMass(iel,ndime,nelnd,coor,conn,mate)
    mel = zeros(ndime*nelnd,ndime*nelnd);
    coorie = zeros(ndime,nelnd);
    rho = mate(4);
    xii = zeros(ndime,1);
    dxdxi = zeros(ndime,ndime);
    M = numIntegPt(ndime,nelnd);
    xi = IntegPt(ndime,nelnd,M);
    w = IntegWt(ndime,nelnd,M);
    for a = 1:nelnd
        for i = 1:ndime
            coorie(i,a) = coor(i,conn(a,iel));
        end
    end
    for im = 1:M
        for i = 1:ndime
            xii(i) = xi(i,im);
        end
        N = ShpFunc(nelnd,ndime,xii);
        dNdxi = ShpFuncDeri(nelnd,ndime,xii);
        dxdxi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    dxdxi(i,j) = dxdxi(i,j)+coorie(i,a)*dNdxi(a,j);
                end
            end
        end
        jcb = abs(det(dxdxi));
        for a = 1:nelnd
            for b = 1:nelnd
                for i = 1:ndime
                    ir = ndime*(a-1)+i;
                    ic = ndime*(b-1)+i;
                    mel(ir,ic)=mel(ir,ic)+rho*N(b)*N(a)*w(im)*jcb;
                end
            end
        end
    end
end
