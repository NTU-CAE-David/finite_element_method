function plotmesh(coor,conn,filename)
  f2D_3 = [1,2,3];
  f2D_4 = [1,2,3,4];
  f2D_6 = [1,4,2,5,3,6];
  f2D_8 = [1,5,2,6,3,7,4,8];
  f3D_4 = [[1,2,3];[1,4,2];[2,4,3];[3,4,1]];
  f3D_10 = [[1,5,2,6,3,7];[1,8,4,9,2,5];[2,9,4,10,3,6];[3,10,4,8,1,7]];
  f3D_8 = [[1,2,3,4];[5,8,7,6];[1,5,6,2];[2,3,7,6];[3,7,8,4];[4,8,5,1]];
  f3D_20 = [[1,9,2,10,3,11,4,12];[5,16,8,15,7,14,6,13]; ...
    [1,17,5,13,6,18,2,9];[2,18,6,14,7,19,3,10]; ...
    [3,19,7,15,8,20,4,11];[4,20,8,16,5,17,1,12]];
  
  [ndime,nnode] = size(coor);
  [nelnd,nelem] = size(conn);
  
  x = zeros(nelnd,ndime);
  set(gcf,'rend','z');
  hold on;
  
  % Plot a 2D mesh
  if(ndime == 2)
    switch(nelnd)
      case 3 
        fD = f2D_3;
      case 4
        fD = f2D_4;
      case 6
        fD = f2D_6;
      case 8
        fD = f2D_8;
      otherwise
        warning('Unexpected 2D mesh type.')
    end
    for j = 1:nelem
      for i = 1:nelnd
        x(i,1:2) = coor(1:2,conn(i,j));
      end
      patch('Vertices',x,'Faces',fD,'FaceColor',[240,240,240]/255,'EdgeColor','b');
    end
    hold on;
    hsct = scatter(coor(1,:),coor(2,:),'MarkerFaceColor','r','MarkerEdgeColor','k');
    hsct.SizeData = 1; 
    xlabel('X');
    ylabel('Y');
    daspect([1 1 1]);
    xhi = max(coor(1,:));
    xlo = min(coor(1,:));
    yhi = max(coor(2,:));
    ylo = min(coor(2,:));
    xmg = 0.125*(xhi-xlo);
    ymg = 0.125*(yhi-ylo);
    axis([xlo-xmg xhi+xmg ylo-ymg yhi+ymg]);
    hold off;
    grid on;
    box on;
    %
    % Write a text file containing the nodes.
    %
    r8mat_write ( [filename '_nodes.txt'], 2, nnode, coor );
    fprintf ( 1, '\n' );
    fprintf(1,'  Nodes saved as "%s"\n',[filename '.txt']);
    %
    % Write a text file containing the triangles.
    %
    i4mat_write ( [filename '_elements.txt'], 3, nelem, conn );
    fprintf(1,'  Elements saved as "%s"\n',[filename '.txt']);
  
  % Plot a 3D mesh  
  elseif(ndime == 3)
    switch(nelnd)
      case 4 
        fD = f3D_4;
      case 10
        fD = f3D_10;
      case 8
        fD = f3D_8;
      case 20
        fD = f3D_20;
      otherwise
        warning('Unexpected 3D mesh type.')
    end
    for j = 1:nelem
      for i = 1:nelnd
        x(i,1:3) = coor(1:3,conn(i,j));
      end
      patch('Vertices',x,'Faces',fD,'FaceColor',[240,240,240]/255,'EdgeColor','b');
    end
    hold on;
    hsct = scatter3(coor(1,:),coor(2,:),coor(3,:),'MarkerFaceColor','r','MarkerEdgeColor','k');
    hsct.SizeData = 1;
    view(-135,25);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    daspect([1 1 1]);
    xhi = max(coor(1,:));
    xlo = min(coor(1,:));
    yhi = max(coor(2,:));
    ylo = min(coor(2,:));
    zhi = max(coor(3,:));
    zlo = min(coor(3,:));
    xmg = 0.125*(xhi-xlo);
    ymg = 0.125*(yhi-ylo);
    zmg = 0.125*(zhi-zlo);
    axis([xlo-xmg xhi+xmg ylo-ymg yhi+ymg zlo-zmg zhi+zmg]);
    hold off;
    grid on;
    box on;
    view([35 25]);
    camproj('perspective');
    %
    %  Write a text file containing the nodes.
    %
    r8mat_write ( [filename '_nodes.txt'], 3, nnode, coor );
    fprintf ( 1, '\n' );
    fprintf(1,'  Nodes saved as "%s"\n',[filename '.txt']);
    %
    %  Write a text file containing the tetrahedrons.
    %
    i4mat_write ( [filename '_elements.txt'], 4, nelem, conn );
    fprintf(1,'  Elements saved as "%s"\n',[filename '.txt']);
    
  end
%
% Print an image file containing the mesh.
%  
  print('-dpng',[filename '_mesh.png']);
  fprintf(1,'  Graphics saved as "%s"\n',[filename '.png']);
end