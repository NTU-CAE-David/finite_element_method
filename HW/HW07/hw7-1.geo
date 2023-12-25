// Define the geometry of the thin-walled pressure vessel
// (This is a basic example, actual geometry definition can vary)
Point(1) = {0, 0, 0, 1.0}; // Center point
Point(2) = {1, 0, 0, 1.0}; // Outer surface point
Point(3) = {0.9, 0, 0, 1.0}; // Inner surface point

Circle(1) = {1, 2, 3}; // Outer circle
Circle(2) = {3, 2, 1}; // Inner circle

Line Loop(1) = {1, 2}; // Outer loop
Plane Surface(1) = {1}; // Outer surface

Line Loop(2) = {-2}; // Inner loop
Plane Surface(2) = {2}; // Inner surface

// Meshing setup
Mesh.CharacteristicLengthFromCurvature = 0;
Mesh.ElementOrder = 2; // Quadratic elements for better accuracy

// Define mesh sizes and refinements based on your requirements
Mesh.ElementSizeFactor = 0.1; // Adjust to get the desired mesh size

// Generate the mesh
Mesh 2;

// Export the mesh
// Save "thin_walled_vessel.msh";
