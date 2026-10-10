% Kuantum Ölçüm ve Silgi Deneylerinin Sistem Dinamiği Simülasyonu (Revize)
t = linspace(0, 10, 2000);
w0 = 2 * pi * 2; % Temel rezonans (ölçülebilir foton dalgası)
base_wave = sin(w0 * t);

% Ortak sönümleme ve yüksek frekans parametreleri
w_unmeasurable = w0 * 8; % 8 kat daha yüksek frekans (Gürültü tabanı)
amp_unmeasurable = 0.15; % Çok düşük genlik
wd = 2 * pi * 5; % Bozucu etki frekansı
t_meas = 3; % Ölçüm anı

%% Senaryo 1: Klasik Çift Yarık Ölçümü (Yüksek Frekansa Çöküş)
y1 = zeros(size(t));
for i = 1:length(t)
    if t(i) < t_meas
        y1(i) = base_wave(i);
    else
        decay = exp(-1.2 * (t(i) - t_meas));
        transient = 2 * exp(-0.15 * wd * (t(i) - t_meas)) * sin(wd * (t(i) - t_meas) + pi/4);
        unmeasurable = amp_unmeasurable * sin(w_unmeasurable * t(i));
        y1(i) = (base_wave(i) * decay) + transient + (unmeasurable * (1 - decay));
    end
end

%% Senaryo 2: Kuantum Silgisi (DCQE - Bozucu Etkinin Telafisi)
y2 = zeros(size(t));
t_erase = 6; % Bilginin silinmesi (Telafi - Erasure) anı

for i = 1:length(t)
    if t(i) < t_meas
        % 1. Bölge: Ölçüm öncesi normal dalga
        y2(i) = base_wave(i);
        
    elseif t(i) >= t_meas && t(i) < t_erase
        % 2. Bölge: Ölçüm yapıldı, dalga çöktü (Ölçülemeyen durum)
        decay = exp(-1.5 * (t(i) - t_meas));
        transient = 2 * exp(-0.2 * wd * (t(i) - t_meas)) * sin(wd * (t(i) - t_meas));
        unmeasurable = amp_unmeasurable * sin(w_unmeasurable * t(i));
        y2(i) = (base_wave(i) * decay) + transient + (unmeasurable * (1 - decay));
        
    else
        % 3. Bölge: Telafi (Silgi) işlemi uygulandı, dalga yeniden inşa ediliyor
        unmeasurable_residual = amp_unmeasurable * sin(w_unmeasurable * t(i)) * exp(-2 * (t(i) - t_erase));
        recovery_transient = -1.5 * exp(-0.3 * wd * (t(i) - t_erase)) * sin(wd * (t(i) - t_erase));
        growth = 1 - exp(-1.5 * (t(i) - t_erase)); % Dalganın yeniden büyümesi
        
        y2(i) = unmeasurable_residual + recovery_transient + (base_wave(i) * growth);
    end
end

%% Grafik Çizimi
figure('Position', [100, 100, 900, 600], 'Color', 'w');

% Alt Grafik 1: Case A
subplot(2,1,1);
plot(t, y1, 'b', 'LineWidth', 1.5); hold on;
xline(t_meas, 'r--', 'LineWidth', 1.5);
text(t_meas+0.2, 2.2, 'Measurement (Disturbance)', 'Color', 'r', 'FontSize', 11, 'Interpreter', 'latex');
text(1, 1.8, 'Measurable Wave', 'FontSize', 11, 'Interpreter', 'latex');
text(5.5, 1.2, 'Unmeasurable State (Decoherence)', 'FontSize', 11, 'Interpreter', 'latex');
text(6, 0.8, '(High Freq/Low Amp)', 'FontSize', 11, 'Interpreter', 'latex');
title('\textbf{Case A: Standard Measurement (Transition to Unmeasurable State)}', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Field Perturbation $\psi(t)$', 'Interpreter', 'latex', 'FontSize', 12);
grid on; set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 11); ylim([-2.5 2.8]);

% Alt Grafik 2: Case B
subplot(2,1,2);
plot(t, y2, 'Color', [0 0.5 0], 'LineWidth', 1.5); hold on;
xline(t_meas, 'r--', 'LineWidth', 1.5);
xline(t_erase, 'k--', 'LineWidth', 1.5);
text(t_meas+0.1, 2.4, 'Measurement', 'Color', 'r', 'FontSize', 11, 'Interpreter', 'latex');
text(t_erase+0.1, 2.4, 'Erasure (Compensation)', 'Color', 'k', 'FontSize', 11, 'Interpreter', 'latex');
text(0.5, -2, 'Wave Behavior', 'FontSize', 11, 'Interpreter', 'latex');
text(4, -2, 'Interference Lost', 'FontSize', 11, 'Interpreter', 'latex');
text(7.5, -2, 'Wave Restored', 'FontSize', 11, 'Interpreter', 'latex');
title('\textbf{Case B: Delayed-Choice Quantum Eraser (Disturbance Cancellation)}', 'Interpreter', 'latex', 'FontSize', 14);
xlabel('Time / Propagation Distance', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Field Perturbation $\psi(t)$', 'Interpreter', 'latex', 'FontSize', 12);
grid on; set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 11); ylim([-2.5 2.8]);