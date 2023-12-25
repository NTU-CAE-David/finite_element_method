function kel = ElemStif_BBar(iel,ndime,nelnd,coor,conn,mate,wglob)
    kel = zeros(ndime*nelnd,ndime*nelnd);
    coorie = zeros(ndime,nelnd);
    wie = zeros(ndime,nelnd);
    xii = zeros(ndime,1);
    dxdxi = zeros(ndime,ndime);
    dNdx = zeros(nelnd,ndime);
    M = numIntegPt(ndime,nelnd);
    xi = IntegPt(ndime,nelnd,M);
    w = IntegWt(ndime,nelnd,M);
    epsi = zeros(ndime,ndime);
    Bv = zeros(nelnd,ndime);
    for a = 1:nelnd
        for i = 1:ndime
            coorie(i,a) = coor(i,conn(a,iel));
            wie(i,a) = wglob(ndime*(conn(a,iel)-1)+i);
        end
    end
    evol= 0;
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
        dNdx(:) = 0.;
        for a = 1:nelnd
            for i = 1:ndime
                for j = 1:ndime
                    dNdx(a,i) = dNdx(a,i)+dNdxi(a,j)*dxidx(j,i);
                end
            end 
        end
        for a = 1:nelnd
            for i = 1:ndime
                Bv(a,i) = Bv(a,i)+dNdx(a,i)*w(im)*jcb;
            end
        end
        evol = evol+w(im)*jcb;
    end
    omega = 0;
    for a = 1:nelnd
        for i = 1:ndime
            Bv(a,i) = Bv(a,i)/(ndime*evol);
            omega = omega+Bv(a,i)*wie(i,a);
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
        ekk = 0;
        epsi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    epsi(i,j) = epsi(i,j)+0.5*(wie(i,a)*dNdx(a,j)+wie(j,a)*dNdx(a,i));
                end
            end
            ekk = ekk+epsi(i,i);
        end
        epsi(1,1) = epsi(1,1)-ekk/ndime+omega;
        epsi(2,2) = epsi(2,2)-ekk/ndime+omega;
        if(ndime == 3)
            epsi(3,3) = epsi(3,3)-ekk/ndime+omega;
        end
        cmat = MatStif(ndime,mate);
        for a = 1:nelnd
            for i = 1:ndime
                for b = 1:nelnd
                    for k = 1:ndime
                        ir = ndime*(a-1)+i;
                        ic = ndime*(b-1)+k;
                        for j = 1:ndime
                            for l = 1:ndime
                                kel(ir,ic)=kel(ir,ic)+cmat(i,j,k,l)*dNdx(b,l)*dNdx(a,j)*w(im)*jcb;
                                kel(ir,ic)=kel(ir,ic)+cmat(j,j,k,l)*dNdx(b,l)*(Bv(a,i)-dNdx(a,i)/ndime)*w(im)*jcb;
                                kel(ir,ic)=kel(ir,ic)+cmat(i,j,l,l)*dNdx(a,j)*(Bv(b,k)-dNdx(b,k)/ndime)*w(im)*jcb;
                                kel(ir,ic)=kel(ir,ic)+cmat(j,j,l,l)*(Bv(b,k)-dNdx(b,k)/ndime)*(Bv(a,i)-dNdx(a,i)/ndime)*w(im)*jcb;
                            end
                        end 
                    end
                end 
            end
        end 
    end
end
