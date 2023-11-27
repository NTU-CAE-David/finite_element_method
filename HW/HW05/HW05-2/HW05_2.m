clc; clear;

%% 打開文件
filename = 'hw5-2_2D';
inputFile = fopen(filename, 'r');

% 讀取輸入數據
[ndime,nnode,nelem,nelnd,npres,ntrac,mate,coor,conn,pres,trac] = ReadInput_Dynamic(inputFile);

mate(4) = mate(4)*1000; % kg/m^3

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
force = [66 2 -10];
% force = [];
nforce = size(force,1);
force = force';

for i = 1:nforce
    node = force(1, i);  % Node where force is prescribed
    dof = force(2, i);   % Degree of freedom (e.g., x=1, y=2, z=3)
    f_value = force(3, i);  % Prescribed force value
end

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

%% 初始位移 u(x,t=0)
% P(a,t=0) = P0*sin(wt) = 0
t = 0;
P0 = f_value;  % Prescribed force value
w1 = 14469.9;
w = 0.1*w1;


%% Newmark Method
mkpres = mpres+0.5*beta2*dt*dt*kpres;
ac = mkpres\(-kpres*uc+rpres);

iprt = 0;
indi = 1;
for i = 1:nstp

    % Update rpres
    t = t + dt;
    P = P0*sin(w*t);
    % Update rpres inside the loop
    rpres(node * ndime - (ndime - dof)) = P;
    
    % Calaulate
    an = mkpres\(rpres-kpres*(uc+dt*vc+0.5*(1.-beta2)*dt*dt*ac)); % Update `rpres`
    vn = (vc+dt*(1.-beta1)*ac+dt*beta1*an);
    un = (uc+dt*vc+(1.-beta2)*0.5*dt*dt*ac+0.5*beta2*dt*dt*an);
    ac = an;
    vc = vn;
    uc = un;
    
    if(iprt == nprt || iprt == 0)
        iprt = 0;

        vtkShapeID = 9; % 設置VTK形狀 ID＝9
        % 一個 mod 做一個檔案
        WriteVTKFile([filename,'_dyna', num2str(indi)], nnode, ndime, nelem, nelnd, coor, conn, uc/0.03, vtkShapeID);

        indi = indi+1;

    end
    iprt = iprt+1;
end

%% 後處理：求位移u
% for i = 1:nnode
%     if abs(coor(2,i)-0.5)<=0.01 && abs(coor(2,i)-0.0212)<=0.03
%         un(i*ndime-1)
%     end
% end
