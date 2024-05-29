% Static memory parameters %
noElements  = 64;                   % Number of transducer elements
p           = 250 * 10^-6;          % Pitch length
t_s         = 40*10^-9;             % Sample period
f_s         = 1/t_s;                % Sample frequency
f_clk       = 100 * 10^6;           % Clock frequency
v           = 1540;                 % Speed of sound
n           = -31:1:32;             % Element indexes
x           = n*p;                  % x-pos of each element
cordic_iter = 12;                    % Iterations used in CORDIC algorithm
delta_length= v/f_s;                % Increment length for scanline
n0_index    = 32;                   % Array index of element in origo
inc_step    = 1/4;                  % Increment step for a, inc_step*2 mirrors approximal maximal error

% Variable input values, used as reference point in scanline
R_0         = 100*10^-3;      % Has to be a value between 1mm and 254mm
scan_length = 255*10^-3 - R_0;
num_points  = round(scan_length / delta_length);
angle_deg   = 120;

% Calculating reference delays
angle = angle_deg*pi/180;
a = R_0*sin(angle);
b = x - R_0*cos(angle);
R_n = sqrt(a.^2+b.^2);
delay_reference = (f_s*R_n/v);

a1 = zeros(noElements);
b1 = zeros(noElements);
R_n1 = zeros(noElements);
delay_reference_scanline = zeros(num_points, noElements);

for k = 1:num_points
    a1 = (R_0+(k-1)*delta_length)*sin(angle);
    b1 = x - (R_0+(k-1)*delta_length)*cos(angle);
    R_n1 = sqrt(a1.^2+b1.^2);
    delay_reference_scanline(k,:) = (f_s*R_n1/v);
end


% SYSTEM FUNCTIONALITY %
% Step 1: Using iterative approach to calculate delays for each element for first point in scanline
[delay,error_list_ref] = delay_ref_point(f_s, p, v, R_0, n0_index, angle_deg, cordic_iter, inc_step);

% Step 2: Calculating delays in next point on scanline for all elements
[scanline_delays, max_iter_out_scanline] = delay_scanline(R_0, f_s, v, n, p, num_points, delay, cordic_iter, angle_deg, inc_step, error_list_ref);

% Plotting result with respect to reference %
%plot_results(n, delay, angle, R_0, scanline_delays, delta_length, num_points, n0_index, delay_reference, x, delay_reference_scanline, max_iter_out_scanline, n0_index-0);



% Functions

% First scanpoint delays calculation
function [delay_list,error_list_ref] = delay_ref_point(f_s, p, v, R_0, n0_index, angle_deg, cordic_iter, inc_step)
    % Pre-calculating constants for each scanline, to increase throughput in hardware
    A_0 = (f_s*p/v)^2; 
    C_0 = cordic(cordic_iter, angle_deg, (f_s/v)^2 * 2 * p * R_0);
    
    % Calculating delay for reference transducer element in origo
    delay(n0_index) = (f_s/v)*R_0;
    
    % Iteratively calculating delay for all elements for first scan point
    error_prev_list = zeros(64);
    inc_term_prev = 0;
    if angle_deg >= 120
        a_prev = 2;
    elseif angle_deg >= 105
        a_prev = 1;
    elseif angle_deg <= 55
        a_prev = -2;
    elseif angle_deg <= 75
        a_prev = -1;
    else
        a_prev = 0;
    end
    total_iter_count = 0;
    a_cur = 0;
    for i = 1:32
        cur_index = n0_index + i;
        inc_term = A_0*(2*(i-1)+1) - C_0;
        [delay(cur_index),error_prev_list(cur_index), a_prev, inc_term_prev, iter_count_out] = increment_and_compare(delay(cur_index-1), error_prev_list(cur_index-1), inc_term, a_prev, inc_term_prev, inc_step);
        total_iter_count = total_iter_count + iter_count_out;
        disp("Cur delay: " + delay(cur_index-1) + ", inc_term_prev: " + inc_term_prev + ", error_prev: "+ error_prev_list(cur_index));
        if a_prev > abs(a_cur)
                a_cur = abs(a_prev);
        end
    end
    disp("Total iter count for pos n: " + total_iter_count);
    disp("Max a:" + a_cur)


    inc_term_prev = 0;
    if angle_deg >= 130
        a_prev = -2;
    elseif angle_deg >= 115
        a_prev = -1;
    elseif angle_deg <= 60
        a_prev = 2;
    elseif angle_deg <= 75
        a_prev = 1;
    else
        a_prev = 0;
    end
    %a_prev =0;
    total_iter_count = 0;
    for i = 1:31
        cur_index = n0_index - i;
        inc_term = A_0*(2*(i-1)+1) + C_0;
        [delay(cur_index),error_prev_list(cur_index), a_prev, inc_term_prev, iter_count_out] = increment_and_compare(delay(cur_index+1), error_prev_list(cur_index+1), inc_term, a_prev, inc_term_prev, inc_step);
        total_iter_count = total_iter_count + iter_count_out;
    end
    disp("Total iter count for neg n: " + total_iter_count);

    delay_list = delay;
    error_list_ref = error_prev_list;
