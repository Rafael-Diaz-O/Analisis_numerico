clc; clear; close all;

%% ===================== Ejercicio 1: Polinomios de Newton =====================
% Se aproxima f(x) = cos(x) en [0,6] usando dos polinomios de Newton:
% P3 (con 4 nodos) y P7 (con 8 nodos).

f = @(x) cos(x);

% ---------- Nodos dados ----------
X3 = [0, 1.4, 4.2, 6];
Y3 = f(X3);

X7 = [0, 0.5, 1.4, 2.1, 3.3, 4.2, 5.4, 6];
Y7 = f(X7);

% ---------- Construccion de los polinomios de Newton ----------
[D3, P3] = my_newton_polynomial_Rafael_Diaz(X3, Y3);
[D7, P7] = my_newton_polynomial_Rafael_Diaz(X7, Y7);

% ---------- Mostrar tablas de diferencias divididas ----------
disp('=== Tabla de diferencias divididas para P3 (4 nodos) ===');
mostrar_tabla_diferencias(X3, D3);

disp(' ');
disp('=== Tabla de diferencias divididas para P7 (8 nodos) ===');
mostrar_tabla_diferencias(X7, D7);

% ---------- Mostrar los polinomios en forma de Newton ----------
disp(' ');
disp('=== Polinomio de Newton P3(x) ===');
disp(forma_newton_texto(X3, D3));

disp(' ');
disp('=== Polinomio de Newton P7(x) ===');
disp(forma_newton_texto(X7, D7));

% ---------- Graficas ----------
x = linspace(0, 6, 500);

figure('Name','Ejercicio 1: Polinomios de Newton');

subplot(2,1,1);
plot(x, f(x), 'k-', 'LineWidth', 1.6); hold on;
plot(x, P3(x), 'b--', 'LineWidth', 1.4);
plot(x, P7(x), 'r-.', 'LineWidth', 1.4);
plot(X3, Y3, 'bo', 'MarkerFaceColor', 'b');
plot(X7, Y7, 'rs', 'MarkerFaceColor', 'r');
grid on;
xlabel('x'); ylabel('valor');
title('cos(x), P_3(x) y P_7(x) en [0,6]');
legend('cos(x)', 'P_3(x)', 'P_7(x)', 'Nodos P_3', 'Nodos P_7', 'Location', 'best');

subplot(2,1,2);
plot(x, abs(f(x) - P3(x)), 'b--', 'LineWidth', 1.4); hold on;
plot(x, abs(f(x) - P7(x)), 'r-.', 'LineWidth', 1.4);
grid on;
xlabel('x'); ylabel('error absoluto');
title('|cos(x) - P_3(x)|  y  |cos(x) - P_7(x)|');
legend('|cos(x)-P_3(x)|', '|cos(x)-P_7(x)|', 'Location', 'best');


%% ===================== Funciones auxiliares =====================

function mostrar_tabla_diferencias(X, D)
% Muestra la tabla de diferencias divididas con columnas:
% nodo, f(x), orden 1, orden 2, ..., orden n-1
n = length(X);
nombres = cell(1, n+1);
nombres{1} = 'X';
nombres{2} = 'f(X)';
for k = 2:n-1
    nombres{k+1} = sprintf('Orden%d', k-1);
end
T = array2table([X(:), D], 'VariableNames', nombres);
disp(T);
end

function texto = forma_newton_texto(X, D)
% Construye una cadena de texto con el polinomio de Newton en su forma
% P(x) = c1 + c2*(x-x1) + c3*(x-x1)*(x-x2) + ...
coefs = diag(D)';
n = length(coefs);
texto = sprintf('%.6g', coefs(1));
factores = '';
for k = 2:n
    if coefs(k) >= 0
        signo = ' + ';
    else
        signo = ' - ';
    end
    factores = [factores, sprintf('(x - %.4g)', X(k-1))];
    texto = [texto, signo, sprintf('%.6g', abs(coefs(k))), factores];
end
end