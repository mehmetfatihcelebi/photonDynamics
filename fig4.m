close all;
% Kuantum Silgisi (DCQE) Bode Yanıtı ve Dekoherans Analizi
s = tf('s');
G = 1 / (s + 1); % Sistemin Alçak Geçiren (Low-Pass) Karakteristiği

% Frekans vektörü (0.1 rad/s ile 100 rad/s arası)
w = logspace(-1, 2, 500);
[mag, phase] = bode(G, w);
mag_db = 20*log10(squeeze(mag));
phase_deg = squeeze(phase);

% Akademik figürü oluştur (Arka plan beyaz)
figure('Color', 'w', 'Position', [100, 100, 750, 600]);

% --- ÜST GRAFİK: Genlik (Magnitude) ---
subplot(2,1,1);
semilogx(w, mag_db, 'k', 'LineWidth', 2.5); hold on; grid on;

% Noktaları işaretle
w_wave = 1;   % Gözlemcisiz Dalga (Pilot-Wave)
w_part = 20;  % Gözlemcili Çöküş (Particle/Decoherence)

mag_wave = 20*log10(abs(freqresp(G, w_wave)));
mag_part = 20*log10(abs(freqresp(G, w_part)));

plot(w_wave, mag_wave, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
plot(w_part, mag_part, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);

% Etiketler
text(1.1, mag_wave + 1, 'Pilot-Wave', 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');
text(20, mag_part + 3, 'Decoherence', 'Color', 'b', 'FontSize', 12, 'FontWeight', 'bold');

ylabel('Magnitude (dB)', 'FontSize', 13, 'FontWeight', 'bold');
title('Bode Response of the Photonic (Linearized) Limit Cycle', 'FontSize', 15, 'FontWeight', 'bold');
set(gca, 'FontSize', 12, 'LineWidth', 1.2);

% --- ALT GRAFİK: Faz (Phase) ---
subplot(2,1,2);
semilogx(w, phase_deg, 'k', 'LineWidth', 2.5); hold on; grid on;

phase_wave = angle(freqresp(G, w_wave)) * 180/pi;
phase_part = angle(freqresp(G, w_part)) * 180/pi;

plot(w_wave, phase_wave, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
plot(w_part, phase_part, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);

ylabel('Phase (deg)', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('Frequency (rad/s)', 'FontSize', 13, 'FontWeight', 'bold');
set(gca, 'FontSize', 12, 'LineWidth', 1.2);