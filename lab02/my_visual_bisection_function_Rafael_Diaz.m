function P = my_visual_bisection_function_Rafael_Diaz(fun, a, b, Iter)
% MY_VISUAL_BISECTION_FUNCTION Visualiza paso a paso la evolución de la bisección.
%
% Entradas:
%   fun  : Function handle de la función f(x)
%   a, b : Extremos del intervalo inicial
%   Iter : Número exacto de iteraciones a ejecutar
%
% Salida:
%   P    : Vector con las aproximaciones del punto medio c en cada iteración

if fun(a) * fun(b) >= 0
    error('El intervalo inicial [a, b] no cumple la condición de cambio de signo.');
end

P = zeros(1, Iter);

% Dominio para graficar la curva de la función
margin = 0.2 * abs(b - a);
x_grid = linspace(a - margin, b + margin, 500);
y_grid = fun(x_grid);

% Configurar la figura
figure('Name', 'Visualización del Método de la Bisección', 'NumberTitle', 'off');
plot(x_grid, y_grid, 'k-', 'LineWidth', 1.5, 'DisplayName', 'f(x)');
hold on;
yline(0, 'r--', 'LineWidth', 1, 'DisplayName', 'Eje X (f(x)=0)');
grid on;
xlabel('x');
ylabel('f(x)');
title('Evolución del Método de la Bisección');

% Bucle principal del método
colors = lines(Iter);
for k = 1:Iter
    c = (a + b) / 2;
    P(k) = c;

    % Graficar el intervalo [a, b] y el punto medio c actual
    plot([a, b], [0, 0], 'o-', 'LineWidth', 2, 'Color', colors(k, :), ...
        'DisplayName', sprintf('Iter %d: [%.3f, %.3f]', k, a, b));
    plot(c, fun(c), 'x', 'MarkerSize', 8, 'LineWidth', 2, 'Color', colors(k, :));

    % Actualizar subintervalos
    if fun(a) * fun(c) < 0
        b = c;
    else
        a = c;
    end
end

legend('Location', 'northeastoutside');
hold off;
end