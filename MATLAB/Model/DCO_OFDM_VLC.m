% DC-OFDM MATLAB Model
% Coder: Angga Pratama Putra, 
%        Master Program of EE,
%        STEI ITB
% No.of FFT Carriers: 64
% coding used: Convolutional coding
% Single frame size: 96 bits
% Total no. of Frames: 100
% Modulation: 16-QAM
% No. of Pilots: 4
% Cylic Extension: 25%(16)

%% clear workspace
close all
clear all
clc

%%
%   LOS gain SNR calculation
Rdet=0.5;
%Hamamatsu S5980/S5981/S5870 Si PIN Photodiode Photosensitivity (A/W)
Rb=1e6;
%Bit rate
No=5.29e-24;
%OPA380 TIA OpAmp single input current noise density (A^2/Hz)
theta=70;
% semi-angle at half power
P_total=13;
%transmitted optical power by individual LED
Adet=1e-4;
%detector physical area of a PD
lx=5; ly=5; lz=3;
% room dimension in metre
h=2.15;
%the distance between source and receiver plane
SNR_dB = LOS_chann_noise( theta, lx, ly, h, P_total, Adet, Rdet, Rb, No );
%call LOS SNR function

% Indoor room SNR dB range
SNR_dB_min=min(SNR_dB(:));
SNR_dB_max=max(SNR_dB(:));

%%
%	Generating data input
data_in=randi([0 1],52000,1)';
x=1; % data_pack index
ber_row=1; % for BER rows
MaxIter = 10;
%%%%%%%%%%%%%
%%	Start of main loop
for d=1:100;
data_pack = data_in(x:x+519);
x=x+520;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%		OFDM
%%%%%%%%%%%		TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 	Convolutional encoding
constrlen = 7;
gen_poly = [171 133];
trellis = poly2trellis(constrlen,gen_poly);
codeword = convenc(data_pack,trellis);

%%
%	Data interleaving
intrlv_row = 10; % block interleaver row size
s2 = size(codeword,2); % codeword column size
intrlv_col = s2/intrlv_row; % block interleaver column size
intrlv_matrx = reshape(codeword,intrlv_row,intrlv_col);
intrlvd_data = matintrlv(codeword,intrlv_row,intrlv_col); % Interleave
intrlvd_data_matrix = reshape(intrlvd_data,intrlv_row,intrlv_col);

