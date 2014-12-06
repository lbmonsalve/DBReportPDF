#tag Class
Protected Class DBReportPDFPages
Inherits DBReportPDFPage
	#tag Method, Flags = &h0
		Function AddPage(width As Double, height As Double) As DBReportPDFPageLeaf
		  Dim p As New DBReportPDFPageLeaf(width, height, fileRoot, me)
		  
		  Kids.Append p
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF, parent As DBReportPDFPages)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  FileRoot= root
		  root.Objects.Append Me
		  Me.Parent= parent
		  
		  Type="Pages"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim i,n As integer
		  Dim s As String
		  
		  s= "<< /Type /"+ type+ " "
		  
		  If Parent<> Nil Then
		    s= s+ "/Parent "+ Parent.IndirectReference+ " "
		  End
		  
		  n= Ubound(Kids)
		  
		  s= s+ "/Kids [ "
		  For i= 0 To n
		    s= s+ Kids(i).IndirectReference+" "
		  Next
		  s= s+ "] "
		  s= s+ "/Count "+ Str(n+ 1)+ " >> "
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFontReferenceName(whichFontName as string, bold as boolean, italic as boolean) As string
		  If Resources= Nil Then
		    Resources= New DBReportPDFResources(FileRoot)
		  End
		  
		  Return Resources.GetFontReferenceName(whichFontName, bold, italic)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetImageReferenceName(image As Picture, x As Integer, y As Integer, width As Integer, height As Integer, pictureQuality As Integer) As string
		  If Resources= Nil Then
		    Resources= New DBReportPDFResources(FileRoot)
		  End
		  
		  Return Resources.GetImageReferenceName(image, x, y, width, height, pictureQuality)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h0
		Kids() As DBReportPDFPage
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
