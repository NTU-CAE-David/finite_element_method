%kel = ElemStif(iel,ndime,nelnd,coor,conn,mate)
function kel = ElemStif_Euler(iel,ndime,nelnd,coor,conn,mate)
    kuu = zeros(ndime*nelnd,ndime*nelnd);
    kau = zeros(ndime*ndime,ndime*nelnd);
    kua = zeros(ndime*nelnd,ndime*ndime);
    kaa = zeros(ndime*ndime,ndime*ndime); 
    coorie = zeros(ndime,nelnd);
    xii = zeros(ndime,1);
    dxdxi = zeros(ndime,ndime);
    dNdx = zeros(nelnd,ndime);
    M = numIntegPt(ndime,nelnd);
    xi = IntegPt(ndime,nelnd,M);
    w = IntegWt(ndime,nelnd,M);
    for a = 1:nelnd
        for i = 1:ndime
            coorie(i,a) = coor(i,conn(a,iel));
        end
    end
    dNdxi = ShpFuncDeri(nelnd,ndime,xii);
    for i = 1:ndime
        for j = 1:ndime
            for a = 1:nelnd
                dxdxi(i,j) = dxdxi(i,j)+coorie(i,a)*dNdxi(a,j);
            end
        end
    end
    jcb0 = abs(det(dxdxi));
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
            jcb = abs(det(dxdxi));
            dNdx(:) = 0.;
        for a = 1:nelnd
            for i = 1:ndime
                for j = 1:ndime
                     dNdx(a,i) = dNdx(a,i)+dNdxi(a,j)*dxidx(j,i);
                end
            end
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
                                kuu(ir,ic)=kuu(ir,ic)+cmat(i,j,k,l)*dNdx(a,j)*dNdx(b,l)*w(im)*jcb;
                            end
                        end
                    end
                end
            end
        end
        for a = 1:nelnd
            for i = 1:ndime
                for m = 1:ndime
                    for k = 1:ndime
                        ir = ndime*(a-1)+i;
                        ic = ndime*(m-1)+k;
                        for j = 1:ndime
                            for l = 1:ndime
                                 tmp = cmat(i,j,k,l)*dNdx(a,j)*(xii(m)*dxidx(m,l)*jcb0/jcb)*w(im)*jcb;
                                 kua(ir,ic)=kua(ir,ic)+tmp;
                                 kau(ic,ir)=kau(ic,ir)+tmp;
                            end
                        end
                    end
                end
            end
        end
        for m = 1:ndime
            for i = 1:ndime
             for n = 1:ndime
                 for k = 1:ndime
                 ir = ndime*(m-1)+i;
                 ic = ndime*(n-1)+k;
                    for j = 1:ndime
                        for l = 1:ndime
                                kaa(ir,ic)=kaa(ir,ic)+...
                            cmat(i,j,k,l)*xii(m)*dxidx(m,j)*xii(n)*dxidx(n,l)*jcb0/jcb*jcb0/jcb*w(im)*jcb;
                        end
                    end
                 end
             end
            end
        end
    end
    kel = kuu-kua*(kaa\kau);
end
