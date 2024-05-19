Image Analysis MATLAB GUI - README

This MATLAB GUI provides a user-friendly environment for interactive digital image processing.
It allows users to perform various operations on images, visualize results, and 
save processed images or graphs. Below is a brief guide on using the GUI:

Running file

You can run either the .m file or the .mlapp file. 
Using the .m file Simply import them into
Either use the run button or type the name of the file at the console then hit enter 

Using the .mlapp file
Double click on the file in Matlab to open the file in the App designer

Usage

1. Browse (Load Image):
Click the "Browse" button.
Select an image file from the file dialog.
The selected image is displayed in the main window (UIAxes) in the image input/output panel.

2. Reset:
Click the "Reset" button.
Resets the view to the original loaded image.
Clears any additional visualizations in UIAxes2.
Resets the scale factor to zero.

3. Crop:
Click the "Crop" button.
Draw a rectangle on the image  in the interactive window shown to define the Region of Interest (ROI).
The cropped region is displayed in UIAxes in the image input/output panel.

4. Pseudocolour:
Click the "Pseudocolour" button.
Converts the image to grayscale and applies pseudocolouring.
The pseudocoloured image is displayed in UIAxes in the image input/output panel.

5. Rotate:
Enter the desired rotation angle in the Value field.
Click the "Rotate" button.
The rotated image is displayed in UIAxes in the image input/output panel.

6. Image Histogram:
Click the "Image Histogram" button.
Displays the histogram of the image in UIAxes2 in the image input/output panel.

7. Resize:
Enter the scaling factor in the Value field.
Click the "Resize" button.
Choose the interpolation method.
The resized image is displayed in UIAxes in the image input/output panel.

8. Intensity Profile:
Click the "Intensity Profile" button.
Move mouse pointer to the image then wait for it to change to cross/ tool to draw line
Draw a line on the image.
Choose exploration options. For Explore Individual Option, you will choose the channel from the dialog box shown
The intensity profile is displayed in UIAxes2.

9. Save:
Click the "Save" button.
Choose between saving the image or the graph.
Select a file format and location for saving.

Note: Ensure you have a valid image file loaded before performing operations. 
Explore the functionalities of each button to analyze and manipulate images interactively.