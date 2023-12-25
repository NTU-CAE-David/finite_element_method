function fel = ElemResi_hypo(iel,ndime,nelnd,coor,conn,mate,wglob)
    fel = zeros(ndime*nelnd,1);
    coorie = zeros(ndime,nelnd);
    wie = zeros(ndime,nelnd);
    xii = zeros(ndime,1);
    epsi = zeros(ndime,ndime);
    dxdxi = zeros(ndime,ndime);
    dNdx = zeros(nelnd,ndime);
    M = numIntegPt(ndime,nelnd);
    xi = IntegPt(ndime,nelnd,M);
    w = IntegWt(ndime,nelnd,M);
    for a = 1:nelnd
        for i = 1:ndime
            coorie(i,a) = coor(i,conn(a,iel));
            wie(i,a) = wglob(ndime*(conn(a,iel)-1)+i);
        end
    end
    for im = 1:M
        for i = 1:ndime
            xii(i) = xi(i,im);
        end
        dNdxi = ShpFuncDeri(nelnd,ndime,xii);
        dxdxi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    dxdxi(i,j) = dxdxi(i,j)+coorie(i,a)*dNdxi(a,j);
                end
            end
        end
        dxidx = inv(dxdxi);
        jcb = det(dxdxi);
        dNdx(:) = 0;
        for a = 1:nelnd
            for i = 1:ndime
                for j = 1:ndime
                    dNdx(a,i) = dNdx(a,i)+dNdxi(a,j)*dxidx(j,i);
                end
            end
        end
        epsi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    epsi(i,j) = epsi(i,j)+0.5*(wie(i,a)*dNdx(a,j)+wie(j,a)*dNdx(a,i)); % Strain
                end
            end
        end
        sigm = MatStrs(ndime,mate,epsi); % Stress
        for a = 1:nelnd
            for i = 1:ndime
                ir = ndime*(a-1)+i;
                for j = 1:ndime
                    fel(ir) = fel(ir)+sigm(i,j)*dNdx(a,j)*w(im)*jcb;
                end
            end
        end
    end
end