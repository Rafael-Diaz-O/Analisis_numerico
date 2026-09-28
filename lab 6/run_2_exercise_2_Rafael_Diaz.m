clc; clear; close all;

%% ===================== Ejercicio 2: Ajuste de curvas =====================
% Se ajustan los datos dados con dos modelos:
%   Modo 1: recta         y = A*x + B   (modo 'linear_fit')
%   Modo 2: curva potencia y = A*x^2    (modo 'power_Fit', M = 2)

xk = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4];
yk = [1.10, 1.32, 1.93, 2.38, 3.24, 3.95, 5.12, 6.10, 7.42];

%% ---------- Modo 1: ajuste lineal y = A*x + B ----------
[A1, B1, T1] = my_curve_fit_Rafael_Diaz(xk, yk, 'linear_fit', []);

disp('=== MODO 1: ajuste lineal  y = A*x + B ===');
disp(' ');
disp('Tabla de calculo (con fila de sumas):');
nombres1 = {'xk','yk','xk2','xk_yk'};
Tabla1 = array2table(T1, 'VariableNames', nombres1);
disp(Tabla1);

n = length(xk);
sx  = T1(end,1);
sy  = T1(end,2);
sx2 = T1(end,3);
sxy = T1(end,4);

disp(' ');
disp('Sistema de ecuaciones normales:');
fprintf('  %.6g*A + %.6g*B = %.6g   (de sum(x^2)*A + sum(x)*B = sum(x*y))\n', sx2, sx, sxy);
fprintf('  %.6g*A + %.6g*B = %.6g   (de sum(x)*A + n*B = sum(y))\n', sx, n, sy);

disp(' ');
fprintf('Coeficientes ajustados: A = %.6g , B = %.6g\n', A1, B1);
fprintf('Funcion ajustada: y = %.6g*x + %.6g\n', A1, B1);

%% ---------- Modo 2: ajuste potencial y = A*x^2 ----------
M = 2;
[A2, B2, T2] = my_curve_fit_Rafael_Diaz(xk, yk, 'power_Fit', M);

disp(' ');
disp('=== MODO 2: ajuste potencial  y = A*x^2 ===');
disp(' ');
disp('Tabla de calculo (con fila de sumas):');
nombres2 = {'xk','yk','xkM','xkM_yk','xk2M'};
Tabla2 = array2table(T2, 'VariableNames', nombres2);
disp(Tabla2);

sxM   = T2(end,3);
sxMy  = T2(end,4);
sx2M  = T2(end,5);

disp(' ');
disp('Ecuacion de minimos cuadrados:');
fprintf('  A = sum(x^M * y) / sum(x^(2M)) = %.6g / %.6g\n', sxMy, sx2M);

disp(' ');
fprintf('Coeficiente ajustado: A = %.6g  (B = %.6g)\n', A2, B2);
fprintf('Funcion ajustada: y = %.6g*x^2\n', A2);

%% ---------- Comparacion de errores con los 9 puntos ----------
yfit_lineal    = A1*xk + B1;
yfit_potencial = A2*xk.^2;

err_lineal    = yk - yfit_lineal;
err_potencial = yk - yfit_potencial;

Einf_lineal = max(abs(err_lineal));
E1_lineal   = mean(abs(err_lineal));
E2_lineal   = sqrt(mean(err_lineal.^2));

Einf_potencial = max(abs(err_potencial));
E1_potencial   = mean(abs(err_potencial));
E2_potencial   = sqrt(mean(err_potencial.^2));

disp(' ');
disp('=== Tabla comparativa de errores (9 puntos) ===');
Modelo = {'y = A*x + B'; 'y = A*x^2'};
Einf   = [Einf_lineal; Einf_potencial];
E1     = [E1_lineal; E1_potencial];
E2     = [E2_lineal; E2_potencial];
TablaErrores = table(Modelo, Einf, E1, E2);
disp(TablaErrores);

%% ---------- Grafica ----------
xg = linspace(0, 4, 200);

figure('Name','Ejercicio 2: Ajuste de curvas');
plot(xk, yk, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Datos'); hold on;
plot(xg, A1*xg + B1, 'b-', 'LineWidth', 1.6, 'DisplayName', 'Ajuste lineal y=Ax+B');
plot(xg, A2*xg.^2,  'r--', 'LineWidth', 1.6, 'DisplayName', 'Ajuste potencial y=Ax^2');
grid on;
xlabel('x'); ylabel('y');
title('Ajuste por minimos cuadrados: recta y potencia');
legend('Location', 'best');