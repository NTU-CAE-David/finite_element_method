% %% GlobTrac function
% function rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac)
%     rglob = zeros(ndime*nnode,1);
%     for j = 1:ntrac
%         rel = ElemTrac(j,coor,conn,trac);
%         iel = trac(1,j);
%         ia = zeros(2,1);
%         if(trac(2,j) == 1)
%             ia(1) = 1;
%             ia(2) = 2;
%         elseif(trac(2,j) == 2)
%             ia(1) = 2;
%             ia(2) = 3;
%         else
%             ia(1) = 3;
%             ia(2) = 1;
%         end
%         for a = 1:2
%             for i = 1:2
%                 ir = ndime*(conn(ia(a),iel)-1)+i;
%                 rglob(ir) = rglob(ir)+rel(ndime*(a-1)+i);
%             end
%         end
%     end
% end

function rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac)
    rglob = zeros(ndime*nnode,1);
    nfcnd = numFaceNd(ndime,nelnd);
    coorif = zeros(ndime,nfcnd);
    for j = 1:ntrac
        iel = trac(1,j);
        ifc = trac(2,j);
        fcnd = FaceNd(ndime,nelnd,ifc);
        for a = 1:nfcnd
            for i = 1:ndime
                coorif(i,a) = coor(i,conn(fcnd(a),iel));
            end
        end
        rel = ElemLoad(ndime,nelnd,nfcnd,coorif,trac(:,j));
        for a = 1:nfcnd
            for i = 1:ndime
                ir = (conn(fcnd(a),iel)-1)*ndime+i;
                rglob(ir) = rglob(ir)+rel((a-1)*ndime+i);
            end
        end
    end
end