end

% Increment and compare block for initial point on scanline (replaces square root)
function [N_next,error_next, a_next, inc_term_next, iter_count_out] = increment_and_compare(N_prev, error_prev, inc_term, a_prev, inc_term_prev, inc_step)
    % Propagate previous a to get an initial guess for a
    a = a_prev;
    
    % Decide whether a has to increase or decrease
    inc_term_w_error = inc_term + error_prev;
    if inc_term_w_error >= inc_term_prev
        sign_bit = 1;
    else
        sign_bit = -1;
    end
    
    % Finding a_n through increment and comparator
    cur_error = 0;
    iter_count = 0;
    for i = 1:100
        iter_count = iter_count+1;    % Reduced accuracy, less iterations
        a = a + sign_bit*inc_step;
        if sign_bit == -1
            if 2*a*N_prev+a^2 < inc_term_w_error
                a = a - sign_bit*inc_step;
                cur_error = inc_term_w_error - (2*a*N_prev + a^2);
                break;
            end
        elseif sign_bit == 1
            if 2*a*N_prev+a^2 > inc_term_w_error
                a = a - sign_bit*inc_step;
                cur_error = inc_term_w_error - (2*a*N_prev + a^2);
                break;
            end
        end
        %a = a + sign_bit*inc_step;     % Increased accuracy, more iterations
    end

    % Values to propagate to next calculation
    N_next = N_prev + a;
    error_next = cur_error;
    a_next = a;
    inc_term_next = 2*a*N_prev+a^2;
    iter_count_out = iter_count;
end

% Next scanpoints delay calculation
function [delay_array,max_iter_out_scanline] = delay_scanline(R_0, f_s, v, n, p, num_points,delay, cordic_iter, angle_deg, inc_step, error_list_ref)
    % Precalculated CORDIC constants, input except angle stored in memory
    B_cordic = cordic(cordic_iter, angle_deg, 2 * n * p * (f_s/v));
    
    % Precalculated constants
    B_n = 2 * R_0 * (f_s/v) - B_cordic;
    
    scanline_delays = zeros(num_points, length(delay));
    error_prev = error_list_ref(1:length(delay));
    a_prev = zeros(length(delay));
    inc_term_prev = zeros(length(delay));
    max_iter_out_array = zeros(num_points);
    
    scanline_delays(1,:) = delay;
    for k = 1:num_points-1
        inc_terms = 2*(k-1) + 1 + B_n;
        [scanline_delays(k+1,:),error_prev, a_prev, inc_term_prev, max_iter_out_array(k)] = increment_and_compare_array(scanline_delays(k,:), error_prev, inc_terms, a_prev, inc_term_prev, inc_step);
    end

    delay_array = scanline_delays;
    max_iter_out_scanline = max_iter_out_array;
end

% Increment and compare array block, for next point in scanline (replaces square root)
function [N_next_array,error_next_array, a_next_array, inc_term_next_array, max_iter_out_array] = increment_and_compare_array(N_prev_array, error_prev_array, inc_terms_array, a_prev_array, inc_term_prev, inc_step)
    max_iter_out = 0;

    for i = 1:length(N_prev_array)
        [N_prev_array(i),error_prev_array(i),a_prev_array(i), inc_term_prev(i), cur_iter_out] = increment_and_compare(N_prev_array(i), error_prev_array(i), inc_terms_array(i), a_prev_array(i), inc_term_prev(i), inc_step);
        if cur_iter_out > max_iter_out
            max_iter_out = cur_iter_out;
        end
    end

    N_next_array = N_prev_array(1:length(N_prev_array));
    error_next_array = error_prev_array(1:length(N_prev_array));
    a_next_array = a_prev_array(1:length(N_prev_array));
    inc_term_next_array = inc_term_prev(1:length(N_prev_array));
    max_iter_out_array = max_iter_out;
