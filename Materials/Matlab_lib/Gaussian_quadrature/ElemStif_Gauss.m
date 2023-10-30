function kel = ElemStif_Gauss(iel,ndime,nelnd,coor,conn,mate)

    kel = zeros(ndime*nelnd,ndime*nelnd);
    coorie = zeros(ndime,nelnd); % 第 i 元素的各node座標值
    xii = zeros(ndime,1);
    dxdxi = zeros(ndime,ndime);
    dNdx = zeros(nelnd,ndime);
    M = numIntegPt(ndime,nelnd); % 高斯積分點個數
    xi = IntegPt(ndime,nelnd,M);
    w = IntegWt(ndime,nelnd,M);
    
    % X^a_i -> 第 i 元素的各node座標值
    for a = 1:nelnd
        for i = 1:ndime
            coorie(i,a) = coor(i,conn(a,iel));
        end
    end

%% 計算積分點
    for im = 1:M
        for i = 1:ndime
            xii(i) = xi(i,im); % 高斯積分點
        end
        N = ShpFunc(nelnd,ndime,xii);
        dNdxi = ShpFuncDeri(nelnd,ndime,xii);
        

        dxdxi = zeros(ndime,ndime);
        for i = 1:ndime
            for j = 1:ndime
                for a = 1:nelnd
                    dxdxi(i,j) = dxdxi(i,j)+coorie(i,a)*dNdxi(a,j); % Jacobian
                end
            end
        end

        
        dxidx = inv(dxdxi);
        jcb = det(dxdxi);
        
        
        dNdx = zeros(nelnd,ndime);
        
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
                                kel(ir,ic)=kel(ir,ic)+cmat(i,j,k,l)*dNdx(b,l)*dNdx(a,j)*w(im)*jcb;
                      
                            end
                        end
                    end
                end
            end
        end
    end
end