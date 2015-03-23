clear
clc
% [list_preinf,rmscsd_preinf] = pop_CSD_sound_only_rms('C:\Users\Nick\Desktop\wht ns expmnt\LFP population data\4 condition\scopolamine high dose\pre infusion\AUD','no drug');
% 
% [list_postinf,rmscsd_postinf] = pop_CSD_sound_only_rms('C:\Users\Nick\Desktop\wht ns expmnt\LFP population data\4 condition\scopolamine high dose\post infusion\AUD','drug');
t_resp=[0 0.65];
[list_preinf,rmscsd_preinf] = pop_CSD_sound_only_rms('C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\pre infusion\AUD','no drug',t_resp);

[list_postinf,rmscsd_postinf] = pop_CSD_sound_only_rms('C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\post infusion\AUD','drug',t_resp);

list_preinf=list_preinf';
list_postinf=list_postinf';
%%

clearvars -except list_postinf list_preinf rmscsd_preinf rmscsd_postinf

rms_vec_preinf.frstshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_preinf.secshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_preinf.thrdshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_preinf.frthshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));

rms_vec_postinf.frstshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_postinf.secshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_postinf.thrdshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));
rms_vec_postinf.frthshnk=cell(1,length(rmscsd_preinf{1}.frstshnk));

for i =1:length(rmscsd_preinf)

        for p=1:length(rmscsd_preinf{1}.frstshnk)
            
        rms_vec_preinf.frstshnk{p}=cat(2,rms_vec_preinf.frstshnk{p},rmscsd_preinf{i}.frstshnk(p));
        rms_vec_preinf.secshnk{p}=cat(2,rms_vec_preinf.secshnk{p},rmscsd_preinf{i}.secshnk(p));
        rms_vec_preinf.thrdshnk{p}=cat(2,rms_vec_preinf.thrdshnk{p},rmscsd_preinf{i}.thrdshnk(p));
        rms_vec_preinf.frthshnk{p}=cat(2,rms_vec_preinf.frthshnk{p},rmscsd_preinf{i}.frthshnk(p));
        
        rms_vec_postinf.frstshnk{p}=cat(2,rms_vec_postinf.frstshnk{p},rmscsd_postinf{i}.frstshnk(p));
        rms_vec_postinf.secshnk{p}=cat(2,rms_vec_postinf.secshnk{p},rmscsd_postinf{i}.secshnk(p));
        rms_vec_postinf.thrdshnk{p}=cat(2,rms_vec_postinf.thrdshnk{p},rmscsd_postinf{i}.thrdshnk(p));
        rms_vec_postinf.frthshnk{p}=cat(2,rms_vec_postinf.frthshnk{p},rmscsd_postinf{i}.frthshnk(p));
            
        end
end



for p=1:length(rmscsd_preinf{1}.frstshnk)
   
    [H.frstshnk(p),P.frstshnk(p)]=ttest(rms_vec_preinf.frstshnk{p},rms_vec_postinf.frstshnk{p});
    [H.secshnk(p),P.secshnk(p)]=ttest(rms_vec_preinf.secshnk{p},rms_vec_postinf.secshnk{p});
    [H.thrdshnk(p),P.thrdshnk(p)]=ttest(rms_vec_preinf.thrdshnk{p},rms_vec_postinf.thrdshnk{p});
    [H.frthshnk(p),P.frthshnk(p)]=ttest(rms_vec_preinf.frthshnk{p},rms_vec_postinf.frthshnk{p});
    
end

%%

clearvars -except list_postinf list_preinf rmscsd_preinf rmscsd_postinf


for i =1:length(rmscsd_preinf)

        for p=1:length(rmscsd_preinf{1}.frstshnk)
            
        rms_vec_preinf.frstshnk(i)=mean(rmscsd_preinf{i}.frstshnk);
        rms_vec_preinf.secshnk(i)=mean(rmscsd_preinf{i}.secshnk);
        rms_vec_preinf.thrdshnk(i)=mean(rmscsd_preinf{i}.thrdshnk);
        rms_vec_preinf.frthshnk(i)=mean(rmscsd_preinf{i}.frthshnk);
        
        rms_vec_postinf.frstshnk(i)=mean(rmscsd_postinf{i}.frstshnk);
        rms_vec_postinf.secshnk(i)=mean(rmscsd_postinf{i}.secshnk);
        rms_vec_postinf.thrdshnk(i)=mean(rmscsd_postinf{i}.thrdshnk);
        rms_vec_postinf.frthshnk(i)=mean(rmscsd_postinf{i}.frthshnk);
            
        end
end

   rms_in_pre=mean([rms_vec_preinf.secshnk;rms_vec_preinf.thrdshnk]);
   rms_out_pre=mean([rms_vec_preinf.frstshnk;rms_vec_preinf.frthshnk]);
   rms_in_post=mean([rms_vec_postinf.secshnk;rms_vec_postinf.thrdshnk]);
   rms_out_post=mean([rms_vec_postinf.frstshnk;rms_vec_postinf.frthshnk]);
   %%

    [H.frstshnk,P.frstshnk]=ttest(rms_vec_preinf.frstshnk,rms_vec_postinf.frstshnk);
    [H.secshnk,P.secshnk]=ttest(rms_vec_preinf.secshnk,rms_vec_postinf.secshnk);
    [H.thrdshnk,P.thrdshnk]=ttest(rms_vec_preinf.thrdshnk,rms_vec_postinf.thrdshnk);
    [H.frthshnk,P.frthshnk]=ttest(rms_vec_preinf.frthshnk,rms_vec_postinf.frthshnk);
    
    pvals=[P.frstshnk,P.secshnk,P.thrdshnk,P.frthshnk];
    [h, crit_p, adj_p]=fdr_bh(pvals,0.05,'pdep','yes');
    
    %%
    
    
        rms_vec_preinf.frstshnk=rms_vec_preinf.frstshnk';
        rms_vec_preinf.secshnk=rms_vec_preinf.secshnk';
        rms_vec_preinf.thrdshnk=rms_vec_preinf.thrdshnk';
        rms_vec_preinf.frthshnk=rms_vec_preinf.frthshnk';
        
        rms_vec_postinf.frstshnk=rms_vec_postinf.frstshnk';
        rms_vec_postinf.secshnk=rms_vec_postinf.secshnk';
        rms_vec_postinf.thrdshnk=rms_vec_postinf.thrdshnk';
        rms_vec_postinf.frthshnk=rms_vec_postinf.frthshnk';
    
    
    %%
    
    
 
