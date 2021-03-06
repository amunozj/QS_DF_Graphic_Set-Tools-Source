% DF Graphics Standardization - Script for updating names to current
% version
% Written by Andr�s Mu�oz-Jaramillo (Quiet-Sun)
clear
fclose('all');

names_sw = false;

%
txtsize = 8;

disp('Matlab Script for updating DF graphics sets v. 0.5')
disp('Made by Andr�s Mu�oz-Jaramillo aka Quiet-Sun')

disp(' ')

disp('Please select folder with DF creature objects')

%Asking user for DF bulild to base itself upon
FolderR = uigetdir('','Select folder with reference DF build');
slsh_in = strfind(FolderR,'\');

disp(' ')
disp('Please select folder with graphics set')

%Asking user for folder with graphics set
FolderI = uigetdir('','Select folder with graphics set');

disp(' ')
disp('Creating Output folders')
slsh_in = strfind(FolderI,'\');
FolderO = [FolderI(max(slsh_in)+1:length(FolderI)) '-Updated'];   %Output Folder
mkdir(FolderO);
rmdir(FolderO ,'s')
mkdir(FolderO);

%Create target folder
copyfile(FolderI,FolderO)
FolderO = [FolderO '\'];


FdisL = fopen([FolderO 'Log_1_Updater.txt'],'w');

%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%Finding all .txt files in the raw/graphics folder of the graphics set
FlsG = rdir([FolderI '\raw\graphics\**\*.txt']);

%Reading all RAW names and checking for differences:

disp(' ')
disp('Reading creature Raws...')
fprintf(FdisL,'Reading creature Raws...');
%Going through all the creature raws
ncr = 0;
for ifR = 1:length(FlsR)
    fidR = fopen(FlsR(ifR).name);
    
    %Going throuhg all lines on each creature raw
    while 1
        
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&strcmp(tmp(1),'[')
            
            ncr = ncr+1;
            cln_in = strfind(tlineR,':');
            brkt_in = strfind(tlineR,']');
            crnameR{ncr} = tlineR(cln_in+1:brkt_in-1);
            
        end
    end
    
    fclose(fidR);
end


fprintf(FdisL,'done!\n\n');




Fdiscr = fopen([FolderO 'Name_Changes.txt'],'w');
tmp = strrep(FolderR, '\', '\\');
fprintf(Fdiscr,['Reference folder: ' tmp '\n']);

tmp = strrep(FolderI, '\', '\\');
fprintf(Fdiscr,['Graphics set folder: ' tmp '\n']);

tmp = strrep(FolderO, '\', '\\');
fprintf(Fdiscr,['Output folder: ' tmp '\n\n']);


Fdis1 = fopen([FolderO 'Names_in_Set_not_in_Raws.txt'],'w');
tmp = strrep(FolderR, '\', '\\');
fprintf(Fdis1,['Reference folder: ' tmp '\n']);

tmp = strrep(FolderI, '\', '\\');
fprintf(Fdis1,['Graphics set folder: ' tmp '\n']);

tmp = strrep(FolderO, '\', '\\');
fprintf(Fdis1,['Output folder: ' tmp '\n\n']);

fprintf(Fdis1,['Number of text files found in graphics set folder: ' num2str(length(FlsG)) '\n\n']);



%Going through all graphic set files and checking for scrambled name matches
disp(' ')
disp('Going through graphics set and looking for scrambled name matches')
fprintf(FdisL,'Going through graphics set and looking for scrambled name matches:\n');
for ifG = 1:length(FlsG)
    
    fidG = fopen(FlsG(ifG).name);    
    
    %Opening mirror file
    slsh_in = strfind(FlsG(ifG).name,'\');
    tmpnm = [FolderO 'raw\graphics\' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name))];
    fidGo = fopen(tmpnm,'w');
    lncnt = 0;
    
    fnd_1diff = false;
    
    %Going through all lines in the graphic set txt
    while 1
        
        lncnt = lncnt + 1;
        %Reading line
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineG);
        if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&strcmp(tmp(1),'[')
            
            cln_in = strfind(tlineG,':');
            brkt_in = strfind(tlineG,']');
            crnameG = tlineG(cln_in+1:brkt_in-1);
            
            disp(['Looking for ' crnameG])
            fprintf(FdisL,['Looking for ' crnameG '\n']);
            
            fnd_sw = false;
            %Going through all the creature raws
            for ifR = 1:length(crnameR)
                
                %If name of creatures different
                if ~strcmp(crnameG,crnameR{ifR})
                    
                    %Finding difference in letter sets
                    stdif1 = setdiff(crnameG,crnameR{ifR});
                    stdif2 = setdiff(crnameR{ifR},crnameG);
                    
                    %Looking for similar patterns
                    
                    %Braking the name into words separated by space or
                    %underscores
                    uscr_in1 = sort([0 strfind(crnameG,'_') strfind(crnameG,' ') (length(crnameG)+1)]);
                    uscr_in2 = sort([0 strfind(crnameR{ifR},'_') strfind(crnameR{ifR},' ') (length(crnameR{ifR})+1)]);
                    
                    %Looking for self-matches
                    slf_mtch1 = 0;  %Number of matches
                    for im1 = 1:length(uscr_in1)-1
                        
                        for im2 = 1:length(uscr_in1)-1
                            
                            if (~isempty(strfind(crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1),crnameG(uscr_in1(im2)+1:uscr_in1(im2+1)-1))))&&(im1~=im2)
                                
                                slf_mtch1 = slf_mtch1+1;
                                
                            end
                        end
                        
                    end
                    
                    slf_mtch2 = 0;  %Number of matches
                    for im1 = 1:length(uscr_in2)-1
                        
                        for im2 = 1:length(uscr_in2)-1
                            
                            if ~isempty(strfind(crnameR{ifR}(uscr_in2(im1)+1:uscr_in2(im1+1)-1),crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1)))&&(im1~=im2)
                                
                                slf_mtch2 = slf_mtch2+1;
                                
                            end
                        end
                        
                    end
                    
                    
                    %Looking for matches
                    nmbr_mtch = 0;  %Number of matches
                    for im1 = 1:length(uscr_in1)-1
                        
                        for im2 = 1:length(uscr_in2)-1
                            
                            if ~isempty(strfind(crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1),crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1)))||~isempty(strfind(crnameR{ifR}(uscr_in2(im2)+1:uscr_in2(im2+1)-1),crnameG(uscr_in1(im1)+1:uscr_in1(im1+1)-1)))
                                
                                nmbr_mtch = nmbr_mtch+1;
                                
                            end
                        end
                        
                    end
                    
                    if ~strcmp(crnameG,crnameR{ifR})&&(abs(length(crnameG)-length(crnameR{ifR}))<=1)&&(length(stdif2)<=1)&&(length(stdif1)<=1)&&(nmbr_mtch>=max([(length(uscr_in1)-1+slf_mtch1) (length(uscr_in2)-1+slf_mtch2)]))
                        
                        tlineG = strrep(tlineG, crnameG, crnameR{ifR});
                        
                        slsh_in = strfind(FlsG(ifG).name,'\');
                        fprintf(Fdiscr,[crnameG '->' crnameR{ifR} ' in line ' num2str(lncnt) ' of ' FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) '\n']);
                        fnd_sw = true;
                        
                    end
                    
                else
                    fnd_sw = true;
                end
                
            end
            
            if ~fnd_sw
                
                if ~fnd_1diff
                    
                    slsh_in = strfind(FlsG(ifG).name,'\');
                    fprintf(Fdis1,'\n');
                    fprintf(Fdis1,[FlsG(ifG).name(max(slsh_in)+1:length(FlsG(ifG).name)) ':\n']);
                    fnd_1diff = true;
                    
                end                
                
                fprintf(Fdis1,[crnameG ' in line ' num2str(lncnt) '\n']);
            end
            
        end
        
        fprintf(fidGo,[tlineG '\n']);
        
    end
    
    fclose(fidG);
    fclose(fidGo);
    
end

fclose(Fdiscr);
fclose(Fdis1);

fprintf(FdisL,'Done!\n\n\n');

Fdis1 = fopen([FolderO 'Names_in_Raws_not_in_Set.txt'],'w');

tmp = strrep(FolderR, '\', '\\');
fprintf(Fdis1,['Reference folder: ' tmp '\n']);

tmp = strrep(FolderI, '\', '\\');
fprintf(Fdis1,['Graphics set folder: ' tmp '\n']);

tmp = strrep(FolderO, '\', '\\');
fprintf(Fdis1,['Output folder: ' tmp '\n']);


%Finding all .txt files in the raw/graphics folder of the corrected graphics set
FlsG = rdir([FolderO 'raw\graphics\**\*.txt']);
fprintf(Fdis1,['Number of text files found in output graphics set folder: ' num2str(length(FlsG)) '\n\n']);


disp(' ')
disp('Looking for creatures in the raws that don''t exist in the graphics set')
fprintf(FdisL,'Looking for creatures in the raws that don''t exist in the graphics set:\n');
%Going through all the creature raws
ncr = 0;
for ifR = 1:length(FlsR)
    fidR = fopen(FlsR(ifR).name);
    
    lncnt = 0;
    
    fnd_1diff = false;
    
    %Going throuhg all lines on each creature raw
    while 1
        
        lncnt = lncnt + 1;
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        %If a creature line is found
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&strcmp(tmp(1),'[')
            
            ncr = ncr+1;
            cln_in = strfind(tlineR,':');
            brkt_in = strfind(tlineR,']');
            crnameR = tlineR(cln_in+1:brkt_in-1);
            
            disp(['Looking for ' crnameR])
            fprintf(FdisL,['Looking for ' crnameR '\n']);

            
            fnd_sw = false;
            for ifG = 1:length(FlsG)
                
                fidG = fopen(FlsG(ifG).name);
                

                %Going through all lines in the graphic set txt
                while 1
                    
                    %Reading line
                    tlineG = fgetl(fidG);
                    if ~ischar(tlineG),   break,   end
                    
                    %If a creature line is found
                    tmp = strtrim(tlineG);
                    if ~isempty(strfind(tlineG,'[CREATURE_GRAPHICS:'))&&strcmp(tmp(1),'[')
                        
                        cln_in = strfind(tlineG,':');
                        brkt_in = strfind(tlineG,']');
                        crnameG = tlineG(cln_in+1:brkt_in-1);
                        
                        if strcmp(crnameG,crnameR)
                            fnd_sw = true;
                        end
                        
                    end
                    
                end
                
                fclose(fidG);                
            end
            
            if ~fnd_sw
                
                
                if ~fnd_1diff
                    
                    slsh_in = strfind(FlsR(ifR).name,'\');
                    fprintf(Fdis1,'\n');
                    fprintf(Fdis1,[FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)) ':\n']);
                    fnd_1diff = true;
                    
                end
                 
                fprintf(Fdis1,[crnameR ' in line ' num2str(lncnt) '\n']);
            end            
             
        end
    end
    
    fclose(fidR);
end

fclose(Fdis1);


%Manifest
FlsStd = rdir([FolderO 'manifest.json']);
if ~isempty(FlsStd)
    
    %Copy file of interest into dummy
    copyfile(FlsStd(1).name,'tmp.txt');
    
    fidG = fopen('tmp.txt');
    fidGo = fopen(FlsStd(1).name,'w');
    
    %Reading all file line by line until finding the end and copying
    %file
    while 1
        
        %Reading line
        tlineG = fgetl(fidG);
        if ~ischar(tlineG),   break,   end
        
        
        if ~isempty(strfind(tlineG, '"title"'))

            qt_in = strfind(tlineG,'"');
            tlineG = [tlineG(1:max(qt_in)-1) ' Updated' tlineG(max(qt_in):length(tlineG))];
            
        end
        
        fprintf(fidGo,[tlineG '\n']);
        
    end
    
    fclose(fidG);
    fclose(fidGo);
    
end


disp(' ')
disp('Done!  Look inside your updated folder for report files.')
fprintf(FdisL,'Done with all!');

fclose(FdisL);

load('gong','Fs','y')
sound(y, Fs);




% load('gong','Fs','y')
% sound(y, Fs);