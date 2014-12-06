#tag Class
Protected Class DBReportPDFCatalog
Inherits DBReportPDFObject
	#tag Method, Flags = &h0
		Function AddPage(width As Double, height As Double) As DBReportPDFPageLeaf
		  Return Pages.AddPage(width, height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(root As DBReportPDF)
		  FileRoot= root
		  root.Objects.Append Me
		  
		  Type="Catalog"
		  
		  Pages= New DBReportPDFPages(root, Nil)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s As String
		  
		  If Pages<> Nil Then
		    s= s+ "<< /Type /"+Type+" /Pages "+ Pages.IndirectReference+ " >> "
		  End
		  
		  Return s
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
	#tag EndProperty

	#tag Property, Flags = &h0
		Pages As DBReportPDFPages
	#tag EndProperty


End Class
#tag EndClass
