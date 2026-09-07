function [L, U] = my_lu_rafael_diaz(A)
% my_lu_rafael_diaz Calcula la factorizacion LU sin pivoteo.
%   A: Matriz cuadrada de entrada
%   L: Matriz triangular inferior con unos en la diagonal
%   U: Matriz triangular superior

[n, m] = size(A);
if n ~= m
    error('La matriz A debe ser cuadrada.');
end

% Inicializamos L como la matriz identidad y U como una copia de A
L = eye(n);
U = A;

% Proceso de eliminacion gaussiana sin pivoteo
for j = 1:n-1
    if U(j,j) == 0
        error('Elemento pivote cero encontrado. Se requiere pivoteo.');
    end
    for i = j+1:n
        % Calcular el multiplicador
        factor = U(i,j) / U(j,j);

        % Guardar el multiplicador en L
        L(i,j) = factor;

        % Actualizar la fila i de U
        U(i,j:n) = U(i,j:n) - factor * U(j,j:n);
    end
end
end


----Testeo ------------

clc; clear; close all;

% Matriz A y vector b del enunciado
A = [ 1  1  0  4;
      2 -1  5  0;
      5  2  1  2;
     -3  0  2  5];

b = [2; 10; -4; 18];

% 1. Factorizacion LU (Punto 3.a)
[L, U] = my_lu_rafael_diaz(A);

% 2. Resolver L*y = b (Sustitucion hacia adelante)
y = L \ b;

% 3. Resolver U*x = y (Sustitucion hacia atras)
x = U \ y;

% --- Demo Output exigido ---
disp('Matriz L =');
disp(L);

disp('Matriz U =');
disp(U);

disp('Vector intermedio y =');
disp(y);

disp('Solucion x =');
disp(x);

% Verificación de error de reconstrucción (A - L*U)
disp('Norma del error ||A - L*U||:');
disp(norm(A - L*U));

