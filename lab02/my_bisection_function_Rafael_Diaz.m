function root = my_bisection_function_Rafael_Diaz(fun, a, b, criterion)
% MY_BISECTION_FUNCTION Aproxima la raiz de fun en el intervalo [a, b].
% 
% Entradas:
%   fun       : Handle de la función, ej. @(x) x^2 - 5
%   a, b      : Extremos del intervalo inicial
%   criterion : Si es entero (>=1), indica el número de iteraciones.
%               Si es decimal (<1), indica la tolerancia de error relativo.
%
% Salida:
%   root      : Aproximación de la raíz

% Validar condición inicial
if fun(a) * fun(b) >= 0
    error('El intervalo [a, b] no cumple la condición de cambio de signo f(a)*f(b) < 0.');
end

% Determinar si el criterio es tolerancia o iteraciones fijas
if criterion < 1
    tol = criterion;
    max_iter = 1000; % Límite de seguridad
else
    tol = 0;
    max_iter = criterion;
end

c_old = a;

for k = 1:max_iter
    c = (a + b) / 2;

    % Comprobar convergencia por tolerancia de error relativo
    if k > 1 && tol > 0
        rel_err = abs(c - c_old) / abs(c);
        if rel_err < tol
            break;
        end
    end

    % Evaluar subintervalos para el siguiente paso
    if fun(a) * fun(c) < 0
        b = c;
    else
        a = c;
    end

    c_old = c;
end

root = c;
end