n = 4; % n indicates number of modulated bits in one QAM symbol
j = size(intrlvd_data,2)/n;
intrlvd_mod_matrix = reshape(intrlvd_data,n,j);
%%
%	Matrix binary to decimal conversion
intrlvd_mod_dec=bi2de(intrlvd_mod_matrix','left-msb');

%%
%	16-QAM modulation
M = 16; % M indicates the type of modulation
mod_data = qammod(intrlvd_mod_dec, M);
%scatterplot(mod_data);

burst_sym = 10; % number of symbol in one burst packet
sub_carrier = 26; % number of used sub-carrier in one OFDM modulation
mod_data_matrix = reshape(mod_data,sub_carrier,burst_sym);

%%
%	Pilot + DC value + Guard band insertion
pilot = 3+3j;
k=1; l=1;

Nfft = 64; % Number of IFFT modulation point

piloted_dat = zeros(Nfft, burst_sym);
pilot_dc=6;
for l=(1:burst_sym)
    for i=(1:32)
        if (i==1|| i==17)
            piloted_dat(i,l)=0;
        else if (i==6||i==11||i==23||i==28)
                piloted_dat(i,l)=pilot;
            else
                piloted_dat(i,l)=mod_data_matrix(k,l);
                k=k+1;
                if (k == 27) 
                    k = 1;
                end
            end
        end
    end
end

%%
%	Hermitian symmetry
for j=(1:10)
    for i=(1:31)
        piloted_dat(i+33,j)=piloted_dat(33-i,j)';
    end
end

%%
%	IFFT
ofdm_tx_dat = zeros(Nfft, burst_sym);
for j=(1:burst_sym)
    ofdm_tx_dat(:,j) = ifft(piloted_dat(:,j),Nfft);
end

%%
%	Add Cyclic Prefix
Ng = Nfft/4;
Nofdm = Nfft+Ng;
ofdm_tx_sig = zeros(Nofdm,burst_sym); % OFDM + Cyclic Prefix
for j=(1:burst_sym)
    ofdm_tx_sig(1:Ng,j) = ofdm_tx_dat(Nfft-Ng+1:Nfft,j);
    ofdm_tx_sig(Ng+1:Ng+Nfft,j) = ofdm_tx_dat(1:Nfft,j);
end

ofdm_tx_burst_sig=reshape(ofdm_tx_sig,1,Nofdm*10);

%%
%   Add symbol timing offset
%nSTO=-3; %[-3 -3 2 2]; 
%CFO=0; %[0 0.5 0 0.5];
%com_delay=Nofdm/2;
%SNRdB=15;
%y = ofdm_tx_burst_sig;
%sig_pow = y*y'/length(y);
%y_CFO= add_CFO(y,CFO,Nfft); y_CFO_STO= add_STO(y_CFO,-nSTO);

%%
%	AWGN Channel 
snr_col=1;
%%%%%%%%%%%%%
%%	Start of SNR loop 
for SNRdB=(0:2:SNR_dB_max)
    %for iter=1:MaxIter 
        ofdm_rx_burst_sig = awgn(ofdm_tx_burst_sig,SNRdB,'measured');
        %ofdm_rx_burst_sig = awgn(y_CFO_STO,SNRdB,'measured');
        %figure;
        %index=1:800;
        %plot(index,ofdm_rx_burst_sig,'r',index, ofdm_tx_burst_sig,'b'); %plot both signals
        %legend('Signal with AWGN & STO','Original Transmitted Signal');
        %[STO_cor,mag_cor]= STO_by_correlation(ofdm_rx_burst_sig,Nfft,Ng,com_delay);
    %end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%		OFDM
%%%%%%%%%%%		RECEIVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%   STO remover
%rx_size = size(ofdm_rx_burst_sig,2);
%ofdm_rx_burst_sig_noSTO = zeros(1,800);
%if (STO_cor<0)
 %   STO_cor = 0;
%end
%ofdm_rx_burst_sig_noSTO(STO_cor+1:rx_size) = ofdm_rx_burst_sig(1:rx_size-STO_cor);
%figure;
%index=1:800;
%plot(index,ofdm_rx_burst_sig_noSTO,'r',index, ofdm_tx_burst_sig,'b'); %plot both signals
%legend('Signal with AWGN and STO Compensated','Original Transmitted Signal');


%%
%	Cyclic Prefix Remover
ofdm_rx_sig_matrix = zeros(Nofdm,burst_sym);
ofdm_rx_sig_matrix_noCP = zeros(Nfft,burst_sym);
for i=(1:burst_sym)
    j=i-1;
    ofdm_rx_sig_matrix(1:Nofdm,i)=ofdm_rx_burst_sig((j*Nofdm)+1:(j+1)*Nofdm);
    %ofdm_rx_sig_matrix(1:Nofdm,i)=ofdm_rx_burst_sig_noSTO((j*Nofdm)+1:(j+1)*Nofdm);
end

for i=(1:burst_sym)
    j=i-1;
    ofdm_rx_sig_matrix_noCP(1:Nfft,i)=ofdm_rx_sig_matrix(Ng+1:Nofdm,i);
end

%%
%	FFT
fft_rx_sig = zeros(Nfft,burst_sym);
for i=(1:burst_sym)
    fft_rx_sig(:,i) = fft(ofdm_rx_sig_matrix_noCP(:,i),64);
end

size_fft_rx=Nfft*burst_sym;
fft_rx_sig_vec = reshape(fft_rx_sig,size_fft_rx,1);
%scatterplot(fft_rx_sig_vec)

%%
%	Pilot Synchronizing (De-Pilot)
rx_dat=zeros(Nfft/2-pilot_dc,burst_sym);
for j=(1:burst_sym)
    k=1;
    for i=(1:Nfft/2)
        if (i~=1 && i~=17 && i~=6 && i~=11 && i~=23 && i~=28)
            rx_dat(k,j)=fft_rx_sig(i,j);
            k=k+1;
        end
    end
end

rx_dat_vec = reshape(rx_dat,size(rx_dat,1)*size(rx_dat,2),1);
%scatterplot(rx_dat_vec);

%%
%	16-QAM demodulation
demod_data= qamdemod(rx_dat_vec,16);

%% 
%	Decimal to binary conversion
bin_demod_data=de2bi(demod_data','left-msb')';

%%
%	Data de-Interleaving
bin_demod_size = size(bin_demod_data,1)*size(bin_demod_data,2);
bin_demod_data_vec=reshape(bin_demod_data,1,bin_demod_size);
deintrlvd_data = matdeintrlv(bin_demod_data_vec,intrlv_row,intrlv_col); % De-Interleave
deintrlvd_data=deintrlvd_data(:)';

%%
%	Viterbi decoding
n=6;
k=3;
decoded_data =vitdec(deintrlvd_data,trellis,5,'trunc','hard');

%%
%	BER calculation
decoded_data=decoded_data(:)';
c = xor(data_pack,decoded_data);
err = nnz(c);

BER(ber_row,snr_col)=err/length(data_pack);
snr_col=snr_col+1;

end 
%%	End of SNR loop 
%%%%%%%%%%%%%

ber_row=ber_row+1;
end
%%	End of main loop
%%%%%%%%%%%%%

%%
% Time averaging for optimum results
ber = zeros(1,size(BER,2));
for col=1:size(BER,2);        %%%change if SNR loop Changed
    ber(1,col)=0;  
for row=1:size(BER,1);
        ber(1,col)=ber(1,col)+BER(row,col);
    end
end
ber=ber./100; 

%%
figure
i=0:2:SNR_dB_max;
semilogy(i,ber);
title('BER vs SNR');
ylabel('BER');
xlabel('SNR (dB)');
grid on