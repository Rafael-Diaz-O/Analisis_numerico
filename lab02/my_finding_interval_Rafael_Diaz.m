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

