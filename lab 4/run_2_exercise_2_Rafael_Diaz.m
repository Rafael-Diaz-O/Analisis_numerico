clc; clear; close all;
%2b
% Sistema A2, b2 del enunciado (Lab 4 - Ejercicio 2b)
A2 = [-2  1  0  1  2 14 -1;
    2 -1 16  1 -2  0  2;
    1 -2  1  0 -1  2 13;
    15  1 -2  1  0  1 -1;
    0  2 -1 13  1  2 -1;
    -1 14  2  0  1 -2  1;
    1  0  2 -2 15 -1  1];

b2 = [4; 20; 60; 29; 33; -16; -31];

% 1) Reordenar filas para lograr dominancia diagonal estricta
[Aord, bord, dominanceTable] = my_diagonal_dominance_Rafael_Diaz(A2, b2);

disp('Aord =');
disp(Aord);
disp('bord =');
disp(bord);
disp('dominanceTable =');
disp(dominanceTable);

% 2) Resolver con Jacobi y Gauss-Seidel
n = length(bord);
x0 = zeros(n,1);
tol = 1e-4;
maxIter = 100;

[xJacobi, jacobiTable] = my_jacobi_Rafael_Diaz(Aord, bord, x0, tol, maxIter);
disp('Jacobi iterationTable =');
disp(jacobiTable);

[xGS, gsTable] = my_gauss_seidel_Rafael_Diaz(Aord, bord, x0, tol, maxIter);
disp('Gauss-Seidel iterationTable =');
disp(gsTable);

% 3) Tabla comparativa
jacobiUpdates  = height(jacobiTable);
gsUpdates      = height(gsTable);
jacobiResidual = jacobiTable.residual(end);
gsResidual     = gsTable.residual(end);

Method   = ["Jacobi"; "Gauss-Seidel"];
updates  = [jacobiUpdates; gsUpdates];
residual = [jacobiResidual; gsResidual];

comparisonTable = table(Method, updates, residual);

disp('comparisonTable =');
disp(comparisonTable);