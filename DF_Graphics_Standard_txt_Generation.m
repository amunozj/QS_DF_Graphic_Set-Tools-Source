% DF Graphics Standardization - Creating standard files
% Written by Andr�s Mu�oz-Jaramillo (Quiet-Sun)
% fclose('all')
% clear
%
%
% %Asking user for DF bulild to base itself upon
% FolderR = uigetdir('','Select folder with reference DF build');

disp('Creating Output folder for standard text files')
slsh_in = strfind(FolderR,'\');
FolderOtx = [pwd FolderR(max(slsh_in):max(slsh_in)+5) ' aa QS_STD_Text_Files'];   %Output Folder
mkdir(FolderOtx);
rmdir(FolderOtx ,'s')
mkdir(FolderOtx);
FolderOtx = [FolderOtx '\'];

%Finding all .txt files in reference folder
FlsR = rdir([FolderR '\**\*.txt']);

%% Definition of categories
nctcr = 0;
fidC = fopen('CATEGORIES_CREATURES_42.05.txt');
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    nctcr = nctcr + 1;
    catg_creatures(nctcr).name = tlineC;
    
end
fclose(fidC);

fidC = fopen('CATEGORIES_HUMANOIDS_42.05.txt');
Sb_cat_sw = false;
ncthm = 0;
while 1
    
    %Reading line
    tlineC = fgetl(fidC);
    if ~ischar(tlineC),   break,   end
    
    if ~strcmp(tlineC(1),' ')&&~strcmp(tlineC(1),'-')
        ncthm = ncthm + 1;
        Sb_cat_sw = true;
        nsct = 1;
        catg_humanoids(ncthm).name{nsct} = tlineC;
    elseif strcmp(tlineC(1),' ')&&~strcmp(tlineC(1),'-')&&Sb_cat_sw
        nsct = nsct + 1;
        catg_humanoids(ncthm).name{nsct} = strtrim(tlineC);
    elseif strcmp(tlineC(1),'-')
        Sb_cat_sw = false;
    end
    
end
fclose(fidC);


%% Doing Creatures
for ifR = 1:length(FlsR)

    disp('Counting number of creatures')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);

    while 1
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end

        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN]'))&&isempty(strfind(tlineR,'ELEMENTMAN'))&&isempty(strfind(tlineR,'GORLAK]'))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&strcmp(tmp(1),'[')
            ncr = ncr+1;
        end
    end
    fclose(fidR);

    %Creating output file for creatures
    if ncr>0

        fidR = fopen(FlsR(ifR).name);

        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_STD_CRT');

        fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name2 = strrep(fl_name2, 'creature', 'QS_STD_CRT');


        FileO = [FolderOtx fl_name '.txt'];

        %Opening output file
        fidO = fopen(FileO,'w');

        %Creating Header
        Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
        undr_in = [0 strfind(Pname,'_')];

        %Creating short title page
        tmp = ['CR'];
        for i = 2:length(undr_in)
            tmp = strcat(tmp,['_' Pname(undr_in(i)+1:undr_in(i)+3)])
        end
        tmp = strcat(tmp,num2str(ifR));

        Pname = tmp;

        %Name
        fprintf(fidO,[fl_name '\n\n']);

        %Object
        fprintf(fidO,'[OBJECT:GRAPHICS]\n\n');

        %Title Page
        fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);

        %File
        fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);

        %Tile size
        fprintf(fidO,'\t[TILE_DIM:X:X]\n');

        %Page size
        fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr) ':' num2str(nctcr) ']\n\n']);

        ntl = 1;

        %Reading all file line by line until finding the end
        while 1

            %Reading line
            tlineR = fgetl(fidR);
            if ~ischar(tlineR),   break,   end

            tmp = strtrim(tlineR);
            %If finding a creature name look for the respective tile
            if ~isempty(strfind(tlineR,'[CREATURE:'))&&isempty(strfind(tlineR,'MAN]'))&&isempty(strfind(tlineR,'ELEMENTMAN'))&&isempty(strfind(tlineR,'GORLAK]'))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&strcmp(tmp(1),'[')

                nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);

                fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);

                %Adding categories
                for ict = 1:length(catg_creatures)
                    cln_in = strfind(catg_creatures(ict).name,':');
                    fprintf(fidO,['\t[' catg_creatures(ict).name(1:cln_in(1)-1) ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) catg_creatures(ict).name(cln_in(1):length(catg_creatures(ict).name)) ']\n']);
                end
                fprintf(fidO,'\n');

                ntl = ntl+1;
            end


        end

        fclose(fidO);
        fclose(fidR);

    end

