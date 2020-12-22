# D2SCMYK

This is the original Death to sharpie code, only edited to be able to preview and create CMYK layers all at once. Instead of having to run all 4 layers separately through the program.

Original project by:
Scott Cooper, Dullbits.com, <scottslongemailaddress@gmail.com>

PDF Export added by Jan Krummrey, jan.krummrey.de

Maybe see some of my drawn images at:
https://www.instagram.com/larspoort12/

This is code to create gcode or pdf in CMYK colors. It takes in 4 images that are separated as layers. Out comes 4 gcode files and 4 pdfs. 
The result can be viewed in a window that overlaps all the layers.

The code is a hacky version of the Death to sharpie algorithm. It basically runs the algorithm 4 times and adds writes the layers colored into the viewer.

There is a naming scheme to easily load the pictures in the algorithm. For example:
amersfoort.jpg is the picture i want to draw.
I separate it into CMYK layers using photoshop.
I save the images as:
amersfoort-cyan.jpg
amersfoort-magenta.jpg
amersfoort-yellow.jpg
amersfoort-black.jpg

The extension -"color".jpg is used, so this naming scheme needs to be used otherwise the code will not load the images. If other file extension or naming scheme, the code should be changed.



The colors that are shown in the preview can also be changed to test if drawing with other colors will look nice. I changed these colors to fit my sharpies. 
Please change according to your own sharpies/pens to make the preview accurate.

### Example input image
![Example](https://github.com/KevLars/D2SCMYK/blob/main/pics/amersfoort.jpg?raw=true)
### Then for that image, this is the preview that is generated:
![GeneratedPreview](https://github.com/KevLars/D2SCMYK/blob/main/pics/amersfoort-generated.jpg?raw=true)
