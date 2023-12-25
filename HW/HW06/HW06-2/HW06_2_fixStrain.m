clc; clear;

%% 打開文件
filename = 'hw6-2_a_1';
inputFile = fopen(filename, 'r');

% 讀取輸入數據
[ndime,nnode,nelem,nelnd,npres,ntrac,mate,coor,conn,pres,trac] = ReadInput_hypo(inputFile);

rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac);

nstpho = mate(13);
nprtho = mate(14);
tol = 1e-4;
maxit = 10;
wglob = zeros(nnode*ndime,1);
stress_e = zeros(nstpho+1,1);
strain_e = zeros(nstpho+1,1);

iprt = 0;
indi = 1;
for i = 2:nstpho+1 % step=1 沒有刺激
    faci = (i-1)/nstpho; % 放大係數
    erri = tol*100;
    niti = 0;
    disp(['Step: ' num2str(i) ', factor: ' num2str(faci)]);
    

    while(erri > tol && niti < maxit) % Check steady state
        niti = niti+1;
        kglob = GlobStif_hypo(ndime,nnode,nelem,nelnd,mate,coor,conn,wglob); % hypo
        fglob = GlobResi_hypo(ndime,nnode,nelem,nelnd,mate,coor,conn,wglob); % hypo
        bglob = faci*rglob-fglob;

        % 處理邊界條件  (Section 2.7 item 11)
        % Prescribed displacements
        for j = 1:npres
            ir = ndime*(pres(1,j)-1)+pres(2,j);
            for ic = 1:ndime*nnode
                kglob(ir,ic) = 0;
            end
            kglob(ir,ir) = 1;
            bglob(ir,1) = -wglob(ir) + faci*pres(3,j);
        end


        dwglob = kglob\bglob;
        dwglobsq = dwglob.'*dwglob;
        wglob = wglob + dwglob; % displacements
        wglobsq = wglob.'*wglob;

        % 計算 dwglob 和 wglob 之間的誤差
        erri = sqrt(dwglobsq/wglobsq);
        disp(['  Iter: ' num2str(niti) ', err: ' num2str(erri)]);
    end 
    
    % 計算當前的應力與應變
    stress_e(i) = max(abs(faci*rglob));
    strain_e(i) = max(abs(wglob./0.1));

    if(iprt == nprtho)
        iprt = 0;
        
        % Output to VTK file
        vtkShapeID = 9; % 設置VTK形狀 ID＝9
        % 一個 mod 做一個檔案
        WriteVTKFile([filename,'_dyna_', num2str(indi)], nnode, ndime, nelem, nelnd, coor, conn, wglob, vtkShapeID);

        indi = indi+1;

    end
    iprt = iprt+1;
end

% 畫出應力與應變圖
plotStressStrain(stress_e, strain_e);

