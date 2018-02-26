function conv_code = encode(in_code, g1, g2, m)
% function to encode given input code using generators g1 and g2 and output
% convolutional code

    cur_state = zeros(1, m-1);
    conv_code = [];
    len_in_code = length(in_code);
    for i=1:len_in_code
        in_bit = in_code(i);
        [cur_state, output] = getNextState(in_bit, cur_state, g1, g2, m);
        conv_code = [conv_code output];
    end    
end

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
