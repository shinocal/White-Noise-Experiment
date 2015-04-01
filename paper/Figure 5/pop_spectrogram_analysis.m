clear
clc
close all

dir='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\pre infusion\AUD';
[s_avg_preinf,sub_mat_preinf,~,~] =pop_spectrogram_sound_only_aud(dir);

dir='C:\Nick Lab\SCRIPTS\White Noise Expmnt\LFP population data\4 condition\scopolamine high dose\post infusion\AUD';
[s_avg_postinf,sub_mat_postinf,t,f] =pop_spectrogram_sound_only_aud(dir);

%%

clearvars -except s_avg_preinf s_avg_postinf sub_mat_preinf sub_mat_postinf t f
norm_preinf_pop.frstshnk=cell(1,8);
norm_preinf_pop.secshnk=cell(1,8);
norm_preinf_pop.thrdshnk=cell(1,8);
norm_preinf_pop.frthshnk=cell(1,8);

norm_postinf_pop.frstshnk=cell(1,8);
norm_postinf_pop.secshnk=cell(1,8);
norm_postinf_pop.thrdshnk=cell(1,8);
norm_postinf_pop.frthshnk=cell(1,8);

for i =1:length(sub_mat_preinf)
   
   for n=1:length(sub_mat_preinf{i}.frstshnk)
   norm_preinf_pop.frstshnk{n}=cat(3,norm_preinf_pop.frstshnk{n},sub_mat_preinf{i}.frstshnk{n});
   norm_preinf_pop.secshnk{n}=cat(3,norm_preinf_pop.secshnk{n},sub_mat_preinf{i}.secshnk{n});
   norm_preinf_pop.thrdshnk{n}=cat(3,norm_preinf_pop.thrdshnk{n},sub_mat_preinf{i}.thrdshnk{n});
   norm_preinf_pop.frthshnk{n}=cat(3,norm_preinf_pop.frthshnk{n},sub_mat_preinf{i}.frthshnk{n});
   
   norm_postinf_pop.frstshnk{n}=cat(3,norm_postinf_pop.frstshnk{n},sub_mat_preinf{i}.frstshnk{n});
   norm_postinf_pop.secshnk{n}=cat(3,norm_postinf_pop.secshnk{n},sub_mat_preinf{i}.secshnk{n});
   norm_postinf_pop.thrdshnk{n}=cat(3,norm_postinf_pop.thrdshnk{n},sub_mat_preinf{i}.thrdshnk{n});
   norm_postinf_pop.frthshnk{n}=cat(3,norm_postinf_pop.frthshnk{n},sub_mat_preinf{i}.frthshnk{n});
   end
    
end   

%%

   for n=1:length(sub_mat_preinf{i}.frstshnk)
   norm_preinf_avg.frstshnk{n}=mean(norm_preinf_pop.frstshnk{n},3);
   norm_preinf_avg.secshnk{n}=mean(norm_preinf_pop.secshnk{n},3);
   norm_preinf_avg.thrdshnk{n}=mean(norm_preinf_pop.thrdshnk{n},3);
   norm_preinf_avg.frthshnk{n}=mean(norm_preinf_pop.frthshnk{n},3);
  
   norm_postinf_avg.frstshnk{n}=mean(norm_postinf_pop.frstshnk{n},3);
   norm_postinf_avg.secshnk{n}=mean(norm_postinf_pop.secshnk{n},3);
   norm_postinf_avg.thrdshnk{n}=mean(norm_postinf_pop.thrdshnk{n},3);
   norm_postinf_avg.frthshnk{n}=mean(norm_postinf_pop.frthshnk{n},3);
   end
   
   %%
   
   
   

   
   