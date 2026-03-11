% =========================================================================
% TÍNH TOÁN VỊ TRÍ TRỌNG TÂM TỔNG (wPc) - PHIÊN BẢN CHẠY NGAY
% =========================================================================
clc; clear; close all;

%% 1. ĐỊNH NGHĨA HÀM DH
DH = @(th, al, a, d) [cos(th), -sin(th), 0, a; ...
                      sin(th)*cos(al), cos(th)*cos(al), -sin(al), -d*sin(al); ...
                      sin(th)*sin(al), cos(th)*sin(al), cos(al), d*cos(al); ...
                      0, 0, 0, 1];

%% 2. KHAI BÁO THAM SỐ (PARAMETERS)
% --- Khối lượng các khâu (kg) ---
m = [0.20503;   % m1: Cẳng chân
     0.02573;   % m2: Đùi dưới
     0.02923;   % m3: Đùi trên
     1.07152];  % m4: Thân xe

% --- Chiều dài các khâu (m) ---
l1 = 0.1155;
l2 = 0.08;
l3 = 0.0954;
l4 = 0.07422;
a = 0.04377;
% --- Vị trí trọng tâm cục bộ (m) ---
lc = [0.05928; % lc1
      0.0459;  % lc2
      0.0477;  % lc3
      0.00438]; % lc4

% --- Góc khớp (Chỉ bắt đầu từ theta 2) ---
% Đã loại bỏ theta1. Mảng này giờ là [theta2; theta3; theta4] cũ

goc_dk= 115;
goc_do=goc_dk-37.65;
goc_rad = deg2rad(goc_do);

l25 = sqrt(l2^2 + l4^2 - 2*l2*l4*cos(goc_rad));
goc21 = acos((l25^2 + a^2 - l3^2)/(2*l25*a));
goc22 = acos((l25^2 + l2^2 - l4^2)/(2*l25*l2));
goc23 = pi - goc21 - goc22;

h = sqrt(l2^2 + (l1 - a)^2 - 2*l2*(l1 - a)*cos(goc23))
%---------------------goc_dk ===> Lc ---------------------------------
theta_1 = acos( (h^2 + (l1 - a)^2 - l2^2) / (2*h*(l1 - a)) );
theta_2 = goc21 + goc22;
theta_3 = pi - acos((l3^2 + a^2 - l25^2)/(2*l3*a));
theta_4 = pi - goc_rad;
%% 3. TÍNH TOÁN MA TRẬN BIẾN ĐỔI
% Logic: Vì bỏ T1, ta coi Link 1 là hệ quy chiếu gốc.
% Các ma trận biến đổi sẽ tính mối quan hệ: 1->2, 2->3, 3->4

T_rel = cell(4, 1); % Chỉ cần 3 ma trận quan hệ (2vs1, 3vs2, 4vs3)

% Ma trận chuyển từ Link 1 sang Link 2 (Dùng theta đầu tiên của mảng mới)
% Lưu ý: l1 là khoảng cách từ khớp 0 đến khớp 1
T_rel{1} = DH(theta_1, 0, l1, 0); 

% Ma trận chuyển từ Link 2 sang Link 3
T_rel{2} = DH(theta(2), 0, l2, 0);

% Ma trận chuyển từ Link 3 sang Link 4
T_rel{3} = DH(theta(3), 0, l3, 0);

% --- Tính ma trận biến đổi toàn cục (So với hệ tọa độ Link 1) ---
% T_global{i} là ma trận chuyển từ Link i về Link 1
T_global = cell(4, 1);

% Link 1: Chính là gốc tọa độ (Ma trận đơn vị)
T_global{1} = eye(4); 

% Link 2: = T_rel{1}
T_global{2} = T_rel{1};

% Link 3: = T_global{2} * T_rel{2}
T_global{3} = T_global{2} * T_rel{2};

% Link 4: = T_global{3} * T_rel{3}
T_global{4} = T_global{3} * T_rel{3};

%% 4. TÍNH TRỌNG TÂM TỔNG HỢP
numerator_sum_vec = [0; 0; 0; 0]; 
denominator_sum_m = 0;            

fprintf('--- Chi tiết vị trí CoM (So với hệ tọa độ Khâu 1) ---\n');

for i = 1:4
    % 4a. CoM cục bộ
    P_local = [lc(i); 0; 0; 1]; 
    
    % 4b. Chuyển sang hệ toạ độ Khâu 1 (Gốc)
    P_global = T_global{i} * P_local;
    
    % In ra kiểm tra
    fprintf('Link %d: Mass=%.2f, Pos=[%.4f, %.4f]\n', ...
            i, m(i), P_global(1), P_global(2));
    
    % 4c. Cộng dồn
    numerator_sum_vec = numerator_sum_vec + (m(i) * P_global);
    denominator_sum_m = denominator_sum_m + m(i);
end

% 4d. Tính kết quả cuối cùng
wPc = numerator_sum_vec / denominator_sum_m;

%% 5. XUẤT KẾT QUẢ
xc = wPc(1);
zc = wPc(2);
lc_equivalent = sqrt(xc^2 + zc^2);

fprintf('\n========================================\n');
fprintf('KẾT QUẢ (HỆ QUY CHIẾU: LINK 1)\n');
fprintf('========================================\n');
fprintf('Tọa độ X (xc): %.4f m\n', xc);
fprintf('Tọa độ Z (zc): %.4f m\n', zc);
fprintf('----------------------------------------\n');
fprintf('Khoảng cách từ gốc Link 1 đến CoM tổng: %.4f m\n', lc_equivalent);
fprintf('========================================\n');
     