% 3D Foton Hidrodinamik Sınır Şartı ve Limit Döngüsü Modeli (Revize: Altıgen ve Lejantlı)
% "Transient Dynamics of Photon Interactions" Makalesi İçin
close all;
% Çözünürlük ağı
u = linspace(0, 2*pi, 80);
v = linspace(0, pi, 80);
[U, V] = meshgrid(u, v);

figure('Position', [100, 100, 800, 800], 'Color', 'w');
hold on; grid on; axis equal;

%% 1. Merkez Çekirdek (Core)
r_core = 0.2;
X_core = r_core * cos(U) .* sin(V);
Y_core = r_core * sin(U) .* sin(V);
Z_core = r_core * cos(V);
% h_core değişkenine atıyoruz ki lejantta kullanabilelim
h_core = surf(X_core, Y_core, Z_core, 'FaceColor', 'k', 'EdgeColor', 'none', 'FaceLighting', 'gouraud');

%% 2. İç Pilot-Dalga Alanı (Altıgen / Hexagonal Harmonik)
% Doğanın en kararlı konfigürasyonu (6 loblu)
R1 = 1.0 + 0.15 * sin(6*U) .* cos(3*V); 
X1 = R1 .* cos(U) .* sin(V);
Y1 = R1 .* sin(U) .* sin(V);
Z1 = R1 .* cos(V);

h_inner = surf(X1, Y1, Z1, 'FaceColor', 'b', 'FaceAlpha', 0.15, 'EdgeColor', 'b', 'LineStyle', ':', 'LineWidth', 0.5);

theta = linspace(0, 2*pi, 200);
r1_eq = 1.0 + 0.15 * sin(6*theta);
plot3(r1_eq.*cos(theta), r1_eq.*sin(theta), zeros(size(theta)), 'b-', 'LineWidth', 2);

%% 3. Dış Dalga Alanı (Dış Harmonik)
R2 = 1.4 + 0.2 * cos(3*U) .* sin(6*V); 
X2 = R2 .* cos(U) .* sin(V);
Y2 = R2 .* sin(U) .* sin(V);
Z2 = R2 .* cos(V);

h_outer = surf(X2, Y2, Z2, 'FaceColor', 'c', 'FaceAlpha', 0.1, 'EdgeColor', 'c', 'LineStyle', ':', 'LineWidth', 0.5);

r2_pol = 1.4 + 0.2 * cos(4*theta);
plot3(r2_pol.*cos(theta), zeros(size(theta)), r2_pol.*sin(theta), 'c-', 'LineWidth', 2);

%% 4. Maksimum Esneme Sınırı (gh kısıtı)
R_max = 1.8;
[X_max, Y_max, Z_max] = sphere(50);
surf(X_max*R_max, Y_max*R_max, Z_max*R_max, 'FaceColor', 'r', 'FaceAlpha', 0.03, 'EdgeColor', 'none');

% Kırmızı kesik çizgiyi h_limit değişkenine atıyoruz
h_limit = plot3(R_max*cos(theta), R_max*sin(theta), zeros(size(theta)), 'r--', 'LineWidth', 2.5);

%% Işıklandırma, Etiketler ve Akademik Lejant (Legend)
camlight; lighting gouraud;
view(45, 30);
title('\textbf{3D Topology of the Photon: Central Core and Fluctuating Pilot-Wave Boundaries}', 'Interpreter', 'latex', 'FontSize', 14);

% Profesyonel Lejant Kutusu
lgd = legend([h_core, h_inner, h_outer, h_limit], ...
    {'Energy Core', 'Inner Harmonic', 'Outer Harmonic', 'Structural Limit ($gh = \frac{1}{2\mu_0\epsilon_0}$)'}, ...
    'Interpreter', 'latex', 'FontSize', 12, 'Location', 'northwest');
lgd.Color = [1 1 1]; % Arka plan beyaz
lgd.EdgeColor = 'k'; % Siyah çerçeve

axis off; % Grafiği temiz tutmak için eksenleri gizliyoruz