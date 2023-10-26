function triangulation_boundary_nodes_test ( )

%*****************************************************************************80
%
%% triangulation_boundary_nodes_test tests triangulation_boundary_nodes.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    09 April 2019
%
%  Author:
%
%    John Burkardt

%   addpath ( '../triangulation_boundary_nodes' )

  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'triangulation_boundary_nodes_test:\n' );
  fprintf ( 1, '  MATLAB version\n' );
  fprintf ( 1, '  Test triangulation_boundary_nodes.\n' );

  triangulation_boundary_nodes ( 'hw3-3-a' );
%
%  Terminate.
%
  fprintf ( 1, '\n' );
  fprintf ( 1, 'triangulation_boundary_nodes_test:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );
  fprintf ( 1, '\n' );
  timestamp ( );

%   rmpath ( '../triangulation_boundary_nodes' )

  return
end
