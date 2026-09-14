clc; clear; close all;

% Funcion a interpolar
f = @(x) 3*sin(pi*x/6).^2;

% Nodos de interpolacion (10 puntos -> polinomio de grado 9)
X = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5];
Y = f(X);

% Construccion del polinomio interpolador con la funcion propia
C = my_lagrange_Rafael_Diaz(X, Y);

disp('C =');
disp(C);

errorMax = max(abs(polyval(C, X) - Y));
disp('max(abs(polyval(C,X)-Y)) =');
disp(errorMax);

% Grafica de f(x), P9(x) y los nodos de interpolacion
xx = linspace(0, 4.5, 500);

figure;
plot(xx, f(xx), 'b-', 'LineWidth', 1.5); hold on;
plot(xx, polyval(C, xx), 'r--', 'LineWidth', 1.5);
plot(X, Y, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
grid on;
xlabel('x');
ylabel('y');
title('Interpolacion de Lagrange: f(x) vs P_9(x)');
legend('f(x)', 'P_9(x)', 'Nodos de interpolacion', 'Location', 'best');