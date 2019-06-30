#!/bin/bash
#--------------------------------------------
cd ~/tesstutorial

 rm -rf ~/tesstutorial/brahmievaleng
 bash ~/tesseract/src/training/tesstrain.sh \
 --fonts_dir ~/.fonts \
 --lang eng \
 --linedata_only \
 --noextract_font_properties \
 --langdata_dir ./langdata \
 --tessdata_dir ~/tessdata_best  \
 --workspace_dir ~/tmp \
 --fontlist \
 "Adinatha Tamil Brahmi" \
 "Noto Sans Brahmi" \
 --training_text ./langdata/brah/brah.evalnew.training_text \
 --exposures "0" \
 --save_box_tiff \
 --maxpages 0 \
 --output_dir ~/tesstutorial/brahmievaleng
  
  rm -rf ~/tesstutorial/brahmitraineng
  bash ~/tesseract/src/training/tesstrain.sh \
  --fonts_dir ~/.fonts \
  --lang eng \
  --linedata_only \
  --noextract_font_properties \
  --langdata_dir ./langdata \
  --tessdata_dir ~/tessdata_best  \
  --workspace_dir ~/tmp \
  --fontlist \
  "Adinatha Tamil Brahmi" \
  "Noto Sans Brahmi" \
  --training_text ./langdata/brah/brah.trainnew.training_text \
  --exposures "0" \
  --save_box_tiff \
  --maxpages 0 \
  --output_dir ~/tesstutorial/brahmitraineng

 cat \
 ~/tesstutorial/brahmitraineng/eng.training_files.txt  \
 > ~/tesstutorial/brahmitraineng/all.training_files.txt 
 
 merge_unicharsets \
 ~/tesstutorial/brahmitraineng/eng/eng.unicharset  \
 ~/tesstutorial/brahmievaleng/eng/eng.unicharset  \
 ~/tesstutorial/brahmitraineng/eng/all.unicharset  
 
 combine_lang_model \
 --input_unicharset ~/tesstutorial/brahmitraineng/eng/all.unicharset   \
 --script_dir ./langdata \
 --output_dir /home/ubuntu/tesstutorial/brahmitraineng \
 --lang eng \
 --version_str "shreeshrii:Brahmi:[Lfx192]:`date +%Y%m%d`"  
 
 rm -rf ~/tesstutorial/brahmilayer
 mkdir ~/tesstutorial/brahmilayer 
 
# using brah from a previous run
 combine_tessdata -e ~/tessdata_best/brah.traineddata ~/tesstutorial/brahmilayer/brah.lstm

~/tesseract/bin/src/training/lstmtraining \
--continue_from  ~/tesstutorial/brahmilayer/brah.lstm \
--append_index 5 --net_spec '[Lfx192 O1c1]' \
--traineddata   ~/tesstutorial/brahmitraineng/eng/eng.traineddata \
--max_iterations 500000 \
--debug_interval 0 \
--train_listfile ~/tesstutorial/brahmitraineng/all.training_files.txt \
--eval_listfile ~/tesstutorial/brahmievaleng/eng.training_files.txt \
--model_output  ~/tesstutorial/brahmilayer/brahmilayer

~/tesseract/bin/src/training/lstmtraining  \
--stop_training \
--continue_from ~/tesstutorial/brahmilayer/brahmilayer_checkpoint \
--traineddata   ~/tesstutorial/brahmitraineng/eng/eng.traineddata \
--model_output ~/tesstutorial/brahmilayer/brahmilayer.traineddata 

cd ~/tesstutorial

tesseract  ./brahmievaleng/eng.Noto_Sans_Brahmi.exp0.tif ./brahmievaleng/eng.Noto_Sans_Brahmi.exp0.brahmilayer -l brahmilayer --tessdata-dir ./brahmilayer

