clc; clear; close all;
%1b
% Sistema A1, b1 del enunciado (Lab 4 - Ejercicio 1b)
A1 = [ -1  1  2 15 -2  1  2;
    1 -1  2  1 -2  1 14;
    2 13 -1  1  0  2 -1;
    2  0 -1  2 13 -1  1;
    12 -1  2  0  1 -1  1;
    1 -2 14  2 -1  1  1;
    -1  2  1  0  1 12 -2];

b1 = [6; 60; -33; 30; 27; 48; -20];

[Aord, bord, dominanceTable] = my_diagonal_dominance_Rafael_Diaz(A1, b1);

disp('Aord =');
disp(Aord);

disp('bord =');
disp(bord);

disp('dominanceTable =');
disp(dominanceTable);