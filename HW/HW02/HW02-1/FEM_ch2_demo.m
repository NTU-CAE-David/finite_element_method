% 主程序（main）
function main(inputFile)
    
    % 打開文件
    inputFile = fopen('input.ipt', 'r');
    % 讀取輸入數據
    [ndime, nnode, nelem, nelnd, npres, ntrac, mate, coor, conn, pres, trac] = ReadInput(inputFile);

    kel = ElemStif(iel,mate,coor,conn);
    rel = ElemTrac(itrac,coor,conn,trac);

    % 計算全局剛度矩陣
    kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn);
    
    % 計算全局荷載向量
    rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, mate, coor, conn, trac);
    
    % 處理邊界條件（如果有的話）
    % 這部分需要根據你的具體情況來實現
    
    % 解方程系統（求解位移）
    % 這部分需要根據你的具體情況來實現
    
    % 計算應力或其他所需結果
    % 這部分需要根據你的具體情況來實現
end



% %% ElemStif function
% function kel = ElemStif(iel,mate,coor,conn)
%     x1a = coor(1,conn(1,iel));
%     x2a = coor(2,conn(1,iel));
%     x1b = coor(1,conn(2,iel));
%     x2b = coor(2,conn(2,iel));
%     x1c = coor(1,conn(3,iel));
%     x2c = coor(2,conn(3,iel));
%     B = zeros(3,6);
%     B(1,1) = -(x2c-x2b)/((x2a-x2b)*(x1c-x1b)-(x1a-x1b)*(x2c-x2b));
%     B(1,2) = 0;
%     B(1,3) = -(x2a-x2c)/((x2b-x2c)*(x1a-x1c)-(x1b-x1c)*(x2a-x2c));
%     .
%     .
%     .
%     ael = . . .;
%     if(mate(1) == 1)
%         D = [1-mate(3) mate(3) 0; mate(3) 1-mate(3) 0; 0 0 (1-2*mate(3)) / 2];
%         D = D*mate(2)/(1+mate(3))/(1-2*mate(3));
%     else
%         D = [1 mate(3) 0; mate(3) 1 0; 0 0 (1-mate(3)) / 2];
%         D = D*mate(2)/(1-mate(3)*mate(3));
%     end
%     kel = ael*B.'*D*B;
% end

% 
% %% ElemTrac function
% function rel = ElemTrac(itrac,coor,conn,trac)
%     iel= trac(1,itrac);
%     if(trac(2,itrac) == 1)
%         x1a = coor(1,conn(1,iel));
%         x2a = coor(2,conn(1,iel));
%         x1b = coor(1,conn(2,iel));
%         x2b = coor(2,conn(2,iel));
%     elseif(trac(2,itrac) == 2)
%         x1a = coor(1,conn(2,iel));
%         x2a = coor(2,conn(2,iel));
%         x1b = coor(1,conn(3,iel));
%         x2b = coor(2,conn(3,iel));
%     else
%         x1a = coor(1,conn(3,iel));
%         x2a = coor(2,conn(3,iel));
%         x1b = coor(1,conn(1,iel));
%         x2b = coor(2,conn(1,iel));
%     end
%     lel = ...;
%         rel = zeros(4,1);
%     rel(1) = trac(3)*lel / 2;
%     rel(2) = trac(4)*lel / 2;
%     .
%     .
% end
% 
