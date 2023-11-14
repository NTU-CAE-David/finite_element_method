//+
Point(1) = {0, -0.5, 0, 1.0};
//+
Point(2) = {0, 0.5, 0, 1.0};
//+
Point(3) = {30, 0.5, 0, 1.0};
//+
Point(4) = {30, -0.5, 0, 1.0};
//+
Line(1) = {2, 1};
//+
Line(2) = {1, 4};
//+
Line(3) = {4, 3};
//+
Line(4) = {3, 2};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Plane Surface(1) = {1};
//+
Physical Curve("fixed", 5) = {3};
//+
Transfinite Curve {4, 2} = 41 Using Progression 1;
//+
Transfinite Curve {1, 3} = 5 Using Progression 1;
//+
Transfinite Surface {1} = {2, 1, 4, 3};
//+
Recombine Surface {1};
//+
Mesh.SecondOrderIncomplete = 2;
Physical Curve("fixed") = {3};
//+
Recombine Surface {1};
