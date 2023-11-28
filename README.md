# MATLAB-Based Finite Element Analysis Framework

Welcome to the MATLAB-Based Finite Element Analysis Framework repository for ME 7112: FINITE ELEMENT METHOD at National Taiwan University. This repository contains course materials, assignments, and resources related to the course. The primary focus of this course includes linear and nonlinear finite element analysis, as well as mesh generation using tools like `dictMesh()`.

## Course Information

**Course**: ME 7112: FINITE ELEMENT METHOD  
**Instructor**: 王建凱  
**Semester**: Fall 2023

## Contents

```
├── HW
│   ├── HW01
│   ├── HW02
│   ├── HW03
│   ├── HW04
│   └── HW05
├── Materials
│   ├── Demo
│   └── Matlab_lib
│       ├── Dynamic
│       ├── Gaussian_quadrature
│       ├── Nonlinear
│       │   ├── Hyperelasticity
│       │   └── Hypoelasticity
│       └── distmesh_ntu
├── README.md
└── finite_element_method-main
    └── mesh_generator
        ├── gen_mesh.py
        ├── geometry.yaml
        ├── input.ipt
        ├── main.py
        └── utlis
```

### Materials

In this repository, you will find a collection of course materials, lecture notes, and resources essential for understanding the finite element method. These materials cover various topics related to finite element analysis, both linear and nonlinear. They are designed to facilitate your learning and provide valuable insights into the principles and applications of finite element analysis.

### Assignments

This repository includes assignments related to ME 7112. Assignments are an integral part of the course curriculum and serve as practical exercises to apply the concepts learned during the lectures. Detailed instructions for each assignment can be found within their respective directories.

### Mesh Generation

Mesh generation is a crucial aspect of finite element analysis. Additionally, it provides a mesh generator tool that can be found in the `finite_element_method-main` directory. This mesh generator, developed in Python, simplifies the process of discretizing complex geometries. You can access and use this mesh generator program to create finite element meshes for your analysis projects.

Detailed documentation on how to use this mesh generator tool effectively is available within its directory.

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/NTU-CAE-David/finite_element_method.git
   ```

2. Access the course materials, assignments, and the Python-based mesh generation tool as needed.

## Example: Finite Element Analysis of a Flat Bar with Shoulder Fillets

In this example, we will perform a finite element analysis on a flat bar with shoulder fillets, as shown in the figure below. The bar is subjected to tensile forces *P* = 2.5 kN and has a thickness of *t* = 5.0 mm.

<div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/NTU-CAE-David/finite_element_method/blob/master/HW/HW01/HW01-4/flatBar_shoulderFillets_Mesh.png" alt="Mesh" width="30%">
    <img src="https://github.com/NTU-CAE-David/finite_element_method/blob/master/HW/HW01/HW01-4/flatBar_shoulderFillets_Mesh_density_func.png" alt="Density Function" width="30%">
    <img src="https://github.com/NTU-CAE-David/finite_element_method/blob/master/HW/HW01/HW01-4/flatBar_shoulderFillets_signed_dis_func.png" alt="Signed Distance Function" width="30%">
</div>

We assume a Poisson's ratio of 0.3 and a Young's modulus (*E*) of 200 GPa for the material.

### Mesh Generation

To perform the finite element analysis, we first generate a mesh for the bar's geometry. The mesh is created using a mesh generation tool, and it discretizes the bar into smaller elements for analysis. Below are statistics related to the mesh:

* Statistics

    - Number of nodes: 2106
    - Number of elements: 4011

* Nodal Coordinates

The following table lists the nodal coordinates (X and Y) for various nodes in the mesh:

| Node Index | X-coordinate | Y-coordinate |
| --- | --- | --- |
| 1 | 0.000000 | 0.000000 |
| 2 | 12.000000 | 0.000000 |
| 3 | 0.000000 | -3.000000 |
| 4 | 0.000000 | 3.000000 |
| 5 | 6.000000 | -3.000000 |
| 6 | 6.000000 | 3.000000 |
| 7 | 12.000000 | -2.000000 |

* Element Connections

The following table shows the element connections, indicating which nodes are connected to each element in the mesh:

| Element | Node Connections |
| --- | --- |
| 1 | [20, 34, 26] |
| 2 | [32, 34, 20] |
| 3 | [2090, 7, 2103] |
| 4 | [41, 19, 24] |
| 5 | [24, 19, 13] |

### Code

To perform the finite element analysis and obtain results such as stress and deformation, you would typically use specialized software or code. This example provides an overview of the mesh generation process and the mesh's characteristics. Actual analysis and computations would involve additional code and simulation procedures tailored to the specific problem.

This example serves as a starting point for conducting finite element analysis on complex geometries and structures.

```Matlab
%% A flat bar of rectangular cross section

iteration_max = 200;
fd = @hw1_4_fd;
fh = @hw1_4_fh;
h = 0.05;
filename = 'hw1-4';
[p,t] = hw1_4_demo(iteration_max,h,fd,fh);

figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X'); ylabel('Y'); colorbar; colormap jet; title('Mesh density function'); 
p = p.';
t = t.';
figure('color','w'); plotmesh(p,t,filename); title('Mesh');

%% Call writeInput to save data to files
path = '/Users/chenchiwei/Desktop/國立台灣大學/碩二上/有限元素法/HW/HW01/HW01-4';
fname = fullfile(path,filename);
write_output_file(fname, p.', t.');

%% hw1-4
function [p,t] = hw1_4_demo(iteration_max,h,fd,fh)
    rng('default');
    box = [0.0, -3.0; 12.0, 3.0];
    fixed = [0.0,0.0; 12.0, 0.0;
             0.0,-3.0; 0.0,3.0; 
             6.0,-3.0; 6.0,3.0;
             12.0,-2.0; 12.0,2.0];
    [p,t] = distmesh_2d(fd,fh,h,box,iteration_max,fixed);
end

%% hw1-4_fd
function d = hw1_4_fd(p)
    d1 = drectangle(p, 0.0, 6.0, -3.0, 3.0);
    d2 = drectangle(p, 6.0, 12.0,-2.0, 2.0);
    d3 = drectangle(p, 6.0, 6.6, 2.0, 2.6);
    d4 = drectangle(p, 6.0, 6.6, -2.6, -2.0);
    c1 = dcircle(p, 6.6, 2.6, 0.6);
    c2 = dcircle(p, 6.6, -2.6, 0.6);
    d_t = min(min(min(d1,d2),d3),d4);
    c_t = min(c1,c2);
    d = ddiff(d_t, c_t);
end

%% hw1-4_fh
function h = hw1_4_fh(p)
    h1 = 0.03+0.6*sqrt((p(:,1)-6.6).^2+(p(:,2)-2.6).^2);
    h2 = 0.03+0.6*sqrt((p(:,1)-6.6).^2+(p(:,2)+2.6).^2);
    h = min(h1,h2);
end

```

Please note that this example provides an overview, and actual analysis may involve more detailed steps and software tools specific to finite element analysis.

## Contributions

We welcome contributions from collaborators. If you have improvements to the course materials, new assignments, or enhancements to the mesh generation tool, please feel free to submit pull requests.

## Contact

Should you have any inquiries, suggestions, or feedback, please don't hesitate to reach out:

* Email: chiwei1614@caece.net
* GitHub: [NTU-CAE-David's GitHub](https://github.com/NTU-CAE-David)

*Last updated: 2023/9/23*