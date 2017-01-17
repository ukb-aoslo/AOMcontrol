aom1seq = zeros(1,150); 
aom1pow = ones(size(aom1seq));
aom1pow(:) = 0.000;
aom1offx = zeros(size(aom1seq));
aom1offy = zeros(size(aom1seq));
aom0seq = ones(size(aom1seq)).*2;
aom0seq(end) = 0;
aom0locx = zeros(size(aom1seq));
aom0locy = zeros(size(aom1seq));
aom0pow = ones(size(aom1seq));
aom0pow(:) = 1.000;
gainseq = ones(size(aom1seq)).*1.0;
angleseq = ones(size(aom1seq)).*0;

Mov.aom0seq = aom0seq;
Mov.aom1seq = aom1seq;
Mov.aom0pow = aom0pow;
Mov.aom1pow = aom1pow;
Mov.aom0locx = aom0locx;
Mov.aom0locy = aom0locy;
Mov.aom1offx = aom1offx;
Mov.aom1offy = aom1offy;
Mov.gainseq = gainseq;
Mov.angleseq = angleseq;
Mov.gainseq(45:105) = 0;

for i = 1:150
    if i == 1
        Mov.seq = [num2str(Mov.aom0seq(i)) ',' num2str(Mov.aom0pow(i)) ',' num2str(Mov.aom0locx(i)) ',' num2str(Mov.aom0locy(i)) ',' num2str(Mov.aom1seq(i)) ',' num2str(Mov.aom1pow(i)) ',' num2str(Mov.aom1offx(i)) ',' num2str(Mov.aom1offy(i)) ',' num2str(Mov.gainseq(i)) ','  num2str(Mov.angleseq(i)) sprintf('\t')];
    elseif i>1 && i<length(Mov.aom0seq)
        Mov.seq = [Mov.seq num2str(Mov.aom0seq(i)) ',' num2str(Mov.aom0pow(i)) ',' num2str(Mov.aom0locx(i)) ',' num2str(Mov.aom0locy(i)) ',' num2str(Mov.aom1seq(i)) ',' num2str(Mov.aom1pow(i)) ',' num2str(Mov.aom1offx(i)) ',' num2str(Mov.aom1offy(i)) ',' num2str(Mov.gainseq(i)) ','  num2str(Mov.angleseq(i)) sprintf('\t')]; %#ok<AGROW>
    elseif i == length(Mov.aom0seq)
        Mov.seq = [Mov.seq num2str(0) ',' num2str(Mov.aom0pow(i)) ',' num2str(Mov.aom0locx(i)) ',' num2str(Mov.aom0locy(i)) ',' num2str(Mov.aom1seq(i)) ',' num2str(Mov.aom1pow(i)) ',' num2str(Mov.aom1offx(i)) ',' num2str(Mov.aom1offy(i)) ',' num2str(Mov.gainseq(i)) ','  num2str(Mov.angleseq(i))]; %#ok<AGROW>
    end
end