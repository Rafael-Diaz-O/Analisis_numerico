function [root, P, iterationTable] = my_secant_Rafael_Diaz(fun, p0, p1, tol, maxIter)
% MY_SECANT_RAFAEL_DIAZ Implementación del método de la secante
%
% Entradas:
%   fun     - Function handle de f(c)
%   p0, p1  - Puntos iniciales de iteración
%   tol     - Tolerancia para los criterios de parada
%   maxIter - Número máximo de iteraciones permitidas
%
% Salidas:
%   root           - Última aproximación aceptada para la raíz
%   P              - Vector fila con todos los iterados [p0, p1, p2, ...]
%   iterationTable - Matriz con el historial detallado de iteraciones

% Inicialización del vector de iterados P
P = [p0, p1];

% Inicialización de la tabla de iteraciones
% Columnas: [k, p_km1, f_p_km1, p_k, f_p_k, p_kp1, step, residual]
iterationTable = [];

converged = false;

for k = 1:maxIter
    p_km1 = P(k);     % p_{k-1}
    p_k   = P(k+1);   % p_k

    f_km1 = fun(p_km1); % f(p_{k-1})
    f_k   = fun(p_k);   % f(p_k)

    % Control de división por cero
    if f_k == f_km1
        warning('Fallo en el método: f(p_k) igual a f(p_{k-1}). Se interrumpe la división por cero.');
        break;
    end

    % Cálculo de la siguiente aproximación p_{k+1}
    p_kp1 = p_k - (f_k * (p_k - p_km1)) / (f_k - f_km1);

    % Cálculo del paso y del residuo
    step     = abs(p_kp1 - p_k);
    residual = abs(fun(p_kp1));

    % Guardar la iteración actual en la tabla
    iterationTable = [iterationTable; k, p_km1, f_km1, p_k, f_k, p_kp1, step, residual]; %#ok<AGROW>

    % Actualizar vector de historial P
    P = [P, p_kp1]; %#ok<AGROW>

    % Verificación del doble criterio de parada
    if (step < tol) && (residual < tol)
        converged = true;
        root = p_kp1;
        break;
    end
end

% Si alcanza maxIter sin converger
if ~converged
    root = P(end);
    warning('Se alcanzó el número máximo de iteraciones sin cumplir la tolerancia especificada.');
end
end


Testeo
% =========================================================================
% DEMO FILE: Punto 1 - Método de la Secante
% Estudiante: Rafael Díaz
% Curso: Análisis Numérico - UIS
% =========================================================================

clc; clear; close all;

%% 1. Definición de parámetros e insumos
% Función handle para f(c)
fun = @(c) (c.^2 - 5*c + 6) ./ (c.^3 - 8*c.^2 + 17*c - 10);

p0 = 2.5;       % Primer punto inicial
p1 = 4.0;       % Segundo punto inicial
tol = 1e-4;     % Tolerancia de parada
maxIter = 100;  % Límite máximo de iteraciones

%% 2. Ejecución de la función principal (Punto 1a)
[root, P, iterationTable] = my_secant_Rafael_Diaz(fun, p0, p1, tol, maxIter);

%% 3. Despliegue de resultados en Command Window
fprintf('========================================================================================\n');
fprintf('                             TABLA DE ITERACIONES - SECANTE                              \n');
fprintf('========================================================================================\n');
fprintf('%-4s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s\n', ...
    'k', 'p_{k-1}', 'f(p_{k-1})', 'p_k', 'f(p_k)', 'p_{k+1}', 'Paso', 'Residuo');
fprintf('----------------------------------------------------------------------------------------\n');

for i = 1:size(iterationTable, 1)
    fprintf('%-4d | %-10.6f | %-10.6f | %-10.6f | %-10.6f | %-10.6f | %-10.6f | %-10.6f\n', ...
        iterationTable(i, 1), ...
        iterationTable(i, 2), ...
        iterationTable(i, 3), ...
        iterationTable(i, 4), ...
        iterationTable(i, 5), ...
        iterationTable(i, 6), ...
        iterationTable(i, 7), ...
        iterationTable(i, 8));
end

fprintf('========================================================================================\n');
fprintf('Raíz aproximada final (root): %.6f\n', root);
fprintf('========================================================================================\n\n');

%% 4. Visualización gráfica (Punto 1b)
% Si ya creaste el archivo my_visual_secant_Rafael_Diaz.m, descomenta la siguiente línea:
% Pvisual = my_visual_secant_Rafael_Diaz(fun, p0, p1, 4);