
function code = decode(conv_code, g1, g2, cur_state, err_count, threshhold, m)
 %============ This function decodes the given input ==================%
 
    if(err_count >= threshhold)
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
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if(isequal(output_1, conv_2bit))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if((output_0(1) == conv_2bit(1)) | (output_0(2) == conv_2bit(2)))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+1, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end  
    
    if((output_1(1) == conv_2bit(1)) | (output_1(2) == conv_2bit(2)))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_1, err_count+1, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    if((output_0(1) ~= conv_2bit(1)) & (output_0(2) ~= conv_2bit(2)))
        code = [0 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end 
    
    if((output_1(1) ~= conv_2bit(1)) & (output_1(2) ~= conv_2bit(2)))
        code = [1 decode(conv_code(3:end), g1, g2, next_state_0, err_count+2, threshhold, m)];
        if(length(code) == (length(conv_code)/2))
            return
        end
        code = code(2:end);
    end
    
    
end

%This function finds the next state and 2-bit convolutional output during
%state transition
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
