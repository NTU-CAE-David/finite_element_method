function rel = ElemLoad(ndime,nelnd,nfcnd,coorif,tracif)

    rel = zeros(ndime*nfcnd,1);

    xii = zeros(ndime-1,1);
    dxdxi = zeros(ndime,ndime-1);
    M = numIntegPt(ndime-1,nfcnd);
    xi = IntegPt(ndime-1,nfcnd,M);
    w = IntegWt(ndime-1,nfcnd,M);

    for im = 1:M

        for i = 1:ndime-1
            xii(i) = xi(i,im);
        end
        N = ShpFunc(nfcnd,ndime-1,xii);
        dNdxi = ShpFuncDeri(nfcnd,ndime-1,xii);
        dxdxi(:) = 0;
        for i = 1:ndime
            for j = 1:ndime-1
                for a = 1:nfcnd
                    dxdxi(i,j) = dxdxi(i,j)+coorif(i,a)*dNdxi(a,j);
                end
            end
        end
        if(ndime == 2)
            jcb = sqrt(dxdxi(1,1)^2+dxdxi(2,1)^2);
        else
            jcb = sqrt( ...
            ((dxdxi(2,1)*dxdxi(3,2))-(dxdxi(2,2)*dxdxi(3,1)))^2+...
            ((dxdxi(1,1)*dxdxi(3,2))-(dxdxi(1,2)*dxdxi(3,1)))^2+...
            ((dxdxi(1,1)*dxdxi(2,2))-(dxdxi(1,2)*dxdxi(2,1)))^2);
        end
        for a = 1:nfcnd
            for i = 1:ndime
                ir = ndime*(a-1)+i;
                rel(ir) = rel(ir)+N(a)*tracif(2+i)*w(im)*jcb;
                
            end

        end
    end 
end
