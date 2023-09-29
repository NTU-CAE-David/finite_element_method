%% ReadInput function
function [ndime,nnode,nelem,nelnd,npres,ntrac,mate,coor,conn,pres,trac] = ReadInput(infile)
    
    % 讀取基本信息
    cellarray = textscan(infile,'%s');
    
    % 讀取PARAMETER
    ndime = str2num(cellarray{1}{3});
    
    % 讀取MATPROP
    mate = zeros(3,1);
    mate(1) = str2num(cellarray{1}{6});
    mate(2) = str2num(cellarray{1}{8});
    mate(3) = str2num(cellarray{1}{10});

    % 讀取節點坐標
    nnode = str2num(cellarray{1}{13});
    ind = 14;
    coor = zeros(ndime,nnode);
    for i = 1:nnode
        for j = 1:ndime
            ind = ind+1;
            coor(j,i) = str2num(cellarray{1}{ind});
        end
    end

    % 讀取ELEMENT
    nelem = str2num(cellarray{1}{ind+3});
    nelnd = str2num(cellarray{1}{ind+5});
    indEle = ind + 6;
    conn = zeros(nelnd,nelem);
    for i = 1:nelem
        for j = 1:nelnd
            indEle = indEle+1;
            conn(j,i) = str2num(cellarray{1}{indEle});
        end
    end

    % 讀取BOUNDARY
    % 讀取disp condition
    npres = str2num(cellarray{1}{indEle+3});
    indBoundary = indEle + 4;
    pres = zeros(3,npres);
    if npres ~= 0 % 檢測是否有位移邊界條件
        for i = 1:npres
            for j = 1:3
                indBoundary = indBoundary+1;
                pres(j,i) = str2num(cellarray{1}{indBoundary});
            end
        end
    end

    
    % 讀取trac外力
    ntrac = str2num(cellarray{1}{indBoundary+2});
    indTrac = indBoundary + 3;
    trac = zeros(2+ndime,ntrac);
    if ntrac ~= 0 % 檢測是否有trac
        for i = 1:ntrac
            for j = 1:2+ndime
                indTrac = indTrac+1;
                trac(j,i) = str2num(cellarray{1}{indTrac});
            end
        end
    end

end