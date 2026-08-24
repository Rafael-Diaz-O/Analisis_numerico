function P = visual_verification_Rafael_Diaz(fun, a, b)
    x = linspace(a, b, 1000);
    y_g = fun(x);
    y_line = x;

    figure;
    plot(x, y_g, 'b-', 'LineWidth', 2, 'DisplayName', 'g(x)');
    hold on;
    plot(x, y_line, 'r--', 'LineWidth', 1.5, 'DisplayName', 'y = x');
    
    grid on;
    xlabel('x');
    ylabel('y');
    title('Verificación Visual de Punto Fijo');
    legend('Location', 'northwest');

    % Estimación visual del punto de intersección
    diff_val = abs(y_g - y_line);
    [~, idx] = min(diff_val);
    P = x(idx);
    
    plot(P, fun(P), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 8, 'DisplayName', 'Punto Fijo Intersección');
    hold off;
end