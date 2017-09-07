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
%	Generating data input
data_in = randi([0 1],5200,1)';
x=1; % data_pack index
ber_row=1; % for BER rows

%%%%%%%%%%%%%
%%	Start of main loop
for d=1:100;
data_pack = data_in(x:x+51);
x=x+52;

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
n = 4; % n indicates number of modulated bits in one QAM symbol
s2 = size(codeword,2); % codeword column size
j = s2/n;
intrlv_matrx = reshape(codeword,n,j);
intrlvd_data = matintrlv(intrlv_matrx,2,2); % Interleave

%%
%	Matrix binary to decimal conversion
intrlvd_dec=bi2de(intrlvd_data','left-msb');

%%
%	16-QAM modulation
M = 16; % M indicates the type of modulation
mod_data = qammod(intrlvd_dec, M);
%scatterplot(mod_data);

%%
%	Pilot + DC value + Guard band insertion
pilot = 3+3j;
k=1;

for i=(1:32)
	if (i==1|| i==17)
		piloted_dat(i)=0;
	else if (i==6||i==11||i==23||i==28)
		piloted_dat(i)=pilot;
	else
		piloted_dat(i)=mod_data(k);
		k=k+1;
	end
	end
end

%%
%	Hermitian symmetry
piloted_dat(33)=0;
for i=(1:31)
	piloted_dat(i+33)=piloted_dat(33-i)';
end

%%
%	IFFT 
ofdm_tx_dat = ifft(piloted_dat,64);

%%
%	Add Cyclic Prefix
ofdm_tx_sig(1:16) = ofdm_tx_dat(49:64);

ofdm_tx_sig(17:80) = ofdm_tx_dat(1:64);

%%
%	AWGN Channel 
snr_col=1;
%%%%%%%%%%%%%
%%	Start of SNR loop

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

SNR_dB_vector=SNR_dB(:);
for SNR=0:2:SNR_dB_max
%for i=(1:1:size(SNR_dB_vector))
%SNR = SNR_dB_vector(i);
ofdm_rx_sig = awgn(ofdm_tx_sig,SNR,'measured');
%figure;
index=1:80;
%plot(index,ofdm_rx_sig,'b',index, ofdm_tx_sig,'r'); %plot both signals
%legend('Original Transmitted Signal','Signal with AWGN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%		OFDM
%%%%%%%%%%%		RECEIVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%	Cyclic Prefix Remover
ofdm_rx_dat(1:64) = ofdm_rx_sig(17:80);

%%
%	FFT
fft_rx_sig = fft(ofdm_rx_dat,64);

%%
%	Pilot Synchronizing (De-Pilot)
k=1;
for i=(1:32)
	if (i~=1 && i~=17 && i~=6 && i~=11 && i~=23 && i~=28)
		rx_dat(k)=fft_rx_sig(i);
		k=k+1;
	end
end

%scatterplot(rx_dat);

%%
%	16-QAM demodulation
demod_data= qamdemod(rx_dat,16);

%% 
%	Decimal to binary conversion
bin_demod_data=de2bi(demod_data','left-msb')';

%%
%	Data de-Interleaving
deintrlvd_data = matdeintrlv(bin_demod_data,2,2); % De-Interleave
deintrlvd_data=deintrlvd_data(:)';

%%
%	Viterbi decoding
n=6;
k=3;
decoded_data =vitdec(deintrlvd_data,trellis,5,'trunc','hard');

%%
%	BER calculation
err = 0;
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

for col=1:size(BER,2);        %%%change if SNR loop Changed
    ber(1,col)=0;  
for row=1:size(BER,1);
        ber(1,col)=ber(1,col)+BER(row,col);
    end
end
ber=ber./100; 

%%%%%%%%%%%%%%%%%%%
%% This part is to calculate indoor BER

for j=1:1:51
    for i=1:1:51
        ber_room(i,j)=ber(j);
    end
end

Nx=lx*10; Ny=ly*10;
% number of grid in the receiver plane
x_width=-lx/2:lx/Nx:lx/2;
y_length=-ly/2:ly/Ny:ly/2;
% receiver plane grid

%% Room BER 
meshc(x_width,y_length,ber_room);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('BER');
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(ber_room)) max(max(ber_room))]);

%% This part is to calculate Indoor BER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
figure
i=0:2:SNR_dB_max;
semilogy(i,ber);
title('BER vs SNR');
ylabel('BER');
xlabel('SNR (dB)');
grid on