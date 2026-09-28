clc; clear; close all;

%% ===================== Ejercicio 3: Crecimiento con capacidad incierta =====================
% Modelo:  y(x) = K / (1 + C*exp(A*x)),  C > 0, A < 0
% x: tiempo en horas, y: concentracion en g/L.

% ---------- Datos completos ----------
x_all = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18];
y_all = [0.95, 1.08, 2.32, 2.85, 5.02, 5.70, 7.95, 8.35, 9.25, 10.05];

% Datos para el ajuste (0 a 12 h, 7 mediciones)
x_fit = x_all(1:7);
y_fit = y_all(1:7);

% Datos para comparacion (14, 16, 18 h)
x_cmp = x_all(8:10);
y_cmp = y_all(8:10);

Ks = [11, 12, 14];
nK = length(Ks);

%% ---------- Parte a): Cambio de variables y ajuste lineal ----------
disp('=== Parte a): Linealizacion del modelo ===');
disp(' ');
disp('Modelo:      y = K / (1 + C*exp(A*x))');
disp('Despejando:  1 + C*exp(A*x) = K/y');
disp('             C*exp(A*x) = K/y - 1');
disp('             ln(K/y - 1) = A*x + ln(C)');
disp(' ');
disp('Cambio de variables:');
disp('   X = x                (tiempo, sin cambio)');
disp('   Y = ln(K/y - 1)       (variable linealizada)');
disp('   Recta:  Y = A*X + B ,  con  B = ln(C)  =>  C = exp(B)');

A_vec = zeros(1, nK);
C_vec = zeros(1, nK);

for k = 1:nK
    K = Ks(k);
    Y = log(K./y_fit - 1);
    X = x_fit;

    [A, B, ~] = my_curve_fit_Rafael_Diaz(X, Y, 'linear_fit', []);
    C = exp(B);

    A_vec(k) = A;
    C_vec(k) = C;

    disp(' ');
    fprintf('--- K = %g g/L ---\n', K);
    fprintf('Recta linealizada: Y = %.6g*X + %.6g\n', A, B);
    fprintf('A = %.6g (1/h),  C = exp(B) = %.6g\n', A, C);
    fprintf('Funcion ajustada: y(x) = %g / (1 + %.6g*exp(%.6g*x))\n', K, C, A);
end

%% ---------- Parte b): Comparacion con mediciones 14,16,18 h ----------
disp(' ');
disp('=== Parte b): Comparacion con las mediciones de 14, 16 y 18 h ===');

E2_vec = zeros(1, nK);
for k = 1:nK
    K = Ks(k);
    A = A_vec(k);
    C = C_vec(k);
    y_pred = K ./ (1 + C.*exp(A.*x_cmp));
    err = y_cmp - y_pred;
    E2_vec(k) = sqrt(mean(err.^2));
end

disp(' ');
disp('Tabla comparativa (K vs E2):');
K_col  = Ks(:);
E2_col = E2_vec(:);
TablaE2 = table(K_col, E2_col, 'VariableNames', {'K_gL', 'E2_gL'});
disp(TablaE2);

% ---------- Seleccion del mejor modelo ----------
[~, idxBest] = min(E2_vec);
Kbest = Ks(idxBest);
Abest = A_vec(idxBest);
Cbest = C_vec(idxBest);

disp(' ');
fprintf('Modelo seleccionado (menor E2): K = %g g/L\n', Kbest);

% ---------- Tiempo en que y(x) = 0.9*K ----------
% 0.9K = K/(1+C*exp(A*x))  =>  C*exp(A*x) = 1/0.9 - 1  =>  x = ln((1/0.9-1)/C)/A
x90 = log((1/0.9 - 1)/Cbest) / Abest;

fprintf('Tiempo en que y(x) alcanza el 90%% de K (0.9*K = %.4g g/L): x = %.4g h\n', ...
        0.9*Kbest, x90);

%% ---------- Grafica ----------
xg = linspace(0, 24, 400);

figure('Name', 'Ejercicio 3: Crecimiento con capacidad incierta');
hold on;

estilos = {'b-', 'r--', 'g-.'};
for k = 1:nK
    K = Ks(k);
    A = A_vec(k);
    C = C_vec(k);
    yg = K ./ (1 + C.*exp(A.*xg));
    plot(xg, yg, estilos{k}, 'LineWidth', 1.6, ...
         'DisplayName', sprintf('K = %g g/L', K));
end

plot(x_fit, y_fit, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6, ...
     'DisplayName', 'Mediciones de ajuste (0-12 h)');
plot(x_cmp, y_cmp, 'ks', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'LineWidth', 1.4, ...
     'DisplayName', 'Mediciones de comparacion (14-18 h)');

grid on;
xlabel('x (h)'); ylabel('y (g/L)');
title('Modelos de crecimiento ajustados para K = 11, 12 y 14 g/L');
legend('Location', 'best');
xlim([0, 24]);