end


%% Doing Humanoids
for ifR = 1:length(FlsR)
    
    disp('Counting number of humanoids')
    ncr = 0;
    fidR = fopen(FlsR(ifR).name);
    
    while 1
        %Reading line
        tlineR = fgetl(fidR);
        if ~ischar(tlineR),   break,   end
        
        tmp = strtrim(tlineR);
        if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'MAN]'))||~isempty(strfind(tlineR,'ELEMENTMAN'))||~isempty(strfind(tlineR,'GORLAK]')))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&isempty(strfind(tlineR,'HUMAN]'))&&strcmp(tmp(1),'[')
            ncr = ncr+1;
        end
    end
    fclose(fidR);
    
    %Creating output file for humanoids
    if ncr>0
        
        npgs = 1;
        while ncr/npgs*length(catg_humanoids)>1023
            npgs = npgs+1;
        end
        ncrpp = floor(ncr/npgs); %Number of creatures per page
        crcn = 1;  %Creature counter
        
        fidR = fopen(FlsR(ifR).name);
        
        %Creating output name
        slsh_in = strfind(FlsR(ifR).name,'\');
        fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
        fl_name = strrep(fl_name, 'creature', 'QS_STD_HMD');
        
        fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)]
        fl_name2 = strrep(fl_name2, 'creature', 'QS_STD_HMD');
        
        
        FileO = [FolderOtx fl_name '.txt'];
        
        %Opening output file
        fidO = fopen(FileO,'w');
        
        %Name
        fprintf(fidO,[fl_name '\n\n']);
        
        %Object
        fprintf(fidO,'[OBJECT:GRAPHICS]\n');
        
        
        for ipgs = 1:npgs
            
            fprintf(fidO,'\n');
            
            %Creating Header
            Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
            undr_in = [0 strfind(Pname,'_')];
            
            %Creating short title page
            tmp = ['HMN'];
            for i = 2:length(undr_in)
                tmp = strcat(tmp,['_' Pname(undr_in(i)+1:undr_in(i)+3)])
            end
            tmp = strcat(tmp,num2str(ipgs));
            
            Pname = tmp;
            
            %Title Page
            fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);
            
            %File
            if npgs==1
                fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);
            else
                fprintf(fidO,['\t[FILE:' fl_name2 num2str(ipgs) '_XxX.png]\n']);
            end
            
            %Tile size
            fprintf(fidO,'\t[TILE_DIM:X:X]\n');
            
            %Page size
            if (npgs==1)||(ipgs~=npgs)
                fprintf(fidO,['\t[PAGE_DIM:' num2str(ncrpp) ':' num2str(ncthm) ']\n\n']);
            else
                fprintf(fidO,['\t[PAGE_DIM:' num2str(ncr-ncrpp*(npgs-1)) ':' num2str(ncthm) ']\n\n']);
            end
            
            ntl = 1;
            
            %Reading all file line by line until finding the end
            while 1
                
                %Reading line
                tlineR = fgetl(fidR);
                if ~ischar(tlineR),   break,   end
                
                tmp = strtrim(tlineR);
                %If finding a humanoid name look for the respective tile
                if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'MAN]'))||~isempty(strfind(tlineR,'ELEMENTMAN'))||~isempty(strfind(tlineR,'GORLAK]')))&&isempty(strfind(tlineR,'DWARF]'))&&isempty(strfind(tlineR,'ELF]'))&&isempty(strfind(tlineR,'GOBLIN]'))&&isempty(strfind(tlineR,'KOBOLD]'))&&isempty(strfind(tlineR,'HUMAN]'))&&strcmp(tmp(1),'[')
                    
                    nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);
                    
                    fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);
                    
                    %Adding categories
                    for ict = 1:length(catg_humanoids)
                        
                        for ipr=1:size(catg_humanoids(ict).name,2)
                            tmpnm = catg_humanoids(ict).name{ipr};
                            cln_in = strfind(tmpnm,':');
                            fprintf(fidO,['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ntl-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n']);
                        end
                        fprintf(fidO,'\n');
                    end
                    
                    fprintf(fidO,'\n');
                    
                    ntl = ntl+1;
                    
                    crcn = crcn +1;
                    if (mod(ntl,ncrpp+1)==0),   break,   end
                    
                end
                
                if (mod(ntl,ncrpp+1)==0),   break,   end
                
                
            end
            
        end
        
        fclose(fidO);
        fclose(fidR);
        
    end
    
