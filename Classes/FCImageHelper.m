/*
 
 TiY (tm) - an iPhone app that supports self-management of type 1 diabetes
 Copyright (C) 2010  Interaction Design Centre (University of Limerick, Ireland)
 
 TiY (tm) is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TiY (tm) is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TiY (tm).  If not, see <http://www.gnu.org/licenses/>.
 
 */

//
//  FCImageHelper.m
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//

#import "FCImageHelper.h"


@implementation UIImage (FCImageHelper)

+(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

+(UIImage *)imageWithImage:(UIImage *)theImage scaledToScale:(CGFloat)theScale {

	CGFloat newWidth = theImage.size.width * theScale;
	CGFloat newHeight = theImage.size.height * theScale;
	CGSize newSize = CGSizeMake(newWidth, newHeight);
	
	return [self imageWithImage:theImage scaledToSize:newSize];
}

- (UIImage*)imageScaledToSize:(CGSize)size {

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	return image;
}


-(UIImage *)resizeImage:(CGSize)newSize {
/*	This solution is borrowed from the Trevor's Bike Shed blog:
	http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
	 
	OBS! Also note that this here is a primitive implementation that needs to be extended!
	E.g. it does not take into account alpha channels or image orientation.
 
	/Anders */
	
	CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
	CGImageRef imageRef = self.CGImage;
	
	// Build a context that's the same dimenstions as the new size
	CGContextRef bitmap = CGBitmapContextCreate(NULL, 
												newRect.size.width, 
												newRect.size.height, 
												CGImageGetBitsPerComponent(imageRef), 
												0,
												CGImageGetColorSpace(imageRef), 
												CGImageGetBitmapInfo(imageRef));
	
	// Draw into the context - this scales the image
	CGContextDrawImage(bitmap, newRect, imageRef);
	
	// Get the resized image from the context and store in UIImage object
	CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
	
	// Clean up
	CGContextRelease(bitmap);
	CGImageRelease(newImageRef);
	
	return newImage;
}

@end
