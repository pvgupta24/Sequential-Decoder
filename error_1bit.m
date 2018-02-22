
function [per_detected, per_corrected] = error_1bit(orig_in_len, g1, g2, threshold, m)
    
    num_in = 2 ^ int16(orig_in_len);   % number of combinations of input code given length of code (2^x)
    
    for i = 0:num_in-1

        orig_in_code = [];
        temp_i = i;
        j = orig_in_len-1;
        
        % construct the input code by converting i to binary number with each
        % bit stored as element in array
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
        
        [per_detected per_corrected] = add_1bit_error(in_code, conv_code, g1, g2, threshold, m); % calculate percentage detected and corrected of 1 bit error convolutional code
    end
    
    
end    

% function to add 1 bit error for given input code padded with zeros
function [per_detected per_corrected] = add_1bit_error(in_code, conv_code, g1, g2, threshold, m)
    len = length(conv_code);
    total_cnt = 0;
    error_detected = 0;
    error_corrected = 0;
    for i = 1:len
        error1bit_conv_code = conv_code;          
        if(error1bit_conv_code(i) == 1)              % if bit is 1  
            error1bit_conv_code(i) = 0;              % change bit from 1 to 0
        else
            error1bit_conv_code(i) = 1;              % else, change bit from 0 to 1
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
    per_detected = error_detected/total_cnt * 100;      % percentage of detected errors
    per_corrected = error_corrected/total_cnt * 100;    % percentage of corrected errors
end

% function to find the convolutional code for given input code (input code must be padded with zeros)
function conv_code = encode(in_code, g1, g2, m)
    cur_state = zeros(1, m-1);            % intial state is [0 0 0 ...]
    conv_code = [];         
    len_in_code = length(in_code);        % length of input code padded with zeros
    for i=1:len_in_code 
        in_bit = in_code(i);              % 1 bit input 
        [cur_state, output] = getNextState(in_bit, cur_state, g1, g2, m);    % transition to next state and corresponding 2 bit convolution output
        conv_code = [conv_code output];   % append the 2 bit output to convolutional code
    end    
end

% function to get the next state and 2 bit convolution output 
function [next_state, output] = getNextState(input, cur_state, g1, g2, m)
    [g1_bit, g2_bit] = conv_2bit(input, cur_state, g1, g2);
    output = [g1_bit g2_bit];
    if(input == 0)
        next_state = [0 cur_state(1:m-2)];
    elseif(input == 1)
        next_state = [1 cur_state(1:m-2)];
        
    end
end

%This function calculates the 2 bit convolutional output during state transition
function [g1_bit, g2_bit] = conv_2bit(input, cur_state, g1, g2)  
    g_len = length(g1);    % length of generator 
    g1_bit = input * g1(1);        
    g2_bit = input * g2(1);        
    for i = 2:g_len       
        if(g1(i) == 1)
            g1_bit = bitxor(g1_bit, cur_state(i-1));
        end    
        if(g2(i) == 1)    
            g2_bit = bitxor(g2_bit, cur_state(i-1));
        end    
    end    
end

% function to decode the convolutional code
function code = decode(conv_code, g1, g2, cur_state, err_count, threshold, m)
    
    if(err_count >= threshold)
        code = [];
        return
    end    
    
    if(length(conv_code) <= 0)
        code = [];
        return
    end
    
    conv_2bit = conv_code(1:2);
    
    [next_state_0, output_0] = getNextState(0, cur_state, g1, g2, m);
    [next_state_1, output_1] = getNextState(1, cur_state, g1, g2, m);
  
    if(isequal(output_0, conv_2bit))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if(isequal(output_1, conv_2bit))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if((output_0(1) == conv_2bit(1)) | (output_0(2) == conv_2bit(2)))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+1, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end  
    
    if((output_1(1) == conv_2bit(1)) | (output_1(2) == conv_2bit(2)))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count+1, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if((output_0(1) ~= conv_2bit(1)) & (output_0(2) ~= conv_2bit(2)))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end 
    
    if((output_1(1) ~= conv_2bit(1)) & (output_1(2) ~= conv_2bit(2)))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    
end
