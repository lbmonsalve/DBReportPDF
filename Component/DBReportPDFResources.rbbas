#tag Class
Protected Class DBReportPDFResources
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF)
		  FileRoot= root
		  root.Objects.Append Me
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim i, n As Integer
		  Dim s As String
		  
		  s= s+ "<< "
		  
		  n= Ubound(Fonts)
		  If n> -1 Then
		    s= s+ "/Font << "
		    For  i= 0 To n
		      s= s+ "/"+ Fonts(i).Name+" "+ Fonts(i).IndirectReference+ " "
		    Next
		    s= s+ ">> "
		  End
		  
		  n= Ubound(XObjects)
		  If n> -1 Then
		    s= s+ "/XObject << "
		    For i= 0 To n
		      s= s+ "/"+ XObjects(i).Name+ " "+ XObjects(i).IndirectReference+ " "
		    Next
		    s= s+ ">> "
		  End
		  
		  Return s+ ">> "
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFontReferenceName(whichFontName as string, bold as boolean, italic as boolean) As string
		  Dim i, n As Integer
		  Dim name As String
		  
		  n= Ubound(Fonts)
		  If n> -1 Then
		    Dim nameCache As String= FileRoot.CacheGetBaseFont(whichFontName, bold, italic)
		    For i= 0 To n
		      if Fonts(i).BaseFont= nameCache Then
		        name= Fonts(i).Name
		        Exit For
		      End
		    Next
		  End
		  
		  If name= "" Then //Not found
		    name= "F"+ Str(Ubound(Fonts)+ 1)
		    Fonts.Append New DBReportPDFFont(FileRoot, name, whichFontName, bold, italic)
		  End
		  
		  Return name
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetImageReferenceName(image As Picture, x As Integer, y As Integer, width As Integer, height As Integer, pictureQuality As Integer) As String
		  Dim i, n As Integer
		  Dim name As String
		  
		  n= Ubound(XObjects)
		  If n> -1 Then
		    For i= 0 To n
		      If XObjects(i) IsA DBReportPDFImage Then
		        If XObjects(i).MD5= MD5(image.GetData(Picture.FormatJPEG)) And XObjects(i).PictureQuality= pictureQuality Then
		          name= XObjects(i).Name
		          Exit For
		        End
		      End
		    Next
		  End
		  
		  If name= "" Then //Not found
		    name= "Im"+ Str(Ubound(XObjects)+ 1)
		    XObjects.Append New DBReportPDFImage(FileRoot, Name, image, x, y, width, height, pictureQuality)
		  End
		  
		  Return Name
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Fonts() As DBReportPDFFont
	#tag EndProperty

	#tag Property, Flags = &h21
		Private XObjects() As DBReportPDFXObject
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
