#tag Class
Protected Class DBReportPDFImage
Inherits DBReportPDFXObject
	#tag Method, Flags = &h1000
		Sub Constructor(root As DBReportPDF, pdfReferenceName As String, whichImage as picture, sourceX as integer, sourceY as integer, sourceWidth as integer, sourceHeight as integer, pictureQuality As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  FileRoot= root
		  root.Objects.Append Me
		  
		  Image= New Picture(sourceWidth, sourceHeight, whichImage.Depth)
		  Image.Graphics.DrawPicture whichImage, 0, 0, image.width, image.height, sourceX, sourceY, sourceWidth, sourceHeight
		  Name= pdfReferenceName
		  Type= "XObject"
		  SubType= "Image"
		  MD5= MD5(whichImage.GetData(Picture.FormatJPEG))
		  Me.PictureQuality= pictureQuality
		  
		  width= Image.Width
		  height= Image.Height
		  colorSpace= "DeviceRGB"
		  bitsPerComponent= 8 // <= PDF-1.4
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s, stream As String
		  
		  stream= Image.GetData(Picture.FormatJPEG, Picture.QualityMax)
		  
		  s= s+ "<< /Type /"+ Type+ " /Subtype /"+ SubType+ " /Width "+ Str(Width)+ " /Height "+ Str(Height)
		  s= s+ " /ColorSpace /"+ ColorSpace+ " /BitsPerComponent "+ Str(BitsPerComponent)+ " /Filter /DCTDecode"
		  s= s+ " /Length "+ Str(Len(stream))+ " >> "+ "stream"+ CR+ stream+ CR+ "endstream"+ CR
		  
		  Return s
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private BitsPerComponent As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ColorSpace As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Height As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Image As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SubType As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Width As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ByteOffset"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Generator"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MD5"
			Group="Behavior"
			Type="String"
			InheritedFrom="DBReportPDFXObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Number"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PictureQuality"
			Group="Behavior"
			InitialValue="80"
			Type="Integer"
			InheritedFrom="DBReportPDFXObject"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="DBReportPDFObject"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
