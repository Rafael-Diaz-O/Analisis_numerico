function N_decimal = puntoflotante_a_decimal_rafael_diaz(P)

% Convierte una representación en punto flotante de 16 bits (cadena)

% Caso especial: Representación de cero
if strcmp(P, '0000000000000000') || all(P == '0')
    N_decimal = 0;
    return;
end

% 1. Extraer bit de signo (Bit 1)
s_bit = str2double(P(1));
if s_bit == 1
    signo = -1;
else
    signo = 1;
end

% 2. Extraer exponente (Bits 2 al 8) y quitar el sesgo (Bias = 63)
exp_bits = P(2:8);
exp_biased = bin2dec(exp_bits); % Convierte binario a entero decimal
bias = 63;
exp_unbiased = exp_biased - bias;

% 3. Extraer la parte fraccionaria de la mantisa (Bits 9 al 16)
mantisa_bits = P(9:16);
fraccion = 0;
for i = 1:length(mantisa_bits)
    bit = str2double(mantisa_bits(i));
    fraccion = fraccion + bit * (2^(-i));
end

% 4. Agregar el 1 implícito a la mantisa
mantisa = 1 + fraccion;

% 5. Reconstruir el número decimal
N_decimal = signo * mantisa * (2^exp_unbiased);
end