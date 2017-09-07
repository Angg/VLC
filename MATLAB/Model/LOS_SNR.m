Rdet=0.5;
%Hamamatsu S5980/S5981/S5870 Si PIN Photodiode Photosensitivity (A/W)
Rb=1e6;
%Bit rate
No=5.29e-24;
%OPA380 TIA OpAmp single input current noise density (A^2/Hz)
theta=70;
% semi-angle at half power
m=-log10(2)/log10(cosd(theta));
%Lambertian order of emission
P_total=8;
%transmitted optical power by individual LED
Adet=1e-4;
%detector physical area of a PD
Ts=1;
%gain of an optical filter; ignore if no filter is used
index=1.5;
%refractive index of a lens at a PD; ignore if no lens is used
FOV=60*pi/180;
%FOV of a receiver
G_Con=(index^2)/sin(FOV);
%gain of an optical concentrator; ignore if no lens is used
lx=5; ly=5; lz=3;
% room dimension in metre
h=2.15;
%the distance between source and receiver plane
%[XT,YT]=meshgrid([?1.25 1.25],[?1.25 1.25]);
XT=0; YT=0;
% position of LED;
Nx=lx*10; Ny=ly*10;
% number of grid in the receiver plane
x=-lx/2:lx/Nx:lx/2;
y=-ly/2:ly/Ny:ly/2;
[XR,YR]=meshgrid(x,y);
% receiver plane grid
D1=sqrt((XR-XT(1,1)).^2+(YR-YT(1,1)).^2+h^2);
% distance vector from source 1
cosphi_A1=h./D1;
% angle vector
H_A1=(m+1)*Adet.*cosphi_A1.^(m+1)./(2*pi.*D1.^2);
% channel DC gain for source 1
P_rec=P_total.*H_A1.*Ts.*G_Con;
% received power from source 1;
SNR=(Rdet^2).*((P_rec.*(10^-3)).^2)./(Rb*No);
%SNR value
SNR_dB=10.*log10(SNR);
%SNR in decibel

meshc(x,y,SNR_dB);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('SNR (dB)');
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(SNR_dB)) max(max(SNR_dB))]);