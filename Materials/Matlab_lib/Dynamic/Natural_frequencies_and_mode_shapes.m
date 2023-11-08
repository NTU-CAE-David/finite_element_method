clc; clear;

%% 打開文件
filename = 'hw4-4';
inputFile = fopen(filename, 'r');

% 讀取輸入數據
[ndime,nnode,nelem,nelnd,npres,ntrac,mate,coor,conn,pres,trac] = ReadInput_Dynamic(inputFile);

mglob = GlobMass(ndime,nnode,nelem,nelnd,mate,coor,conn);
kglob = GlobStif_Euler(ndime,nnode,nelem,nelnd,mate,coor,conn); % 使用 "Euler-Bernoulli"
rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac); % 讀取 Traction
mpres = mglob;
kpres = kglob;
rpres = rglob;

%% 計算全局荷載向量(force unit N)
% 讀取 node force [node dof force]
% force = [6 2 -80000];
% nforce = size(force,1);
% force = force';

% 處理邊界條件  (Section 2.7 item 11)
% Prescribed displacements
for i = 1:npres
    ir = ndime*(pres(1,i)-1)+pres(2,i);
    for ic = 1:ndime*nnode
        mpres(ir,ic) = 0;
        mpres(ic,ir) = 0;
        kpres(ir,ic) = 0;
        kpres(ic,ir) = 0;
    end
    mpres(ir,ir) = 1.;
    rpres(ir) = pres(3,i);
end

%% Natural freq. & Mode shapes
mpresroot = sqrtm(mpres); % M^{1/2}
mpresrootinv = pinv(mpresroot); % M^{-1/2}
hpres = mpresrootinv*(kpres*mpresrootinv); % H
[q,lambda,~] = svd(hpres); % 特徵向量、特徵值

% Sort the eigenvalues
lambdasort = zeros(ndime*nnode,1);
for i = 1:ndime*nnode
    lambdasort(i) = lambda(i,i);
end
lambdasort = unique(sort(lambdasort));

% mode shapes
nmod = mate(10);
if(ndime == 2)
    nmodrbm = 3;
else
    nmodrbm = 6;
end
u = zeros(nnode*ndime,nmod);
u_temp = zeros(nnode*ndime,1);

for k = 1:nmod
    for i = 1:nnode*ndime
        if((lambda(i,i)-lambdasort(nmodrbm+k))^2 < 1e-8)
            ipick = i;
            break;
        end
    end

    u(:,k) = mpresrootinv*q(:,ipick); % u = M^{-1/2}*Q*w
    u_temp(:,1) = u(:,k);

    % Write VTK file
    vtkShapeID = 9; % 設置VTK形狀 ID＝9
    % 一個 mod 做一個檔案
    WriteVTKFile([num2str(k),'mod03.vtk'], nnode, ndime, nelem, nelnd, coor, conn, u_temp, vtkShapeID);
    
end



coor = coor.';

for i = 1:nnode*ndime
    if mod(i,3) == 1
        u1(fix(i/3)+1,1) = u(i,1);
    end
    if mod(i,3) == 2
        u2(fix(i/3)+1,1) = u(i,1);
    end
    if mod(i,3) == 0
        u3(fix(i/3),1) = u(i,1);
    end
end
