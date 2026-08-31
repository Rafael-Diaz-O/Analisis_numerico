function [a, b] = my_finding_interval_Rafael_Diaz(fun, step, max_iter)
    % MY_FINDING_INTERVAL Enombra e identifica un intervalo valido [a, b] 
    % donde exista un cambio de signo f(a)*f(b) < 0 comenzando la busqueda en x = 0.
    %
    % Entradas:
    %   fun      : Handle de la funcion, ej. @(x) x^2 - 4
    %   step     : Tamaño del paso de busqueda (ej. 0.5 o 1)
    %   max_iter : Limite de iteraciones para evitar bucles infinitos
    %
    % Salidas:
    %   a, b     : Extremos del intervalo que cumplen f(a)*f(b) < 0

    if nargin < 2, step = 0.5; end
    if nargin < 3, max_iter = 1000; end

    x0 = 0;
    a = [];
    b = [];

    % Verificar si x = 0 ya es raiz
    if fun(x0) == 0
        error('x = 0 es exactamente una raíz de la función.');
    end

    % Busqueda incremental alrededor de x = 0
    for k = 1:max_iter
        % Puntos evaluados en la direccion negativa y positiva
        x_left  = x0 - k * step;
        x_right = x0 + k * step;

        % Evaluar cambio de signo en el intervalo derecho [x0, x_right]
        if fun(x0) * fun(x_right) < 0
            a = x0;
            b = x_right;
            return;
        end

        % Evaluar cambio de signo en el intervalo izquierdo [x_left, x0]
        if fun(x_left) * fun(x0) < 0
            a = x_left;
            b = x0;
            return;
        end

        % Evaluar cambio de signo en el tramo exterior [x_left, x_right]
        if fun(x_left) * fun(x_right) < 0
            a = x_left;
            b = x_right;
            return;
        end
    end

    if isempty(a)
        error('No se encontró un intervalo con cambio de signo en el número máximo de iteraciones.');
    end
end

%Prueba en consola 

% Script de prueba para la funcion my_finding_interval
clear; clc;

% 1. Definir una funcion de prueba continua con raiz
% Ejemplo: f(x) = x^2 - 5  (raices en +- sqrt(5) ≈ +-2.236)
fun = @(x) x.^2 - 5;

% 2. Parametros de busqueda
step_size = 0.5;
max_iterations = 100;

% 3. Llamar a la funcion
try
    [a, b] = my_finding_interval_nombre_apellido(fun, step_size, max_iterations);
    
    % 4. Mostrar resultados
    fprintf('=== RESULTADO DE LA BÚSQUEDA ===\n');
    fprintf('Intervalo encontrado: [%.4f, %.4f]\n', a, b);
    fprintf('f(a) = %.4f\n', fun(a));
    fprintf('f(b) = %.4f\n', fun(b));
    fprintf('Producto f(a)*f(b) = %.4f\n', fun(a)*fun(b));
    
    if fun(a)*fun(b) < 0
        fprintf('¡Éxito! El intervalo cumple la condición de Bolzano.\n');
    end
catch ME
    disp(ME.message);
end