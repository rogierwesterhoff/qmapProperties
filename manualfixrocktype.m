function C = manualfixrocktype(C)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% spelling changes
for iC=1:length(C)
    if strcmp(C(iC),'trondjhemite')
        C(iC)=cellstr('trondhjemite');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'argilite')
        C(iC)=cellstr('argillite');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'quart')
        C(iC)=cellstr('quartz');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'orthogniess')
        C(iC)=cellstr('orthogneiss');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'gabbo')
        C(iC)=cellstr('gabbro');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'metavolcanic')
        C(iC)=cellstr('metavolcanics');
    end
end

for iC=1:length(C)
    if strcmp(C(iC),'sandy')
        C(iC)=cellstr('sand');
    end
end

%%

% iC=1;
% while iC <= length(C)
%     if strcmp(C(iC),'volcanic')
%         C(iC)=strcat(C(iC),{' '}, C(iC+1));
%         C(iC+1)=[];
%     end
%     iC=iC+1;
% end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'olivine')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'quartz')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'calcareous')&&strcmp(C(iC+1),'mudstone')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'domestic')&&strcmp(C(iC+1),'waste')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'industrial')&&strcmp(C(iC+1),'waste')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'leaf')&&strcmp(C(iC+1),'beds')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'volcanic')&&strcmp(C(iC+1),'sandstone')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'volcanic')&&strcmp(C(iC+1),'conglomerate')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'volcanic')&&strcmp(C(iC+1),'breccia')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'pyroclastic')&&strcmp(C(iC+1),'breccia')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'dioritic')&&strcmp(C(iC+1),'orthogneiss')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'basaltic')&&strcmp(C(iC+1),'andesite')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1; % gives an error, as sometimes debris is the last word. Solved by -1 in next line
while iC <= length(C)-1
    if strcmp(C(iC),'debris')&&strcmp(C(iC+1),'flow')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'lapilli')&&strcmp(C(iC+1),'tuff')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'shell')&&strcmp(C(iC+1),'beds')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'vitric')&&strcmp(C(iC+1),'tuff')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'gabbroic')&&strcmp(C(iC+1),'orthogneiss')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'broken')&&strcmp(C(iC+1),'formation')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end

iC=1;
while iC <= length(C)
    if strcmp(C(iC),'algal')&&strcmp(C(iC+1),'limestone')
        C(iC)=strcat(C(iC),{' '}, C(iC+1));
        C(iC+1)=[];
    end
    iC=iC+1;
end


