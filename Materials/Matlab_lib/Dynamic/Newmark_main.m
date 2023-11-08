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

% 取出 kpres 的特徵值並排序
% for i = 1:ndime*nnode
%     kpressort(i) = kpres(i,i);
% end
% kpressort = sort(kpressort);

%% 計算全局荷載向量(force unit N)
% 讀取 node force [node dof force]
force = [6 2 -80000];
nforce = size(force,1);
force = force';

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

%% Newmark Initial
beta1 = mate(5);
beta2 = mate(6);
dt = mate(7);
nstp = mate(8);
nprt = mate(9);
vc = zeros(nnode*ndime,1);
uc = zeros(nnode*ndime,1);

% For What ??? -> 初始位移
% L=1;
% for i=1:nnode
%     uc((i-1)*ndime+3,1)=0.02*(coor(3,i)/L-2*coor(3,i)^3/L^3+coor(3,i)^4/L^4);
% end

mkpres = mpres+0.5*beta2*dt*dt*kpres;
ac = mkpres\(-kpres*uc+rpres);

iprt = 0;
for i = 1:nstp
    an = mkpres\(rpres-kpres*(uc+dt*vc+0.5*(1.-beta2)*dt*dt*ac));
    vn = (vc+dt*(1.-beta1)*ac+dt*beta1*an);
    un = (uc+dt*vc+(1.-beta2)*0.5*dt*dt*ac+0.5*beta2*dt*dt*an);
    ac = an;
    vc = vn;
    uc = un; 
    
    if(iprt == nprt)
        iprt = 0;
        indi = 1;

        vtkShapeID = 8; % 設置VTK形狀 ID＝8
        % 一個 mod 做一個檔案
        WriteVTKFile(['01dyna', num2str(indi), '.txt'], nnode, ndime, nelem, nelnd, coor, conn, uc, vtkShapeID);

        indi = indi+1;

    end
    iprt = iprt+1;
end

%% For What ???
% for i = 1:nnode
%     if abs(coor(3,i)-0.5)<=0.01 && abs(coor(2,i)-0.0212)<=0.03
%         un(i*3-1)
%     end
% end
