function J=JND(I,p)
J=max(ML(I),p*min(MT(I),FME(I)));

function M=ML(I)
Ipad=padarray(I,[2,2],'replicate');

% MG-----------------------------------
G1=[ 0  0  0  0  0
     1  3  8  3  1
     0  0  0  0  0
    -1 -3 -8 -3 -1
     0  0  0  0  0 ];
G2=[ 0  0  1  0  0
     0  8  3  0  0
     1  3  0 -3 -1
     0  0 -3 -8  0
     0  0 -1  0  0 ];
G3=[ 0  0  1  0  0
     0  0  3  8  0
    -1 -3  0  3  1
     0 -8 -3  0  0
     0  0 -1  0  0];
G4=[ 0  1  0 -1  0
     0  3  0 -3  0
     0  8  0 -8  0
     0  3  0 -3  0
     0  1  0 -1  0];

Ipad_C=im2col(Ipad,[5 5],'sliding');
G=[G1(:),G2(:),G3(:),G4(:)]';
MG=reshape(max(abs(G*Ipad_C/16)),size(I));

% BG --------------------------------------
B=[1 1 1 1 1
   1 2 2 2 1
   1 2 0 2 1
   1 2 2 2 1
   1 1 1 1 1];

BG=reshape((B(:)'*Ipad_C)/32,size(I));

ALP=0.0001*BG+0.115;
BTA=0.5-0.01*BG;

F1=MG.*ALP+BTA;
F2=zeros(size(I));
F2(BG<=127)=17*(1-(BG(BG<=127)/127).^0.5)+3;
F2(BG>127)=3/128*(BG(BG>127)-127)+3;
M=max(F1,F2);

function Mt=MT(I)
%I=double(imread('lena_gray.tiff'));
L=1;
Ipad=padarray(I,[L,L],'replicate');
Mt=zeros(size(I));
for i=1:size(I,1)
    for j=1:size(I,2)
        xt=0;
        for m=-L:L
            for n=-L:L
                xt=xt+Ipad(i+m+L,j+n+L);
            end
        end
        Mt(i,j)=abs(I(i,j)-xt/(2*L+1)^2);
    end
end
Mt=round(Mt);
                
function FilteredME =FME(I)
H = fspecial('laplacian');
H=[0  1  0;
   1 -4  1 
   0  1  0];
ME = imfilter(I,H,'replicate');
%imshow(F);
se = strel('disk',1); 
BW = imdilate(edge(I,'canny'),se);
FilteredME=BW.*round(abs(ME));



 