function d = dmatrix ( p, xx, yy, dd, varargin )

%*****************************************************************************80
%
%% DMATRIX returns signed distance by interpolation from values on a Cartesian grid.
%
%  Licensing:
%
%    (C) 2004 Per-Olof Persson. 
%    See COPYRIGHT.TXT for details.
%
%  Modified:
%
%    16 December 2020
%
%  Reference:
%
%    Per-Olof Persson and Gilbert Strang,
%    A Simple Mesh Generator in MATLAB,
%    SIAM Review,
%    Volume 46, Number 2, June 2004, pages 329-345.
%
%  Input:
%
%    real P(NP,2), the point coordinates.
%
%    real XX(NDATA), YY(NDATA), the points at which the distance was evaluated.
%
%    real DD(NDATA), the signed distance function at the data points.
%
%    VARARGIN, optional arguments.
%
%  Output:
%
%    real D(NP), the signed distance to the region, estimated by interpolation.
%
  d = interp2 ( xx, yy, dd, p(:,1), p(:,2), '*linear' );

  return
end
