function [error_detected, error_corrected, total_cnt] = add_1bit_error(in_code, conv_code, g1, g2, threshold, m)
% function to add 1 bit error for given input code padded with zeros

    len = length(conv_code);
    total_cnt = 0;
    error_detected = 0;
    error_corrected = 0;
    for i = 1:len
        error1bit_conv_code = conv_code;          
        
        error1bit_conv_code(i) = ~error1bit_conv_code(i);    %Introduce error in the bit
        
        decoded = decode(error1bit_conv_code, g1, g2, zeros(1, m-1), 0, threshold, m);   % decode the 1 bit error convolutional code
        
        total_cnt = total_cnt + 1;                    % increment count of total combination
        
        if(length(decoded) < length(in_code))         % if decoded code's length is less than input code's length
            error_detected = error_detected + 1;      % increment number of detected error
        elseif(decoded == in_code)                    % else if decoded code is equal to input code
            error_corrected = error_corrected + 1;    % increment number of detected error
            error_detected = error_detected + 1;      % and, increment number of corrected error
        end
    end
    %per_detected = error_detected/total_cnt * 100;      % percentage of detected errors
    %per_corrected = error_corrected/total_cnt * 100;    % percentage of corrected errors
end
