% Define the sampling frequency and time vector
fs = 5e6; % Sampling frequency (Hz)
t = 0:1/fs:1e-4; % Time vector (1 second duration)

% Generate the input wave
wave = 2+cos(2*pi*500000*t) + cos(2*pi*1000000*t)+cos(2*pi*3000000*t);
% Design an elliptic low-pass filter
fc = 100000; % Cutoff frequency (Hz)
rp = 1; % Passband ripple (dB)
rs = 60; % Stopband attenuation (dB)
[N, Wn] = ellipord(fc/(fs/2), fc*1.2/(fs/2), rp, rs); % Order and cutoff frequencies
[b, a] = ellip(N, rp, rs, Wn); % Elliptic filter coefficients

% Convert to cascade IIR filter form
sos = tf2sos(b, a); % Second-order sections (SOS) representation

% Create a cell array to store the binary representations
binary_coeff = cell(size(sos));

% Convert each coefficient to its binary representation
for i = 1:size(sos, 1)
    for j = 1:size(sos, 2)
        binary_coeff{i, j} = fi_to_bin(sos(i, j));
    end
end

% Open a file for writing
file_id = fopen('bin_coeff.txt', 'w');

% Write the binary coefficients to the file
for i = 1:size(binary_coeff, 1)
    for j = 1:size(binary_coeff, 2)
        fprintf(file_id, '%s ', binary_coeff{i, j});
        fprintf(file_id, '\n');
    end
    fprintf(file_id,'---------------------\n');
end

% Close the file
fclose(file_id);

% Apply the cascade IIR filter to the input wave
filtered_wave = sosfilt(sos,wave);
[c,d]=fplot(filtered_wave,fs);
figure;
[e,f]=fplot(wave,fs);
plot(t,filtered_wave)
fopen("input.txt", 'w');  % Open the file for writing
for i = 1:length(wave)-1
    number = fi_to_bin(wave(i))
    fprintf(fopen("input.txt", 'a'), '%s\n', number);  % Write binary string to file
end
fclose('all');  % Close all open files
