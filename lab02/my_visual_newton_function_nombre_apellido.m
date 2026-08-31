function P = my_visual_newton_function_nombre_apellido(fun, p0, der, Iter)
% MY_VISUAL_NEWTON_FUNCTION Visualiza geométricamente las iteraciones
% del método de Newton-Raphson mostrando la curva f(x) y las tangentes.
%
% Entradas:
%   fun  : Function handle de f(x)
%   p0   : Punto inicial
%   der  : Function handle de f'(x)
%   Iter : Número exacto de iteraciones a graficar
%
% Salida:
%   P    : Vector con la secuencia de aproximaciones x_k (incluyendo p0)

P = zeros(1, Iter + 1);
P(1) = p0;
x_curr = p0;

% Crear figura para la visualización
figure('Name', 'Visualización del Método de Newton-Raphson', 'NumberTitle', 'off');

% Definir malla de puntos para la gráfica de la curva f(x)
x_grid = linspace(p0 - 5, p0 + 5, 500);
y_grid = fun(x_grid);

plot(x_grid, y_grid, 'b-', 'LineWidth', 1.5, 'DisplayName', 'f(x)');
hold on;
yline(0, 'k--', 'LineWidth', 1, 'DisplayName', 'Eje X (f(x)=0)');
grid on;
xlabel('x'); ylabel('f(x)');
title('Evolución Geométrica del Método de Newton-Raphson');

colors = lines(Iter);

for k = 1:Iter
    fx = fun(x_curr);
    dfx = der(x_curr);

    if dfx == 0
        warning('La derivada se anuló en la iteración %d', k);
        break;
    end

    % Cálculo de la siguiente aproximación
    x_next = x_curr - fx / dfx;
    P(k+1) = x_next;

    % 1. Punto actual sobre la curva (x_k, f(x_k))
    plot(x_curr, fx, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r', ...
        'HandleVisibility', 'off');

    % 2. Proyección de la línea recta tangente
    x_tangent = linspace(min(x_curr, x_next) - 0.5, max(x_curr, x_next) + 0.5, 50);
    y_tangent = fx + dfx * (x_tangent - x_curr);
    plot(x_tangent, y_tangent, '--', 'Color', colors(k, :), 'LineWidth', 1.2, ...
        'DisplayName', sprintf('Iter %d: x_{%d}=%.4f', k, k-1, x_curr));

    % 3. Línea vertical discontinua hacia el eje X
    plot([x_curr, x_curr], [0, fx], 'k:', 'HandleVisibility', 'off');

    % Actualizar para la siguiente iteración
    x_curr = x_next;
end

% Marca final en el eje X de la raíz encontrada
plot(x_curr, 0, 'gx', 'MarkerSize', 10, 'LineWidth', 2, ...
    'DisplayName', sprintf('Raíz final: x\\approx%.4f', x_curr));

legend('Location', 'northeastoutside');
hold off;
end