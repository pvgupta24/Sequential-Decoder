function [error_detected, error_corrected, total_cnt] = analyze_kerror(in_code, conv_code, g1, g2, threshold, m, k)
    % Analyze errors by introducing errors and decoding for k-bits

    len = length(conv_code);
    total_cnt = 0;
    error_detected = 0;
    error_corrected = 0;          
    
    pos = 1:len; 
    % Generate all possible indices combination for introducing k errors in the codeword
    k_indices_list = combnk(pos,k);
    [rows,~] = size(k_indices_list);
    for item = 1:rows  
        error1bit_conv_code = conv_code;
        
        % Change bits to add error
        for index = 1:k
            error1bit_conv_code(k_indices_list(item, index)) = ~error1bit_conv_code(k_indices_list(item, index));            
        end
        
        decoded = decode(error1bit_conv_code, g1, g2, zeros(1, m-1), 0, threshold, m);   % decode the 1 bit error convolutional code
        total_cnt = total_cnt + 1;                    % increment count of total combination

        if(length(decoded) < length(in_code))         % if decoded code's length is less than input code's length
            error_detected = error_detected + 1;      % increment number of detected error
            
        elseif(decoded == in_code)                    % else if decoded code is equal to input code
            error_corrected = error_corrected + 1;    % increment number of detected error
            error_detected = error_detected + 1;      % and, increment number of corrected error
        end
    end

end