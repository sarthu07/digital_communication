clc, clear, close all; 
start = tic; 



%                        "System Properties"                 %        

modulation_name = 'BPSK'; 
samples_per_bit = 40; 
Rb = 1000; 
amp = [1 0];
freq = 1000;                         
snr = 10; 
Generator = [1 1 1; 1 0 1]; 
shift = 1; 


%                     "Reading Text Data File"                   %   

tic
fprintf('Reading data: '); 
text = 'heyy i am sarthak babra my enrollment no. is bt19ece028, heyy i am avish my enrollment no. is bt19ece037, heyy i am ganesh my enrollment no. is bt19ece031';
fprintf(text);
fprintf('Reading data over ');  
toc 


%                        "Source Statistics"                   %      
fprintf('Source statistics: '); 
tic
[unique_symbol, probability] = source_statistics(text); 
toc 


%                        "Huffman Encoding"                   %       

fprintf('Huffman encoding: '); 
tic 
code_word = huffman_encoding(probability); 
toc 



%                       "Stream Generator"                  %        

tic
fprintf('Stream generator: '); 
bit_stream = stream_generator(unique_symbol, code_word, text);
input = bit_stream;
toc 



%                          "Channel Coding"                    %      

tic
fprintf('Channel coding: '); 

channel_coded = convolutional_coding(bit_stream, Generator);
toc 



%                            "Modulation"                       %      

tic
fprintf('Modulation: ');
modulated = modulation(modulation_name, channel_coded, Rb, samples_per_bit, amp, freq); 
toc 



%                              "Channel"                          %    

tic
fprintf('Channel: ');
received = awgn_channel(modulated, snr); 
toc 



%                           "Demodulation"                      %      

tic
fprintf('Demodulation: ');
bit_stream = demodulation(modulation_name, received, Rb, samples_per_bit, amp, freq);
toc



%                         "Channel Decoding"                    %      

tic
fprintf('Channel decoding: ');
bit_stream = viterbi_decoder(bit_stream, Generator, shift); 
output = bit_stream; 
toc



%                         "Huffman Decoding"                       %   

tic
fprintf('Huffman decoding: ');
decoded_msg = huffman_decoding(unique_symbol, code_word, bit_stream); 
toc 



%                    "Writting the Received Data"                  %   

tic
fprintf('Writing data: ');
fprintf(decoded_msg);
fprintf('Writing data over');
toc



%                     "Time & Error Calculation"                    %  

fprintf('Total execution time: ');
toc(start); 

Error = sum(abs(input - output)); 
disp(['Total Bit Error: ' num2str(Error)]); 