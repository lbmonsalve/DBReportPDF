#tag Class
Protected Class DBReportPDFImage
Inherits DBReportPDFXObject
	#tag Method, Flags = &h1000
		Sub Constructor(root As DBReportPDF, pdfReferenceName As String, whichImage as picture, sourceX as integer, sourceY as integer, sourceWidth as integer, sourceHeight as integer, pictureQuality As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  FileRoot= root
		  root.Objects.Append Me
		  
		  Dim ratio As Double= pictureQuality/ 100
		  
		  Image= PictureScale(whichImage,whichImage.Width* ratio, whichImage.Height* ratio)
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

	#tag Method, Flags = &h21
		Private Shared Function PictureScale(p as Picture, maxWidth as Integer, maxHeight as Integer) As Picture
		  ' Calculate the scale ratio
		  Dim ratio As Double = Min( maxHeight/p.Height, maxWidth/p.Width)
		  ' Create a new picture to return
		  Dim newPic As New Picture( p.Width* ratio, p.Height* ratio )
		  ' background white
		  newPic.Graphics.ForeColor= &cFFFFFF00
		  newPic.Graphics.FillRect 0, 0, newPic.Width, newPic.Height
		  ' Draw picture in the new size
		  newPic.Graphics.DrawPicture( p, 0, 0, newPic.Width, newPic.Height, 0, 0, p.Width, p.Height)
		  
		  Return newPic
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
		#tag EndViewProperty
		#tag ViewProperty
			Name="Generator"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MD5"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Number"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PictureQuality"
			Group="Behavior"
			InitialValue="80"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
