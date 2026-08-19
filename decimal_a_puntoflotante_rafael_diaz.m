function P = decimal_a_puntoflotante_rafael_diaz(N)

%   1 bit de signo (S)
%   7 bits de exponente con sesgo (E)
%   8 bits de mantisa fraccionaria (M)
%
%   Entrada: N (Número decimal)
%   Salida:  P (Cadena binaria de 16 bits)

% 1. Caso especial: cero
if N == 0
    P = '0000000000000000';
    return;
end

% 2. Determinación del bit de signo (S)
if N < 0
    S = '1';
    N = abs(N);
else
    S = '0';
end

% 3. Cálculo del exponente (E) con sesgo (bias = 63 para 7 bits)
exp_sinbias = floor(log2(N));
bias = 63;
exp_bias = exp_sinbias + bias;
E = dec2bin(exp_bias, 7);

% 4. Extracción de la mantisa (M) de 8 bits
frac = (N / (2^exp_sinbias)) - 1; % Normalización
M = '';
for k = 1:8
    frac = frac * 2;
    if frac >= 1
        M = [M, '1'];
        frac = frac - 1;
    else
        M = [M, '0'];
    end
end

% 5. Ensamblado final del vector de 16 bits
P = [S, E, M];
end
