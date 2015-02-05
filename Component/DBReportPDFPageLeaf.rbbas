#tag Class
Protected Class DBReportPDFPageLeaf
Inherits DBReportPDFPage
	#tag Method, Flags = &h0
		Sub AddFilledOval(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Contents.AddFilledOval x, y, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledPolygon(points() As Double, penWidth As Double, foreColor As Color)
		  Contents.AddFilledPolygon points, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledRect(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Contents.AddFilledRect x, y, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFilledRoundRect(x as Double, y as Double, width as Double, height as Double, ovalWidth as Double, ovalHeight as Double, penWidth as Double, foreColor as color)
		  Contents.AddFilledRoundRect x, y, width, height, ovalWidth, ovalHeight, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddImage(imageRef as string, x as Double, y as Double, width as Double, height as Double)
		  Contents.AddImage(imageRef, x, y, width, height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(x1 as Double, y1 as Double, x2 as Double, y2 as Double, penWidth as Double, foreColor as color)
		  Contents.AddLine x1, y1, x2, y2, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddOval(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Contents.AddOval x, y, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddPolygon(points() As Double, penWidth As Double, foreColor As Color)
		  Contents.AddPolygon points, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRect(x as Double, y as Double, width as Double, height as Double, penWidth as Double, foreColor as color)
		  Contents.AddRect x, y, width, height, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddRoundRect(x as Double, y as Double, width as Double, height as Double, ovalWidth as Double, ovalHeight as Double, penWidth as Double, foreColor as color)
		  Contents.AddRoundRect x, y, width, height, ovalWidth, ovalHeight, penWidth, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddText(whichText as string, x as Double, y as Double, fontRef as string, fontSize as Double, foreColor as color)
		  Contents.AddText whichText, x, y, fontRef, fontSize, foreColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTextBlock(whichText As string)
		  Contents.AddTextBlock whichText
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(width As Double, height As Double, root As DBReportPDF, parent As DBReportPDFPages)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  FileRoot= root
		  root.Objects.Append Me
		  Me.Parent= parent
		  Type= "Page"
		  
		  MediaBox= New DBReportPDFRect(0, 0, width, height)
		  Contents= New DBReportPDFContents(FileRoot)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetData() As String
		  Dim s As String
		  
		  s= s+ "<< /Type /"+ Type+ " /Parent "+ Parent.indirectReference+ " "
		  
		  If GetMediaBox<> Nil Then
		    s= s+ "/MediaBox "+ GetMediaBox.DataStream+ " "
		  End
		  
		  If GetResources<> Nil Then
		    s= s+ "/Resources "+ GetResources.IndirectReference+ " "
		  Else
		    's= s+ "/Resources 0 0 R "
		  End
		  
		  If Contents<> Nil Then
		    s= s+ "/Contents "+ Contents.IndirectReference+ " "
		  End
		  
		  Return s+ ">> "
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Contents As DBReportPDFContents
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FileRoot As DBReportPDF
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
