function [f, y] = fplot(x, Fs)
    % Performing Fourier transform and analyzing frequency components
    n = length(x);
    y = fftshift(fft(x)) / n;
    f = (-n/2:n/2-1) * Fs / n; % Frequency axis in Hertz
    stem(f, abs(y), 'filled', 'LineWidth', 2);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    grid on;
end