end

%% Doing Major Races

disp('Counting number of major professions')
npr = 0;
totpr = 0;
for i = 1:length(catg_humanoids)
    npr = max([npr size(catg_humanoids(i).name,2)]);
    totpr = totpr + size(catg_humanoids(i).name,2);
end

for ifR = 1:length(FlsR)

        fidR = fopen(FlsR(ifR).name);

        %Reading all file line by line until finding each major race
        while 1

            %Reading line
            tlineR = fgetl(fidR);
            if ~ischar(tlineR),   break,   end

            tmp = strtrim(tlineR);
            %If finding a humanoid name look for the respective tile
            if ~isempty(strfind(tlineR,'[CREATURE:'))&&(~isempty(strfind(tlineR,'DWARF]'))||~isempty(strfind(tlineR,'ELF]'))||~isempty(strfind(tlineR,'GOBLIN]'))||~isempty(strfind(tlineR,'KOBOLD]'))||~isempty(strfind(tlineR,'HUMAN]')))&&strcmp(tmp(1),'[')

                nameR = tlineR(strfind(tlineR,':')+1:strfind(tlineR,']')-1);


                %Creating output name
                slsh_in = strfind(FlsR(ifR).name,'\');
                fl_name = ['graphics_' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
                fl_name = strrep(fl_name, 'creature', ['QS_STD_MJR_' lower(nameR)]);

                fl_name2 = ['QS_STD/' FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4)];
                fl_name2 = strrep(fl_name2, 'creature', ['QS_STD_MJR_' lower(nameR)]);



                FileO = [FolderOtx fl_name '.txt'];

                %Opening output file
                fidO = fopen(FileO,'w');

                %Creating Header
                Pname =  upper(FlsR(ifR).name(max(slsh_in)+1:length(FlsR(ifR).name)-4));
                undr_in = [0 strfind(Pname,'_')];

                %Creating short title page
                Pname = ['MJR_' nameR];

                %Name
                fprintf(fidO,[fl_name '\n\n']);

                %Object
                fprintf(fidO,'[OBJECT:GRAPHICS]\n\n');

                %Title Page
                fprintf(fidO,['[TILE_PAGE:' Pname ']\n']);

                %File
                fprintf(fidO,['\t[FILE:' fl_name2 '_XxX.png]\n']);

                %Tile size
                fprintf(fidO,'\t[TILE_DIM:X:X]\n');

                %Page size
                fprintf(fidO,['\t[PAGE_DIM:' num2str(npr) ':' num2str(ncthm) ']\n\n']);

                fprintf(fidO,['[CREATURE_GRAPHICS:' nameR ']\n']);

                %Adding categories
                for ict = 1:length(catg_humanoids)

                    for ipr=1:size(catg_humanoids(ict).name,2)
                        tmpnm = catg_humanoids(ict).name{ipr};
                        cln_in = strfind(tmpnm,':');
                        fprintf(fidO,['\t[' tmpnm(1:cln_in(1)-1) ':' Pname ':' num2str(ipr-1) ':'  num2str(ict-1) tmpnm(cln_in(1):length(tmpnm)) ']\n']);
                    end
                    fprintf(fidO,'\n');
                end

                fclose(fidO);
            end


        end


        fclose(fidR);

end
