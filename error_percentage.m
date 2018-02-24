
function [per_detected, per_corrected] = error_percentage(orig_in_len, g1, g2, threshold, m, max_errors)
    
    num_in = 2 ^ int16(orig_in_len);   % number of combinations of input code given length of code (2^x)
    
    error_detected_aggregate = zeros(1,max_errors);
    error_corrected_aggregate = zeros(1,max_errors);
    total_cnt_aggregate = zeros(1,max_errors);
    
    for i = 0:num_in-1

        orig_in_code = [];
        temp_i = i;
        j = orig_in_len-1;
            
        % construct the input code by converting i to binary number with eachbit stored as element in array
        while(j >= 0)
            if(temp_i >= 2^j)
                orig_in_code = [orig_in_code 1];
                temp_i = temp_i - 2^j;
            else
                orig_in_code = [orig_in_code 0];
            end
            j = j-1;
        end

        in_code = [orig_in_code zeros(1, m-1)];   % append zeros to original input code        
        conv_code = encode(in_code, g1, g2, m);   % convolutional encoding of input code
        
        %[error_detected, error_corrected, total_cnt] = add_1bit_error(in_code, conv_code, g1, g2, threshold, m); % calculate percentage detected and corrected of 1 bit error convolutional code
        %[error_detected, error_corrected, total_cnt] = analyze_kerror(in_code, conv_code, g1, g2, threshold, m, 1); % calculate percentage detected and corrected of 1 bit error convolutional code
        
        for k_errors = 1:max_errors
            [error_detected, error_corrected, total_cnt] = analyze_kerror(in_code, conv_code, g1, g2, threshold, m, k_errors); % calculate percentage detected and corrected of 1 bit error convolutional code       
            error_detected_aggregate(k_errors) = error_detected_aggregate(k_errors) + error_detected;
            error_corrected_aggregate(k_errors) = error_corrected_aggregate(k_errors) + error_corrected;
            total_cnt_aggregate(k_errors) = total_cnt_aggregate(k_errors) + total_cnt;
        end       
    end        
    per_detected = error_detected_aggregate * 100 ./ total_cnt_aggregate;
    per_corrected = error_corrected_aggregate * 100 ./ total_cnt_aggregate;
    
end    

% function to find the convolutional code for given input code (input code must be padded with zeros)
function conv_code = encode(in_code, g1, g2, m)
    cur_state = zeros(1, m-1);            % intial state is [0 0 0 ...]
    conv_code = []; 
    %Pre allocate memory
    %conv_code = zeroes(1,len_in_code);
    len_in_code = length(in_code);        % length of input code padded with zeros
    for i=1:len_in_code 
        in_bit = in_code(i);              % 1 bit input 
        [cur_state, output] = getNextState(in_bit, cur_state, g1, g2, m);    % transition to next state and corresponding 2 bit convolution output
        conv_code = [conv_code output];   % append the 2 bit output to convolutional code
    end    
end