end

% Plotting and result functionality
function plot_results(n, delay, angle, R_0, scanline_delays, delta_length, num_points, n0_index, delay_reference, x, delay_reference_scanline, max_iter_out_scanline, scanline_element_index)
    % Calculating difference between delay in origo and other elements
    for i = 1:length(n)
        delta_delay(i) = delay(i)-delay(n0_index);
    end
    
    % Calculating errors from reference values
    for i = 1:length(n)
        error_delay(i) = delay(i) - delay_reference(i);
    end
    
    % Plotting scanpoint
    figure(1);
    polarscatter(angle, R_0,'filled','blue'); hold on;
    for i = 1:32
        polarscatter(0, (i-1)*250 * 10^-6,8,'filled','black'); hold on;
        polarscatter(pi, (i-1)*250 * 10^-6,8,'filled','black'); hold on;
    end
    linehandle = polarplot([angle,angle], [0,R_0],'red'); hold on;
    ax = linehandle.Parent;
    %ax.RGrid = "off";
    %ax.RTickLabel = [];
    title("Delay for each element to reference scanpoint");
    subtitle("Black indicates error when compared to theoretical reference");
    
    % Plotting illustration of delay for each element at first point of
    % scanline, error plotted in black
    delay_gain = R_0*0.01;
    for i = 1:length(n)-1
        [theta,rho] = cart2pol([x(i),x(i)],[0,delay_gain*delta_delay(i)]); 
        if delta_delay(i) >= 0
            polarplot(theta,rho,'green');
            [theta1,rho1] = cart2pol([x(i),x(i)],[0,delay_gain*error_delay(i)]);
        else
            polarplot(theta,rho,'red');
            [theta1,rho1] = cart2pol([x(i),x(i)],[0,delay_gain*error_delay(i)]);
        end
        polarplot(theta1,rho1,'black');
    end
    hold off;
    
    % Plotting scanline delay for a given element
    figure(2);
    x_ax = R_0:delta_length:R_0+delta_length*(num_points-1);
    plot(x_ax,scanline_delays(:,scanline_element_index,:)); hold on
    plot(x_ax,delay_reference_scanline(:,scanline_element_index,:)); hold on
    xlabel("Distance travelled on scanline");
    ylabel("Delay in sample frequency cycles");
    legend("Iterative approach", "Theoretical reference");
    title(sprintf("Delay for element n=%d as focal points moves through scanline", scanline_element_index-32));
    hold off;

    % Plotting delta delay between each element as a function of
    figure(3);
    for k = 1:1:num_points
        delta_scanline_delays = scanline_delays(k,:,1) - scanline_delays(k,32,1);
        plot(-32:1:31,delta_scanline_delays(:,:)); hold on;
    end
    title("Delta delay profile for elements");
    xlabel("Element index");
    ylabel("Delta delay in sample frequency cycles");
    subtitle(sprintf(" R_0 = %d mm and angle = %.0d", R_0*10^3, angle*180/pi));
    hold off;

    % Plotting max iterations needed for each point in scanline
    figure(4);
    plot(1:num_points,max_iter_out_scanline(1:num_points)); hold on;
    title("Iterations for each point in scanline");
    xlabel("Point index");
    ylabel("Iterations needed");
    subtitle(sprintf(" R_0 = %d mm and angle = %.0d", R_0*10^3, angle*180/pi));
    hold off;

    % Finding maximal error
    max_error_pos = 0;
    max_error_neg = 0;
    max_error_element_pos = 0;
    max_error_element_neg = 0;
    max_error_point_pos = 0;
    max_error_point_neg = 0;
    for k = 1:num_points
        for n = 1:64
            if scanline_delays(k,n) - delay_reference_scanline(k,n,:) > max_error_pos
                max_error_pos = scanline_delays(k,n) - delay_reference_scanline(k,n);
                max_error_element_pos = n - 32;
                max_error_point_pos = k;
            end
            if scanline_delays(k,n) - delay_reference_scanline(k,n,:) < max_error_neg
                max_error_neg = scanline_delays(k,n) - delay_reference_scanline(k,n);
                max_error_element_neg = n - 32;
                max_error_point_neg = k;
            end
        end
    end
    disp("Maximal pos error in whole scan area: " + max_error_pos + " (element " + max_error_element_pos + " point " + max_error_point_pos + ")");
    disp("Maximal neg error in whole scan area: " + max_error_neg + " (element " + max_error_element_neg + " point " + max_error_point_neg + ")");
end