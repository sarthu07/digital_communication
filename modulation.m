function modulated = modulation(modulation_name, bit_stream, Rb, k, amp, freq)
% INPUT: 
%     modulation_name = can be 'BASK', 'BPSK',
%     bit_stream = string of bits 
%     Rb = bit rate 
%     k = samples per bit
%     amp = amplitude of the modulated signal
%           scaler for BPSK and QPSK, vector ([max min]) for BASK
%     freq = carrier frequency of the modulated signal 
% OUTPUT: 
%     modulated = modulated signal of the bit stream 

modulated = []; 

% converting string to vector 
N = length(bit_stream); 

% line coding 
line_code = repelem(bit_stream, k); 

Tb = 1/Rb;      % bit duration 
Fs = k * Rb;    % sampling frequency 
Ts = 1 / Fs;
time = 0 : Ts : N*Tb-Ts;

switch modulation_name
    case 'BASK'
        carrier = sin(2*pi*freq*time); 
        a1 = amp(1); 
        a0 = amp(2);
        line_code = a1 * line_code + a0 .* (line_code==0); 
        modulated = line_code .* carrier;
    
    case 'BPSK'
        a = amp(1);
        carrier = sin(2*pi*freq*time); 
        line_code = a .* (line_code == 1) + (-a) .* (line_code == 0); 
        modulated = line_code .* carrier;
    
   
        
    otherwise
        fprintf('\n'); 
        warning(['"', modulation_name, '" Modulation is not supported! ONLY BASK, BPSK, are supported.']);
        return; 
end
end