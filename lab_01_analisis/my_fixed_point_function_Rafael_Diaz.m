function P = my_fixed_point_function_Rafael_Diaz(fun, a, b, p0, Iter)
    % Valida que el punto inicial esté en el rango
    if p0 < a || p0 > b
        error('El punto inicial p0 debe estar dentro del intervalo [a, b].');
    end

    p = p0;
    fprintf('Iter\t\tp_k\t\t\tg(p_k)\n');
    fprintf('----------------------------------------\n');
    
    for k = 1:Iter
        p_next = fun(p);
        fprintf('%d\t\t%.6f\t\t%.6f\n', k, p, p_next);
        
        % Verifica si la iteración se sale del rango
        if p_next < a || p_next > b
            warning('La iteración se salió del intervalo [a, b] en k = %d.', k);
        end
        
        p = p_next;
    end
    
    P = p;
end

