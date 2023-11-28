function kel = ElemStif_hyper(iel,ndime,nelnd,coor,conn,mate,wglob)
    kel = zeros(ndime*nelnd,ndime*nelnd);
    coorie = zeros(ndime,nelnd);
    wie = zeros(ndime,nelnd);
    xii = zeros(ndime,1);
    F = zeros(ndime,ndime);
    dxdxi = zeros(ndime,ndime);
    dNdx = zeros(nelnd,ndime);
    dNdy = zeros(nelnd,ndime);
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
        F(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                if(i == j)
                    F(i,j) = 1;
                end
                for a = 1:nelnd
                    F(i,j) = F(i,j)+wie(i,a)*dNdx(a,j);
                end 
            end
        end
        jhat = det(F);
        B = F*F.';
        Finv = inv(F);
        dNdy(:) = 0;
        for a = 1:nelnd
            for i = 1:ndime
                for j = 1:ndime
                    dNdy(a,i) = dNdy(a,i)+dNdx(a,j)*Finv(j,i);
                end
            end 
        end
        tau = KchStrs(ndime,mate,B,jhat);
        dsde = MatStif_hyper(ndime,mate,epsi);
        for a = 1:nelnd
            for i = 1:ndime
                for b = 1:nelnd
                    for k = 1:ndime
                        ir = ndime*(a-1)+i;
                        ic = ndime*(b-1)+k;
                        for j = 1:ndime
                            for l = 1:ndime
                                kel(ir,ic) = kel(ir,ic)+dsde(i,j,k,l)*dNdy(a,j)*dNdy(b,l)*w(im)*jcb;
                            end
                            kel(ir,ic) = kel(ir,ic)-tau(i,j)*dNdy(a,k)*dNdy(b,j)*w(im)*jcb;
                        end
                    end 
                end
            end 
        end
    end 
end
