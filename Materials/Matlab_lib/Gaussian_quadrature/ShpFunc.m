function N = ShpFunc(nelnd,ndime,xii)
    N = zeros(nelnd,1);
    if (ndime == 1)
        N(1) = 0.5*(1.+xii(1));
        N(2) = 0.5*(1.-xii(1));
    elseif (ndime == 2)
        if (nelnd == 3)
            N(1) = xii(1);
            N(2) = xii(2);
            N(3) = 1-xii(1)-xii(2);
        end
        if (nelnd == 6)
            N(1) = (2*xii(1)-1)*xii(1);
            N(2) = (2*xii(2)-1)*xii(2);
            N(3) = (2*(1-xii(1)-xii(2))-1)*(1-xii(1)-xii(2));
            N(4) = 4*xii(1)*xii(2);
            N(5) = 4*xii(2)*(1-xii(1)-xii(2));
            N(6) = 4*xii(1)*(1-xii(1)-xii(2));
        end
        if (nelnd == 4)
            N(1) = 0.25*(1-xii(1))*(1-xii(2));
            N(2) = 0.25*(1+xii(1))*(1-xii(2));
            N(3) = 0.25*(1+xii(1))*(1+xii(2));
            N(4) = 0.25*(1-xii(1))*(1+xii(2));
        end
        if (nelnd == 8)
            N(1) = -0.25*(1-xii(1))*(1-xii(2))*(1+xii(1)+xii(2));
            N(2) = 0.25*(1+xii(1))*(1-xii(2))*(xii(1)-xii(2)-1);
            N(3) = 0.25*(1+xii(1))*(1+xii(2))*(xii(1)+xii(2)-1);
            N(4) = 0.25*(1-xii(1))*(1+xii(2))*(xii(2)-xii(1)-1);
            N(5) = 0.5*(1-xii(1)*xii(1))*(1-xii(2));
            N(6) = 0.5*(1+xii(1))*(1-xii(2)*xii(2));
            N(7) = 0.5*(1-xii(1)*xii(1))*(1+xii(2));
            N(8) = 0.5*(1-xii(1))*(1-xii(2)*xii(2));
        end
    elseif (ndime == 3)
        if (nelnd == 4) 
            N(1) = xii(1);
            N(2) = xii(2);
            N(3) = xii(3);
            N(4) = 1-xii(1)-xii(2)-xii(3);
        end
        if (nelnd == 10)
            N(1) = (2*xii(1)-1)*xii(1);
            N(2) = (2*xii(2)-1)*xii(2);
            N(3) = (2*xii(3)-1)*xii(3);
            N(4) = (2*xii(4)-1)*xii(4);
            N(5) = 4*xii(1)*xii(2);
            N(6) = 4*xii(2)*xii(3);
            N(7) = 4*xii(3)*xii(1);
            N(8) = 4*xii(4)*xii(1);
            N(9) = 4*xii(2)*(1-xii(1)-xii(2)-xii(3));
            N(10) = 4*xii(3)*(1-xii(1)-xii(2)-xii(3));
        end
        if (nelnd == 8)
            N(1) = (1-xii(1))*(1-xii(2))*(1-xii(3))/8;
            N(2) = (1+xii(1))*(1-xii(2))*(1-xii(3))/8;
            N(3) = (1+xii(1))*(1+xii(2))*(1-xii(3))/8;
            N(4) = (1-xii(1))*(1+xii(2))*(1-xii(3))/8;
            N(5) = (1-xii(1))*(1-xii(2))*(1+xii(3))/8;
            N(6) = (1+xii(1))*(1-xii(2))*(1+xii(3))/8;
            N(7) = (1+xii(1))*(1+xii(2))*(1+xii(3))/8;
            N(8) = (1-xii(1))*(1+xii(2))*(1+xii(3))/8;
        end
        if (nelnd == 20)
            N(1) = (1-xii(1))*(1-xii(2))*(1-xii(3))*(-xii(1)-xii(2)-xii(3)-2)/8;
            N(2) = (1+xii(1))*(1-xii(2))*(1-xii(3))*(xii(1)-xii(2)-xii(3)-2)/8;
            N(3) = (1+xii(1))*(1+xii(2))*(1-xii(3))*(xii(1)+xii(2)-xii(3)-2)/8;
            N(4) = (1-xii(1))*(1+xii(2))*(1-xii(3))*(-xii(1)+xii(2)-xii(3)-2)/8;
            N(5) = (1-xii(1))*(1-xii(2))*(1+xii(3))*(-xii(1)-xii(2)+xii(3)-2)/8;
            N(6) = (1+xii(1))*(1-xii(2))*(1+xii(3))*(xii(1)-xii(2)+xii(3)-2)/8;
            N(7) = (1+xii(1))*(1+xii(2))*(1+xii(3))*(xii(1)+xii(2)+xii(3)-2)/8;
            N(8) = (1-xii(1))*(1+xii(2))*(1+xii(3))*(-xii(1)+xii(2)+xii(3)-2)/8;
            N(9) = (1-xii(1)*xii(1))*(1-xii(2))*(1-xii(3))/4;
            N(10) = (1+xii(1))*(1-xii(2)*xii(2))*(1-xii(3))/4;
            N(11) = (1-xii(1)*xii(1))*(1+xii(2))*(1-xii(3))/4;
            N(12) = (1-xii(1))*(1-xii(2)*xii(2))*(1-xii(3))/4;
            N(13) = (1-xii(1)*xii(1))*(1-xii(2))*(1+xii(3))/4;
            N(14) = (1+xii(1))*(1-xii(2)*xii(2))*(1+xii(3))/4;
            N(15) = (1-xii(1)*xii(1))*(1+xii(2))*(1+xii(3))/4;
            N(16) = (1-xii(1))*(1-xii(2)*xii(2))*(1+xii(3))/4;
            N(17) = (1-xii(1))*(1-xii(2))*(1-xii(3)*xii(3))/4;
            N(18) = (1+xii(1))*(1-xii(2))*(1-xii(3)*xii(3))/4;
            N(19) = (1+xii(1))*(1+xii(2))*(1-xii(3)*xii(3))/4;
            N(20) = (1-xii(1))*(1+xii(2))*(1-xii(3)*xii(3))/4;
        end
    end
end
