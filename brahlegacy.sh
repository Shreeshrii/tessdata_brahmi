#!/bin/bash
#--------------------------------------------
cd ~/tesstutorial

 rm -rf ~/tesstutorial/brahmilegacy
 bash ~/tesseract/src/training/tesstrain.sh \
 --fonts_dir ~/.fonts \
 --lang eng \
 --langdata_dir ./langdata \
 --tessdata_dir ~/tessdata_best  \
 --workspace_dir ~/tmp \
 --fontlist \
 "Adinatha Tamil Brahmi" \
 "Noto Sans Brahmi" \
 --training_text ./langdata/brah/brah.train.training_text \
 --exposures "0" \
 --save_box_tiff \
 --maxpages 0 \
 --output_dir ~/tesstutorial/brahmilegacy

cd ~/tesstutorial/langdata/brah/test

tesseract  tam.Adinatha_Tamil_Brahmi.exp0.page1.png  tam.Adinatha_Tamil_Brahmi.exp0.page1.png-legacy --tessdata-dir /home/ubuntu/tesstutorial/brahmilegacy -l eng
tesseract  dhamma.png  dhamma.png-legacy --tessdata-dir /home/ubuntu/tesstutorial/brahmilegacy -l eng
