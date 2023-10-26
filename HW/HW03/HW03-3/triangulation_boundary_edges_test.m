function triangulation_boundary_edges_test ( )

%*****************************************************************************80
%
%% triangulation_boundary_edges_test tests triangulation_boundary_edges.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    08 April 2019
%
%  Author:
%
%    John Burkardt


%   addpath ( '../triangulation_boundary_edges' )

  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'triangulation_boundary_edges_test:\n' );
  fprintf ( 1, '  MATLAB version\n' );
  fprintf ( 1, '  Test triangulation_boundary_edges.\n' );

  triangulation_boundary_edges ( 'hw3-3-a' );
%
%  Terminate.
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'triangulation_boundary_edges_test:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
  fprintf ( 1, '\n' );
  timestamp ( );

%   rmpath ( '../triangulation_boundary_edges' )

  return
end
