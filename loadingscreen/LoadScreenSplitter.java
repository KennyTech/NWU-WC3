// LoadScreenSplitter.java
// Purpose: Splits NWU Load Screens into 4 sections
// Notes: Image Size Requirement: 1024x768
// Updated: March 16, 2018

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import javax.imageio.ImageIO;
import javax.swing.JOptionPane;

public class LoadScreenSplitter {
	
	public static void SplitImage() throws IOException 
	{	
		// Get absolute path of executing program (.jar file)
		String path = LoadScreenSplitter.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		
		// Go back to parent directory (ie. C:/Users/You/Desktop/LoadScreenSplitter.jar -> C:/Users/You/Desktop/)
		String parentPath = new File(path).getParent();
		
		// Decode path in case of spaces and special characters (will not work for some characters like "+"
		String decodedPath = URLDecoder.decode(parentPath, "UTF-8");
		
		// Set loading screen file
		File f = new File(decodedPath + "/loadingscreen.png");
		
		Message.infoBox("searching for loadingscreen.png at: " + f, "NWU Loading Screen Splitter");
		
		// Split the loading screen if it exists
	    if (f.exists()) 
	    { 
	    	BufferedImage image = ImageIO.read(f);
			int width          	= image.getWidth();
			int height         	= image.getHeight();
			
			// If image size is incorrect, throw error and end, otherwise, split image
			if (width != 1024 || height != 768)
				Message.infoBox("IMAGE SIZE MUST BE 1024x768. Please resize with good editor (pixlr.com, Photoshop, GIMP, NOT MS Paint)", "NWU Loading Screen Splitter");
			else
				Message.infoBox("loadingscreen.png has been split. Please convert to .blp using Warcraft 3 Viewer.exe", "NWU Loading Screen Splitter");	
	
			/*
			* Here we split loading screen to 4 images (parameters are x offset, y offset, width, height)
			*
			* png has transparency alpha and jpg does not, so we change transparency default to white
			* This is to avoid bizarre coloration such as all white becoming red during conversion
			*/
			
			// Top Left
			BufferedImage cutTL = image.getSubimage(0, 0, 512, 512); // cut
			BufferedImage bufferedImageTL = (BufferedImage)cutTL; // buffer
			BufferedImage outTL = new BufferedImage(cutTL.getWidth(), cutTL.getHeight(), BufferedImage.TYPE_INT_RGB);
			outTL.createGraphics().drawImage(bufferedImageTL, 0, 0, Color.WHITE, null); // convert
			
			// Top Right
			BufferedImage cutTR = image.getSubimage(512, 0, 512, 512); // cut
			BufferedImage bufferedImageTR = (BufferedImage)cutTR; // buffer
			BufferedImage outTR = new BufferedImage(cutTR.getWidth(), cutTR.getHeight(), BufferedImage.TYPE_INT_RGB);
			outTR.createGraphics().drawImage(bufferedImageTR, 0, 0, Color.WHITE, null); // convert
			
			// Bottom Left
			BufferedImage cutBL = image.getSubimage(0, 512, 512, 256); // cut
			BufferedImage bufferedImageBL = (BufferedImage)cutBL; // buffer
			BufferedImage outBL = new BufferedImage(cutBL.getWidth(), cutBL.getHeight(), BufferedImage.TYPE_INT_RGB);
			outBL.createGraphics().drawImage(bufferedImageBL, 0, 0, Color.WHITE, null); // convert
			
			// Bottom Right
			BufferedImage cutBR = image.getSubimage(512, 512, 512, 256); // cut
			BufferedImage bufferedImageBR = (BufferedImage)cutBR; // buffer
			BufferedImage outBR = new BufferedImage(cutBR.getWidth(), cutBR.getHeight(), BufferedImage.TYPE_INT_RGB);
			outBR.createGraphics().drawImage(bufferedImageBR, 0, 0, Color.WHITE, null); // convert

			// Create new images
			ImageIO.write(outTL, "jpg", new File(decodedPath + "/LoadingScreenTL.jpg"));
			ImageIO.write(outTR, "jpg", new File(decodedPath + "/LoadingScreenTR.jpg"));
			ImageIO.write(outBL, "jpg", new File(decodedPath + "/LoadingScreenBL.jpg"));
			ImageIO.write(outBR, "jpg", new File(decodedPath + "/LoadingScreenBR.jpg"));	
			
			// ------------------------------------------------------------------------------------
	    }
	    else if (!f.exists())
		{ 
			Message.infoBox("Could not find loadingscreen.png in directory. Please check to see image is there and is .png in same directory as this .jar file. If it is still not working, make sure there are no special characters in this directory and the path to directory.", "NWU Loading Screen Splitter");
		}
	}

	// Java pop-up messages
	public static class Message {

	    public static void infoBox(String infoMessage, String titleBar)
	    {
	        JOptionPane.showMessageDialog(null, infoMessage, "InfoBox: " + titleBar, JOptionPane.INFORMATION_MESSAGE);
	    }
	}
	
	// Main function call
	public static void main(String[] args) throws IOException {
		SplitImage();
	}
	
}