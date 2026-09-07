function Pvisual = my_visual_secant_rafael_diaz(fun, p0, p1, Iter)
    % my_visual_secant_rafael_diaz Grafica f(c) y las lineas secantes.
    
    Pvisual = zeros(1, Iter + 2);
    Pvisual(1) = p0;
    Pvisual(2) = p1;
    
    % Calculamos la secuencia de iterados
    for k = 2:(Iter + 1)
        f_km1 = fun(Pvisual(k-1));
        f_k   = fun(Pvisual(k));
        
        if (f_k - f_km1) == 0
            error('Division por cero en el metodo de la secante.');
        end
        
        Pvisual(k+1) = Pvisual(k) - f_k * (Pvisual(k) - Pvisual(k-1)) / (f_k - f_km1);
    end
    
    % Definir rango de visualización fijo para ver los puntos p0=2.5 y p1=4
    c_grid = linspace(2, 4.5, 1000);
    f_grid = fun(c_grid);
    
    % Crear la figura
    figure('Name', 'Secant Method Visualization', 'NumberTitle', 'off');
    plot(c_grid, f_grid, 'b-', 'LineWidth', 2, 'DisplayName', 'f(c)');
    hold on;
    grid on;
    yline(0, 'k--', 'LineWidth', 1, 'HandleVisibility', 'off'); % Eje f(c)=0
    
    colors = lines(Iter);
    
    % Graficar cada recta secante
    for k = 2:(Iter + 1)
        pk_m1 = Pvisual(k-1);
        pk    = Pvisual(k);
        fpk_m1 = fun(pk_m1);
        fpk    = fun(pk);
        
        % Pendiente entre los dos puntos evaluados
        m = (fpk - fpk_m1) / (pk - pk_m1);
        
        % Ecuación de la recta secante extendida a toda la gráfica
        secant_line = fpk + m * (c_grid - pk);
        
        % Graficar la recta secante
        plot(c_grid, secant_line, '--', 'LineWidth', 1.2, 'Color', colors(k-1, :), ...
            'DisplayName', sprintf('Secante Iter %d', k-1));
        
        % Marcar los dos puntos evaluados sobre la curva
        plot([pk_m1, pk], [fpk_m1, fpk], 'o', 'MarkerSize', 5, ...
            'MarkerFaceColor', colors(k-1, :), 'HandleVisibility', 'off');
        
        % Marcar la intersección con el eje X (nuevo iterado)
        plot(Pvisual(k+1), 0, 'x', 'MarkerSize', 8, 'LineWidth', 2, ...
            'Color', colors(k-1, :), 'HandleVisibility', 'off');
    end
    
    % Formato final
    ylim([-1, 0.5]);
    title('Metodo de la Secante - Visualizacion de Interacciones');
    xlabel('c (Concentracion [g/L])');
    ylabel('f(c)');
    legend('Location', 'southwest');
    hold off;
end




------Testeo ----------

clc; clear; close all;

% Definición de la función objetivo como handles
f = @(c) (c.^2 - 5*c + 6) ./ (c.^3 - 8*c.^2 + 17*c - 10);

% Parámetros iniciales
p0 = 2.5;
p1 = 4;
tol = 1e-4;
maxIter = 100;
IterVisual = 4;

% 1. Visualización de las 4 primeras líneas secantes (Parte b)
Pvisual = my_visual_secant_rafael_diaz(f, p0, p1, IterVisual);

% 2. Resolución completa del problema usando la función de la Parte a
[root, P, iterationTable] = my_secant_rafael_diaz(f, p0, p1, tol, maxIter);

% Mostrar resultados en la ventana de comandos (Command Window)
disp('======================================================');
disp('            TABLA DE ITERACIONES (SECANTE)           ');
disp('======================================================');
disp(iterationTable);

disp('======================================================');
fprintf('Raiz calculada (root): %.6f\n', root);
disp('======================================================');