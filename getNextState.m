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


